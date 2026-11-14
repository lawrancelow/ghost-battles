// 轉譯前對原 JS 做嘅修改：熱點交俾原生 GDScript、瀏覽器專屬部分換樁
module.exports = {
  // 線路 C：巡陰選單（準備畫面、揀主管、裝備房）交俾 Godot 原生介面（ui/patrol_menu）
  patrol: [
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
