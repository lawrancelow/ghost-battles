// 轉譯前對原 JS 做嘅修改：熱點交俾原生 GDScript、瀏覽器專屬部分換樁
module.exports = {
  // 線路 C：巡陰選單（準備畫面、揀主管、裝備房）交俾 Godot 原生介面（ui/patrol_menu）
  // 線路 D：回陽間・夜班嚇人——角色交俾原生 Art（每隻 JS ART.drawChar 約 9ms → 原生 <0.5ms）
  scare: [
    ['const NIGHT_SEC = 180;', "const NIGHT_SEC = 180;\nconst __scDC = (c, k, x, y, s, o) => typeof __nat_drawChar !== 'undefined' ? __nat_drawChar(c, k, x, y, s, o || {}) : ART['drawChar'](c, k, x, y, s, o);"],
    ['ART.drawChar(', '__scDC('],
    // 原生外殼（game/scare/sc_run.gd）：頂欄、小地圖、拖鏡頭、人物卡、出招列都係原生；畫面由原生喺 _draw 直接叫 draw()（唔經錄製器、唔經 DOM 排版）
    ["    this.last = performance.now(); requestAnimationFrame((n) => this.frame(n));", "    if (typeof __nat_scare !== 'undefined' && __nat_scare(this)) { this.resize(); if (site.pano) this.camX = this.clampCam(this.npcs[0].x - this.viewW() * 0.5); }\n    this.last = performance.now(); requestAnimationFrame((n) => this.frame(n));"],
    ["  resize() {", "  resize() { if (this._nat) { const r = __nat_scSize(); this.W = r[0]; this.H = r[1]; this.dpr = 1; return; }"],
    ["    const r = $('#sc-cvs').getBoundingClientRect(), mx", "    const r = this._nat ? { left:0, top:0 } : $('#sc-cvs').getBoundingClientRect(), mx"],
    ["    const c = $('#sc-cvs'); if (!c) return; const ctx = c.getContext('2d'); ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);", "    if (this._nat && !this._natCtx) return; const c = this._natCtx ? null : $('#sc-cvs'); if (!this._natCtx && !c) return; const ctx = this._natCtx || c.getContext('2d'); ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);"],
    ["    $('#sc-clock').textContent = ", "    if (this._nat) return;\n    $('#sc-clock').textContent = "],
    ["  drawNpc(ctx, n, t) {", "  drawNpc(ctx, n, t) { if (this._nat && typeof __nat_scNpc !== 'undefined' && !(this.office() && ((OFFICE.seated(n) && !n.out) || n.d.k === 'mis'))) { const r = __nat_scNpc(ctx, this, n, t); return { x:r.x, top:r.top }; }"],
    ["    if (!this.active) return; this.active = false;", "    if (!this.active) return; this.active = false; if (this._nat && typeof __nat_scEnd !== 'undefined') __nat_scEnd(this);"],
  ],
  office: [
    // 線路 D：家具、工位交俾原生（game/scare/sc_office.gd）；office.js 仍然負責狀態（tick）
    ['  return { elevator:', '  return { _n:{ st:() => st, STATIONS, items:() => items, drops:() => drops }, elevator:'],
    ['      if (it.chair) { out.push([it.y + (it.oz || 0), (ctx) => drawFreeChair(ctx, it, t)]); continue; }', "      if (it.chair) { out.push([it.y + (it.oz || 0), (ctx) => (SC._nat && typeof __nat_scItem !== 'undefined') ? __nat_scItem(ctx, SC, it, t, 'chair') : drawFreeChair(ctx, it, t)]); continue; }"],
    ['      out.push([it.z != null ? it.z : it.y, (ctx) => drawItem(ctx, it, t)]);', "      out.push([it.z != null ? it.z : it.y, (ctx) => (SC._nat && typeof __nat_scItem !== 'undefined') ? __nat_scItem(ctx, SC, it, t, '') : drawItem(ctx, it, t)]);"],
    ['(ctx) => { const keep = STN; use(s); drawKenChair(ctx, null, t); use(keep); }]); });', "(ctx) => { if (SC._nat && typeof __nat_scItem !== 'undefined') return __nat_scItem(ctx, SC, s, t, 'kenchair'); const keep = STN; use(s); drawKenChair(ctx, null, t); use(keep); }]); });"],
    ['  function drawKen(ctx, n, t) {', "  function drawKen(ctx, n, t) { if (SC && SC._nat && typeof __nat_scKen !== 'undefined') return __nat_scKen(ctx, SC, n, t);"],
    // 線路 D：全景只畫鏡頭附近嘅家具（以前成層 12 個畫面闊嘅工位每幀都畫）
    ['    for (const it of list) {', '    for (const it of list) { if (SC && SC._nat && SC.site && SC.site.pano && it.x != null && !SC.onScreen(it.x, 0.7)) continue;'],
  ],
  patrol: [
    // 線路 A：巡邏本身交俾 Godot 原生（game/patrol/pt_run.gd）；JS 只負責選單、劇情、存檔同規則函數
    ['  function begin(ci, z0) {', "  function begin(ci, z0) { if (typeof __nat_patrol !== 'undefined' && __nat_patrol(ci, z0)) return;"],
    ['  return { open:openPrep, openPrep, close,', "  return { _nat:{ CW, CH, COLS, ROWS, FOG, VIEW, GW, FAC, FAC_OF, REG, CH_FOD, TLAY, TGATE, TLAIR, TMAIN, TSECRET, TNAME, LM_N, LMNAME, TKING, TTIER, FACI0, TEA_CD, DOWN_T, MEET, SOLID, PROP, HUE, TC, CLOTH, ACC, RING, ATK, PH, st, regSt, startZ, sidOf, regionOpen, crewCap, troopTeams, crewList, leads, restRecover, facOf, phase, elitesOf, fodOf, pageGhosts, emit, setActive:(v) => { active = !!v; }, T:(a, b) => T(a, b) }, open:openPrep, openPrep, close,"],
    ['  function openPrep() {', "  function openPrep() { if (typeof __nat_patrolMenu !== 'undefined') { Patrol._menu = { st, regSt, crewList, leads, crewCap, troopTeams, regionOpen, sidOf, startZ, mkFaci, faci:() => FACI, TNAME, LMNAME, terOf, restRecover, start, intro, facOf, FAC, setMir:(ci) => { MIR = ci % 2 === 1; } }; if (__nat_patrolMenu('prep')) return; }"],
    ['  function open(b) { if (b) back = b; render(); }', "  function open(b) { if (typeof __nat_patrolMenu !== 'undefined') { Gear._menu = { st, nameOf, effText, craftCost, upCost, canPayAll, payAll, held, FK, WIMG, SLOTS }; if (__nat_patrolMenu('gear', b)) return; } if (b) back = b; render(); }"],
  ],
  meshanim: [
    ['function drawRaw(ctx, id, x, y, h, pose, flip) {', 'function drawRaw(ctx, id, x, y, h, pose, flip) { return __nat_meshDraw(ctx, id, RIG[id], x, y, h, pose, flip);'],
  ],
  // 線路 A：村子每幀畫面交俾 Godot 原生（ui/nv_village.gd）；JS 只出「物件清單」（打工鬼、廣場鬼、阿福嘅畫法閉包）
  game: [
    ['function start() {', 'function start() { return;'],
    ['    if (!covered()) Village.draw();', "    if (!covered() && typeof __nat_village === 'undefined') Village.draw();"],
    ['  scatterCrows(i) {', `  collect(ctx) {
    const t = this.t, items = [];
    const spots = this.workerSpots(); const vis = this.vis = [];
    for (const s of spots) vis.push({ g:s.g, x:s.x, y:s.y });
    const workInfo = { furnace:S.bld.furnace ? [POS.furnace[0], POS.furnace[1] - 22] : null };
    for (const s of spots) items.push({ y:s.y, kind:'work', s, f:() => typeof WORK !== 'undefined' ? WORK.drawWorker(ctx, s, t, 0.62, workInfo) : ART.drawChar(ctx, s.g.k, s.x, s.y, 0.62, { t:t + s.ph, work:true, flip:s.flip, tamed:true, untied:true }) });
    const idle = S.ghosts.filter(g => !g.post && g.k !== 'afu');
    const n0 = items.length;
    if (typeof PlazaLife !== 'undefined') PlazaLife.frame(this, idle, items, vis, ctx, t);
    for (let i = n0; i < items.length; i++) items[i].kind = items[i].kind || 'plaza';
    const H = this.hero;
    vis.push({ g:S.ghosts[0], x:H.x, y:H.y, hero:true });
    const hp = this.heroPose(), hd = typeof HeroDaily !== 'undefined' ? HeroDaily.opts(this) : null;
    items.push({ y:H.y, kind:'hero', f:() => ART.drawChar(ctx, 'afu', H.x, H.y, 0.72, Object.assign({ t, walk:H.walking, work:!!H.act, flip:H.dir < 0, mood:S.ended ? 'happy' : null, pose:hp[0], pt:hp[1] }, hd || {})) });
    return items;
  },
  scatterCrows(i) {`],
  ],
};
