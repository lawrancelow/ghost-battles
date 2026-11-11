import sys
p=sys.argv[1]; s=open(p).read()
F="typeof StnFoes !== 'undefined'"
H=[
("this.bosses = []; this.walkers = [];", f"this.bosses = []; this.walkers = []; if ({F}) StnFoes.reset();"),
("const nw = this.newWalker(el);", f"const nw = this.newWalker(el); if (!el && {F}) {{ const fid = StnFoes.roll(this.sd.lv, q); if (fid) StnFoes.decorate(nw, fid); }}"),
("this.bossTick(dt); this.traceTick(dt); this.obsTick(dt);", f"this.bossTick(dt); this.traceTick(dt); this.obsTick(dt); if ({F}) StnFoes.update(dt, this);"),
("sd.posts.forEach((p, i) => { if (p && p.role && !(p.build > 0) && this.lay.posts[i]) this.devTick(i, p, dt); });",
 "sd.posts.forEach((p, i) => { if (p && p.role && !(p.build > 0) && this.lay.posts[i]) { this._foeRole = p.role; this.devTick(i, p, dt); } }); this._foeRole = 'throw';"),
("this.walkers = this.walkers.filter(w => !(w.gone === 'out'", "this._foeRole = null; this.walkers = this.walkers.filter(w => !(w.gone === 'out'"),
("if (p.stun > 0) { p.stun -= dt; return; }", f"if (p.stun > 0) {{ p.stun -= dt; return; }} if ({F} && StnFoes.blocks(p)) return;"),
("atk = L0[2] * M.atk * (amb ? 1.3 : 1)", f"atk = L0[2] * M.atk * (amb ? 1.3 : 1) * ({F} ? StnFoes.devMul(p) : 1)"),
("w.slowM = Math.min(w.slowT > 0 ? w.slowM : 1, 1 - L0[5]);", f"w.slowM = Math.min(w.slowT > 0 ? w.slowM : 1, 1 - L0[5] * ({F} ? StnFoes.devMul(p) : 1));"),
("w.hp -= dmg; if (!o.aura || w.hp <= 0)", f"if ({F}) dmg = StnFoes.onHit(w, dmg, o, this); w.hp -= dmg; if (!o.aura || w.hp <= 0)"),
("for (const B of this.bosses) {", f"for (const B of this.bosses) {{ B.sealed = {F} ? StnFoes.isSealed(B) : 0; if (B.sealed > 0) continue;"),
("let ok = false; if (hasArt && CHAR_H_OK(w.spr))", f"let ok = !!(w.foe && {F} && StnFoes.drawBody(c, w, hh, t, {{ flip:(run || w.back > 0 || w.rev > 0 ? right : !right) }})); if (!ok && hasArt && CHAR_H_OK(w.spr))"),
]
for a,b in H:
    n=s.count(a); assert n==1,(n,a); s=s.replace(a,b)
# draw: 喺 items 迴圈之後
a="for (const it of items) { if (it[1] === 0) drawW("
i=s.index(a); j=s.index("\n",i); s=s[:j]+f"\n      if ({F}) StnFoes.draw(c, this); // 強敵特效：封禁黃符／鎖鏈／倒數、電筒扇形、鹽米、光環、唸咒圈"+s[j:]
open(p,'w').write(s); print('ok', len(H)+1, 'hooks')
