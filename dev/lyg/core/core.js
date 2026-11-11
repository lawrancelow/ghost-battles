  var G=null, scene='title', paused=false;
  var PHT=60;                                         // 每個時辰秒數
  var HUM={guard:{n:'保安',sp:58,spr:'npc_guard',h:62}, compass:{n:'羅盤保安',sp:62,spr:'npc_guard',h:64}, mirror:{n:'鏡子道士',sp:52,spr:'npc_boss',h:62}, decoy:{n:'道士',sp:50,spr:'npc_boss',h:62}, dog:{n:'看門狗',sp:190,spr:null,h:30}};
  var ITEM={food:{n:'宵夜',t:0.8,who:'eking'}, money:{n:'銀包',t:1.3,who:'toyol'}, comb:{n:'木梳',t:1.6,who:'tianhua'}, doll:{n:'替身紙人',t:2.0}, key:{n:'鎖匙',t:2.6}};
  var BAGMAX=10;
  function newGame(s,lv){
    if (lv) curLv=lv; useLevel(curLv);
    seed=s||((Date.now()%100000)+7); used={};
    G={t:0, phase:0, nodes:{}, edges:[], units:[], res:[], guards:[], floats:[], fear:0, fearNext:30, fearTotal:0,
       mods:{spd:1,pow:1,inv:3,task:1,arm:1,fear:1}, story:[], active:0, over:null, choice:null, toast:null, toastT:0, alarm:[],
       alert:0, alertLv:0, bag:[], dolls:0, keys:{}, wave:0, waveT:20, gate:null, gateCharge:0, captured:0};
    buildMap(); placeUnits();
    G.gh=GH.map(function(d,i){ return {d:d, i:i, node:'f0_e', to:null, p:0, x:0, y:0, dir:1, loot:0, taskP:0, inv:0, invCd:0, stun:0, scareCd:0, home:false, energy:0, actT:0, hitT:0, bounceT:0, mv:0, ph:Math.random()*6, still:1, caught:0, out:false, mirrored:0}; });
    G.gh.forEach(function(g){ var n=G.nodes[g.node]; g.x=n.x; g.y=n.y; });
    G.parts=[]; G.ult=null; G.wardFx=[]; G.dark={};
    G.guards.push(mkHuman('guard',LV.guard0));
    scene='play'; paused=false;
    toast(LV.name+'：拖動摇桿郁鬼，鬆手企定先嚇得人、搜得嘢。開新一戶全樓會更警覺；集齊6個替身紙人可以隨時遁走，或者去陰門企穩30秒帶晒收穫返去。');
  }
  var curLv='flat';
  function node(id,x,y,f,kind){ G.nodes[id]={id:id,x:x,y:y,f:f,kind:kind,links:[]}; }
  function link(a,b,ward){ var e={a:a,b:b,ward:ward||null}; G.edges.push(e); G.nodes[a].links.push({to:b,e:e}); G.nodes[b].links.push({to:a,e:e}); return e; }
  function buildMap(){
    for (var f=0;f<=FL;f++){
      var y=fy(f); node('f'+f+'_s',SX,y,f,'stair'); node('f'+f+'_l',f===0?GLX:LX,y,f,'lift');
      if (f<FL){ var stops=LV.units.filter(function(L){return L[0]===f;}).map(function(L){ return {x:L[7],u:L[1]}; });
        if (f===0) stops.push({x:PX0,p:1}); stops.sort(function(a,b){return a.x-b.x;});
        var prev='f'+f+'_s';
        stops.forEach(function(st){ var id; if (st.p){ id='f0_e'; node(id,st.x,y,0,'portal'); } else { id='f'+f+'_d'+st.u; node(id,st.x,y,f,'door'); node('f'+f+'_i'+st.u,st.x-14,y-34,f,'in'); var e=link(id,'f'+f+'_i'+st.u); e.door=true; }
          link(prev,id); prev=id; });
        link(prev,'f'+f+'_l');
      } else { node('f'+FL+'_p',300,y,f,'portal'); link('f'+FL+'_s','f'+FL+'_p'); link('f'+FL+'_p','f'+FL+'_l'); }
      if (f>0){ link('f'+(f-1)+'_s','f'+f+'_s').vert=true; link('f'+(f-1)+'_l','f'+f+'_l').vert=true; }
    }
  }
  // 開門方式（照原作 openType 反轉）：0 開局入得 / 1 連鎖（隔籬戶住客被嚇走先人心惶惶，入得但係黑屋）/ 2 用怕意逐點注入破鎮宅 / 11 要先偷到對應物件 / deity 神明鎮宅永遠唔入得
  function placeUnits(){
    var keyUnit=null;
    LV.units.forEach(function(L){ var f=L[0],u=L[1],w=L[2];
      var id='f'+f+'_i'+u, did='f'+f+'_d'+u, e=G.nodes[did].links.find(function(l){return l.to===id;}).e; e.ward=w;
      var un={f:f,u:u,id:id,did:did,ward:w,task:L[3],story:L[5]>=0,si:L[5],name:L[6],x:G.nodes[did].x,y:fy(f),rx:L[8],lit:false,litT:0,
        open:true,ot:0,cost:0,paid:0,seen:false,entered:false,plus:L[5]>=0?2:1,items:[],door:false,doorOpen:0,ambush:null,dep:null,keyNeed:null};
      if (w==='fu'||w==='menshen'||w==='datuk'){ un.open=false; un.ot='deity'; }
      else if (w==='zha'){ un.open=false; un.ot=2; un.cost=14; }
      else if (w==='nuomi'){ un.open=false; un.ot=2; un.cost=10; }
      if (L[3]) un.items.push(L[3]); if (L[3]==='food'||L[3]==='money') un.items.push(L[3]);
      G.units.push(un); e.unit=un;
      if (L[4]){ var cx=(un.rx[0]+un.rx[1])/2, rxp=Math.abs(cx-un.x)<30?cx-34:cx;
        var r={unit:un,sprite:L[4],x:rxp,y:fy(f)-16,fear:0,brave:0,state:'home',vx:0,doorT:8+rnd()*10}; G.res.push(r); un.res=r; }
    });
    // 連鎖：同層冇鎮宅、無任務嘅故事戶 → 靠隔籬戶嚇走人先開；樓上嘅故事戶要鎖匙（openType 11）
    var top=G.units.filter(function(u){return u.story&&u.ot===0;}).sort(function(a,b){return b.f-a.f;})[0];
    if (top){ top.open=false; top.ot=11; top.keyNeed='key'; keyUnit=top; }
    G.units.forEach(function(u){ if (u.ot!==0||u.f===0||u===top) return; var nb=G.units.filter(function(v){return v.f===u.f&&v!==u&&v.res&&v.ot!=='deity';})[0];
      if (nb&&u.story){ u.open=false; u.ot=1; u.dep=nb; } });
    // 物件：替身紙人散落、鎖匙放喺另一戶
    var cand=G.units.filter(function(u){return u.ot!=='deity'&&u!==keyUnit;});
    shuffle(cand).slice(0,1).forEach(function(u){ u.items.push('key'); });
    var dolls=0; shuffle(cand).forEach(function(u){ if (dolls<7){ u.items.push('doll'); dolls++; } });
    // 門：部分住戶夜晚鎖門，住客行出門口先開
    G.units.filter(function(u){return u.res&&u.ot===0&&u.f>0;}).slice(0,2).forEach(function(u){ u.door=true; });
    // 黑屋伏擊：一戶冇人嘅屋有隻醒住嘅看門狗
    var amb=G.units.filter(function(u){return !u.res&&u.ot!=='deity';})[0]||G.units.filter(function(u){return u.ot===2;})[0];
    if (amb) amb.ambush='dog';
  }
  function unitByDoor(did){ for (var i=0;i<G.units.length;i++) if (G.units[i].did===did) return G.units[i]; return null; }
  function unitOf(id){ for (var i=0;i<G.units.length;i++) if (G.units[i].id===id) return G.units[i]; return null; }
  function mkHuman(kind,nodeId,extra){ var n=G.nodes[nodeId]; var h={kind:kind,node:nodeId,to:null,p:0,x:n.x,y:n.y,dir:1,wait:1,talkT:3+rnd()*5,courage:kind==='compass'?5:kind==='decoy'?2:1,path:null,repath:0,chase:null,alertT:0,state:'patrol'}; for (var k in extra||{}) h[k]=extra[k]; return h; }
  function toast(m){ G.toast=m; G.toastT=5.5; }
  function float(x,y,t,c){ G.floats.push({x:x,y:y,t:t,c:c||'#fff',life:1.6}); }

  // ---------- 通行規則 ----------
  function shortcut(g,e){ return e.ward && g.d.cross[e.ward]; }       // Toyol 鑽鐵閘管道、天花姐行天花過糯米
  function canPass(g,e){
    if (G.gate && e.vert && (G.nodes[e.a].f===G.gate.f||G.nodes[e.b].f===G.gate.f)) return 'stairSeal';
    if (!e.door) return true; var un=e.unit;
    if (un.ot==='deity') return 'deity';
    if (!un.open && !shortcut(g,e)) return un.ot===2?'breach':un.ot===11?'key':'chain';
    if (un.door && un.doorOpen<=0 && !shortcut(g,e)) return 'door';
    return true;
  }
  var BLOCKMSG={deity:'呢度有神明鎮宅，要尊重，繞路', breach:'鎮宅未破：企定喺門口注入怕意', key:'要先喺別戶偷到鎖匙', chain:'隔籬戶未亂，呢度仲未入得', door:'度門閂住，等住客開門嗰下先入', stairSeal:'陰門開咗，樓梯封住'};
  function humanPass(h,e){ if (h.kind==='dog' && e.door && e.unit.door && e.unit.doorOpen<=0) return false; if (e.door && e.unit.ot==='deity') return false; return true; }

  // ---------- 鬼移動（企定 vs 移動二選一）----------
  function joyMove(g,jx,jy,dt){
    if (g.stun>0||g.home||g.out) return;
    var L=Math.hypot(jx,jy); if (L<0.25) return; jx/=L; jy/=L;
    var mt=mirrorOn(g); if (mt && Math.sign(mt.x-g.x)===Math.sign(jx) && Math.abs(jx)>0.3){ if (!g.blockT||g.blockT<=0){ float(g.x,g.y-80,'被鏡照住！轉身先走得','#ffe9a0'); g.blockT=1; } return; }
    var sp=g.d.sp*G.mods.spd;
    if (!g.to){ var n=G.nodes[g.node], best=null, bd=0.55;
      n.links.forEach(function(l){ var m=G.nodes[l.to], dx=m.x-n.x, dy=m.y-n.y, D=Math.hypot(dx,dy), dot=(dx*jx+dy*jy)/D; if (Math.abs(dy)>Math.abs(dx)) dot+=0.12; if (dot>bd){ bd=dot; best=l; } });
      if (!best) return;
      var ok=canPass(g,best.e);
      if (ok!==true){ if (!g.blockT||g.blockT<=0){ float(n.x,n.y-80,BLOCKMSG[ok],'#ffd54a'); g.blockT=1.4; g.bounceT=0.45; if (ok==='deity') G.wardFx.push({x:n.x,y:n.y,t:0.9}); } return; }
      g.to=best.to; g.p=0;
    }
    var a=G.nodes[g.node], b=G.nodes[g.to], dx=b.x-a.x, dy=b.y-a.y, D=Math.hypot(dx,dy), dot=(dx*jx+dy*jy)/D;
    if (dot<-0.3){ var t=g.node; g.node=g.to; g.to=t; g.p=1-g.p; return; }
    g.p+=sp*dt/D; if (dx) g.dir=dx>0?1:-1; g.still=0; g.taskP=0;
    if (g.p>=1){ g.node=g.to; g.to=null; g.p=0; onArrive(g); }
  }
  function posOf(o){ var a=G.nodes[o.node]; if (!o.to) return {x:a.x,y:a.y}; var b=G.nodes[o.to]; return {x:a.x+(b.x-a.x)*o.p, y:a.y+(b.y-a.y)*o.p}; }
  function onArrive(g){
    var n=G.nodes[g.node];
    if (n.kind==='in'){ var un=unitOf(n.id); if (!un.entered){ un.entered=true; un.seen=true; G.alert+=un.plus; float(n.x,n.y-90,'全樓警覺 +'+un.plus,'#ff9a9a'); checkAlert();
        if (un.ambush==='dog'){ un.ambush=null; var d=mkHuman('dog',un.did,{state:'chase'}); d.alertT=1.4; G.guards.push(d); G.shake=0.4; float(n.x,n.y-110,'黑屋有隻狗醒咗！','#ffb0b0'); G.alert+=1; } } }
    if (n.kind==='portal'&&g.i===G.active) float(n.x,n.y-70,'陰門：企定按「開陰門」','#9fd6bf');
  }
  function gotoNode(g,target){
    var prev={}, q=[g.node], seen={}; seen[g.node]=1;
    while(q.length){ var c=q.shift(); if (c===target) break; G.nodes[c].links.forEach(function(l){ if (!seen[l.to] && canPass(g,l.e)===true){ seen[l.to]=1; prev[l.to]=c; q.push(l.to); } }); }
    if (!seen[target]) return false; var path=[target]; while(path[0]!==g.node) path.unshift(prev[path[0]]); g.auto=path.slice(1); return true;
  }
  // 人類 Dijkstra（同鬼共用一張圖）
  function dijkstra(h,src,dst){
    var dist={}, prev={}, Q=Object.keys(G.nodes); Q.forEach(function(k){dist[k]=1e9;}); dist[src]=0;
    while(Q.length){ var bi=0; for (var i=1;i<Q.length;i++) if (dist[Q[i]]<dist[Q[bi]]) bi=i; var u=Q.splice(bi,1)[0]; if (u===dst||dist[u]>=1e9) break;
      G.nodes[u].links.forEach(function(l){ if (!humanPass(h,l.e)) return; var a=G.nodes[u], b=G.nodes[l.to], w=Math.hypot(a.x-b.x,a.y-b.y); if (dist[u]+w<dist[l.to]){ dist[l.to]=dist[u]+w; prev[l.to]=u; } }); }
    if (dist[dst]>=1e9) return null; var p=[dst]; while(p[0]!==src) p.unshift(prev[p[0]]); return p.slice(1);
  }
  function mirrorOn(g){ var m=null; G.guards.forEach(function(h){ if (h.kind!=='mirror'||h.state==='gone') return; if (Math.abs(h.y-g.y)>40) return; var dx=g.x-h.x; if (Math.abs(dx)>220) return; if (Math.sign(dx)===h.dir && g.dir===-h.dir) m=h; }); return m; }

  // ---------- 主更新 ----------
  function update(dt){
    if (G.over||G.choice||paused) return;
    if (G.ult){ G.ult.t+=dt; if (G.ult.t<1.3){ stepFx(dt); return; } if (!G.ult.done){ G.ult.done=true; applyUlt(G.ult); } if (G.ult.t>4){ G.ult=null; G.ultCool=1.5; } }
    G.t+=dt; var np=Math.min(3,Math.floor(G.t/PHT));
    if (np!==G.phase){ G.phase=np; toast(np<3?PH[np]+'到喇——巡邏加派，越近天光人越精。':'天光喇！樓下開始有人起身，追兵越嚟越快，快啲走！'); }
    G.toastT-=dt;
    // 波次：每個時辰入面定時加派巡邏，天光後指數加強
    G.waveT-=dt; if (G.waveT<=0 && !G.gate){ G.wave++; G.waveT=G.phase>=3?18:30; var f=1+Math.floor(rnd()*(FL-1)); var h=mkHuman('guard','f'+f+'_'+(rnd()<0.5?'s':'l')); h.boost=G.phase>=3?Math.pow(1.15,G.wave):1; G.guards.push(h); float(h.x,h.y-80,'加派保安','#ffb0b0'); }
    G.gh.forEach(function(g){ if (g.home||g.out) return;
      g.blockT=(g.blockT||0)-dt; g.inv=Math.max(0,g.inv-dt); g.invCd=Math.max(0,g.invCd-dt); g.stun=Math.max(0,g.stun-dt); g.scareCd=Math.max(0,g.scareCd-dt);
      g.actT=Math.max(0,g.actT-dt); g.hitT=Math.max(0,g.hitT-dt); g.bounceT=Math.max(0,g.bounceT-dt); g.sealT=Math.max(0,(g.sealT||0)-dt);
      if (g.auto&&g.auto.length){ var nx=g.auto[0];
        if (!g.to){ if (g.node===nx) g.auto.shift(); else { var ln=G.nodes[g.node].links.find(function(l){return l.to===nx;}); if (ln&&canPass(g,ln.e)===true){ g.to=nx; g.p=0; } else g.auto=null; } }
        if (g.to){ var a=G.nodes[g.node], b=G.nodes[g.to], D=Math.hypot(b.x-a.x,b.y-a.y); g.p+=g.d.sp*G.mods.spd*dt/D; g.still=0; g.taskP=0; if (b.x!==a.x) g.dir=b.x>a.x?1:-1; if (g.p>=1){ g.node=g.to; g.to=null; g.p=0; if (g.auto&&g.auto[0]===g.node) g.auto.shift(); onArrive(g); } } }
      var p=posOf(g); g.mv=Math.max(0,g.mv-dt); if (Math.abs(p.x-g.x)+Math.abs(p.y-g.y)>0.2){ g.mv=0.18; g.still=0; } else g.still+=dt; g.x=p.x; g.y=p.y;
      var n=G.nodes[g.node], st=!g.to&&g.still>=0.1&&g.stun<=0&&!mirrorOn(g);
      // 搜刮讀條：逐件、越值錢越耐、收穫有格數上限
      if (st && n.kind==='in'){ var un=unitOf(n.id);
        if (un.lit){ float(g.x,g.y-70,'開咗燈！被逼返出去','#ffb0b0'); g.node=un.did; g.stun=0.6; loseLoot(g,0.3); }
        else { var it=un.items.find(function(k){ var I=ITEM[k]; return !I.who||I.who===g.d.key; });
          if (it){ if (it!=='doll'&&it!=='key'&&G.bag.length>=BAGMAX){ if (!g.fullT||g.fullT<=0){ float(g.x,g.y-80,'收穫格滿咗！','#ffb0b0'); g.fullT=2; } g.fullT-=dt; }
            else { g.taskP+=dt*G.mods.task/ITEM[it].t; if (rnd()<dt*14) part(g.x+(rnd()-0.5)*20,g.y-g.d.h*0.5,(rnd()-0.5)*60,-40-rnd()*40,0.7,{eking:'crumb',toyol:'coin',tianhua:'hair'}[g.d.key]);
              if (g.taskP>=1){ g.taskP=0; un.items.splice(un.items.indexOf(it),1); takeItem(g,it,un); } } }
          if (un.res && un.res.state==='home'){ un.res.fear+=dt*3*G.mods.pow; if (un.res.fear>=100) flee(un.res,g); } } }
      else if (!st) g.taskP=0;
      // 破鎮宅：企喺門口 0.5 秒後每 0.1 秒注入 1 點怕意，離開保留進度
      if (!g.to && n.kind==='door'){ var du=unitByDoor(n.id); g.injT=(g.injT||0)+(st?dt:-99); if (du && !du.open && du.ot===2 && g.injT>=0.5){ g.injAcc=(g.injAcc||0)+dt; while (g.injAcc>=0.1 && G.fear>0 && du.paid<du.cost){ g.injAcc-=0.1; G.fear--; du.paid++; if (rnd()<0.6) part(g.x,g.y-40,(du.x-g.x)*2,-20,0.5,'suck'); }
          if (du.paid>=du.cost){ unlockUnit(du,'鎮宅破咗！'); } else if (G.fear<=0 && (!g.blockT||g.blockT<=0)){ float(g.x,g.y-80,'怕意唔夠，去嚇多啲人','#ffd54a'); g.blockT=1.5; } }
        if (du && !du.open && du.ot===11 && st && G.keys.key){ G.keys.key--; unlockUnit(du,'用鎖匙開咗門'); } }
      else g.injT=0;
    });
    // 住客：夜晚行出門口（開門窗口）、逃走
    G.res.forEach(function(r){
      r.jumpT=Math.max(0,(r.jumpT||0)-dt); r.tangle=Math.max(0,(r.tangle||0)-dt);
      if (r.state==='flee'){ if (r.tripT>0){ r.tripT-=dt; r.x+=r.vx*0.18*dt; } else r.x+=r.vx*dt; if (r.x<SX||r.x>LX) r.state='gone'; if (rnd()<dt*8) part(r.x-Math.sign(r.vx)*10,r.y-4,-r.vx*0.1,-10,0.5,'dust'); }
      if (r.state==='home' && r.unit.door){ r.doorT-=dt; if (r.doorT<=0){ r.unit.doorOpen=2.6; r.doorT=12+rnd()*8; say(r,pick(['出去倒杯水先','邊個喺門口？','開門透下氣'])); } }
      if (r.unit.doorOpen>0) r.unit.doorOpen-=dt;
    });
    if (G.phase>=2) G.units.forEach(function(un){ un.litT-=dt; if (un.res&&un.res.state==='home'&&!un.lit&&rnd()<dt*0.04){ un.lit=true; un.litT=7; say(un.res,line('wake')); } if (un.lit&&un.litT<=0) un.lit=false; });
    G.guards.forEach(function(h){ humanUpdate(h,dt); }); G.guards=G.guards.filter(function(h){return h.state!=='gone';});
    G.ultCool=Math.max(0,(G.ultCool||0)-dt);
    if (G.choiceQ>0 && !G.ult && G.ultCool<=0){ G.choiceQ--; G.choice=shuffle(CARDS).slice(0,3); }
    taoUpdate(dt); gateUpdate(dt);
    stepFx(dt);
    G.floats.forEach(function(f){ f.life-=dt; f.y-=dt*22; }); G.floats=G.floats.filter(function(f){return f.life>0;});
    G.res.forEach(function(r){ if (r.say){ r.sayT-=dt; if (r.sayT<=0) r.say=null; } });
    if (G.gh.every(function(g){return g.out;})) endNight('fail');
  }
  function takeItem(g,it,un){
    if (it==='doll'){ G.dolls++; float(g.x,g.y-90,'替身紙人 '+G.dolls+'/6','#e8d8b0'); if (G.dolls===6) toast('替身紙人夠 6 個！隨時可以按「替身遁走」，但係故事碎片同部分收穫會留低。'); return; }
    if (it==='key'){ G.keys.key=(G.keys.key||0)+1; float(g.x,g.y-90,'偷到鎖匙！','#ffd54a'); return; }
    G.bag.push({t:it,o:g.i}); g.loot++; g.energy=Math.min(100,g.energy+12); float(g.x,g.y-90,'收到'+ITEM[it].n+'（'+G.bag.length+'/'+BAGMAX+'）','#ffd54a');
  }
  function unlockUnit(u,msg){ if (u.open) return; u.open=true; float(u.x,u.y-90,msg,'#9fd6bf'); G.wardFx.push({x:u.x,y:u.y,t:0.9}); u.unlockFx=1.2; }
  function checkAlert(){
    var lv=G.alert>=10?3:G.alert>=6?2:G.alert>=3?1:0;
    while (G.alertLv<lv){ G.alertLv++;
      var fr=1+Math.floor(rnd()*(FL-1));
      if (G.alertLv===1){ G.guards.push(mkHuman('compass','f'+fr+'_s')); toast('全樓警覺 3：管理處加派「羅盤保安」——每次只嚇得走佢一點膽，靠閂門同繞路避開佢。'); }
      if (G.alertLv===2){ var m=mkHuman('mirror','f'+fr+'_l'); m.dir=-1; G.guards.push(m); toast('全樓警覺 6：「鏡子道士」到——唔好正面對住佢面鏡，要兜去佢背後先嚇得到。'); }
      if (G.alertLv===3){ G.taoWant=true; var real=Math.floor(rnd()*3); for (var k=0;k<3;k++){ var d=mkHuman('decoy','f'+fr+'_d'+k in G.nodes?'f'+fr+'_d'+k:'f'+fr+'_s',{real:k===real}); G.guards.push(d); } toast('全樓警覺 10：天師同「紙人替身陣」上樓——三個道士得一個係真身，試下嚇邊個。'); }
      G.shake=0.4;
    }
  }
  // ---------- 人類 ----------
  function nearestGhost(h){ var best=null, bd=1e9; G.gh.forEach(function(g){ if (g.home||g.out||g.inv>0) return; var d=Math.abs(g.x-h.x)+Math.abs(g.y-h.y)*1.5; if (d<bd){ bd=d; best=g; } }); return best; }
  function humanUpdate(h,dt){
    var H=HUM[h.kind]; h.alertT=Math.max(0,h.alertT-dt); h.talkT-=dt; if (h.sayT>0) h.sayT-=dt; else h.say=null;
    if (h.state==='flee'){ h.x+=h.vx*dt; if (h.x<SX-20||h.x>LX+20) h.state='gone'; return; }
    if (h.talkT<=0 && h.kind!=='dog'){ h.say=h.kind==='guard'?line('guard'):h.kind==='compass'?pick(['羅盤指住呢邊……','針震緊，有嘢喺附近']):pick(['照妖鏡在此，莫要亂來','鏡光到處，邪靈退後']); h.sayT=2.4; h.talkT=8+rnd()*8; }
    var tg=nearestGhost(h), chaser=h.kind!=='guard'||h.state==='chase';
    if (h.kind==='guard' && tg && Math.abs(tg.y-h.y)<40 && (tg.x-h.x)*h.dir>0 && Math.abs(tg.x-h.x)<150 && h.state!=='chase'){ h.state='chase'; h.alertT=1.2; h.say=line('guardHit'); h.sayT=2; }
    if (h.kind==='decoy' && !h.real) chaser=false;
    if (!h.to){ h.wait-=dt; if (h.wait>0) return; h.repath-=dt;
      if (chaser && tg){ var tn=tg.to? (Math.abs(G.nodes[tg.node].x-tg.x)<Math.abs(G.nodes[tg.to].x-tg.x)?tg.node:tg.to) : tg.node; if (h.repath<=0||!h.path){ h.path=dijkstra(h,h.node,tn); h.repath=0.5; } if (h.path&&h.path.length){ h.to=h.path.shift(); h.p=0; } }
      if (!h.to){ var n=G.nodes[h.node], opts=n.links.filter(function(l){ var m=G.nodes[l.to]; return m.kind!=='in' && m.kind!=='portal' && humanPass(h,l.e); }); if (opts.length){ h.to=pick(opts).to; h.p=0; } } }
    var a=G.nodes[h.node], b=G.nodes[h.to]; if (!b){ h.to=null; return; } var D=Math.max(1,Math.hypot(b.x-a.x,b.y-a.y));
    var sp=H.sp*(h.boost||1)*(G.gate?(G.gate.t>20?2:1.5):1)*(1+0.12*G.phase); if (tg&&chaser) sp*=Math.pow(1.4,Math.abs(a.f-tg.d&&G.nodes[tg.node].f-a.f)); sp=Math.min(sp,320);
    h.p+=sp*dt/D; if (b.x!==a.x) h.dir=b.x>a.x?1:-1;
    if (h.p>=1){ h.node=h.to; h.to=null; h.p=0; h.wait=chaser?0:0.3+rnd()*0.8; }
    var p=posOf(h); h.x=p.x; h.y=p.y;
    // 撞到鬼
    G.gh.forEach(function(g){ if (g.home||g.out||g.inv>0||g.stun>0||(h.catchCd||0)>0) return; if (Math.abs(g.y-h.y)>30||Math.abs(g.x-h.x)>18) return;
      if (h.kind==='dog'){ g.stun=1; G.alert+=1; checkAlert(); float(g.x,g.y-80,'狗吠到成棟樓醒晒！','#ffb0b0'); h.catchCd=2; return; }
      if (h.kind==='decoy'&&!h.real) return;
      catchGhost(g,h); h.catchCd=2.2; });
    h.catchCd=Math.max(0,(h.catchCd||0)-dt);
  }
  function catchGhost(g,h){
    g.caught++; g.hitT=0.8; g.hitDir=h.dir; g.stun=1.5; g.to=null; g.auto=null; h.alertT=1.3; h.say=line('guardHit'); h.sayT=2; G.shake=0.35;
    for (var k=0;k<10;k++) part(g.x,g.y-g.d.h*0.5,(rnd()-0.5)*50+h.dir*40,-30-rnd()*40,0.9,'smoke');
    if (g.caught>=3){ g.out=true; var lost=G.bag.filter(function(b){return b.o===g.i;}).length; G.bag=G.bag.filter(function(b){return b.o!==g.i;}); g.loot=0; float(g.x,g.y-100,g.d.name+'被收服！','#ff7a5a'); toast(g.d.name+'畀人收服咗，佢身上 '+lost+' 件收穫冇埋。'+(G.gh.some(function(o){return !o.out;})?'快啲切去其他鬼！':'')); if (G.active===g.i){ var nx=G.gh.find(function(o){return !o.out&&!o.home;}); if (nx) G.active=nx.i; } }
    else { loseLoot(g,0.34); float(g.x,g.y-80,'被捉住！（'+g.caught+'/3）','#ffb0b0'); var back=G.nodes[g.node].links.map(function(l){return G.nodes[l.to];}).filter(function(m){return m.kind!=='in'&&(m.x-h.x)*h.dir>0;})[0]; if (back) g.node=back.id; }
  }
  function loseLoot(g,frac){ var mine=G.bag.filter(function(b){return b.o===g.i;}); var l=Math.ceil(mine.length*frac*(G.mods.arm<1?0.5:1)); for (var k=0;k<l;k++){ var i=G.bag.indexOf(mine[k]); G.bag.splice(i,1); } g.loot=Math.max(0,g.loot-l); if (l>0) float(g.x,g.y-95,'跌咗收穫 -'+l,'#ff9a9a'); }
  // ---------- 天師（鈴聲逼退，尊重用語）----------
  var TAOL=['鈴……鈴……各位街坊安心瞓','天師巡樓，邪氣退散','聽住鈴聲，唔好亂走','鈴聲到處，夜路平安'];
  function spawnTao(f,x){ G.tao={x:x, f:f, dir:x<300?1:-1, ringT:2.2, life:26, waves:[], say:pick(TAOL), sayT:2.6}; float(x,fy(f)-90,'天師嚟咗！','#ffd54a'); }
  function taoUpdate(dt){
    if (G.taoWant && !G.tao && !G.gate){ G.taoCd=(G.taoCd==null?2:G.taoCd)-dt; if (G.taoCd<=0){ var f=1+Math.floor(rnd()*(FL-1)); spawnTao(f,rnd()<0.5?SX:LX); } }
    var T=G.tao; if (!T) return;
    T.life-=dt; T.x+=T.dir*36*dt; if (T.x>LX-10||T.x<SX+10) T.dir*=-1; T.sayT-=dt;
    T.ringT-=dt; if (T.ringT<=0){ T.ringT=4; T.waves.push({r:10,t:1}); T.say=pick(TAOL); T.sayT=2.4;
      G.gh.forEach(function(g){ if (g.home||g.out) return; if (G.nodes[g.node].f!==T.f) return; if (Math.abs(g.x-T.x)>140) return;
        g.sealT=3; g.hitT=0.8; g.hitDir=g.x>T.x?1:-1; g.to=null; g.auto=null; g.taskP=0;
        var n=G.nodes[g.node], away=n.links.map(function(l){return G.nodes[l.to];}).filter(function(m){return m.kind!=='in'&&(m.x-T.x)*(g.x-T.x)>=0&&Math.abs(m.x-T.x)>Math.abs(n.x-T.x);})[0];
        if (n.kind==='in') g.node=n.id.replace('_i','_d'); else if (away) g.node=away.id;
        float(g.x,g.y-90,'鈴聲逼退，暫時嚇唔到人','#ffe9a0'); for (var k=0;k<8;k++) part(g.x,g.y-30,(rnd()-0.5)*60,-30-rnd()*40,0.9,'smoke'); }); }
    T.waves.forEach(function(w){ w.t-=dt; w.r+=180*dt; }); T.waves=T.waves.filter(function(w){return w.t>0;});
    if (T.life<=0){ G.tao=null; G.taoCd=16+rnd()*10; }
  }
  // ---------- 撤離 ----------
  function gatePress(){ var g=G.gh[G.active], n=G.nodes[g.node]; if (G.gate||g.to||n.kind!=='portal') return; if (g.still<0.1){ float(g.x,g.y-80,'企定先開得陰門','#ffd54a'); return; } G.gateCharge=0.001; G.gateG=g.i; }
  function gateUpdate(dt){
    if (G.gateCharge>0 && !G.gate){ var g=G.gh[G.gateG]; if (g.to||g.still<0.1||G.nodes[g.node].kind!=='portal'){ G.gateCharge=0; float(g.x,g.y-80,'郁咗，陰門開唔到','#ffb0b0'); } else { G.gateCharge+=dt; if (G.gateCharge>=1){ G.gateCharge=0; G.gate={t:0,f:G.nodes[g.node].f,node:g.node,sp:1.2,fin:false}; G.tao=null; toast('陰門開咗！企穩 30 秒——樓梯封住，追兵會越嚟越快，最後 8 秒天師會喺你兩邊出現。'); G.shake=0.5; } } }
    var Gt=G.gate; if (!Gt) return; Gt.t+=dt; Gt.sp-=dt;
    if (Gt.sp<=0){ Gt.sp=Gt.t<20?2.6:1.4; var side=rnd()<0.5; var h=mkHuman('guard','f'+Gt.f+'_'+(side?'s':'l'),{state:'chase'}); G.guards.push(h); }
    if (Gt.t>=22 && !Gt.fin){ Gt.fin=true; var g=G.gh[G.active]; spawnTao(Gt.f,Math.max(SX+10,g.x-120)); G.tao.ringT=1.5; var d=mkHuman('mirror','f'+Gt.f+'_l'); d.dir=-1; G.guards.push(d); toast('最後 8 秒！天師同道士喺兩邊殺到，頂住！'); }
    if (Gt.t>=30){ var alive=G.gh.filter(function(g){return !g.out;}); alive.forEach(function(g){ g.home=true; }); endNight('gate'); }
  }
  function dollEscape(){ if (G.dolls<6||G.gate) return; G.gh.forEach(function(g){ if (!g.out) g.home=true; }); endNight('doll'); }
  function endNight(why){
    if (G.over) return;
    var kept=why==='gate'?G.bag.length:why==='doll'?Math.floor(G.bag.length/2):0, story=why==='gate'?G.story.length:0;
    G.over={ok:why!=='fail', why:why, kept:kept, lost:G.bag.length-kept, home:G.gh.filter(function(g){return !g.out;}).length, fear:G.fearTotal, story:story, storyLost:why==='doll'?G.story.length:0, alert:G.alert};
    try{ var sv=JSON.parse(localStorage.getItem('lyg_pangsa')||'{}'); sv.nights=(sv.nights||0)+1; if (why!=='fail'){ sv.best=Math.max(sv.best||0,kept); sv['clear_'+curLv]=1; } localStorage.setItem('lyg_pangsa',JSON.stringify(sv)); }catch(e){}
  }
  // ---------- 嚇人（要企定）----------
  function say(r,t){ r.say=t; r.sayT=2.6; }
  function scareRes(r,amt,g){ if (r.state!=='home') return; r.fear+=amt*G.mods.pow*(1-r.brave); r.jumpT=0.5; if (g) g.energy=Math.min(100,g.energy+(r.brave?8:18)); for (var k=0;k<5;k++) part(r.x,r.y-48,(rnd()-0.5)*90,-60-rnd()*40,0.6,'sweat'); if (r.fear>=100) flee(r,g); else say(r,r.brave?line('brave'):line('afraid')); }
  function flee(r,g){
    r.state='flee'; r.y=fy(r.unit.f); r.vx=(r.x<300?-1:1)*150; r.tripT=rnd()<0.35?0.9:0; say(r,line('flee')); if (g) g.energy=Math.min(100,g.energy+20);
    addFear(Math.round(15*G.mods.fear),r.x,r.y-80);
    G.units.forEach(function(u){ if (u.ot===1&&u.dep===r.unit&&!u.open){ unlockUnit(u,'隔籬人心惶惶，入得喇（黑屋）'); } });
    if (r.unit.story && G.story.indexOf(r.unit.si)<0){ G.story.push(r.unit.si); G.story.sort(); toast('收集到故事碎片——'+STORY[r.unit.si]+'（要正規經陰門返去先帶得走）'); }
  }
  function addFear(a,x,y){ G.fear+=a; G.fearTotal+=a; float(x,y,'怕意 +'+a,'#9fd6bf'); if (G.fearTotal>=G.fearNext){ G.fearNext+=30; G.choiceQ=(G.choiceQ||0)+1; } }
  function scarePress(){
    var g=G.gh[G.active]; if (g.scareCd>0||g.home||g.out) return; var n=G.nodes[g.node];
    if (g.to||g.still<0.1){ float(g.x,g.y-80,'鬆手企定先嚇得','#ffd54a'); return; }
    if (g.sealT>0){ float(g.x,g.y-80,'鈴聲未散，暫時嚇唔到人','#ffe9a0'); return; }
    if (mirrorOn(g)){ float(g.x,g.y-80,'被鏡照住，嚇唔出','#ffe9a0'); return; }
    var un=n.kind==='in'?unitOf(n.id):null;
    if (un&&un.res&&un.res.state==='home'){ g.scareCd=1.2; g.actT=0.9; g.dir=un.res.x>g.x?1:-1; scareRes(un.res,34,g); float(g.x,g.y-90,'嚇！','#ff7a5a'); G.shake=0.25; return; }
    var h=null, bd=90; G.guards.forEach(function(o){ if (o.state==='flee') return; if (Math.abs(o.y-g.y)>30) return; var d=Math.abs(o.x-g.x); if (d<bd){ bd=d; h=o; } });
    if (!h){ float(g.x,g.y-80,'附近冇人可以嚇','#ddd'); return; }
    g.scareCd=1.2; g.actT=0.9; g.dir=h.x>g.x?1:-1; G.shake=0.25;
    if (h.kind==='mirror' && Math.sign(g.x-h.x)===h.dir){ float(h.x,h.y-90,'正面對住面鏡，嚇唔到！兜去背後','#ffe9a0'); return; }
    if (h.kind==='decoy' && !h.real){ h.state='gone'; for (var k=0;k<12;k++) part(h.x,h.y-30,(rnd()-0.5)*120,-60-rnd()*60,0.9,'paper'); float(h.x,h.y-80,'紙人替身！','#e8d8b0'); return; }
    h.courage--; h.alertT=0.8; float(h.x,h.y-90,h.kind==='compass'?'羅盤保安膽量 -1（剩 '+Math.max(0,h.courage)+'）':'嚇！','#ff7a5a');
    if (h.courage<=0){ h.state='flee'; h.vx=(h.x<300?-1:1)*170; h.say=line('flee'); h.sayT=2; addFear(h.kind==='dog'?6:12,h.x,h.y-80); g.energy=Math.min(100,g.energy+20); }
  }
  function part(x,y,vx,vy,life,type){ if (G.parts.length<260) G.parts.push({x:x,y:y,vx:vx,vy:vy,life:life,max:life,type:type}); }
  function stepFx(dt){ G.parts.forEach(function(p){ p.life-=dt; p.x+=p.vx*dt; p.y+=p.vy*dt; if (p.type==='coin'||p.type==='crumb'||p.type==='sweat'||p.type==='paper') p.vy+=220*dt; if (p.type==='smoke') { p.vx*=0.96; p.vy*=0.96; } if (p.type==='suck'&&p.tx!=null){ p.x+=(p.tx-p.x)*dt*3; p.y+=(p.ty-p.y)*dt*3; } }); G.parts=G.parts.filter(function(p){return p.life>0;});
    G.wardFx.forEach(function(w){ w.t-=dt; }); G.wardFx=G.wardFx.filter(function(w){return w.t>0;}); G.shake=Math.max(0,(G.shake||0)-dt);
    G.units.forEach(function(u){ if (u.unlockFx>0) u.unlockFx-=dt; });
    for (var k in G.dark){ G.dark[k]-=dt; if (G.dark[k]<=0) delete G.dark[k]; } }
  var ULT={eking:{n:'大胃王',d:'整層燈滅，一啖吞晒啲驚！'},toyol:{n:'一掃光',d:'分身滿層亂竄，偷到一個唔留！'},tianhua:{n:'千絲垂髮',d:'頭髮由天花鋪落嚟，纏實成層人！'}};
  function ultPress(i){ var g=G.gh[i]; if (g.energy<100||g.home||g.out||G.ult) return false; g.energy=0; G.ult={g:g,t:0,f:G.nodes[g.node].f,done:false}; return true; }
  function applyUlt(U){ var g=U.g, f=U.f, k=g.d.key, rs=G.res.filter(function(r){return r.unit.f===f&&r.state==='home';}), hs=G.guards.filter(function(h){return G.nodes[h.node].f===f&&h.state!=='flee';});
    if (k==='eking'){ G.dark[f]=3.2; rs.forEach(function(r){ scareRes(r,130,g); for (var q=0;q<6;q++){ var p={x:r.x,y:r.y-30,vx:0,vy:0,life:1.4,max:1.4,type:'suck'}; p.tx=g.x; p.ty=g.y-30; G.parts.push(p); } }); hs.forEach(function(h){ h.wait=3; }); }
    if (k==='toyol'){ U.clones=[0,1,2,3,4].map(function(j){ return {x:60+j*110,v:(j%2?1:-1)*(220+j*30)}; }); var got=0; G.units.forEach(function(u){ if (u.f===f&&u.open){ for (var q=u.items.length-1;q>=0;q--){ var it=u.items[q]; if ((it==='money'||it==='key'||it==='doll')&&(it!=='money'||G.bag.length<BAGMAX)){ u.items.splice(q,1); takeItem(g,it,u); got++; } } } }); float(g.x,g.y-100,'一掃光！攞到 '+got+' 件','#ffd54a'); rs.forEach(function(r){ scareRes(r,85,g); }); }
    if (k==='tianhua'){ rs.forEach(function(r){ r.tangle=3.2; scareRes(r,105,g); }); hs.forEach(function(h){ h.wait=3.2; h.to=null; }); }
    G.shake=0.5;
  }
  function invPress(){ var g=G.gh[G.active]; if (g.invCd>0||g.out) return; g.inv=G.mods.inv; g.invCd=G.mods.inv+9; float(g.x,g.y-90,'隱身','#9fe0ff'); }
  function chooseCard(i){
    var c=G.choice[i]; if (!c) return; var m=G.mods;
    if (c.id==='spd') m.spd*=1.2; if (c.id==='pow') m.pow*=1.4; if (c.id==='inv') m.inv+=2; if (c.id==='task') m.task*=1.35; if (c.id==='arm') m.arm=0.5; if (c.id==='fear') m.fear*=1.3;
    G.choice=null; toast('揀咗「'+c.t+'」：'+c.d);
  }

