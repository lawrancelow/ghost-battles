// 轉譯前對原 JS 做嘅修改：熱點交俾原生 GDScript、瀏覽器專屬部分換樁
module.exports = {
  meshanim: [
    ['function drawRaw(ctx, id, x, y, h, pose, flip) {', 'function drawRaw(ctx, id, x, y, h, pose, flip) { return __nat_meshDraw(ctx, id, RIG[id], x, y, h, pose, flip);'],
  ],
  game: [
    ['function start() {', 'function start() { return;'],
  ],
};
