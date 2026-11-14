// 轉譯前對原 JS 做嘅修改：熱點交俾原生 GDScript、瀏覽器專屬部分換樁
module.exports = {
  // 線路 C：巡陰選單（準備畫面、揀主管、裝備房）交俾 Godot 原生介面（ui/patrol_menu）
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
  game: [
    ['function start() {', 'function start() { return;'],
  ],
};
