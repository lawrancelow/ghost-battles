# v6：真機觸控修正（由 patch_v5.py 最尾引用；喺 LIFT HOOK 之後先打）
#  1. 嚇人：撳「嚇！」自動停低再出手；半路企喺兩個點中間都嚇得（自動行埋去最近住戶）；冇目標講清楚原因
#  2. 浮字：同一句唔重疊、1.5 秒冷卻、唔同句自動錯開
#  3. 輸入：底部 HUD 範圍嘅撳／拖永遠唔會變成移動；多隻手指時只認撳落嗰隻
def patch(s):
    def R(a,b,cnt=1):
        nonlocal s
        assert s.count(a)==cnt,('v6 錨點',a[:90],s.count(a)); s=s.replace(a,b)
    # ---------- 2. 浮字 ----------
    R("  function float(x,y,t,c){ G.floats.push({x:x,y:y,t:t,c:c||'#fff',life:1.6}); }",
"""  function float(x,y,t,c){ if (!G) return; var now=performance.now(), fc=G.fcd||(G.fcd={}), L0=fc[t];
    // 同一句：1.5 秒內喺附近唔再出；仲喺畫面上就唔再疊
    if (L0 && now-L0.t<1500 && Math.abs(L0.x-x)<260 && Math.abs(L0.y-y)<200) return;
    if (G.floats.some(function(f){ return f.t===t && Math.abs(f.x-x)<260 && Math.abs(f.y0-y)<200; })) return;
    fc[t]={t:now,x:x,y:y};
    // 唔同句喺同一位：自動向上錯開，唔會疊埋一舊
    var yy=y, k=0; while (k<4 && G.floats.some(function(f){ return Math.abs(f.x-x)<120 && Math.abs(f.y-yy)<17; })){ yy-=18; k++; }
    G.floats.push({x:x,y:yy,y0:y,t:t,c:c||'#fff',life:1.6}); if (G.floats.length>10) G.floats.shift(); }""")
    # ---------- 1. 嚇人 ----------
    i0=s.index("  function scarePress(){"); i1=s.index("  function part(x,y,vx,vy,life,type){")
    old=s[i0:i1]
    gpart=old[old.index("    g.scareCd=1.2; g.actT=0.9; g.dir=h.x>g.x?1:-1; G.shake=0.25;"):old.rindex("  }")]
    s=s[:i0]+"""  // 停低：取消搖桿、自動行；企定計時當已企定（撳掣嗰下鬼即刻停）
  function standStill(g){ g.auto=null; g.autoS=null; if (joy) joy=null; }
  function calm(g){ g.still=Math.max(g.still||0,0.12); g.mv=0; }
  // 由而家位置（可能喺兩點中間）行去 target：揀較近嗰頭，再沿路行
  function approach(g,target){
    if (!g.to){ if (g.node===target) return true; var ok=gotoNode(g,target); return ok; }
    var a=g.node, b=g.to, p=g.p, na=G.nodes[a], nb=G.nodes[b], E=Math.hypot(nb.x-na.x,nb.y-na.y);
    function plen(st,arr){ var L=0, c=G.nodes[st]; (arr||[]).forEach(function(k){ var m=G.nodes[k]; L+=Math.hypot(m.x-c.x,m.y-c.y); c=m; }); return L; }
    g.to=null; g.node=b; var okB=gotoNode(g,target), pB=g.auto; g.node=a; var okA=gotoNode(g,target), pA=g.auto; g.auto=null; g.node=a; g.to=b; g.p=p;
    var cB=okB?E*(1-p)+plen(b,pB):1e9, cA=okA?E*p+plen(a,pA):1e9; if (!okA&&!okB) return false;
    if (cA<cB){ g.node=b; g.to=a; g.p=1-p; g.auto=[a].concat(pA||[]); } else g.auto=[b].concat(pB||[]);
    return true; }
  function nearRes(g,R){ var f=G.nodes[g.node].f, best=null, bd=R; G.res.forEach(function(r){ if (r.state!=='home'||!r.unit||r.unit.f!==f) return; var d=Math.abs(r.x-g.x); if (d<bd){ bd=d; best=r; } }); return best; }
  function doorBlock(g,un){ var dn=G.nodes[un.did], l=dn&&dn.links.find(function(l){return l.to===un.id;}); if (!l) return 'door'; var ok=canPass(g,l.e); return ok===true?null:ok; }
  function scarePress(){
    var g=G.gh[G.active]; if (!g||g.home||g.out) return;
    if (LIFT&&LIFT.state&&(LIFT.state()||{}).gi===g.i) return;
    if (g.sc) return;
    if (g.scareCd>0){ float(g.x,g.y-80,'啱啱嚇完，等陣先','#dddddd'); return; }
    if (g.stun>0){ float(g.x,g.y-80,g.dropT>0?'跌咗落嚟，等陣先嚇得':g.countT>0?'數緊綠豆，數完先嚇得':'暈緊，等陣先嚇得','#ffd54a'); return; }
    standStill(g);
    if (g.sealT>0){ float(g.x,g.y-80,'鈴聲未散，暫時嚇唔到人','#ffe9a0'); return; }
    if (mirrorOn(g)){ float(g.x,g.y-80,'被鏡照住，嚇唔出','#ffe9a0'); return; }
    var n=G.nodes[g.node];
    if (!g.to && n.kind==='in'){ var un0=unitOf(n.id); if (un0.res&&un0.res.state==='home'){ calm(g); startMove(g,un0.res,un0); return; } }
    var h=null, bd=90; G.guards.forEach(function(o){ if (o.state==='flee'||o.state==='gone') return; if (Math.abs(o.y-g.y)>30) return; var d=Math.abs(o.x-g.x); if (d<bd){ bd=d; h=o; } });
    // 住戶：優先揀最近而又入得嘅一戶；全部入唔到先講原因
    var f0=n.f, cands=G.res.filter(function(q){ return q.state==='home'&&q.unit&&q.unit.f===f0&&Math.abs(q.x-g.x)<260; }).sort(function(a,b){ return Math.abs(a.x-g.x)-Math.abs(b.x-g.x); });
    var r=null, blocked=null; for (var ci=0;ci<cands.length;ci++){ var cq=cands[ci], wq=doorBlock(g,cq.unit); if (!wq){ r=cq; break; } if (!blocked&&Math.abs(cq.x-g.x)<190) blocked={r:cq,why:wq}; }
    if (h && (!r || Math.abs(h.x-g.x)<=Math.abs(r.x-g.x)+20)){ calm(g); scareGuard(g,h); return; }
    if (LIFT&&LIFT.scareWaiting){ var lw=LIFT.scareWaiting(g); if (lw){ calm(g); g.scareCd=1.2; g.actT=0.9; G.shake=0.25; return; } }
    if (r){ var un=r.unit, tr=un.res&&un.res.state==='home'?un.res:r;
      if (approach(g,un.id)){ g.autoS={r:tr}; if (!g.to&&!(g.auto&&g.auto.length)){ calm(g); g.autoS=null; startMove(g,tr,un); return; } float(tr.x,tr.y-86,'飄埋去嚇'+(HH[tr.hh]?HH[tr.hh].n:'住戶'),'#ffb7a0'); return; }
      float(r.x,r.y-80,'嚇唔到：行唔到入呢戶','#ffb0b0'); return; }
    if (blocked){ float(g.x,g.y-80,'嚇唔到——'+(BLOCKMSG[blocked.why]||'呢戶未入得'),'#ffb0b0'); return; }
    var f=n.f, some=G.res.some(function(q){ return q.state==='home'&&q.unit&&q.unit.f===f; }), out=G.res.some(function(q){ return q.unit&&q.unit.f===f&&Math.abs(q.x-g.x)<190&&(q.state==='away'||q.state==='leave'||q.state==='back'); });
    float(g.x,g.y-80,out?'佢出咗門，唔喺屋企':some?'附近冇人：行近住戶（或者撳住戶）先嚇':'呢層冇人喺屋企','#dddddd');
  }
  function scareGuard(g,h){
"""+gpart+"""  }
"""+s[i1:]
    # 做嘢／開陰門：撳掣即當企定
    R("    if (g.still<0.1){ float(g.x,g.y-80,'鬆手企定先做得','#ffd54a'); return; }",
      "    standStill(g); if (g.to){ float(g.x,g.y-80,'行到位先做得','#ffd54a'); return; } calm(g);")
    R("if (g.still<0.1){ float(g.x,g.y-80,'企定先開得陰門','#ffd54a'); return; }","standStill(g); calm(g);")
    # 自動行埋去嚇：中途暈／數綠豆唔好甩咗個目標，醒返先出手
    R("if (g.autoS && !g.to && !(g.auto&&g.auto.length) && g.still>=0.12){","if (g.autoS && !g.to && !(g.auto&&g.auto.length) && g.still>=0.12 && g.stun<=0 && g.scareCd<=0){")
    # 搭緊𨋢（面板開住）：鏡頭將𨋢口擺喺面板中間嘅透明帶，見到世界剖面嘅鋼門開關
    R("fyc=cam.free?cam.free.y:g.y, ty=clamp(fyc-viewH*0.55,0,Math.max(0,WH-viewH+70)),",
      "fyc=cam.free?cam.free.y:g.y, LB=(!cam.free&&LIFT&&LIFT.band)?LIFT.band():null, ty=LB?fyc-(LB.y1-14-TOP)/S:clamp(fyc-viewH*0.55,0,Math.max(0,WH-viewH+70)),")
    # ---------- 3. 輸入 ----------
    R("function tap(x,y){ LASTP={x:x,y:y}; var b=hitBtn(x,y); if (b){ press(b.id); return; } if (scene==='play'&&G&&!G.over&&!G.choice&&!G.showStory) worldTap(x,y); }",
      "function tap(x,y){ LASTP={x:x,y:y}; var b=hitBtn(x,y); if (b){ press(b.id); return; } if (scene==='play'&&G&&!G.over&&!G.choice&&!G.showStory&&y>TOP&&y<VH-BOT) worldTap(x,y); }")
    R("ptr={sx:p.x,sy:p.y,drag:false,btn:hb.id}; joy=null;","ptr={sx:p.x,sy:p.y,drag:false,btn:hb.id,id:e.pointerId}; joy=null;")
    R("ptr={sx:p.x,sy:p.y,drag:false}; if (scene==='play'&&!G.over&&!G.choice&&!G.showStory&&p.y>TOP&&p.y<VH-BOT) joy=",
      "ptr={sx:p.x,sy:p.y,drag:false,id:e.pointerId,hud:p.y>=VH-BOT||p.y<=TOP}; if (scene==='play'&&!G.over&&!G.choice&&!G.showStory&&p.y>TOP&&p.y<VH-BOT) joy=")
    R("if(!ptr) return; if (!ptr.btn&&","if(!ptr||ptr.id!==e.pointerId) return; if (!ptr.btn&&")
    R("var p=pt(e), was=ptr; ptr=null; var j=joy&&joy.on; joy=null;",
      "if (ptr&&ptr.id!=null&&ptr.id!==e.pointerId) return; var p=pt(e), was=ptr; ptr=null; var j=joy&&joy.on; joy=null; if (j&&scene==='play'&&G&&!G.over) settleNear(G.gh[G.active],44);")
    R("  function pt(e){","  // 搖桿鬆手時離最近嗰點好近：自動行埋去，唔好卡喺兩點中間\n  function settleNear(g,R0){ if (!g||!g.to||g.home||g.out) return; var a=G.nodes[g.node], b=G.nodes[g.to], E=Math.hypot(b.x-a.x,b.y-a.y); if (E*(1-g.p)<=R0) g.auto=[g.to]; else if (E*g.p<=R0){ var t=g.node; g.node=g.to; g.to=t; g.p=1-g.p; g.auto=[t]; } }\n  function pt(e){")
    return s
