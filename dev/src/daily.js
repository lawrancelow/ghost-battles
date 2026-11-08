// 平日動作登記表：DAILY[動作名] = function(ctx, a) {...}；a = {type,x,y,s,H,o,faceRight,solid,shadow}
// o.act = 動作名，o.at = 已經做了幾秒，o.t = 時間，o.prop = 可選道具。回傳 false = 不接手。
// 各分檔：daily_hero.js（阿福）、daily_work.js（岗位打工）、daily_plaza.js（广场闲逛与互动）、daily_town.js（冥街與陽間活人）
const DAILY = {};
