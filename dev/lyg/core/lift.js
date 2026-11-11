// 樓裡有鬼 — 電梯系統（獨立模組）
// 用法：pangsa.js 喺 IIFE 入面 `var LIFT=window.LiftSys?window.LiftSys(api):null;`（見 // LIFT HOOK）
// 模組自己行 requestAnimationFrame：遊戲進行中（scene==='play'、冇暫停、冇揀卡、冇結局）先推進邏輯。
// 世界剖面上嘅𨋢廂、𨋢口、等𨋢嘅人畫喺一張疊喺遊戲 canvas 上面嘅透明 canvas（pointer-events:none）；
// 鬼入𨋢後彈出 HTML 疊層：上面係𨋢廂內景（程序畫），下面係樓層面板，中間透明擋板（擋住搖桿）。
// 紅線：唔嚇小朋友（遊戲本身冇細路住戶）、唔嘲弄宗教（對白冇宗教字眼）。
(function(){
'use strict';
window.LiftSys=function(A){
  var L={}, S=null, lastG=null;
  var CAP=4, VMAX=0.75, ACC=1.4, DOOR_T=0.5, HOLD=2.6;
  var TR={
    dark:{n:'熄燈',cd:14,f:34,d:'閃兩下熄晒，黑暗中有人唞氣'},
    btns:{n:'亂按',cd:18,f:22,d:'全部樓層掣自己亮，層層都停'},
    mirror:{n:'鏡中影',cd:16,f:38,d:'𨋢鏡多咗個人影'},
    over:{n:'超重',cd:20,f:26,d:'超重警報響，但得佢一個'},
    stuck:{n:'卡𨋢',cd:26,f:45,d:'停喺兩層中間，門開一半見到牆'},
    door:{n:'嚇門口',cd:10,f:40,d:'開門嚇喺門口等𨋢嘅人'}
  };
  var TRK=['dark','btns','mirror','over','stuck','door'];
  // ---------- 對白（港式粵語；同一關唔重複，抽完先洗牌）----------
  var LN={
    wait:['部𨋢又停咗喺頂樓……','撳咗好耐都未嚟','快啲啦，好肚餓','呢部𨋢慢到死','等𨋢等到頸都長','係咪又有人㩒住度門？'],
    board:['唔該等等！','唔該借借','唔該撳埋我嗰層','入面仲有位嘛？','唔該，等埋我'],
    full:['滿咗？等下一轉啦','咁多人，我等陣先'],
    snack:['落樓下打包碗雲吞麵先','去士多買支維他奶','茶餐廳仲開，去買個菠蘿油','肚餓，落去買宵夜'],
    back:['買到宵夜喇，返上去食','好彩仲有得買','返屋企食住睇劇先'],
    work:['返通宵更喇，遲到就死','的士要交更，走先'],
    dark:['嘩！做咩黑晒呀？！','邊個喺度唞氣……？','唔好玩啦，開返盞燈啦！','我好似聽到有人喺我耳邊抖氣……'],
    btns:['邊個撳晒啲掣呀？！','我冇撳過㗎……','層層停，停到幾時呀？','啲掣自己亮㗎？！'],
    mirror:['面鏡……我後面多咗個人……','頭先係咪有人企喺我後面？','我唔敢再望面鏡喇','鏡入面嗰個唔係我……'],
    over:['超重？得我一個人咋喎！','響乜嘢呀，我好重咩……','咪嚇我啦，入面冇其他人㗎','超重……咁即係仲有邊個喺度？'],
    stuck:['卡住咗？！開門呀！','得半度門，出面係牆呀！','救命呀，有冇人聽到呀？','唔好喺度停呀，求下你郁啦'],
    bolt:['我行樓梯好過！','唔搭喇唔搭喇！','走呀——！','俾我出去！'],
    cower:['我唔郁……我乜都冇見到……','快啲到啦，快啲到啦……','唔關我事，唔好搵我……'],
    land:['嘩！部𨋢入面黑麻麻冇人㗎……','做咩自己開門嘅？！','入面……入面有嘢呀！','我唔搭喇，行樓梯！'],
    gReport:['管理處，管理處，部𨋢有啲古怪，我落機房睇睇。','Over，𨋢又壞，我去機房check吓。','對講機：𨋢有問題，我而家去機房。'],
    gLand:['咦？部𨋢自己開門？','冇人㗎喎……奇怪','邊個喺度玩部𨋢？'],
    gBack:['機房搞掂，冇事喎……奇怪。','電掣冇跳過，鬼知咩事。','檢查完，部𨋢冇壞……'],
    gRide:['搭𨋢巡上去睇睇','行樓梯行到腳軟，搭𨋢啦','上去巡下先']
  };
  var lnUsed={};
  function line(k){ var p=LN[k]; if (!lnUsed[k]||!lnUsed[k].length){ var a=p.map(function(_,i){return i;}); for (var i=a.length-1;i>0;i--){ var j=Math.floor(Math.random()*(i+1)); var t=a[i]; a[i]=a[j]; a[j]=t; } lnUsed[k]=a; } return p[lnUsed[k].pop()]; }

  // ---------- 聲（WebAudio 程序合成）----------
  var AC=null, hum=null, noiseBuf=null;
  function ac(){ if (!AC){ try{ AC=new (window.AudioContext||window.webkitAudioContext)(); }catch(e){ AC=null; } } if (AC&&AC.state==='suspended'){ try{AC.resume();}catch(e){} } return AC; }
  function nbuf(c){ if (!noiseBuf){ noiseBuf=c.createBuffer(1,c.sampleRate*2,c.sampleRate); var d=noiseBuf.getChannelData(0); for (var i=0;i<d.length;i++) d[i]=Math.random()*2-1; } return noiseBuf; }
  function tone(f,t0,dur,vol,type){ var c=ac(); if (!c) return; try{ var o=c.createOscillator(), g=c.createGain(); o.type=type||'sine'; o.frequency.value=f; g.gain.setValueAtTime(0.0001,c.currentTime+t0); g.gain.exponentialRampToValueAtTime(vol,c.currentTime+t0+0.01); g.gain.exponentialRampToValueAtTime(0.0001,c.currentTime+t0+dur); o.connect(g); g.connect(c.destination); o.start(c.currentTime+t0); o.stop(c.currentTime+t0+dur+0.05); }catch(e){} }
  function noiseBurst(t0,dur,vol,freq,q){ var c=ac(); if (!c) return null; try{ var s=c.createBufferSource(); s.buffer=nbuf(c); s.loop=true; var bp=c.createBiquadFilter(); bp.type='bandpass'; bp.frequency.value=freq||900; bp.Q.value=q||0.8; var g=c.createGain(); var T=c.currentTime+t0; g.gain.setValueAtTime(0.0001,T); g.gain.linearRampToValueAtTime(vol,T+dur*0.3); g.gain.linearRampToValueAtTime(0.0001,T+dur); s.connect(bp); bp.connect(g); g.connect(c.destination); s.start(T); s.stop(T+dur+0.05); return g; }catch(e){ return null; } }
  var SND={
    ding:function(){ tone(1318,0,1.1,0.18); tone(2636,0,0.5,0.04); tone(1046,0.28,1.3,0.15); },
    door:function(){ noiseBurst(0,0.6,0.06,700,0.7); tone(140,0,0.5,0.03,'triangle'); },
    buzz:function(){ for (var i=0;i<7;i++) tone(520,i*0.32,0.2,0.07,'square'); },
    breath:function(){ noiseBurst(0.2,1.3,0.07,420,0.6); noiseBurst(1.8,1.6,0.06,360,0.6); },
    clunk:function(){ tone(58,0,0.6,0.25,'sine'); noiseBurst(0,0.25,0.12,220,0.5); },
    click:function(){ tone(1900,0,0.05,0.05,'square'); },
    hum:function(on){ var c=ac(); if (!c) return; try{ if (on&&!hum){ var o=c.createOscillator(), o2=c.createOscillator(), lp=c.createBiquadFilter(), g=c.createGain(); o.type='sawtooth'; o.frequency.value=55; o2.type='sine'; o2.frequency.value=110.5; lp.type='lowpass'; lp.frequency.value=220; g.gain.value=0.0001; o.connect(lp); o2.connect(lp); lp.connect(g); g.connect(c.destination); o.start(); o2.start(); g.gain.exponentialRampToValueAtTime(0.05,c.currentTime+0.4); hum={o:o,o2:o2,g:g}; }
        if (!on&&hum){ var h=hum; hum=null; h.g.gain.exponentialRampToValueAtTime(0.0001,c.currentTime+0.4); h.o.stop(c.currentTime+0.5); h.o2.stop(c.currentTime+0.5); } }catch(e){ hum=null; } }
  };
  document.addEventListener('pointerdown',function(){ ac(); },{passive:true});

  // ---------- 工具 ----------
  function G(){ return A.G; }
  function FL(){ return A.FL; }
  function top(){ return FL()-1; }                      // 𨋢去到最高住宅層（天台行樓梯）
  function lab(f){ return f===0?'B':f===1?'G':String(f-1); }
  function fyf(p){ var a=Math.floor(p), b=Math.min(top(),a+1), fr=p-a; return A.fy(a)+(A.fy(b)-A.fy(a))*fr; }
  function col(){ var c=(A.LV.xs||[]).find(function(q){return q[2]==='lift';}); return c?{x0:c[0],x1:c[1],cx:(c[0]+c[1])/2}:{x0:A.LV.MX-42,x1:A.LV.MX+42,cx:A.LV.MX}; }
  function FH(){ return Math.abs(A.fy(0)-A.fy(1)); }
  function rnd(){ return A.rnd?A.rnd():Math.random(); }
  function pick(a){ return a[Math.floor(rnd()*a.length)]; }
  function cabF(){ return Math.round(S.pos); }
  function atFloor(){ return Math.abs(S.pos-Math.round(S.pos))<0.002; }
  function ghost(){ return S&&S.gi!=null?G().gh[S.gi]:null; }
  function sayR(o,t){ o.say=t; o.sayT=2.8; }
  function fl(x,y,t,c){ try{ A.float(x,y,t,c); }catch(e){} }
  function riderSpr(o){ return o.kind==='guard'?((A.HUM&&A.HUM[o.ref.kind]&&A.HUM[o.ref.kind].spr)||'res_guard'):o.ref.sprite; }
  function inCab(){ return S.riders.filter(function(o){return o.ph==='ride';}); }
  function resIn(){ return inCab().filter(function(o){return o.kind==='res';}); }

  function reset(){
    lastG=G(); lnUsed={};
    S={on:!!(A.LV&&A.LV.lift), pos:1, v:0, dir:0, st:'idle', door:0, hold:0, target:null, stops:{}, lit:{}, riders:[], away:[], mroom:[],
       gi:null, gCall:null, dfx:{}, prevSt:'idle', cd:{}, fx:{dark:0,mirror:0,over:0,flick:0,btnAll:0}, stuckT:0, stuckTo:null, spawnT:6, gSpawnT:14, t:0, log:[], shake:0, ext:null};
    TRK.forEach(function(k){ S.cd[k]=0; });
    hideUI();
  }

  // ---------- 調度 ----------
  function wanted(){ var w={}; for (var k in S.stops) w[k]=1;
    var room=CAP-inCab().length;
    S.riders.forEach(function(o){ if (o.ph==='ride') w[o.dest]=1; if (o.ph==='wait' && room>0) w[o.f]=1; });
    if (S.gCall!=null) w[S.gCall]=1; return w; }
  function chooseTarget(){
    var w=wanted(), keys=Object.keys(w).map(Number).filter(function(f){return f>=0&&f<=top();}), p=S.pos;
    keys=keys.filter(function(f){ return Math.abs(f-p)>0.01 || S.st==='idle'; });
    if (!keys.length) return null;
    var up=keys.filter(function(f){return f>p+0.01;}).sort(function(a,b){return a-b;}), dn=keys.filter(function(f){return f<p-0.01;}).sort(function(a,b){return b-a;});
    var here=keys.filter(function(f){return Math.abs(f-p)<=0.01;});
    if (here.length && S.st==='idle') return here[0];
    if (S.dir>=0 && up.length) return up[0]; if (S.dir<=0 && dn.length) return dn[0];
    return up.length?up[0]:dn.length?dn[0]:null;
  }
  function startMove(t){ S.target=t; S.dir=t>S.pos?1:-1; S.st='move'; SND.hum(true); }
  function arrive(){
    var f=cabF(); S.pos=f; S.v=0; delete S.stops[f]; delete S.lit[f]; if (S.gCall===f) S.gCall=null;
    S.st='opening'; SND.ding(); SND.door(); S.target=null;
    var c=col(), y=A.fy(f);
    // 空𨋢「叮」一聲開門：引保安過嚟（保留原本「叫𨋢」引開保安機制）
    var g=ghost(), hasPeople=inCab().length||S.riders.some(function(o){return o.ph==='wait'&&o.f===f;});
    if (!g && !hasPeople){ try{ A.noise('f'+f+'_l',2); }catch(e){} fl(c.cx,y-90,'叮——（'+lab(f)+' 樓𨋢門自己開咗）','#ffd54a'); }
  }
  function boardAndExit(dt){
    var f=cabF(), c=col();
    S.xT=(S.xT||0)-dt; if (S.xT>0) return; S.xT=0.35;
    // 落𨋢
    var out=inCab().find(function(o){ return o.dest===f || o.mood==='bolt' || o.mood==='mroom'; });
    if (out){ exitRider(out,f); dingFx(f,true); S.hold=Math.max(S.hold,1.0); return; }
    // 上𨋢
    var w=S.riders.find(function(o){ return o.ph==='wait'&&o.f===f; });
    if (w){ if (inCab().length>=CAP){ if (!w.fullSaid){ w.fullSaid=1; sayR(w,line('full')); } return; } w.ph='ride'; dingFx(f,true); w.x=c.cx+(inCab().length-1.5)*10; sayR(w,rnd()<0.5?line('board'):lab(w.dest)+'樓，唔該'); S.hold=Math.max(S.hold,1.2); }
  }
  function exitRider(o,f){
    var c=col(), y=A.fy(f), g0=G(); S.riders.splice(S.riders.indexOf(o),1);
    if (o.kind==='guard'){ var h=o.ref; h.to=null; h.path=null; h.p=0; h.node='f'+f+'_l'; h.x=c.cx; h.y=y; h.wait=0.8;
      if (o.mood==='mroom'){ S.mroom.push({h:h,t:22}); fl(c.cx,y-110,'保安去咗機房（離開巡邏 22 秒）','#9fd6bf'); log('mroom'); return; }
      h.state='patrol'; g0.guards.push(h); return; }
    var r=o.ref; r.y=y-16;
    if (o.mood==='bolt'){ r.state='flee'; r.vx=(rnd()<0.5?-1:1)*150; r.x=c.cx; g0.res.push(r); sayR(r,line('bolt')); r.sayT=2.4; log('bolt'); return; }
    if (o.trip==='back'){ o.ph='walkHome'; o.f=f; o.x=c.cx; S.riders.push(o); return; }
    // 落咗 G 樓：出門（離開地圖），一陣返嚟
    if (o.trip==='snack') S.away.push({o:o,t:16+rnd()*12});
  }

  // ---------- 搭𨋢嘅人（按作息）----------
  function spawnResident(){
    var g0=G(), ph=Math.min(2,g0.phase||0);
    var cand=g0.res.filter(function(r){ return r.state==='home'&&r.awake!==false&&!(r.fear>40)&&r.unit&&r.unit.f>=2&&r.unit.f<=top()&&!r.liftUsed&&r.unit.ot!=='deity'; });
    if (!cand.length) return null; var r=pick(cand); return addResRider(r,'snack');
  }
  function addResRider(r,trip,dest){
    var g0=G(); var i=g0.res.indexOf(r); if (i>=0) g0.res.splice(i,1);
    r.state='lift'; r.liftUsed=1; var o={kind:'res',ref:r,f:r.unit.f,dest:dest!=null?dest:1,ph:'walk',x:r.x,trip:trip||'snack',fear:0,mood:'ok',say:null,sayT:0};
    sayR(o,line(o.trip==='work'?'work':'snack')); S.riders.push(o); return o;
  }
  function spawnGuard(){
    var g0=G(), c=col();
    var cand=g0.guards.filter(function(h){ var n=g0.nodes[h.node]; return h.kind==='guard'&&h.state==='patrol'&&n&&n.f<=top()&&Math.abs(h.x-c.cx)<240&&!h.liftCd; });
    if (!cand.length) return null; var h=pick(cand); return addGuardRider(h);
  }
  function addGuardRider(h,dest){
    var g0=G(), n=g0.nodes[h.node], i=g0.guards.indexOf(h); if (i>=0) g0.guards.splice(i,1);
    var f=n?n.f:1, d=dest; if (d==null){ do { d=Math.floor(rnd()*(top()+1)); } while (d===f && top()>0); }
    var o={kind:'guard',ref:h,f:f,dest:d,ph:'walk',x:h.x,trip:'patrol',mood:'ok',say:null,sayT:0}; sayR(o,line('gRide')); S.riders.push(o); return o;
  }

  // ---------- 鬼 ----------
  L.action=function(g,n){
    if (!S||!S.on||!g||g.home||g.out) return null; n=n||G().nodes[g.node];
    if (!n||n.kind!=='lift'||n.f>top()) return null;
    if (S.gi!=null) return null;
    return {k:'liftIn',t:S.gCall===n.f?'等緊𨋢……（再撳取消）':'入𨋢（撳掣叫𨋢）'};
  };
  L.enter=function(g){
    if (!S||!S.on) return false; var n=G().nodes[g.node]; if (!n||n.kind!=='lift') return false; var f=n.f;
    if (S.gCall===f){ S.gCall=null; S.gWait=null; fl(g.x,g.y-80,'唔等喇','#ffd54a'); return false; }
    if (atFloor() && cabF()===f && (S.st==='open'||S.st==='opening'||S.st==='idle')){ doEnter(g,f); return true; }
    S.gCall=f; S.gWait=g.i; SND.click(); fl(g.x,g.y-80,'撳咗𨋢掣，等緊𨋢……','#ffd54a'); return 'called';
  };
  function doEnter(g,f){
    S.gi=g.i; S.gCall=null; S.gWait=null; g.to=null; g.auto=null; g.autoS=null;
    if (S.st==='idle'){ S.st='opening'; SND.ding(); SND.door(); }
    S.hold=Math.max(S.hold,3.5); dingFx(f); log('enter'); showUI();
    A.toast&&A.toast('入咗𨋢：揀樓層、撳開關門。有人一齊搭嘅時候，上面會出「𨋢內嚇人」。');
  }
  L.exit=function(){ var g=ghost(); if (!g) return false;
    if (!(S.st==='open'&&S.door>0.8&&atFloor())){ flash('門未開，出唔到'); return false; }
    var f=cabF(), c=col(); S.gi=null; g.node='f'+f+'_l'; g.to=null; g.x=c.cx; g.y=A.fy(f); g.inv=0; g.still=1; dingFx(f); if (S.st==='open') S.hold=Math.max(S.hold,0.8); hideUI(); log('exit'); return true; };
  L.press=function(f){ if (!S||S.gi==null) return; SND.click(); f=+f;
    if (atFloor() && cabF()===f && S.st!=='move'){ L.open(); return; }
    if (S.st==='stuck'||S.st==='stuckMove'){ flash('卡住咗，掣冇反應'); return; }
    S.stops[f]=1; S.lit[f]=1; if (S.st==='open') S.hold=Math.min(S.hold,0.9); log('press'+f); };
  L.open=function(){ if (!S||S.gi==null) return; SND.click();
    if (S.st==='move'||S.st==='stuckMove'||S.st==='stuck'){ flash(S.st==='move'?'行緊，開唔到門':'卡住咗，門開唔到'); return; }
    if (S.st==='closing'||S.st==='idle'){ S.st='opening'; SND.door(); }
    S.hold=Math.max(S.hold,3); };
  L.close=function(){ if (!S||S.gi==null) return; SND.click();
    if (S.fx.over>0){ flash('超重！門閂唔到'); return; }
    if (S.st==='open'||S.st==='opening'){ S.st='closing'; S.hold=0; SND.door(); } };
  L.canTrick=function(k){
    if (!S||S.gi==null) return 'out'; if (S.cd[k]>0) return 'cd';
    if (k==='door'){ var f=cabF(); if (!atFloor()||S.st==='move'||String(S.st).indexOf('stuck')===0) return 'nolanding'; return S.riders.some(function(o){return o.ph==='wait'&&o.f===f;})?true:'nolanding'; }
    if (!inCab().length) return 'empty';
    if (k==='stuck'&&(S.st==='stuck'||S.st==='stuckMove')) return 'busy';
    return true;
  };
  L.trick=function(k){
    var ok=L.canTrick(k); if (ok!==true){ if (ok==='cd') flash(TR[k].n+'冷卻中'); else if (ok==='empty') flash('𨋢入面冇人'); else if (ok==='nolanding') flash('門口冇人等𨋢'); return false; }
    var T=TR[k], g=ghost(), c=col(); S.cd[k]=T.cd; log('trick:'+k);
    if (k==='dark'){ S.fx.dark=4.2; SND.breath(); }
    if (k==='btns'){ S.btnsSet=S.btnsSet||{}; for (var f=0;f<=top();f++){ if ((f!==cabF()||!atFloor())&&!S.stops[f]){ S.stops[f]=1; S.lit[f]=1; S.btnsSet[f]=1; } } S.btnsUntil=S.t+30; S.fx.btnAll=3; SND.click(); }
    if (k==='mirror'){ S.fx.mirror=3.6; tone(196,0,1.6,0.05,'triangle'); }
    if (k==='over'){ S.fx.over=3.6; SND.buzz(); if (S.st==='closing'){ S.st='opening'; } }
    if (k==='stuck'){ var mid=Math.min(top()-0.5,Math.max(0.5,Math.floor(S.pos)+0.5)); if (S.dir<0&&!atFloor()) mid=Math.max(0.5,Math.ceil(S.pos)-0.5); S.stuckTo=mid; S.st='stuckMove'; S.stuckT=5.5; SND.hum(true); if (S.door>0){ /* 由開門狀態直接拉走：先閂 */ S.door=0; SND.door(); } }
    if (k==='door'){ S.fx.dark=Math.max(S.fx.dark,2.2); scareLanding(); A.addFear&&A.addFear(Math.round(T.f*0.4),c.cx,fyf(S.pos)-120); return true; }
    // 𨋢入面嘅人
    var tot=0;
    inCab().forEach(function(o){
      if (o.kind==='guard'){ sayR(o,line('gReport')); o.mood='mroom'; tot+=8; fl(c.cx,fyf(S.pos)-130,'保安用對講機報𨋢故障','#ffb0b0'); return; }
      var r=o.ref, amt=T.f*(1-(r.brave||0)); o.fear+=amt; r.fear=(r.fear||0)+amt*0.3; tot+=amt;
      if (o.fear>=60||k==='stuck'&&o.fear>=45){ o.mood='bolt'; sayR(o,line(k)); }
      else { o.mood='cower'; sayR(o,line(k)); }
    });
    var add=Math.max(4,Math.round(tot*0.35)); if (A.addFear) A.addFear(add,c.cx,fyf(S.pos)-110);
    if (g) g.energy=Math.min(100,(g.energy||0)+6);
    S.shake=0.35; return true;
  };
  function scareLanding(){
    var f=cabF(), c=col(), y=A.fy(f), g0=G();
    S.riders.filter(function(o){return o.ph==='wait'&&o.f===f;}).forEach(function(o){ S.riders.splice(S.riders.indexOf(o),1);
      if (o.kind==='guard'){ var h=o.ref; h.node='f'+f+'_l'; h.to=null; h.p=0; h.x=c.cx-30; h.y=y; h.state='patrol'; g0.guards.push(h); try{ A.spook(h,line('gLand')); }catch(e){} return; }
      var r=o.ref; r.state='flee'; r.vx=(o.x<c.cx?-1:1)*160; r.x=o.x; r.y=y-16; g0.res.push(r); sayR(r,line('land')); r.sayT=2.4; });
  }
  // 𨋢口特效：叮字浮出＋樓層燈閃（同一層 0.8 秒內唔重複）
  function dingFx(f,quiet){ if (!S) return; var d=S.dfx[f]; if (d&&d.t<0.8) return; S.dfx[f]={t:0}; if (!quiet) try{ SND.ding(); }catch(e){} }
  L.scareWaiting=function(g){ if (!S||!S.on||!g) return 0; var n=G().nodes[g.node]; if (!n) return 0; var f=n.f, y=A.fy(f), g0=G(), c=col(), got=0;
    S.riders.filter(function(o){ return (o.ph==='wait'||o.ph==='walk'||o.ph==='walkHome')&&o.f===f&&Math.abs(o.x-g.x)<150; }).forEach(function(o){ S.riders.splice(S.riders.indexOf(o),1); got++;
      if (o.kind==='guard'){ var h=o.ref; h.node='f'+f+'_l'; h.to=null; h.p=0; h.x=o.x; h.y=y; h.state='patrol'; g0.guards.push(h); try{ A.spook(h,line('gLand')); }catch(e){} return; }
      var r=o.ref; r.state='flee'; r.vx=(o.x<g.x?-1:1)*160; r.x=o.x; r.y=y-16; g0.res.push(r); sayR(r,line('bolt')); r.sayT=2.4; });
    if (got){ try{ A.addFear&&A.addFear(10*got,g.x,y-110); }catch(e){} g.dir=1; log('scareWait'); }
    return got; };
  function flash(m){ S.msg=m; S.msgT=1.6; var g=ghost(); if (g) fl(g.x,g.y-120,m,'#ffd54a'); }
  function log(e){ S.log.push(e); if (S.log.length>80) S.log.shift(); }

  // ---------- 主推進 ----------
  L.step=function(dt){
    if (G()!==lastG) reset(); if (!S||!S.on||!G()) return;
    var g0=G(); S.t+=dt; for (var k in S.cd) S.cd[k]=Math.max(0,S.cd[k]-dt);
    if (S.btnsUntil&&S.t>=S.btnsUntil){ S.btnsUntil=0; for (var bf in (S.btnsSet||{})){ delete S.stops[bf]; delete S.lit[bf]; } S.btnsSet={}; log('btnsReset'); }   // 亂按最多 30 秒
    for (var q in S.fx) S.fx[q]=Math.max(0,S.fx[q]-dt); S.shake=Math.max(0,S.shake-dt); S.msgT=Math.max(0,(S.msgT||0)-dt);
    // 生成搭𨋢嘅人
    S.spawnT-=dt; if (S.spawnT<=0){ S.spawnT=11+rnd()*9; if (S.riders.filter(function(o){return o.kind==='res';}).length<5) spawnResident(); }
    S.gSpawnT-=dt; if (S.gSpawnT<=0){ S.gSpawnT=18+rnd()*10; spawnGuard(); }
    S.away=S.away.filter(function(a){ a.t-=dt; if (a.t>0) return true; var o=a.o; o.ph='wait'; o.f=1; o.dest=o.ref.unit.f; o.trip='back'; o.x=col().cx-46; o.mood='ok'; o.fear=0; sayR(o,line('back')); S.riders.push(o); return false; });
    S.mroom=S.mroom.filter(function(m){ m.t-=dt; if (m.t>0) return true; var h=m.h, nid=g0.nodes['f1_s']?'f1_s':'f0_s', n=g0.nodes[nid]; h.node=nid; h.to=null; h.p=0; h.x=n.x; h.y=n.y; h.state='patrol'; h.wait=1; h.say=line('gBack'); h.sayT=2.6; h.liftCd=1; g0.guards.push(h); return false; });
    // 行去𨋢口 / 行返屋企
    var c=col();
    S.riders.forEach(function(o){ o.sayT=Math.max(0,(o.sayT||0)-dt); if (o.sayT<=0) o.say=null;
      if (o.ph==='walk'){ var slot=S.riders.filter(function(p){return p.ph==='wait'&&p.f===o.f;}).length, tx=c.cx-44-slot*16; o.x+=Math.sign(tx-o.x)*Math.min(Math.abs(tx-o.x),62*dt); if (Math.abs(tx-o.x)<1){ o.ph='wait'; o.waitT=0; } }
      else if (o.ph==='wait'){ o.waitT=(o.waitT||0)+dt; if (o.waitT>7&&!o.said){ o.said=1; sayR(o,line('wait')); } }
      else if (o.ph==='walkHome'){ var r=o.ref, hx=r.unit.rx[0]+(r.unit.rx[1]-r.unit.rx[0])*0.42; o.x+=Math.sign(hx-o.x)*Math.min(Math.abs(hx-o.x),62*dt); if (Math.abs(hx-o.x)<1){ S.riders.splice(S.riders.indexOf(o),1); r.x=hx; r.y=A.fy(r.unit.f)-16; r.state='home'; r.fear=Math.max(0,(r.fear||0)); g0.res.push(r); if (r.unit) r.unit.doorOpen=2; } }
    });
    // 𨋢
    var g=ghost();
    if (g&&(g.out||g.home)){ S.gi=null; g=null; hideUI(); }
    if (S.gWait!=null){ var gw=g0.gh[S.gWait], nw=gw&&g0.nodes[gw.node]; if (!gw||gw.to||!nw||nw.kind!=='lift'||nw.f!==S.gCall){ S.gCall=null; S.gWait=null; } }
    switch(S.st){
      case 'idle': { var t=chooseTarget(); if (t!=null){ if (Math.abs(t-S.pos)<0.01){ arrive(); } else startMove(t); } break; }
      case 'move': { var w=wanted(); var t2=chooseTarget(); if (t2!=null && S.dir>0 && t2>S.pos && t2<S.target) S.target=t2; if (t2!=null && S.dir<0 && t2<S.pos && t2>S.target) S.target=t2;
        var d=S.target-S.pos, ad=Math.abs(d), vm=Math.min(VMAX,Math.sqrt(2*ACC*ad)+0.05); S.v=Math.min(vm,S.v+ACC*dt); var mv=Math.min(ad,S.v*dt); S.pos+=Math.sign(d)*mv;
        if (rnd()<dt*0.5) S.fx.flick=0.18;
        if (ad-mv<=0.002){ S.pos=S.target; SND.hum(false); arrive(); } break; }
      case 'opening': { S.door=Math.min(1,S.door+dt/DOOR_T); if (S.door>=1){ S.st='open'; S.hold=Math.max(S.hold,HOLD); } break; }
      case 'open': { boardAndExit(dt);
        S.hold-=dt; if (S.fx.over>0) S.hold=Math.max(S.hold,0.3);
        if (S.hold<=0){ S.st='closing'; SND.door(); } break; }
      case 'closing': { S.door=Math.max(0,S.door-dt/DOOR_T); if (S.door<=0){ S.st='closed'; } break; }
      case 'closed': { var t3=chooseTarget(); if (t3!=null && Math.abs(t3-S.pos)>0.01) startMove(t3); else if (t3!=null){ S.st='opening'; SND.door(); } else { S.st='idle'; } break; }
      case 'stuckMove': { var dd=S.stuckTo-S.pos; var st=Math.min(Math.abs(dd),1.3*dt); S.pos+=Math.sign(dd)*st; if (Math.abs(dd)<=0.003){ S.pos=S.stuckTo; S.st='stuck'; SND.hum(false); SND.clunk(); S.shake=0.6; } break; }
      case 'stuck': { S.door=Math.min(0.45,S.door+dt/DOOR_T); S.stuckT-=dt; if (S.stuckT<=0){ S.st='unstick'; SND.door(); } break; }
      case 'unstick': { S.door=Math.max(0,S.door-dt/DOOR_T); if (S.door<=0){ var nf=S.dir>=0?Math.ceil(S.pos):Math.floor(S.pos); nf=Math.max(0,Math.min(top(),nf)); S.stops[nf]=1; startMove(nf); S.target=nf; } break; }
    }
    // 鬼喺度等𨋢：到咗、開咗門就自動入
    if (S.gWait!=null && S.gCall==null){ var gw2=g0.gh[S.gWait]; if (gw2 && atFloor() && (S.st==='opening'||S.st==='open') && g0.nodes[gw2.node].f===cabF()) doEnter(gw2,cabF()); }
    if (S.gWait!=null && S.gCall!=null && atFloor() && cabF()===S.gCall && (S.st==='opening'||S.st==='open')){ var gw3=g0.gh[S.gWait]; doEnter(gw3,cabF()); }
    // 鬼喺𨋢入面：釘住位置、保安睇唔到
    g=ghost();
    if (g){ g.to=null; g.auto=null; g.autoS=null; var fN=Math.max(0,Math.min(top(),Math.round(S.pos))); g.node='f'+fN+'_l'; g.x=c.cx; g.y=fyf(S.pos); if (S.door<0.5||!atFloor()) g.inv=Math.max(g.inv||0,0.15); g.taskP=0; }
    for (var df in S.dfx){ S.dfx[df].t+=dt; if (S.dfx[df].t>1.6) delete S.dfx[df]; }
    if (S.st!==S.prevSt){ if (S.st==='opening'&&atFloor()) dingFx(cabF(),true); S.prevSt=S.st; }
    if (S.st==='stuck'||S.st==='stuckMove') S.riders.forEach(function(o){ if (o.ph==='ride'&&o.mood==='bolt'&&!o.boltSaid){ o.boltSaid=1; } });
  };

  // ---------- 世界剖面（疊層 canvas）----------
  var wc=document.createElement('canvas'); wc.id='lift-world'; wc.style.cssText='position:fixed;pointer-events:none;z-index:5;left:0;top:0';
  document.body.appendChild(wc); var wx=wc.getContext('2d');
  function img(k){ var im=A.IMG&&A.IMG[k]; return im&&im.width?im:null; }
  function sprAt(c2,k,x,y,h,alpha,flip,sy){ var im=img(k); if (!im) { c2.fillStyle='rgba(30,30,36,'+(alpha==null?1:alpha)+')'; c2.fillRect(x-h*0.18,y-h,h*0.36,h); return; } var w=h*im.width/im.height; c2.save(); c2.globalAlpha=alpha==null?1:alpha; c2.translate(x,y); if (flip) c2.scale(-1,1); if (sy) c2.scale(1,sy); c2.drawImage(im,-w/2,-h,w,h); c2.restore(); }
  function bub(c2,x,y,t,sc){ c2.save(); c2.font='bold '+Math.round(12/sc)+'px '+A.FONT; var w=Math.min(220/sc,c2.measureText(t).width+14/sc), h=22/sc; c2.fillStyle='rgba(255,250,240,0.95)'; c2.strokeStyle='#1a1a1e'; c2.lineWidth=1.5/sc; c2.beginPath(); c2.rect(x-w/2,y-h,w,h); c2.fill(); c2.stroke(); c2.fillStyle='#1a1a1e'; c2.textAlign='center'; c2.fillText(t,x,y-h*0.3,w-6/sc); c2.restore(); }
  function drawWorld(){
    var cv=A.cv, r=cv.getBoundingClientRect(), D=Math.min(2,window.devicePixelRatio||1);
    if (wc.width!==Math.round(r.width*D)||wc.height!==Math.round(r.height*D)){ wc.width=Math.round(r.width*D); wc.height=Math.round(r.height*D); }
    wc.style.left=r.left+'px'; wc.style.top=r.top+'px'; wc.style.width=r.width+'px'; wc.style.height=r.height+'px';
    wx.setTransform(1,0,0,1,0,0); wx.clearRect(0,0,wc.width,wc.height);
    if (!S||!S.on||A.scene!=='play'||!G()||G().choice||G().over||G().showStory) return;
    var p0=A.W2S(0,0), p1=A.W2S(100,0), sc=(p1.x-p0.x)/100; if (!(sc>0)) return;
    wx.setTransform(D,0,0,D,0,0); wx.save(); wx.beginPath(); var cb=(G().toastT>0&&G().toast)?62:0; wx.rect(0,A.TOP,A.VW,A.VH-A.TOP-A.BOT-cb); try{ (A.BTNS||[]).forEach(function(b){ if (b.y<A.VH-A.BOT && b.y+b.h>A.TOP){ wx.rect(b.x+b.w+2,b.y-2,-(b.w+4),b.h+4); } }); }catch(e){} wx.clip('evenodd');
    wx.setTransform(D*sc,0,0,D*sc,D*p0.x,D*p0.y);
    var c=col(), fh=FH(), cw=(c.x1-c.x0)*0.66, ch=fh*0.6, t=S.t;
    // 鋼纜 + 𨋢廂
    var cy=fyf(S.pos), sh=(S.st==='move'?Math.sin(t*41)*0.8:0)+(S.shake>0?(Math.random()-0.5)*4:0);
    wx.strokeStyle='rgba(180,180,170,0.7)'; wx.lineWidth=1.2; wx.beginPath(); wx.moveTo(c.cx-6,A.fy(FL())-40); wx.lineTo(c.cx-6,cy-ch-2); wx.moveTo(c.cx+6,A.fy(FL())-40); wx.lineTo(c.cx+6,cy-ch-2); wx.stroke();
    wx.save(); wx.translate(sh,0);
    var lit=lightLevel(); wx.fillStyle='#3a3a36'; wx.fillRect(c.cx-cw/2-3,cy-ch-3,cw+6,ch+3);
    var ig=wx.createLinearGradient(0,cy-ch,0,cy); ig.addColorStop(0,'rgba(255,228,150,'+(0.95*lit)+')'); ig.addColorStop(1,'rgba(150,120,70,'+(0.9*lit)+')'); wx.fillStyle='#0a0a0a'; wx.fillRect(c.cx-cw/2,cy-ch,cw,ch); wx.fillStyle=ig; wx.fillRect(c.cx-cw/2,cy-ch,cw,ch);
    // 𨋢入面嘅人
    var inn=inCab(), g=ghost(), n=inn.length+(g?1:0), k=0;
    inn.forEach(function(o){ var px=c.cx-cw/2+cw*(n===1?0.5:0.18+0.64*k/(Math.max(1,n-1))); k++; sprAt(wx,riderSpr(o),px,cy-1,ch*0.82*(o.mood==='cower'?0.7:1),1,k%2===0,null); });
    if (g){ var px2=c.cx-cw/2+cw*(n===1?0.5:0.18+0.64*k/(Math.max(1,n-1))); sprAt(wx,g.d.sprite,px2,cy-2+Math.sin(t*3)*1.5,ch*0.82,0.75,false); }
    if (lit<0.3){ wx.fillStyle='rgba(0,0,0,0.75)'; wx.fillRect(c.cx-cw/2,cy-ch,cw,ch); }
    // 𨋢廂門（只喺兩層之間／卡𨋢時見到；到咗層由𨋢口鋼門負責）
    if (!atFloor()){ var pw2=cw/2*(1-S.door); if (pw2>0.5){ steel(c.cx-cw/2,cy-ch,pw2,ch,1); steel(c.cx+cw/2-pw2,cy-ch,pw2,ch,-1); } if (S.door>0.02) gapLight(c.cx,cy,cw*S.door/2,ch,Math.min(1,S.door*3)); }
    if (S.fx.over>0&&Math.floor(t*6)%2){ wx.fillStyle='rgba(255,40,30,0.35)'; wx.fillRect(c.cx-cw/2,cy-ch,cw,ch); }
    wx.restore();
    // 𨋢口（每層，畫喺𨋢廂前面）：兩扇鋼門左右滑開／合埋、門罅透光、樓層燈閃、叮字
    for (var f=0;f<=top();f++){ var y=A.fy(f), here=atFloor()&&cabF()===f, op=here?ease(S.door):0, dfx=S.dfx[f];
      wx.fillStyle='#2a2b2e'; wx.fillRect(c.cx-cw/2-5,y-ch-5,cw+10,5); wx.fillRect(c.cx-cw/2-5,y-ch,5,ch); wx.fillRect(c.cx+cw/2,y-ch,5,ch); wx.fillStyle='#4a4c50'; wx.fillRect(c.cx-cw/2-5,y-ch-5,cw+10,2);
      if (!here){ wx.fillStyle='#121214'; wx.fillRect(c.cx-cw/2,y-ch,cw,ch); }
      var pw=cw/2*(1-op);
      if (pw>0.5){ steel(c.cx-cw/2,y-ch,pw,ch,1); steel(c.cx+cw/2-pw,y-ch,pw,ch,-1); }
      if (here&&S.door>0.001) gapLight(c.cx,y,cw*op/2,ch,S.door<1?1:0.55);
      // 樓層燈箱
      var fl2=dfx&&dfx.t<1.2&&(Math.floor(dfx.t/0.15)%2===0), lampOn=Math.abs(S.pos-f)<0.5;
      if (fl2){ var hg=wx.createRadialGradient(c.cx,y-ch-12,2,c.cx,y-ch-12,26); hg.addColorStop(0,'rgba(255,214,120,0.85)'); hg.addColorStop(1,'rgba(255,214,120,0)'); wx.fillStyle=hg; wx.fillRect(c.cx-28,y-ch-40,56,56); }
      wx.fillStyle='#000'; wx.fillRect(c.cx-14,y-ch-19,28,13); wx.fillStyle=fl2?'#fff3c0':lampOn?'#ffb347':'#7a4a20'; wx.font='bold 10px '+A.FONT; wx.textAlign='center';
      wx.fillText((S.st==='move'?(S.dir>0?'▲':'▼'):'')+lab(cabF()),c.cx,y-ch-9);
      var wn=S.riders.some(function(o){return o.ph==='wait'&&o.f===f;})||S.gCall===f; wx.fillStyle=wn||fl2?'#ffd54a':'#444'; wx.beginPath(); wx.arc(c.cx+cw/2+9,y-ch*0.5,3.2,0,7); wx.fill();
      // 叮
      if (dfx&&dfx.t<1.4){ var u=dfx.t/1.4, pop=1+0.5*Math.max(0,1-dfx.t/0.18); wx.save(); wx.globalAlpha=Math.min(1,(1-u)*1.6); wx.translate(c.cx+cw/2+16,y-ch-14-u*34); wx.scale(pop,pop); wx.font='bold 20px '+A.FONT; wx.lineWidth=4; wx.strokeStyle='#1a1205'; wx.strokeText('叮',0,0); wx.fillStyle='#ffd54a'; wx.fillText('叮',0,0); wx.restore(); }
    }
    // 企喺𨋢口（未入𨋢）嘅鬼：重畫喺門前，唔好俾鋼門遮住
    (G().gh||[]).forEach(function(q,qi){ if (q.home||q.out||qi===S.gi) return; var nq=G().nodes[q.node]; if (!nq||nq.kind!=='lift'||Math.abs(q.x-c.cx)>cw*0.7) return; var al=(q.inv>0?0.35:0.92);
      if (q.d.key==='tianhua'&&!q.to&&!(q.dropT>0)) sprAt(wx,q.d.sprite,q.x,A.fy(Math.min(FL(),nq.f+1))+14,q.d.h,al,q.dir<0,-1); else sprAt(wx,q.d.sprite,q.x,q.y,q.d.h,al,q.dir<0);
      if (qi===G().active){ wx.strokeStyle='rgba(138,255,200,0.55)'; wx.setLineDash([4,4]); wx.lineWidth=1.5; wx.beginPath(); wx.ellipse(q.x,q.y-2,30,8,0,0,7); wx.stroke(); wx.setLineDash([]); } });
    // 等𨋢嘅人 + 行緊嘅人
    S.riders.forEach(function(o){ if (o.ph==='ride') return; var y=A.fy(o.f); sprAt(wx,riderSpr(o),o.x,y-2,(o.kind==='guard'?64:(o.ref.h||66))*0.9,1,o.ph==='walkHome'?o.x>((o.ref.unit&&o.ref.unit.rx[0])||0):o.x>c.cx); });
    S.riders.forEach(function(o){ if (!o.say) return; if (o.ph==='ride') bub(wx,c.cx,cy-ch-8,o.say,1); else bub(wx,o.x,A.fy(o.f)-80,o.say,1); });
    wx.restore();
  }
  function ease(x){ return x<0.5?2*x*x:1-Math.pow(-2*x+2,2)/2; }
  function steel(x,y,w,h,side){ var gr=wx.createLinearGradient(x,0,x+w,0); gr.addColorStop(0,'#7f8387'); gr.addColorStop(0.45,'#c9ccd0'); gr.addColorStop(1,'#8a8e92'); wx.fillStyle=gr; wx.fillRect(x,y,w,h);
    wx.fillStyle='rgba(255,255,255,0.10)'; for (var i=1;i<4;i++) wx.fillRect(x,y+h*i/4,w,0.8);
    var ex=side>0?x+w-1.6:x; wx.fillStyle='#4a4d52'; wx.fillRect(ex,y,1.6,h); if (w>6){ wx.fillStyle='rgba(40,42,46,0.7)'; wx.fillRect(side>0?x+w-5:x+3.4,y+h*0.42,1.6,h*0.16); } }
  function gapLight(cx,y,half,ch,a){   // 門罅透光：門邊一條暖光＋地下一片光，唔蓋住𨋢內
    wx.save();
    if (half<4){ var gs=wx.createLinearGradient(cx-10,0,cx+10,0); gs.addColorStop(0,'rgba(255,226,150,0)'); gs.addColorStop(0.5,'rgba(255,244,200,'+(0.95*a)+')'); gs.addColorStop(1,'rgba(255,226,150,0)'); wx.fillStyle=gs; wx.fillRect(cx-10,y-ch,20,ch); }
    else [-1,1].forEach(function(sd){ var ex=cx+sd*half, gr=wx.createLinearGradient(ex,0,ex+sd*9,0); gr.addColorStop(0,'rgba(255,236,170,'+(0.75*a)+')'); gr.addColorStop(1,'rgba(255,236,170,0)'); wx.fillStyle=gr; wx.fillRect(Math.min(ex,ex+sd*9),y-ch,9,ch); });
    var w=Math.max(3,half*2); wx.fillStyle='rgba(255,220,140,'+(0.30*a)+')'; wx.beginPath(); wx.moveTo(cx-w/2,y); wx.lineTo(cx+w/2,y); wx.lineTo(cx+w/2+26,y+9); wx.lineTo(cx-w/2-26,y+9); wx.closePath(); wx.fill(); wx.restore(); }
  function lightLevel(){ var d=S.fx.dark; if (d>0){ var e=4.2-d; if (e<0.7){ return (Math.floor(e/0.175)%2)?0.15:1; } return 0.04; } if (S.fx.flick>0) return 0.55; if (S.st==='stuck') return 0.6+0.3*Math.abs(Math.sin(S.t*9)); return 1; }

  // ---------- 𨋢內 UI（HTML 疊層）----------
  // ---- v7 蠟筆 UI：HTML 疊層用嘅 9-slice 蠟筆框／紙紋（一次生成 dataURL，.tw- 前綴樣式）----
  var CRT={bone:['#1e1a16','#5c5246','#d8ccb0'],rust:['#2a190d','#8c4b1d','#e08840'],moss:['#121a11','#3b5431','#8aac6c'],red:['#2b1012','#7a2522','#c4493c'],ink:['#18141b','#3c3544','#958a9c'],violet:['#19132a','#4b3b6e','#9c88cc']};
  function crFrame(tone,press){ var T=CRT[tone], N=64, c=document.createElement('canvas'); c.width=c.height=N*2; var x=c.getContext('2d'); x.scale(2,2); var s=7+tone.charCodeAt(0)*131+tone.length*977+(press?31:0); function r(){ s=(s*16807)%2147483647; return s/2147483647; }
    function path(j){ var P=[]; [[4,4,N-4,4],[N-4,4,N-4,N-4],[N-4,N-4,4,N-4],[4,N-4,4,4]].forEach(function(e){ for (var i=0;i<4;i++){ var t=i/4; P.push([e[0]+(e[2]-e[0])*t+(r()-0.5)*j,e[1]+(e[3]-e[1])*t+(r()-0.5)*j]); } }); x.beginPath(); x.moveTo(P[0][0],P[0][1]); P.forEach(function(p){ x.lineTo(p[0],p[1]); }); x.closePath(); }
    path(1.4); x.fillStyle=T[0]; x.fill(); x.save(); x.clip(); x.strokeStyle=T[1]; x.lineCap='round'; for (var k=-N;k<N*2;k+=4+r()*2){ x.globalAlpha=0.3+r()*0.3; x.lineWidth=0.8+r()*1.3; x.beginPath(); x.moveTo(k,N); x.lineTo(k+N*0.9,0); x.stroke(); }
    x.globalAlpha=1; for (var q=0;q<500;q++){ x.fillStyle=r()<0.6?'rgba(0,0,0,'+(0.1+r()*0.25)+')':'rgba(255,240,220,'+(0.04+r()*0.06)+')'; x.fillRect(r()*N,r()*N,1+r(),1+r()); } x.restore();
    for (var p=0;p<(press?4:3);p++){ x.globalAlpha=p?0.5:0.95; x.strokeStyle=p===2&&!press?'rgba(0,0,0,0.6)':T[2]; x.lineWidth=(press?3.4:2.2)-p*0.35; x.lineJoin='round'; path(2.2); x.stroke(); }
    return 'url('+c.toDataURL()+')'; }
  function crPaperURL(){ var c=document.createElement('canvas'); c.width=c.height=160; var x=c.getContext('2d'), s=11; function r(){ s=(s*16807)%2147483647; return s/2147483647; } x.fillStyle='#141016'; x.fillRect(0,0,160,160);
    x.strokeStyle='#2e2430'; x.lineCap='round'; for (var k=-160;k<320;k+=6+r()*2){ x.globalAlpha=0.25+r()*0.25; x.lineWidth=0.8+r()*1.4; x.beginPath(); x.moveTo(k,160); x.lineTo(k+144,0); x.stroke(); }
    x.globalAlpha=1; for (var q=0;q<1400;q++){ x.fillStyle=r()<0.6?'rgba(0,0,0,'+(0.1+r()*0.25)+')':'rgba(255,240,220,'+(0.03+r()*0.06)+')'; x.fillRect(r()*160,r()*160,1+r()*1.5,1+r()); } return 'url('+c.toDataURL()+')'; }
  function crEdgeURL(){ var c=document.createElement('canvas'); c.width=256; c.height=12; var x=c.getContext('2d'), s=23; function r(){ s=(s*16807)%2147483647; return s/2147483647; } x.lineCap='round';
    for (var p=0;p<3;p++){ x.strokeStyle=p===2?'rgba(0,0,0,0.6)':'#d8ccb0'; x.globalAlpha=p?0.5:0.9; x.lineWidth=2.4-p*0.5; x.beginPath(); x.moveTo(0,4+p*1.5); for (var i=1;i<=16;i++) x.lineTo(i*16,4+p*1.5+(r()-0.5)*2.4); x.stroke(); } return 'url('+c.toDataURL()+')'; }
  var CRF={}; ['bone','rust','moss','red','ink','violet'].forEach(function(t){ CRF[t]=crFrame(t,false); CRF[t+'P']=crFrame(t,true); });
  function bi(t){ return 'border:11px solid transparent;border-image:'+CRF[t]+' 22 fill stretch;background:none;border-radius:0;'; }
  var ui=document.createElement('div'); ui.id='lift-ui'; ui.className='tw-lift';
  ui.innerHTML='<canvas id="lift-cab"></canvas><div id="lift-tricks"></div><div id="lift-block"></div><div id="lift-panel"><div id="lift-st"></div><div id="lift-floors"></div><div id="lift-doors"></div></div>';
  var css=document.createElement('style'); css.textContent=
    '#lift-ui{position:fixed;display:none;z-index:30;pointer-events:none;font-family:'+A.FONT.replace(/"/g,"'")+'}'+
    '#lift-ui.on{display:block}#lift-ui>*{position:absolute;left:0;right:0;pointer-events:auto}'+
    '#lift-cab{width:100%;display:block;transform:translateY(-12px);opacity:0;transition:transform .28s,opacity .28s;border-bottom:3px solid #3a2e2a;box-shadow:0 6px 18px rgba(0,0,0,.6)}#lift-ui.show #lift-cab{transform:none;opacity:1}'+
    '#lift-block{background:transparent;touch-action:none}'+
    '#lift-tricks{display:flex;gap:5px;padding:0 6px;justify-content:center;touch-action:manipulation}'+
    '.tw-lift #lift-panel{background:'+crEdgeURL()+' repeat-x top left/256px 12px,'+crPaperURL()+' repeat 0 0/160px 160px,#141016;padding:12px 8px 10px;box-sizing:border-box;touch-action:manipulation;transform:translateY(20px);opacity:0;transition:transform .28s,opacity .28s;box-shadow:0 -6px 14px rgba(0,0,0,.6)}.tw-lift.show #lift-panel{transform:none;opacity:1}'+
    '.tw-lift #lift-st{color:#e6a85a;font-size:15px;font-weight:bold;height:20px;line-height:20px;text-align:center;text-shadow:1px 2px 0 rgba(6,3,8,.9),0 0 3px #000;white-space:nowrap;overflow:hidden}'+
    '.tw-lift #lift-floors{display:grid;gap:6px;margin:6px 0;justify-content:center}.tw-lift #lift-doors{display:flex;gap:6px}'+
    '.tw-lift .lb{min-width:48px;min-height:48px;'+bi('bone')+'color:#efe5cf;font-weight:bold;font-size:18px;display:flex;align-items:center;justify-content:center;user-select:none;-webkit-user-select:none;transition:transform .06s;box-sizing:border-box;text-shadow:1px 2px 0 rgba(6,3,8,.9),0 0 2px #000}'+
    '.tw-lift .lb.lit{border-image-source:'+CRF.rust+';color:#f6dcb6}.tw-lift .lb.cur{border-image-source:'+CRF.moss+';color:#e4ecd2}'+
    '.tw-lift .lb.press,.tw-lift .lb:active{transform:translateY(2px);border-image-source:'+CRF.boneP+'}.tw-lift .lb.lit.press,.tw-lift .lb.lit:active{border-image-source:'+CRF.rustP+'}'+
    '.tw-lift .ld{flex:1;min-height:52px;'+bi('ink')+'color:#ebe3d6;font-weight:bold;font-size:16px;display:flex;align-items:center;justify-content:center;user-select:none;-webkit-user-select:none;transition:transform .06s;box-sizing:border-box;text-shadow:1px 2px 0 rgba(6,3,8,.9),0 0 2px #000}'+
    '.tw-lift .ld.exit{border-image-source:'+CRF.moss+';color:#e4ecd2}.tw-lift .ld.off{opacity:.45;filter:saturate(.5)}.tw-lift .ld.press,.tw-lift .ld:active{transform:translateY(2px);border-image-source:'+CRF.inkP+'}.tw-lift .ld.exit.press,.tw-lift .ld.exit:active{border-image-source:'+CRF.mossP+'}'+
    '.tw-lift .lt{flex:1;min-height:52px;max-width:76px;'+bi('red')+'color:#f2e3cc;font-size:14px;font-weight:bold;display:flex;flex-direction:column;align-items:center;justify-content:center;line-height:1.15;user-select:none;-webkit-user-select:none;transition:transform .06s;box-sizing:border-box;text-shadow:1px 2px 0 rgba(6,3,8,.9),0 0 2px #000}'+
    '.tw-lift .lt small{font-size:11px;font-weight:bold;color:#e8c4b0}.tw-lift .lt.cd{opacity:.5;filter:saturate(.4)}.tw-lift .lt.press,.tw-lift .lt:active{transform:translateY(2px);border-image-source:'+CRF.redP+'}';
  document.head.appendChild(css); document.body.appendChild(ui);
  var cabCv=ui.querySelector('#lift-cab'), cx2=cabCv.getContext('2d'), trickBox=ui.querySelector('#lift-tricks'), block=ui.querySelector('#lift-block'), panel=ui.querySelector('#lift-panel'), stEl=ui.querySelector('#lift-st'), floorsEl=ui.querySelector('#lift-floors'), doorsEl=ui.querySelector('#lift-doors');
  ['pointerdown','pointermove','pointerup','touchstart','touchmove'].forEach(function(ev){ ui.addEventListener(ev,function(e){ e.stopPropagation(); },{passive:true}); });
  function tapFx(el){ el.classList.add('press'); setTimeout(function(){ el.classList.remove('press'); },160); try{ navigator.vibrate&&navigator.vibrate(10); }catch(e){} }
  function mkBtn(cls,html,fn){ var b=document.createElement('div'); b.className=cls; b.innerHTML=html; b.addEventListener('pointerdown',function(e){ e.preventDefault(); tapFx(b); ac(); fn(); refresh(); }); return b; }
  var built=-1, fBtns={}, tBtns={};
  function build(){
    floorsEl.innerHTML=''; doorsEl.innerHTML=''; trickBox.innerHTML=''; fBtns={}; tBtns={};
    var n=top()+1, cols=n<=7?n:Math.min(7,Math.ceil(n/2)); if (n>14) cols=Math.ceil(n/3); floorsEl.style.gridTemplateColumns='repeat('+cols+',minmax(48px,56px))';
    var order=[]; for (var f=top();f>=0;f--) order.push(f);
    order.forEach(function(f){ var b=mkBtn('lb',lab(f),function(){ L.press(f); }); b.dataset.f=f; floorsEl.appendChild(b); fBtns[f]=b; });
    doorsEl.appendChild(mkBtn('ld','◀▶ 開門',function(){ L.open(); }));
    doorsEl.appendChild(mkBtn('ld','▶◀ 關門',function(){ L.close(); }));
    var ex=mkBtn('ld exit','出𨋢',function(){ L.exit(); }); ex.id='lift-exit'; doorsEl.appendChild(ex);
    TRK.forEach(function(k){ var b=mkBtn('lt','<span>'+TR[k].n+'</span><small></small>',function(){ L.trick(k); }); b.dataset.k=k; trickBox.appendChild(b); tBtns[k]=b; });
    built=n;
  }
  function layout(){
    var r=A.cv.getBoundingClientRect(), W=r.width, H=r.height, D=Math.min(2,window.devicePixelRatio||1);
    ui.style.left=r.left+'px'; ui.style.top=r.top+'px'; ui.style.width=W+'px'; ui.style.height=H+'px';
    var bot=Math.max(A.BOT,200), cabH=Math.round(Math.min(330,Math.max(200,(H-A.TOP-bot)*0.62)));
    cabCv.style.top=A.TOP+'px'; cabCv.style.height=cabH+'px'; if (cabCv.width!==Math.round(W*D)||cabCv.height!==Math.round(cabH*D)){ cabCv.width=Math.round(W*D); cabCv.height=Math.round(cabH*D); }
    trickBox.style.top=(A.TOP+cabH-58)+'px';
    block.style.top=(A.TOP+cabH)+'px'; block.style.height=Math.max(0,H-bot-A.TOP-cabH)+'px';
    panel.style.top=(H-bot)+'px'; panel.style.height=bot+'px';
    L._band={y0:A.TOP+cabH,y1:H-bot};
    return {W:W,H:cabH,D:D};
  }
  function refresh(){
    if (!S||S.gi==null) return; if (built!==top()+1) build();
    var f=cabF(), inn=inCab(), dest=Object.keys(S.stops).map(Number).sort(function(a,b){return a-b;});
    for (var k in fBtns){ fBtns[k].classList.toggle('lit',!!S.lit[k]||S.fx.btnAll>0); fBtns[k].classList.toggle('cur',+k===f&&atFloor()); }
    var any=false; TRK.forEach(function(k){ var ok=L.canTrick(k), b=tBtns[k]; var show=ok===true||ok==='cd'&&(k==='door'?S.riders.some(function(o){return o.ph==='wait'&&o.f===f;}):inn.length>0)||ok==='busy'; b.style.display=show?'flex':'none'; if (show) any=true; b.classList.toggle('cd',ok!==true); b.querySelector('small').textContent=ok==='cd'?Math.ceil(S.cd[k])+'s':ok==='busy'?'進行中':('怕意+'+TR[k].f); });
    trickBox.style.display=any?'flex':'none';
    var ex=doorsEl.querySelector('#lift-exit'); if (ex) ex.classList.toggle('off',!(S.st==='open'&&S.door>0.8&&atFloor()));
    var stTxt={idle:'停定',closed:'停定',move:(S.dir>0?'▲ 上緊':'▼ 落緊'),opening:'開門中',open:'門開咗',closing:'閂門中',stuckMove:'⚠ 卡住',stuck:'⚠ 卡咗喺兩層中間',unstick:'⚠ 重新起動'}[S.st]||'';
    stEl.textContent=(S.msgT>0?S.msg:(lab(f)+' 樓｜'+stTxt+(dest.length?'｜去 '+dest.map(lab).join('、'):'')+'｜𨋢內 '+inn.length+' 人'+(any?'':'（冇人一齊搭）')));
  }
  function showUI(){ if (built!==top()+1) build(); ui.classList.add('on'); layout(); requestAnimationFrame(function(){ ui.classList.add('show'); }); refresh(); }
  function hideUI(){ ui.classList.remove('show'); ui.classList.remove('on'); }
  // 面板開住時：遊戲鏡頭用嚟將𨋢口擺喺中間透明帶（見到𨋢口鋼門開關）
  L.band=function(){ return (S&&S.gi!=null&&ui.classList.contains('on')&&L._band)?L._band:null; };

  // ---------- 𨋢廂內景（程序畫，蠟筆風）----------
  var tex=null;
  function crayonTex(){ if (tex) return tex; tex=document.createElement('canvas'); tex.width=256; tex.height=256; var c=tex.getContext('2d'), s=7; function r(){ s=(s*16807)%2147483647; return s/2147483647; }
    c.strokeStyle='rgba(0,0,0,0.5)'; c.lineWidth=1; for (var i=0;i<900;i++){ var x=r()*256, y=r()*256, l=3+r()*9; c.globalAlpha=0.25+r()*0.4; c.beginPath(); c.moveTo(x,y); c.lineTo(x+l,y-l*0.35); c.stroke(); }
    c.strokeStyle='rgba(255,255,255,0.6)'; for (var j=0;j<300;j++){ var x2=r()*256, y2=r()*256; c.globalAlpha=0.15+r()*0.3; c.beginPath(); c.moveTo(x2,y2); c.lineTo(x2+4+r()*6,y2+r()*2); c.stroke(); } return tex; }
  function poly(c,pts,fill){ c.beginPath(); c.moveTo(pts[0],pts[1]); for (var i=2;i<pts.length;i+=2) c.lineTo(pts[i],pts[i+1]); c.closePath(); c.fillStyle=fill; c.fill(); }
  function texFill(c,pts,a){ c.save(); c.beginPath(); c.moveTo(pts[0],pts[1]); for (var i=2;i<pts.length;i+=2) c.lineTo(pts[i],pts[i+1]); c.closePath(); c.clip(); c.globalAlpha=a||0.18; c.fillStyle=c.createPattern(crayonTex(),'repeat'); c.fillRect(0,0,4000,4000); c.restore(); }
  function drawCab(){
    if (!S||S.gi==null) return; var Lo=layout(), W=Lo.W, H=Lo.H, c=cx2, t=S.t; c.setTransform(Lo.D,0,0,Lo.D,0,0); c.clearRect(0,0,W,H);
    var mv=S.st==='move'||S.st==='stuckMove', sx=(mv?(Math.sin(t*37)*1.1+Math.sin(t*53)*0.6):0)+(S.shake>0?(Math.random()-0.5)*8*S.shake:0), sy=mv?Math.sin(t*29)*0.9:0;
    c.save(); c.translate(sx,sy);
    var bx0=W*0.25, bx1=W*0.75, by0=H*0.2, by1=H*0.84;
    // 天花
    poly(c,[-10,-10,W+10,-10,bx1,by0,bx0,by0],'#5d5847'); texFill(c,[-10,-10,W+10,-10,bx1,by0,bx0,by0],0.2);
    var lit=lightLevel(), lg=c.createRadialGradient(W/2,H*0.06,4,W/2,H*0.06,W*0.55); lg.addColorStop(0,'rgba(255,232,160,'+(0.95*lit)+')'); lg.addColorStop(1,'rgba(255,232,160,0)'); c.fillStyle=lg; c.fillRect(0,0,W,H*0.5);
    c.fillStyle='rgba(255,240,190,'+(0.9*lit)+')'; c.fillRect(W*0.36,H*0.05,W*0.28,H*0.05);
    // 地板
    poly(c,[-10,H+10,W+10,H+10,bx1,by1,bx0,by1],'#4b4034'); texFill(c,[-10,H+10,W+10,H+10,bx1,by1,bx0,by1],0.25);
    c.strokeStyle='rgba(0,0,0,0.25)'; c.lineWidth=1; for (var i=1;i<6;i++){ var q=i/6; c.beginPath(); c.moveTo(bx0+(bx1-bx0)*q,by1); c.lineTo(-10+(W+20)*q,H+10); c.stroke(); }
    // 兩邊鋼牆
    var lw=[-10,-10,bx0,by0,bx0,by1,-10,H+10], rw=[W+10,-10,bx1,by0,bx1,by1,W+10,H+10];
    var gl=c.createLinearGradient(0,0,bx0,0); gl.addColorStop(0,'#7c8084'); gl.addColorStop(1,'#a9adb1'); poly(c,lw,gl); texFill(c,lw,0.22);
    var gr=c.createLinearGradient(W,0,bx1,0); gr.addColorStop(0,'#74787c'); gr.addColorStop(1,'#a3a7ab'); poly(c,rw,gr); texFill(c,rw,0.22);
    c.strokeStyle='rgba(255,255,255,0.12)'; for (var j=0;j<9;j++){ var xx=bx0*j/9; c.beginPath(); c.moveTo(xx,-10+(by0+10)*j/9); c.lineTo(xx,H+10-(H+10-by1)*j/9); c.stroke(); }
    // 扶手
    c.strokeStyle='#d8c690'; c.lineWidth=6; c.lineCap='round'; c.beginPath(); c.moveTo(6,H*0.66); c.lineTo(bx0-4,by0+(by1-by0)*0.62); c.stroke(); c.beginPath(); c.moveTo(W-6,H*0.66); c.lineTo(bx1+4,by0+(by1-by0)*0.62); c.stroke();
    c.strokeStyle='#6a5a30'; c.lineWidth=2; c.beginPath(); c.moveTo(6,H*0.66+3); c.lineTo(bx0-4,by0+(by1-by0)*0.62+2); c.stroke();
    // 右牆塊鏡
    var mr=[W-16,H*0.12,bx1+8,by0+10,bx1+8,by0+(by1-by0)*0.56,W-16,H*0.6];
    var mg=c.createLinearGradient(W,0,bx1,H); mg.addColorStop(0,'#6f8894'); mg.addColorStop(0.5,'#a8c0c8'); mg.addColorStop(1,'#56707c'); poly(c,mr,mg);
    c.save(); c.beginPath(); c.moveTo(mr[0],mr[1]); for (var m=2;m<8;m+=2) c.lineTo(mr[m],mr[m+1]); c.closePath(); c.clip();
    // 鏡入面嘅倒影：𨋢內每個人一個暗影；「鏡中影」多一個
    var inn=inCab(); inn.forEach(function(o,i){ sprAt(c,riderSpr(o),W-40-i*18,H*0.6,H*0.4,0.35,true); });
    if (S.fx.mirror>0){ var a=Math.min(1,S.fx.mirror/0.6,(3.6-S.fx.mirror)/0.4); c.globalAlpha=0.85*a; c.fillStyle='#0c0f12'; var hx=W-58, hy=H*0.26; c.beginPath(); c.ellipse(hx,hy,11,14,0,0,7); c.fill(); c.beginPath(); c.moveTo(hx-14,hy+4); c.quadraticCurveTo(hx-20,hy+60,hx-16,H*0.6); c.lineTo(hx+16,H*0.6); c.quadraticCurveTo(hx+20,hy+60,hx+14,hy+4); c.closePath(); c.fill(); c.fillStyle='rgba(255,255,255,'+(0.7*a)+')'; c.fillRect(hx-5,hy-2,2,2); c.fillRect(hx+3,hy-2,2,2); c.globalAlpha=1; }
    c.fillStyle='rgba(255,255,255,0.25)'; c.beginPath(); c.moveTo(W-30,H*0.15); c.lineTo(W-24,H*0.15); c.lineTo(bx1+30,by0+60); c.lineTo(bx1+24,by0+60); c.fill(); c.restore();
    c.strokeStyle='#c8b878'; c.lineWidth=3; c.beginPath(); c.moveTo(mr[0],mr[1]); for (var m2=2;m2<8;m2+=2) c.lineTo(mr[m2],mr[m2+1]); c.closePath(); c.stroke();
    // 左牆掣板（裝飾）
    c.fillStyle='#3a3c40'; c.fillRect(bx0-38,by0+28,22,58); for (var b=0;b<6;b++){ var onB=S.fx.btnAll>0?(Math.floor(t*10+b)%2===0):!!S.lit[top()-b]; c.fillStyle=onB?'#ffb347':'#8a8d90'; c.beginPath(); c.arc(bx0-27,by0+36+b*9,3,0,7); c.fill(); }
    // 後面：𨋢門＋門外景
    var dw=(bx1-bx0)*0.8, dx0=W/2-dw/2, dy0=by0+(by1-by0)*0.14, dh=by1-dy0;
    c.fillStyle='#8e9296'; c.fillRect(bx0,by0,bx1-bx0,by1-by0); texFill(c,[bx0,by0,bx1,by0,bx1,by1,bx0,by1],0.15);
    var op=S.door; c.save(); c.beginPath(); c.rect(dx0,dy0,dw,dh); c.clip();
    if (atFloor() || S.st!=='stuck'&&S.st!=='unstick'){ c.fillStyle='#2c2b24'; c.fillRect(dx0,dy0,dw,dh); c.fillStyle='#4a4535'; c.fillRect(dx0,dy0+dh*0.82,dw,dh*0.18); c.fillStyle='rgba(255,214,140,0.25)'; c.beginPath(); c.arc(W/2,dy0+10,40,0,7); c.fill();
      var f=cabF(); S.riders.filter(function(o){return o.ph==='wait'&&o.f===f;}).forEach(function(o,i){ sprAt(c,riderSpr(o),dx0+dw*(i%2?0.78:0.22),dy0+dh,dh*0.85,1,i%2===0); }); }
    else { c.fillStyle='#5e594d'; c.fillRect(dx0,dy0,dw,dh); texFill(c,[dx0,dy0,dx0+dw,dy0,dx0+dw,dy0+dh,dx0,dy0+dh],0.35); c.fillStyle='#3a362e'; var sl=dy0+dh*(0.35+0.1*Math.sin(1)); c.fillRect(dx0,sl,dw,dh*0.16); c.fillStyle='rgba(0,0,0,0.5)'; c.fillRect(dx0,sl+dh*0.16,dw,4); }
    c.restore();
    var pw=dw/2*(1-op);
    [0,1].forEach(function(s){ var x=s?dx0+dw-pw:dx0; var dg=c.createLinearGradient(x,0,x+pw,0); dg.addColorStop(0,'#9da1a5'); dg.addColorStop(0.5,'#cfd2d5'); dg.addColorStop(1,'#8a8e92'); c.fillStyle=dg; c.fillRect(x,dy0,pw,dh); texFill(c,[x,dy0,x+pw,dy0,x+pw,dy0+dh,x,dy0+dh],0.12); });
    c.fillStyle='#1d1e20'; c.fillRect(W/2-1,dy0,2,dh*(op<0.02?1:0));
    // 行緊：門罅透過嚟嘅井道光帶
    if (mv && op<0.02){ for (var k=0;k<4;k++){ var yy=dy0+(((t*(S.dir>0?260:-260)+k*dh/4)%dh)+dh)%dh; c.fillStyle='rgba(255,240,200,0.55)'; c.fillRect(W/2-1.5,yy,3,10); } }
    c.strokeStyle='#5c5f63'; c.lineWidth=4; c.strokeRect(dx0-2,dy0-2,dw+4,dh+4);
    // 樓層顯示
    var ix=W/2-38, iy=by0-2; c.fillStyle='#111'; c.fillRect(ix,iy,76,dy0-iy-6>18?dy0-iy-6:22); c.strokeStyle='#777'; c.lineWidth=1.5; c.strokeRect(ix,iy,76,dy0-iy-6>18?dy0-iy-6:22);
    var stuck=S.st==='stuck'||S.st==='stuckMove'||S.st==='unstick', ovr=S.fx.over>0;
    c.font='bold 20px "Courier New",monospace'; c.textAlign='center'; c.fillStyle=ovr?(Math.floor(t*6)%2?'#ff3b2f':'#5a1410'):'#ffa030';
    c.shadowColor=c.fillStyle; c.shadowBlur=8; c.fillText(ovr?'OVER':stuck?'- -':((S.dir>0&&mv?'▲':S.dir<0&&mv?'▼':' ')+lab(cabF())),W/2,iy+19); c.shadowBlur=0;
    // 𨋢內嘅人（前景）＋鬼
    var g=ghost(), slots=[W*0.13,W*0.87,W*0.3,W*0.7];
    inn.forEach(function(o,i){ var x=slots[i%4], cower=o.mood==='cower', hh=H*(cower?0.5:0.78), shk=(cower||o.mood==='bolt')?Math.sin(t*40+i)*1.8:0; sprAt(c,riderSpr(o),x+shk,H+4,hh,1,x>W/2); if (o.say){ c.font='bold 13px '+A.FONT; var tw=Math.min(W*0.46,c.measureText(o.say).width+14), bx=Math.max(4,Math.min(W-tw-4,x-tw/2)), byy=H*0.2+i*28; c.fillStyle='rgba(255,250,240,0.96)'; c.fillRect(bx,byy,tw,24); c.strokeStyle='#1a1a1e'; c.lineWidth=1.5; c.strokeRect(bx,byy,tw,24); c.fillStyle='#1a1a1e'; c.textAlign='center'; c.fillText(o.say,bx+tw/2,byy+17,tw-6); } });
    if (g){ sprAt(c,g.d.sprite,W*0.5,H*1.04+Math.sin(t*2.6)*3,H*0.5,0.5,false); }
    // 燈光：暗、閃、黑
    var dk=1-lit; if (dk>0){ c.fillStyle='rgba(0,0,0,'+(0.92*dk)+')'; c.fillRect(-20,-20,W+40,H+40); if (S.fx.dark>0&&lit<0.1){ c.fillStyle='rgba(220,235,255,0.5)'; var ey=H*0.45+Math.sin(t*1.3)*4; c.fillRect(W*0.62,ey,4,2); c.fillRect(W*0.62+12,ey,4,2); c.font='14px '+A.FONT; c.fillStyle='rgba(200,210,220,0.55)'; c.textAlign='center'; c.fillText('……呼……呼……',W/2,H*0.35); } }
    if (ovr){ c.fillStyle='rgba(255,30,20,'+(Math.floor(t*6)%2?0.18:0.05)+')'; c.fillRect(-20,-20,W+40,H+40); }
    // 暗角
    var vg=c.createRadialGradient(W/2,H/2,H*0.3,W/2,H/2,W*0.75); vg.addColorStop(0,'rgba(0,0,0,0)'); vg.addColorStop(1,'rgba(20,14,0,0.55)'); c.fillStyle=vg; c.fillRect(-20,-20,W+40,H+40);
    c.restore();
  }

  // ---------- 自己嘅迴圈 ----------
  var last=0;
  function running(){ var g0=G(); return A.scene==='play'&&g0&&!g0.over&&!g0.choice&&!g0.showStory&&!g0.ult&&!A.paused; }
  function loop(ts){ requestAnimationFrame(loop); var dt=last?Math.min(0.1,(ts-last)/1000):0; last=ts;
    try{
      if (G()!==lastG) reset();
      if (S&&running()&&!L.manual) L.step(dt);
      var vis=S&&S.gi!=null&&A.scene==='play'&&G()&&!G().over&&!G().choice&&!G().showStory;
      if (vis){ if (!ui.classList.contains('on')) showUI(); refresh(); drawCab(); } else if (ui.classList.contains('on')) { ui.classList.remove('on'); }
      drawWorld();
    }catch(e){ if (!L._err){ L._err=String(e&&e.stack||e); console.error('[lift]',e); } }
  }
  requestAnimationFrame(loop);
  // 測試介面
  L.state=function(){ if (!S) return null; return {dfx:Object.keys(S.dfx).map(Number),on:S.on,pos:S.pos,st:S.st,door:S.door,dir:S.dir,stops:Object.keys(S.stops).map(Number),gi:S.gi,gCall:S.gCall,cd:JSON.parse(JSON.stringify(S.cd)),fx:JSON.parse(JSON.stringify(S.fx)),riders:S.riders.map(function(o){return {kind:o.kind,ph:o.ph,f:o.f,dest:o.dest,mood:o.mood,fear:Math.round(o.fear||0),say:o.say};}),mroom:S.mroom.length,away:S.away.length,log:S.log.slice(-30),err:L._err||null,top:top()}; };
  L.debugRider=function(kind,f,dest){ if (G()!==lastG) reset(); var g0=G(), o;
    if (kind==='guard'){ var h=g0.guards.find(function(h){return h.kind==='guard'&&h.state!=='gone';}); if (!h) return null; o=addGuardRider(h,dest); }
    else { var r=g0.res.find(function(r){return r.state==='home'&&r.unit&&r.unit.f===f;})||g0.res.find(function(r){return r.state==='home'&&r.unit&&r.unit.f>=2;}); if (!r) return null; o=addResRider(r,'snack',dest); r.brave=0; }
    o.f=f; o.ph='wait'; o.x=col().cx-44; return true; };
  L.setPos=function(f){ if (G()!==lastG) reset(); S.pos=f; S.st='idle'; S.door=0; S.v=0; };
  L.noSpawn=function(){ if (G()!==lastG) reset(); S.spawnT=1e9; S.gSpawnT=1e9; };
  L.lab=lab;
  return L;
};
})();
