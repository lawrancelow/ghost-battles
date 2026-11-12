# 《過勞鬼大作戰》Godot 版：移植藍圖

方針：GDScript 原生重寫，分階段逐個玩法搬；邏輯、數值、文字、美術同網頁版一致；以後方便擴展。
引擎：Godot 4.3（GL Compatibility 渲染，手機／網頁都穩）。導出：網頁、Android、Windows、Mac、iOS（Xcode 工程）。


## 〇、2026-11-12 晚：架構升級（v0.2）——整個網頁版轉譯落 Godot

第一階段係人手逐句搬；而家改為**自動轉譯**，所有玩法一次過搬晒：

| 位置 | 作用 |
|---|---|
| `tools/jsgd/jsgd.js` | JS → GDScript 轉譯器（acorn 解析；閉包變數裝入作用域字典；表達式降級；switch/for/解構/展開/getter 都支援）。`tools/jsgd/build.sh` 一鍵轉晒 61 個模塊 → `jsgen/*.gd` |
| `tools/jsgd/patches.js` | 轉譯前嘅原碼修改：熱點交俾原生（例如 meshanim 嘅網格變形 → `MeshAnim.draw_js`） |
| `js/j.gd`（class `J`） | JS 運行庫：真假值、加減、比較、屬性讀寫、方法分派、JSON/Object/Array/Math/Date… |
| `js/ja.gd` `js/jstr.gd` `js/jsmap.gd` `js/jsset.gd` `js/jsregexp.gd` `js/jspromise.gd` `js/jspath.gd` | 陣列／字串／Map／Set／正則／Promise／Path2D |
| `js/jsrun.gd`（autoload `JSRun`） | 宿主：計時器、requestAnimationFrame、localStorage（user://localStorage.json）、window/document、模塊載入 |
| `js/el.gd` `js/html.gd` `js/css.gd` | DOM 替身＋HTML 解析＋CSS 引擎（讀網頁版 style.css 同各模塊動態加嘅 `<style>`） |
| `js/recorder.gd` `js/baker.gd` | 每塊 `<canvas>` 係錄製器；Godot 喺 `_draw` 重播；大嘅靜態畫布自動拍成貼圖 |
| `ui/dom_view.gd` | 把各玩法嘅 HTML 介面按 CSS 排版畫出嚟（block／flex／absolute／文字換行／背景圖／圓角），撳嘢轉做 click/pointer 事件 |
| `ui/js_canvas_view.gd` | 村子畫布顯示＋觸控 |
| `js/bridge.gd` | 原生替身（SPR、sprOk、網格變形、Web）＋ JS 介面（Story、Fx、Title、Phone）轉駁去 Godot |

**移植程度**：原碼 3120KB，轉譯並喺 Godot 跑緊 3056KB ＝ **98%**（全部 61 個遊戲模塊；冇轉嘅只有瀏覽器啟動器 web.js 同圖片數據檔，圖片已另外導出成素材）。
**已實機驗證（截圖＋0 個腳本錯誤）**：村子全套生活、建築／名冊／箱子／劇情面板、陰間地圖、搶地盤戰鬥、陽間站崗地圖、樓裡有鬼入口、冥街夜市、亂葬崗、夜班嚇人選隊。
**未完成**：聲音（WebAudio 合成未接）、手機序章（Phone）、部分 CSS 細節（偽元素 ::before/::after、陰影、動畫過渡）、各玩法深入流程未逐一試玩、網頁版 Godot 匯出效能慢（建議用 App）。

## 一、架構（第一階段，人手移植部分；仍保留做原生底層）

| 位置 | 作用 |
|---|---|
| `core/ctx.gd`（class `Ctx`） | **Canvas 2D 相容層**：`save/restore/translate/rotate/scale`、路徑（`moveTo/lineTo/arc/ellipse/quadraticCurveTo/bezierCurveTo/roundRect`）、`fill/stroke`、漸變、`drawImage`（3/5/9 參數）、`fillText/strokeText/measureText`、`globalAlpha`、`filter`（brightness/saturate/grayscale）、`setLineDash`、網格貼圖 `drawTriangles`。網頁版幾乎全部畫面都係 Canvas 2D 畫，有咗呢層就可以**逐行對照**移植。 |
| `core/db.gd`（autoload `DB`） | 數據表 `DB.D.XXX`（`data/core.json`）、對白語言 `DB.L()` / `DB.Lf()`（中文／粵語切換） |
| `core/spr.gd`（autoload `Spr`） | 蠟筆畫素材，鍵名同網頁版 `SPR` 一樣（背景加 `bg_` 前綴）：`Spr.get_tex(k)`、`Spr.ok(k)` |
| `core/meshanim.gd`（autoload `MeshAnim`） | 原圖網格變形動畫（meshanim.js）：骨架、權重、動作 idle/walk/windup/strike/follow/recover/hurt/cast/die/scared |
| `core/limbs.gd`（autoload `Limbs`） | 拆手揮武器（limbs.js） |
| `core/art.gd`（autoload `Art`） | art.js ＋ scene.js：建築、樹、稻田、擺設、烏鴉、彼岸花、角色 `Art.draw_char()`、頭像裁切 |
| `game/game.gd`（autoload `G`） | 存檔狀態 `G.S`（**同網頁版同一份 JSON**）、公式 F、經濟、任務、離線收益、存檔碼 |
| `game/village.gd` | 村子場景（拖動鏡頭、砍樹、收割、親手做、特效、烏鴉、碎碎念、任務箭頭） |
| `game/ground_painter.gd` | 村子地面（同網頁版同一個隨機種子，畫一次拍成貼圖） |
| `ui/main.gd` | 頂欄、任務條、底部導航、面板（建築／派人／名冊／箱子／劇情設定）、提示、橫幅、標題畫面 |
| `ui/story.gd` `ui/story_stage.gd` | 劇情播放器（talk 舞台＋對話框、sys 陰司 KPI 系統視窗；其他樣式暫用旁白框） |
| `core/tester.gd`（autoload `Tst`） | 自動測試：環境變數 `GB_TEST=<腳本.json>` 先會跑（截圖、導入存檔、點擊、印狀態） |
| `tools/` | `dump_runtime.py`（跑網頁正式版，等所有模塊補丁打完先導出數據）、`dump_spr.js`（素材）、`dump_rigs.js`（骨架）、`build_all.sh`（一鍵重生＋導出） |

**數據同步原則**：數據唔手抄。網頁版改咗數值／任務／劇情／對白，跑 `tools/build_all.sh` 就會由正式版網頁重新導出，Godot 版自動跟上。

**存檔互通**：存檔碼格式同網頁版一樣（base64 的 UTF-8 JSON）。網頁版「備份存檔」嘅碼可以喺 Godot 版「劇情 → 導入存檔碼」直接用，反之亦然（已驗證）。

## 二、進度

### 第一階段 ✅（2026-11-12）
- 核心：存檔、公式、生產鏈、離線收益（最多 8 小時）、升級解鎖、任務（51 個，含 guide.js 插入嘅兩個；舊存檔索引搬位）
- 村子：地面、11 座建築（蠟筆畫＋牌匾字＋等級章）、槐樹／稻田再生、砍樹（停格、震動、木屑、烏鴉驚飛）、收割、親手做（批量）、打工鬼、閒鬼、碎碎念、任務箭頭、浮字
- 角色：MeshAnim 網格變形＋Limbs 拆手武器（阿福揮斧）、冇骨架角色整張圖呼吸
- 介面：頂欄（主公印、好評條、6 種資源）、任務條、導航、建築面板（建造／升級／親手做／化寶爐／招魂／盂蘭宴／崗位派人撤下）、鬼怪名冊（升級、投胎）、箱子、劇情回顧＋設定（語言、存檔碼導出導入、重新開始）、標題畫面
- 劇情：talk、sys 兩種樣式
- 導出：網頁、Android APK（arm64）、Windows、Mac、iOS Xcode 工程

### 第二階段：村莊完整度
- 村莊生活：daily_hero（阿福打呵欠、看手機、打瞌睡）、daily_plaza（廣場走位聊天）、daily_work（崗位動作）、daily_town、chatter/bonds（對話羈絆）、presence（存在感）
- rework（嚇功訓練班）、gpower（鬼力 GP）、guide 紅點
- 聲音（audio.js：WebAudio 合成 → Godot AudioStreamGenerator）
- 手機 phone.js（序章 WhatsApp、新聞、帖子）、其他劇情樣式（chat/news/notice/radio/report/mail/letter/narr）
- special.js（Penanggal / Pocong / Toyol 網格）、puppet、n30_rigs 個別走路方式、npc_antag 原畫角色
- 化寶爐金銀紙特效（JossFx）

### 第三階段：世界地圖＋主線戰鬥
world.js、battle.js、moves*.js、n30_moves.js、special 招式、勝負結算、章節劇情

### 第四階段：陽間站崗
station*.js、street.js、policy.js、本關冥幣、佔領度、發展收入

### 第五階段：樓裡有鬼
tower*.js（lyg/core 各模塊，入屋模式、警覺、電梯、樓力）

### 第六階段：其他玩法
夜班嚇人（scare*.js、office、rooms、pantry）、運動會 sports、冥街夜市 ghoststreet、亂葬崗 graveyard、脫口秀 standup／skits、rivals

## 三、建置
```
bash godot/tools/build_all.sh          # 全部
bash godot/tools/build_all.sh web      # 只出網頁
```
環境：`/opt/godot/Godot_v4.3-stable_linux.x86_64` ＋ 導出模板（`~/.local/share/godot/export_templates/4.3.stable`）；Android 要 `/opt/android/sdk`（platform-tools、build-tools 34、android-34）同 `~/.config/godot/editor_settings-4.3.tres` 入面嘅 SDK／keystore 路徑。
測試：`GB_TEST=test.json xvfb-run godot --path godot --rendering-driver opengl3`。

## 四、注意
- 唔好直接改 `data/*.json`、`assets/spr/*`：由網頁版導出。
- 改畫法：搬 JS 嗰陣盡量保持同一句對應同一句，方便日後網頁版改咗再跟。
- Android 而家用 debug 簽名（側載測試用）；上 Google Play 要整正式 keystore（唔好入 repo）。
- iOS：喺 Mac 用 Xcode 打開 `GhostBattles.xcodeproj`，填 Team ID 簽名。
