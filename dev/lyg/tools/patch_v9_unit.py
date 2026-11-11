# patch_v9_unit：由 patch_v5.py 引用；def patch(s) 收 pangsa.js 字串、回傳改好嘅字串
# 入屋模式（core/unit.js）接駁。全部 hook 用 // UNIT HOOK 標明；錨點唔見／唔唯一會 assert 報錯。
#  1. 建立模組（LIFT HOOK 1 之後）：將閉包變數交俾 window.UnitSys
#  2. update()：鬼喺屋入面 → 大樓唔再推進佢（計時器照行）
#  3. onArrive()：行到住戶 in 點 → 開室內介面
#  4. ctxAction()：門口出「入屋」／神明鎮宅「要尊重」
#  5. actPress()：處理上面嘅互動
#  6. worldTap()：撳住戶門／門上「入屋」掣
#  7. draw()：門口綠光、「入屋」掣、神明鎮宅紅燈、✓ 標記
#  8. taoUpdate()：屋入面嘅鬼唔受走廊鈴聲影響
#  9. frame()：室內介面蓋住全畫面時唔使畫大樓
def patch(s):
    if 'UNIT HOOK' in s: return s
    def R(a,b):
        nonlocal s
        assert s.count(a)==1,('v9 錨點唔見／唔唯一',a[:90],s.count(a)); s=s.replace(a,b)
    R("  window.LIFT=LIFT;\n",
      "  window.LIFT=LIFT;\n"
      "  // UNIT HOOK 1：入屋模式（core/unit.js）——只係將閉包變數交俾模組，模組自己行 rAF、自己開疊層 canvas\n"
      "  var UNIT=window.UnitSys?window.UnitSys({get G(){ return G; }, get LV(){ return LV; }, get FL(){ return FL; }, get FLN(){ return FLN; }, get IMG(){ return IMG; }, get scene(){ return scene; }, get paused(){ return paused; },\n"
      "    get VW(){ return VW; }, get VH(){ return VH; }, get TOP(){ return TOP; }, get BOT(){ return BOT; }, FONT:FONT, HH:HH, ITEM:ITEM, BAGMAX:BAGMAX, MV:MV, BLOCKMSG:BLOCKMSG, PH:PH, PHT:PHT, cv:cv,\n"
      "    fy:fy, rnd:rnd, float:float, toast:toast, say:say, addFear:addFear, scareRes:scareRes, takeItem:takeItem, onArrive:onArrive, unitOf:unitOf, doorBlock:doorBlock, ctxAction:ctxAction, actPress:actPress, gotoNode:gotoNode, noise:noise, checkAlert:checkAlert,\n"
      "    crPanel:crPanel, crText:crText, crBtn:crBtn, crBar:crBar, crGet:crGet, crBlit:crBlit}):null;\n"
      "  window.UNIT=UNIT;\n")
    R("g.sealT=Math.max(0,(g.sealT||0)-dt); g.dropT=Math.max(0,(g.dropT||0)-dt);",
      "g.sealT=Math.max(0,(g.sealT||0)-dt); g.dropT=Math.max(0,(g.dropT||0)-dt);\n      if (g.inUnit) return;   // UNIT HOOK 2：鬼喺屋入面，由 unit.js 推進")
    R("    if (n.kind==='portal'&&g.i===G.active) float(n.x,n.y-70,'陰門：企定按「開陰門」','#9fd6bf');",
      "    if (n.kind==='portal'&&g.i===G.active) float(n.x,n.y-70,'陰門：企定按「開陰門」','#9fd6bf');\n    if (UNIT&&n.kind==='in') UNIT.arrive(g,n);   // UNIT HOOK 3：入住戶 → 室內介面")
    R("    if (LIFT){ var la=LIFT.action(g,n); if (la) return la; }",
      "    if (UNIT){ var ua=UNIT.action(g,n); if (ua) return ua; }   // UNIT HOOK 4：門口「入屋」\n    if (LIFT){ var la=LIFT.action(g,n); if (la) return la; }")
    R("    if (a.k==='liftIn'){ LIFT.enter(g); return; }",
      "    if (a.k==='liftIn'){ LIFT.enter(g); return; }\n    if (UNIT&&UNIT.act(g,a)) return;   // UNIT HOOK 5")
    R("best=null, bd=40;",
      "best=null, bd=40;\n    if (UNIT&&UNIT.worldTap(wx,wy)) return;   // UNIT HOOK 6：撳門／「入屋」掣")
    R("    drawMoves();\n",
      "    drawMoves();\n    if (UNIT) UNIT.drawWorld(ctx);   // UNIT HOOK 7\n")
    R("if (G.nodes[g.node].f!==T.f) return;",
      "if (g.inUnit) return; if (G.nodes[g.node].f!==T.f) return;")
    R("    draw(); drawJoy(); }",
      "    if (!(UNIT&&UNIT.covering())){ draw(); drawJoy(); } }   // UNIT HOOK 9")
    return s
