# station_foes.js 接駁 street.js（12 處 hook）

模組：`StnFoes`（全域常數，build.py 已經喺 street.js **之前**載入 station_foes.js）。
所有 hook 都包住 `typeof StnFoes !== 'undefined'`，冇模組都唔會壞。

> 懶人法：`python3 /home/claude/gb/tools/apply_foes_hooks.py /home/claude/gb/src/street.js`
> 會將下面 12 處逐處「舊字串 → 新字串」替換（每個舊字串必須唯一，否則 assert 停低）。已喺 2026-11-11 版 street.js 副本試過：12 處全中、`node --check` 過、真遊戲跑冇 error。
> 如果 street.js 改咗，就照下面手動加。

以下 `F` = `typeof StnFoes !== 'undefined'`。

| # | 位置（Street.Turf） | 搵呢句 | 改成／加上 |
|---|---|---|---|
| 1 | `open()` 清場 | `this.bosses = []; this.walkers = [];` | 後面加 `if (F) StnFoes.reset();` |
| 2 | `queueTick()` 生路人 | `const nw = this.newWalker(el);` | 後面加 `if (!el && F) { const fid = StnFoes.roll(this.sd.lv, q); if (fid) StnFoes.decorate(nw, fid); }`（一定要喺 `q.list.push(nw)` 之前，decorate 會清走情侶 `mate`） |
| 3 | `tick()` | `this.bossTick(dt); this.traceTick(dt); this.obsTick(dt);` | 後面加 `if (F) StnFoes.update(dt, this);` |
| 4 | `tick()` 設備迴圈 | `sd.posts.forEach((p, i) => { if (p && p.role && !(p.build > 0) && this.lay.posts[i]) this.devTick(i, p, dt); });` | 改成 `sd.posts.forEach((p, i) => { if (p && p.role && !(p.build > 0) && this.lay.posts[i]) { this._foeRole = p.role; this.devTick(i, p, dt); } }); this._foeRole = 'throw';`（記低「邊類設備」出手，用嚟計強敵抗性；之後嘅 shots 結算當 throw） |
| 5 | `tick()` 清路人 | `this.walkers = this.walkers.filter(w => !(w.gone === 'out'` | 前面加 `this._foeRole = null; ` |
| 6 | `devTick()` 第一行 | `if (p.stun > 0) { p.stun -= dt; return; }` | 後面加 `if (F && StnFoes.blocks(p)) return;`（被封／被照住 → 設備完全停止運作，鬼打牆都會放人行過） |
| 7 | `devTick()` 攻擊力 | `atk = L0[2] * M.atk * (amb ? 1.3 : 1)` | 尾加 `* (F ? StnFoes.devMul(p) : 1)`（鹽米 −40%） |
| 8 | `devTick()` 減速 | `w.slowM = Math.min(w.slowT > 0 ? w.slowM : 1, 1 - L0[5]);` | `1 - L0[5]` 改 `1 - L0[5] * (F ? StnFoes.devMul(p) : 1)`（鹽米都減弱水鬼拉腳） |
| 9 | `hit()` 扣膽量前 | `w.hp -= dmg; if (!o.aura \|\| w.hp <= 0)` | 前面加 `if (F) dmg = StnFoes.onHit(w, dmg, o, this); `（強敵抗性、直播主光環 +30% 膽量、唸咒被打斷） |
| 10 | `bossTick()` 名鬼迴圈 | `for (const B of this.bosses) {` | 後面加 `B.sealed = F ? StnFoes.isSealed(B) : 0; if (B.sealed > 0) continue;`（名鬼被封：唔行、唔出招） |
| 11 | `draw()` 內 `drawW` 畫路人 | `let ok = false; if (hasArt && CHAR_H_OK(w.spr))` | 改成 `let ok = !!(w.foe && F && StnFoes.drawBody(c, w, hh, t, { flip:(run \|\| w.back > 0 \|\| w.rev > 0 ? right : !right) })); if (!ok && hasArt && CHAR_H_OK(w.spr))` |
| 12 | `draw()` 深度排序畫完之後 | `for (const it of items) { if (it[1] === 0) drawW(` 嗰一行之後 | 新一行 `if (F) StnFoes.draw(c, this);`（喺鏡頭變換入面、粒子／飄字之前） |

## 介面

```js
StnFoes.reset()                       // 開地盤時清狀態（封禁／暫停／鹽米唔入存檔）
StnFoes.spawnTable(level)             // → [{ id, name, weight, chance(每個空位), hpMul }]；未解鎖就冇
StnFoes.roll(level, q)                // 排隊每生一個人擲一次 → 'taoist'|'hunter'|'streamer'|null；q = Turf.q 用嚟限每波上限
StnFoes.decorate(w, id)               // 將 newWalker() 出嚟嘅普通路人改裝成強敵（w.foe、膽量×、速度、名、對白池、獎勵）
StnFoes.update(dt, world)             // world = Turf（用 walkers / lay.posts / sd.posts / bosses / alive / wp / dist / rdist / rect / bpos / float / P / box / staffMul）
StnFoes.draw(ctx, world)              // 鏡頭內畫：黃符＋金鎖鏈＋倒數圈、名鬼「被封印 N 秒」、電筒扇形、鹽米白點、直播光環、唸咒進度圈、強敵合力格
StnFoes.drawBody(ctx, w, hh, t, o)    // 喺腳底原點畫強敵身體；有 SPR.foe_taoist / foe_hunter / foe_streamer 圖就用圖，否則畫 Q 版佔位
StnFoes.onHit(w, dmg, o, world)       // → 實際扣幾多膽量
StnFoes.isSealed(deviceOrBoss)        // → 剩餘秒數（0＝冇封）
StnFoes.isPaused(device)              // → 電筒暫停剩餘秒數
StnFoes.blocks(device)                // 封禁或暫停 → true
StnFoes.devMul(device)                // 鹽米中 0.6，否則 1
StnFoes.FOES / StnFoes.RES            // 數值表（可直接調）
```

## 規則（數值喺 `FOES`）

- **出場**：直播主 Lv2+、捉鬼師 Lv4+、道士 Lv6+。每個空位機率 `3% + 1.2%×(Lv−2)`，上限 30%，再隨本局波數升（第 20 波 ×2）。每波上限：Lv<8 一個、<18 兩個、之後三個。
- **合力先嚇得走**：道士膽量 ×3.6、捉鬼師 ×3.0。同一類設備（trap / puzzle / scare / aura / slow / throw）最多實打 40% 膽量，之後嗰類只得兩成效果 → 一類設備打到底只得約 52%，要三類以上先順。第一次撞上限會飄字「同一招唔夠嚇佢，夾埋第二類設備！」；頭頂右邊三粒點顯示已經用咗幾類。`force`（驚嚇盒、名鬼招、大招）唔受抗性影響。
- **茅山道士**：射程 240px 內有未封設備／名鬼 → 停低唸咒 1.6 秒（頭頂進度圈＋金色虛線指向目標）→ 封禁 6–10 秒；每個道士同時最多封 2 個；封完冷卻 3.5 秒。唸咒中受一下 ≥6% 膽量嘅驚嚇會倒退 0.5 秒（圈變紅震）。膽量跌到 45% 以下即撤晒符、唔再唸咒；佢逃走都會撤符。
- **現代捉鬼師**：每 5–7 秒停低 1.1 秒，前方扇形（300px、±43°）內設備暫停 4 秒；每 9–13 秒向 300px 內設備最密嗰點灑鹽米（半徑 1.3 格），範圍內設備效果 −40%，6 秒。
- **靈異直播主**：膽量 ×0.7、受驚 ×1.3（好易嚇）；環形燈 170px 內其他路人受驚 ÷1.3（＝膽量 +30%），頭頂顯示「膽+30%」。
- 對白全部地道港式粵語、短句；同一句同一時間唔會兩個人講。佢哋係專業對手，唔殺鬼，只封禁；符紋係抽象圖案，冇真實文字。

## 換正式美術

ChatGPT 生好 Q 版角色後，載入做 `SPR.foe_taoist`、`SPR.foe_hunter`、`SPR.foe_streamer`（透明底、腳底置中），`drawBody` 會自動改用圖，高度 = `hh × 1.15`、按 `flip` 左右反。唔使改 street.js。

## 測試

- 獨立測試頁：`/home/claude/gb/tools/foes_test.html`（假地圖＋固定隨機數），跑法見報告；截圖 `/tmp/claude-0/out/foes_1_chant.png` … `foes_7_cast.png`。
- 真遊戲整合（套晒 12 個 hook 嘅副本）：`/tmp/claude-0/out/foes_9_ingame_seal.png`。
