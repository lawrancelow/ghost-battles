# 電梯系統（core/lift.js）接駁清單

lift.js 係獨立模組，自己行 requestAnimationFrame、自己開疊層（世界剖面 canvas＋𨋢內 HTML 面板），**唔使改 draw()/update()/frame()/輸入**。
pangsa.js 只需要 3 個 hook（全部用 `// LIFT HOOK` 標明），另加 build 載入 lift.js。
`tools/apply_lift_hooks.py` 會自動將以下 3 個 hook 插入一份**臨時副本**（唔改 src/pangsa.js）並砌 `/tmp/claude-0/out/GhostTower_Lift.html`；錨點唔見會 assert 報錯。

## Hook 1：建立模組（IIFE 尾，`window.TW={` 呢句**之前**）
```js
  // LIFT HOOK 1：電梯系統（core/lift.js）接駁——只係將閉包變數交俾模組，模組自己行 rAF
  var LIFT=window.LiftSys?window.LiftSys({get G(){return G;}, get LV(){return LV;}, get FL(){return FL;}, get FLN(){return FLN;}, get IMG(){return IMG;}, get scene(){return scene;}, get paused(){return paused;},
    get VW(){return VW;}, get VH(){return VH;}, get TOP(){return TOP;}, get BOT(){return BOT;}, FONT:FONT, HUM:HUM, HH:HH, cv:cv, fy:fy, rnd:rnd, float:float, toast:toast, say:say, addFear:addFear, noise:noise, spook:spook, W2S:W2S}):null;
  window.LIFT=LIFT;
```
用到嘅 pangsa 名：G LV FL FLN IMG scene paused VW VH TOP BOT FONT HUM HH cv fy rnd float toast say addFear noise spook W2S。B 如果改名，要同步改呢度。

## Hook 2：`function ctxAction(g)` 入面
喺呢句**之前**：
```js
    if (n.kind==='lift'&&LV.lift&&(G.liftCd||0)<=0) return {k:'lift',t:'叫𨋢自己上落'};
```
插入：
```js
    if (LIFT){ var la=LIFT.action(g,n); if (la) return la; }   // LIFT HOOK 2：𨋢口出「入𨋢」
```
（有𨋢嘅樓會取代舊「叫𨋢自己上落」；舊引開保安效果保留喺新系統：空𨋢「叮」一聲喺某層開門會 `noise(該層𨋢口,2)` 引保安。老店屋 LV.lift=false，行返舊邏輯。）

## Hook 3：`function actPress()` 入面
喺呢句**之後**：
```js
    if (g.still<0.1){ float(g.x,g.y-80,'鬆手企定先做得','#ffd54a'); return; }
```
插入：
```js
    if (a.k==='liftIn'){ LIFT.enter(g); return; }   // LIFT HOOK 3：入𨋢／叫𨋢
```

## Build：載入 lift.js（喺遊戲之前）
build_play.py 而家將 `/*SIM*/` 換成空字串；改成換入 core/lift.js：
```python
.replace('/*SIM*/',open(f'{D}/core/lift.js',encoding='utf-8').read())
```

## 模組同遊戲狀態嘅互動（俾 B 留意）
- 搭𨋢期間，住戶會暫時由 `G.res` 移走（`r.state='lift'`），保安由 `G.guards` 移走；落𨋢／返屋企／由機房返嚟先放返入去。所以 `G.res`、`G.guards` 長度會變。
- 鬼喺𨋢入面：每幀釘住 `g.node='f{層}_l'`、`g.to=null`、`g.auto=null`，閂門時 `g.inv>=0.15`（保安睇唔到、捉唔到）。
- 座標全部讀 `LV.xs` 入面 `'lift'` 欄、`fy()`、`FL`，冇寫死尺寸；𨋢去 B(0)…頂住宅層(FL-1)，天台行樓梯。
- 𨋢內 UI 疊喺 canvas 上面：上面 `TOP` 以下係𨋢廂內景＋嚇人掣，下面 `BOT` 高係樓層面板，中間透明擋板擋住搖桿／點地圖。揀卡、故事、結局彈出時自動收起。
- 測試介面：`LIFT.state() / press(f) / open() / close() / exit() / trick(k) / step(dt) / debugRider(kind,f,dest) / setPos(f) / noSpawn()`，`LIFT.manual=true` 停自動推進。
