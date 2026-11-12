import re
p='/home/claude/gb/src/street.js'; s=open(p).read(); lines=s.split('\n')
def rep(old,new,cnt=1):
    global s
    n=s.count(old); assert n==cnt,(old[:60],n); s=s.replace(old,new)
# 1) 有名鬼傷害：連續成長
rep("const g = B.g, lv = Math.min(6, g.lv || g.level || 1), base = BOSS_DMG + (lv >= 2 ? 180 : 0) + (lv >= 5 ? 361 : 0);",
    "const g = B.g, base = bossDmg(g);")
rep("const g = B.g, k = g.k, L = this.lore(k), lv = Math.min(6, g.lv || g.level || 1), base = (BOSS_DMG + (lv >= 2 ? 180 : 0) + (lv >= 5 ? 361 : 0)) * L.dmg, pos = this.bpos(B);",
    "const g = B.g, k = g.k, L = this.lore(k), base = bossDmg(g) * L.dmg, pos = this.bpos(B);")
# 建設度：有名鬼 0.1 起，跟成長（舊：Lv1→0.1、Lv6+→0.2）
rep("v += 0.1 + (Math.min(6, (g && (g.lv || g.level)) || 1) - 1) * 0.02; }",
    "v += 0.1 + Math.min(0.15, ((g ? GP.grow(g) : 1) - 1) * 0.2); }")
# 2) 勵鬼加持
rep("staffMul(p) { const g = p.staff != null && ghost(p.staff); if (!g) return { atk:1, cd:1, hp:1 }; return this.SPECIAL.includes(g.k) ? { atk:1.5, cd:0.8, hp:1.5, named:1 } : { atk:1.3, cd:0.9, hp:1.3 }; }, // 勵鬼加持",
    "staffMul(p) { const g = p.staff != null && ghost(p.staff); if (!g) return { atk:1, cd:1, hp:1 }; return staffOf(g, this.SPECIAL.includes(g.k)); }, // 勵鬼加持（跟鬼力：gpower.js）")
# 3) 大招：跟成長
rep("pw:power(g), done:false, fx:[] }; this.shake = 0.5;\n      if (has(Sound)", "pw:power(g), pm:GP.grow(g), done:false, fx:[] }; this.shake = 0.5;\n      if (has(Sound)")
rep("name:T(nm[0], nm[1]), gname:g.name, pw:power(g), done:false, fx:[] }, this.ULTT[g.k] || {});", "name:T(nm[0], nm[1]), gname:g.name, pw:power(g), pm:GP.grow(g), done:false, fx:[] }, this.ULTT[g.k] || {});")
rep("const live = this.walkers.filter(w => this.alive(w)), P = BOSS_DMG, me", "const live = this.walkers.filter(w => this.alive(w)), P = BOSS_DMG * (U.pm || 1), me")
rep("const live = this.walkers.filter(w => this.alive(w)), P = BOSS_DMG, a", "const live = this.walkers.filter(w => this.alive(w)), P = BOSS_DMG * (U.pm || 1), a")
for k in ['BOSS_DMG * 8,','BOSS_DMG * 5,','BOSS_DMG * 4,']:
    rep("this.hit(w, "+k, "this.hit(w, BOSS_DMG * (U.pm || 1) * "+k[11:])
# 有名鬼餘痕／聯動：跟場上有名鬼平均成長
for k in ['this.hit(o, BOSS_DMG * 0.2,','this.hit(w, BOSS_DMG * 0.6,','this.hit(w, BOSS_DMG * 0.15,','this.hit(w, BOSS_DMG * 0.35,','this.hit(w, BOSS_DMG * 0.3,']:
    rep(k, k.replace('BOSS_DMG *','BOSS_DMG * (this.bg || 1) *'))
# 場上有名鬼平均成長 bg
rep("this.bosses = this.bosses.filter(b => sd.bosses.includes(b.g.id));",
    "this.bosses = this.bosses.filter(b => sd.bosses.includes(b.g.id)); this.bg = this.bosses.length ? this.bosses.reduce((a, b) => a + GP.grow(b.g), 0) / this.bosses.length : 1;")
# helper：放喺 BOSS_DMG 定義之後
rep("const BOSS_CD = 15, BOSS_DMG = 362, BOSS_MAX = 3;",
    """const BOSS_CD = 15, BOSS_DMG = 362, BOSS_MAX = 3;
  // ---- 鬼力（gpower.js）接駁 ----
  // 有名鬼出招傷害：舊版 Lv1=362、Lv2–4=542、Lv5 以上封頂 903。而家跟 GP.grow 連續升：
  //   k = 1 + 4.5×(grow−1)（grow ≤ 4/3，約 11 級前）；之後 2.5 + 2×(grow−4/3)
  //   Lv1 ×1.0（362）・Lv8 ×2.05・Lv17 ×2.83（1024，舊 903）・Lv20 ×2.99・Lv30 ×3.5・Lv40 ×3.95（1430）・Lv40＋嚇功5 ×5.7
  function bossK(g) { const q = g ? GP.grow(g) : 1; return q <= 4 / 3 ? 1 + 4.5 * (q - 1) : 2.5 + 2 * (q - 4 / 3); }
  function bossDmg(g) { return BOSS_DMG * bossK(g); }
  // 勵鬼加持：驚嚇／耐久 ×(1＋0.3×mul)，回靈 ×0.9^mul；有名鬼驚嚇／耐久再 ×1.15、回靈再 ×0.89（1 級：雜鬼 ×1.3／0.9，名鬼 ×1.5／0.8，同舊版一樣）
  function staffOf(g, named) { const m = GP.mul(g), nm = named ? 1.15 : 1; return { atk:(1 + 0.3 * m) * nm, hp:(1 + 0.3 * m) * nm, cd:Math.pow(0.9, m) * (named ? 0.89 : 1), named:named ? 1 : 0, m, pw:GP.pow(g) }; }
  const staffTxt = (M) => T(`驚嚇 ×${M.atk.toFixed(2)}・回靈 ×${M.cd.toFixed(2)}`, `驚嚇 ×${M.atk.toFixed(2)}・回靈 ×${M.cd.toFixed(2)}`);""")
open(p,'w').write(s); print('ok')
