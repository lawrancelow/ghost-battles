// 專屬招式登記表：MOVES[角色] = function(ctx, a) { ... }，a = {type,x,y,s,H,o,faceRight,solid,shadow}
// o.pose = windup/strike/follow/recover，o.pt = 0~1，o.tdx/o.tdy = 對手位置（相對自己，世界單位），o.t = 時間
// 回傳 false 代表這次不接手，照一般畫法。
const MOVES = {};
