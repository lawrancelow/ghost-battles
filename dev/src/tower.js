// ---- 電梯模組 core/lift.js ----
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
  // PEOPLE：Q 版／驚嚇圖（window.PPLFX，pangsa v10）
  function rKey(o){ var k=riderSpr(o), F=window.PPLFX; return F?F.key(k,o.mood==='bolt'||o.mood==='cower'):k; }
  function rH(o,k,h){ var F=window.PPLFX; return F?F.hgt(riderSpr(o),k,h):h; }
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
    if (o.mood==='bolt'){ r.state='flee'; r.vx=(rnd()<0.5?-1:1)*150; r.x=c.cx; g0.res.push(r); if (window.PPLFX) PPLFX.screamOn(r); else sayR(r,line('bolt')); r.sayT=2.4; log('bolt'); return; }
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
      var r=o.ref; r.state='flee'; r.vx=(o.x<g.x?-1:1)*160; r.x=o.x; r.y=y-16; g0.res.push(r); if (window.PPLFX) PPLFX.screamOn(r); else sayR(r,line('bolt')); r.sayT=2.4; });
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
      if (o.ph==='walk'){ var slot=S.riders.filter(function(p){return p.ph==='wait'&&p.f===o.f;}).length, tx=c.cx-44-slot*16; o.x+=Math.sign(tx-o.x)*Math.min(Math.abs(tx-o.x),(o.kind==='guard'?36:62)*dt);   /* PEOPLE：保安行慢 */ if (Math.abs(tx-o.x)<1){ o.ph='wait'; o.waitT=0; } }
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
  var wc=document.createElement('canvas'); wc.id='lift-world'; wc.style.cssText='position:fixed;pointer-events:none;z-index:61;left:0;top:0';
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
    S.riders.forEach(function(o){ if (o.ph==='ride') return; var y=A.fy(o.f); var rk=rKey(o); sprAt(wx,rk,o.x,y-2,rH(o,rk,(o.kind==='guard'?64:(o.ref.h||66))*0.9),1,o.ph==='walkHome'?o.x>((o.ref.unit&&o.ref.unit.rx[0])||0):o.x>c.cx); });
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
    '#lift-ui{position:fixed;display:none;z-index:62;pointer-events:none;font-family:'+A.FONT.replace(/"/g,"'")+'}'+
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
    inn.forEach(function(o,i){ var x=slots[i%4], cower=o.mood==='cower', hh=H*(cower?0.5:0.78), shk=(cower||o.mood==='bolt')?Math.sin(t*40+i)*1.8:0; var rk=rKey(o); sprAt(c,rk,x+shk,H+4,Math.min(H*0.9,rH(o,rk,hh)),1,x>W/2); if (o.say){ c.font='bold 13px '+A.FONT; var tw=Math.min(W*0.46,c.measureText(o.say).width+14), bx=Math.max(4,Math.min(W-tw-4,x-tw/2)), byy=H*0.2+i*28; c.fillStyle='rgba(255,250,240,0.96)'; c.fillRect(bx,byy,tw,24); c.strokeStyle='#1a1a1e'; c.lineWidth=1.5; c.strokeRect(bx,byy,tw,24); c.fillStyle='#1a1a1e'; c.textAlign='center'; c.fillText(o.say,bx+tw/2,byy+17,tw-6); } });
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

// ---- 入屋模式 core/unit.js（背景數據表 core/unit_layouts.json）----
window.UNIT_LAYOUTS={"ppr": {"img": "gb_unit_ppr", "W": 1536, "H": 1024, "crop": [250, 830], "floor": 752, "ceil": 280, "ph": 290, "door": 62, "rooms": [{"k": "living", "n": "客廳", "x0": 20, "x1": 524}, {"k": "kitchen", "n": "廚房", "x0": 536, "x1": 810}, {"k": "bed", "n": "睡房", "x0": 824, "x1": 1280}, {"k": "bath", "n": "廁所", "x0": 1296, "x1": 1520}], "spots": [{"k": "lamp", "x": 352, "y": 400}, {"k": "tv", "x": 474, "y": 582}, {"k": "tap", "x": 668, "y": 572}, {"k": "fridge", "x": 770, "y": 600}, {"k": "wardrobe", "x": 1136, "y": 560}, {"k": "mirror", "x": 1354, "y": 478}], "acts": {"sofa": {"x": 330, "pose": "sit", "look": "tv"}, "tv": {"x": 356, "pose": "sit", "look": "tv"}, "table": {"x": 356, "seats": [262, 318, 398, 452], "pose": "sit"}, "cook": {"x": 604, "look": "tap"}, "sink": {"x": 672, "look": "tap"}, "fridge": {"x": 744, "look": "fridge"}, "desk": {"x": 872, "pose": "sit", "look": "wardrobe"}, "pc": {"x": 872, "pose": "sit", "look": "wardrobe"}, "radio": {"x": 356, "pose": "sit", "look": "tv"}, "bed": {"x": 1030, "pose": "lie", "lift": 66}, "shower": {"x": 1440}, "wash": {"x": 1352, "look": "mirror"}}, "search": [{"x": 456, "y": 650, "n": "電視櫃"}, {"x": 560, "y": 620, "n": "碗櫃"}, {"x": 1190, "y": 690, "n": "衣櫃底"}, {"x": 1358, "y": 668, "n": "膠桶"}], "steal": {"table": {"x": 356, "y": 670}, "sofa": {"x": 300, "y": 640}, "door": {"x": 120, "y": 700}, "cook": {"x": 600, "y": 590}, "desk": {"x": 872, "y": 600}}}, "gamer": {"img": "gb_unit_gamer", "W": 1536, "H": 1024, "crop": [130, 880], "floor": 820, "ceil": 140, "ph": 330, "door": 52, "rooms": [{"k": "living", "n": "客廳", "x0": 30, "x1": 524}, {"k": "kitchen", "n": "廚房", "x0": 540, "x1": 850}, {"k": "bed", "n": "睡房", "x0": 870, "x1": 1280}, {"k": "bath", "n": "浴室", "x0": 1300, "x1": 1520}], "spots": [{"k": "pc", "x": 212, "y": 530}, {"k": "fan", "x": 312, "y": 232}, {"k": "fridge", "x": 792, "y": 560}, {"k": "lamp", "x": 1098, "y": 524}, {"k": "wardrobe", "x": 1190, "y": 470}, {"k": "shower", "x": 1440, "y": 372}], "acts": {"pc": {"x": 300, "pose": "sit", "look": "pc"}, "desk": {"x": 300, "pose": "sit", "look": "pc"}, "sofa": {"x": 430, "pose": "sit", "look": "pc"}, "tv": {"x": 430, "pose": "sit", "look": "pc"}, "radio": {"x": 452, "pose": "sit", "look": "pc"}, "table": {"x": 400, "seats": [300, 360, 420, 480], "pose": "sit"}, "cook": {"x": 690, "look": "fridge"}, "sink": {"x": 640}, "fridge": {"x": 760, "look": "fridge"}, "bed": {"x": 1000, "pose": "lie", "lift": 90}, "shower": {"x": 1430}, "wash": {"x": 1350}}, "search": [{"x": 372, "y": 790, "n": "零食枱"}, {"x": 610, "y": 660, "n": "廚櫃"}, {"x": 1220, "y": 680, "n": "衫籃"}, {"x": 1450, "y": 740, "n": "水桶"}], "steal": {"pc": {"x": 250, "y": 620}, "desk": {"x": 250, "y": 620}, "door": {"x": 110, "y": 760}, "sofa": {"x": 290, "y": 770}, "cook": {"x": 660, "y": 560}}}, "shop": {"img": "gb_unit_shop", "W": 1536, "H": 1024, "crop": [290, 830], "floor": 772, "ceil": 300, "ph": 290, "door": 44, "rooms": [{"k": "living", "n": "廳", "x0": 20, "x1": 464}, {"k": "kitchen", "n": "廚房", "x0": 480, "x1": 796}, {"k": "bed", "n": "睡房", "x0": 810, "x1": 1290}, {"k": "bath", "n": "沖涼房", "x0": 1300, "x1": 1510}], "spots": [{"k": "lamp", "x": 262, "y": 384}, {"k": "radio", "x": 238, "y": 582}, {"k": "fan", "x": 414, "y": 548}, {"k": "pots", "x": 552, "y": 496}, {"k": "net", "x": 1140, "y": 530}, {"k": "jar", "x": 1424, "y": 660}], "acts": {"sofa": {"x": 340, "pose": "sit", "look": "radio"}, "tv": {"x": 340, "pose": "sit", "look": "radio"}, "radio": {"x": 300, "pose": "sit", "look": "radio"}, "table": {"x": 270, "seats": [150, 220, 320, 380], "pose": "sit"}, "cook": {"x": 600, "look": "pots"}, "sink": {"x": 700}, "fridge": {"x": 700}, "desk": {"x": 860, "pose": "sit"}, "pc": {"x": 860, "pose": "sit"}, "bed": {"x": 1120, "pose": "lie", "lift": 80}, "shower": {"x": 1380, "look": "jar"}, "wash": {"x": 1460}}, "search": [{"x": 170, "y": 640, "n": "木櫃"}, {"x": 680, "y": 610, "n": "碗櫃"}, {"x": 1200, "y": 716, "n": "樟木槓"}, {"x": 1470, "y": 730, "n": "水桶"}], "steal": {"table": {"x": 270, "y": 680}, "sofa": {"x": 150, "y": 690}, "door": {"x": 90, "y": 740}, "cook": {"x": 590, "y": 640}, "desk": {"x": 856, "y": 610}}}};
// 樓裡有鬼 — 入屋模式（獨立模組）
// 鬼企喺住戶門口（或者撳門／撳門上嘅「入屋」）→ 入到獨立室內介面（疊喺遊戲 canvas 上面嘅另一張 canvas，自己行 rAF）。
// 室內：客廳／廚房／睡房／廁所側面剖面；住客按作息走動；作怪點、直接嚇人、搜嘢、屋內任務；住客警覺爆咗鬼會被趕返出走廊。
// 狀態全部寫返原有物件：住客驚值＝r.fear、驚走用原有 flee()（經 r.fleeAfter）、搜嘢用 takeItem()、怕意 addFear()，所以大樓計數唔會重複／漏計。
// 背景：window.UNIT_LAYOUTS（core/unit_layouts.json，一個 key 一張圖＋房間 x 範圍、地板高度、作怪點）；冇圖就用 room_* 拼砌後備。
// 紅線：冇細路做目標（住戶種類本身冇細路）；神明鎮宅永遠入唔到，只係講「要尊重」；冇真實品牌。
(function(){
'use strict';
window.UnitSys=function(A){
  var U={}, S=null, lastG=null;
  var LIMIT=80, BAN=25, REIN=6, SEE_LIT=26, SEE_DARK=7, RANGE_HOT=130, RANGE_SCARE=150, OMEN=0.6;
  // ---------- 作怪點 ----------
  var HOT={
    lamp:{v:'閃燈熄燈',f:14,loud:0,ln:['盞燈做咩閃吓閃吓……','跳掣？黑麻麻咁……','又停電？']},
    tv:{v:'電視雪花',f:24,loud:1,ln:['部電視自己轉台？！','雪花入面……好似有個人影','我冇撳過遙控㗎！']},
    tap:{v:'水喉自己開',f:20,loud:1,ln:['邊個開咗水喉？','水喉自己嘩啦嘩啦咁流……']},
    fridge:{v:'雪櫃門自己開',f:20,loud:0,ln:['雪櫃門自己彈開咗！','點解成間屋咁凍……']},
    wardrobe:{v:'衣櫃門自己開',f:24,loud:1,ln:['衣櫃門……自己慢慢打開……','入面係咪有人匿埋？']},
    mirror:{v:'鏡入面多個影',f:28,loud:0,ln:['面鏡……我後面有人？','頭先鏡入面嗰個唔係我……']},
    pc:{v:'電腦彈鬼臉',f:26,loud:1,ln:['個 mon 彈咗張臉出嚟！','我隻角色自己行開咗？！']},
    fan:{v:'風扇狂轉',f:18,loud:0,ln:['把風扇自己轉到咁大力？！','啲窗簾吹到飛晒起……']},
    shower:{v:'花灑自己開',f:22,loud:1,ln:['花灑自己開咗……','冇人喺度，點解有水聲？']},
    radio:{v:'收音機自己播',f:20,loud:1,ln:['收音機自己播粵曲……','邊個開咗收音機？']},
    pots:{v:'鑊鏟自己跌',f:22,loud:1,ln:['乒乓聲！鑊鏟自己跌落地！','廚房咩聲呀？！']},
    net:{v:'蚊帳自己郁',f:22,loud:0,ln:['蚊帳自己郁緊……','冇風㗎喎，點解蚊帳會郁？']},
    jar:{v:'水缸冒泡',f:20,loud:0,ln:['水缸咕嚕咕嚕咁冒泡……','水缸入面……有嘢？']}
  };
  var LN={
    see:['嗰度……有嘢！','頭先係咪有個影？','邊個喺度？！','我見到喇！唔好走！','你……你係邊個？'],
    lightOn:['開燈先……','咁黑，開咗盞燈先','點解會跳掣嘅？開返先'],
    go:['咩聲嚟㗎？去睇睇','我過去睇下……','邊度傳嚟嘅聲？'],
    look:['冇嘢喎……','係咪我聽錯？','奇怪……明明有聲'],
    wake:['醒醒呀！屋企有嘢呀！','起身呀，有怪聲呀！'],
    phone:['喂？管理處呀？我屋企有古怪，快啲上嚟！','喂？保安呀？我哋呢層有嘢呀！'],
    lights:['開晒啲燈！開晒佢！','全部燈開晒，睇佢仲點匿！'],
    kick:['出去呀！唔好再嚟！','開晒燈大嗌：「唔該你出去！」'],
    leave:['返工喇，出門口先','出去行下先']
  };
  var lnUsed={};
  function line(k){ var p=LN[k]; if (!lnUsed[k]||!lnUsed[k].length){ var a=p.map(function(_,i){return i;}); for (var i=a.length-1;i>0;i--){ var j=Math.floor(Math.random()*(i+1)); var t=a[i]; a[i]=a[j]; a[j]=t; } lnUsed[k]=a; } return p[lnUsed[k].pop()]; }
  // 住客作息：每種住戶想做咩（權重）
  var WANT={gamer:[['pc',6],['fridge',1.5],['sofa',1.5],['wash',1]], ot:[['desk',4],['tv',3],['cook',2],['shower',1]], gym:[['sofa',2],['shower',3],['cook',3],['tv',2]],
    nurse:[['cook',3],['tv',3],['shower',3],['desk',1]], elder:[['radio',5],['cook',2],['wash',1],['desk',2]], insomnia:[['radio',5],['cook',2],['desk',3]],
    granny:[['tv',6],['cook',3],['wash',1]], couple:[['tv',5],['cook',2.5],['shower',2.5]], mahjong:[['table',1]], shopper:[['sofa',5],['desk',2],['cook',3]],
    taxi:[['tv',6],['cook',2],['shower',2]], cook:[['cook',7],['tv',3]], helper:[['cook',4],['sink',3],['shower',1],['wash',2]], debt:[['sofa',6],['desk',4]]};
  var ACTN={pc:'打機',desk:'坐喺枱前',sofa:'坐梳化',tv:'睇電視',radio:'聽收音機',table:'打麻雀',cook:'煮嘢食',sink:'洗碗',fridge:'搵嘢食',shower:'沖涼',wash:'洗面',bed:'瞓覺'};
  // 屋內任務（跟住戶種類）
  var TASK={gamer:{k:'media'}, ot:{k:'steal',o:'公司門卡',at:'desk'}, gym:{k:'room',room:'bath',act:'shower'}, nurse:{k:'room',room:'bath',act:'shower'},
    elder:{k:'media'}, insomnia:{k:'media'}, granny:{k:'steal',o:'葵扇',at:'sofa'}, couple:{k:'allout'}, mahjong:{k:'steal',o:'一隻麻雀牌',at:'table'},
    shopper:{k:'steal',o:'速遞包裹',at:'door'}, taxi:{k:'media'}, cook:{k:'room',room:'kitchen',act:'cook'}, helper:{k:'steal',o:'熨斗',at:'cook'}, debt:{k:'steal',o:'門口嗰封追數信',at:'door'}};
  // 後備間屋（冇新背景圖時用 room_* 拼）
  var FB={img:null, W:1440, H:420, crop:[20,420], floor:396, ceil:40, ph:230, door:40, fb:true,
    rooms:[{k:'living',n:'客廳',x0:0,x1:360},{k:'kitchen',n:'廚房',x0:360,x1:720},{k:'bed',n:'睡房',x0:720,x1:1080},{k:'bath',n:'廁所',x0:1080,x1:1440}],
    spots:[{k:'lamp',x:180,y:70},{k:'tv',x:300,y:270},{k:'fridge',x:640,y:270},{k:'tap',x:500,y:280},{k:'wardrobe',x:1000,y:260},{k:'mirror',x:1200,y:220}],
    acts:{sofa:{x:150,pose:'sit',look:'tv'},tv:{x:200,pose:'sit',look:'tv'},radio:{x:200,pose:'sit',look:'tv'},table:{x:180,seats:[100,150,210,260],pose:'sit'},cook:{x:450,look:'tap'},sink:{x:520,look:'tap'},fridge:{x:610,look:'fridge'},desk:{x:800,pose:'sit',look:'wardrobe'},pc:{x:800,pose:'sit',look:'wardrobe'},bed:{x:900,pose:'lie',lift:60},shower:{x:1300},wash:{x:1200,look:'mirror'}},
    search:[{x:90,y:360,n:'櫃桶'},{x:560,y:340,n:'碗櫃'},{x:1040,y:360,n:'衣櫃底'},{x:1380,y:370,n:'膠桶'}],
    steal:{}};
  function LAYS(){ return window.UNIT_LAYOUTS||{}; }
  function layFor(un){ var L=LAYS(), k=(A.LV&&A.LV.key==='shop')?'shop':(['gamer','ot','gym'].indexOf(un.hh)>=0?'gamer':'ppr');
    var l=L[k]||L.ppr; if (l&&img(l.img)) { l.key=k; return l; } FB.key='fb'; return FB; }
  // ---------- 工具 ----------
  function G(){ return A.G; }
  function rnd(){ return A.rnd?A.rnd():Math.random(); }
  function pick(a){ return a[Math.floor(rnd()*a.length)]; }
  function img(k){ var im=k&&A.IMG&&A.IMG[k]; return im&&im.width?im:null; }
  function clamp(v,a,b){ return v<a?a:v>b?b:v; }
  function wpick(a){ var t=0; a.forEach(function(p){t+=p[1];}); var r=rnd()*t; for (var i=0;i<a.length;i++){ r-=a[i][1]; if (r<=0) return a[i][0]; } return a[0][0]; }
  function isHH(un){ return !!(un&&un.hh&&un.ot!=='deity'&&un.rs); }
  function iu(un){ if (!un.iu){ var T=TASK[un.hh]||{k:'allout'}; un.iu={alert:0,leftT:0,ban:0,cd:0,task:JSON.parse(JSON.stringify(T)),done:false,fled:0,visits:0,phoned:false}; } return un.iu; }
  function roomAt(x){ var R=S.lay.rooms; for (var i=0;i<R.length;i++) if (x>=R[i].x0-8&&x<=R[i].x1+8) return i; return x<R[0].x0?0:R.length-1; }
  function sayR(r,t){ if (!r) return; r.say=t; r.sayT=2.6; }
  function msg(t,c){ if (S){ S.msg=t; S.msgT=3.2; S.msgC=c||'#efdcb4'; } }
  function wfl(x,y,t,c){ if (!S) return; var yy=y; for (var k=0;k<4&&S.floats.some(function(f){return Math.abs(f.x-x)<140&&Math.abs(f.y-yy)<30;});k++) yy-=32; S.floats.push({x:x,y:yy,t:t,c:c||'#efe5cf',life:1.8}); if (S.floats.length>8) S.floats.shift(); }
  function part(x,y,vx,vy,life,type){ if (S&&S.parts.length<220) S.parts.push({x:x,y:y,vx:vx,vy:vy,life:life,max:life,type:type}); }
  function running(){ var g0=G(); return A.scene==='play'&&g0&&!g0.over&&!g0.choice&&!g0.showStory&&!g0.ult&&!A.paused; }
  function visible(){ var g0=G(); return !!(S&&A.scene==='play'&&g0&&!g0.over&&!g0.choice&&!g0.showStory); }

  // ---------- 聲（WebAudio）----------
  var AC=null, NB=null;
  function ac(){ if (!AC){ try{ AC=new (window.AudioContext||window.webkitAudioContext)(); }catch(e){ AC=null; } } if (AC&&AC.state==='suspended'){ try{AC.resume();}catch(e){} } return AC; }
  function tone(f,t0,dur,vol,type){ var c=ac(); if (!c) return; try{ var o=c.createOscillator(), g=c.createGain(); o.type=type||'sine'; o.frequency.value=f; g.gain.setValueAtTime(0.0001,c.currentTime+t0); g.gain.exponentialRampToValueAtTime(vol,c.currentTime+t0+0.01); g.gain.exponentialRampToValueAtTime(0.0001,c.currentTime+t0+dur); o.connect(g); g.connect(c.destination); o.start(c.currentTime+t0); o.stop(c.currentTime+t0+dur+0.05); }catch(e){} }
  function hiss(t0,dur,vol,freq){ var c=ac(); if (!c) return; try{ if (!NB){ NB=c.createBuffer(1,c.sampleRate,c.sampleRate); var d=NB.getChannelData(0); for (var i=0;i<d.length;i++) d[i]=Math.random()*2-1; } var s=c.createBufferSource(); s.buffer=NB; s.loop=true; var bp=c.createBiquadFilter(); bp.type='bandpass'; bp.frequency.value=freq||900; var g=c.createGain(), T=c.currentTime+t0; g.gain.setValueAtTime(0.0001,T); g.gain.linearRampToValueAtTime(vol,T+dur*0.3); g.gain.linearRampToValueAtTime(0.0001,T+dur); s.connect(bp); bp.connect(g); g.connect(c.destination); s.start(T); s.stop(T+dur+0.05); }catch(e){} }
  var SND={door:function(){ hiss(0,0.5,0.06,500); tone(110,0,0.4,0.05,'triangle'); }, hot:function(k){ if (k==='lamp'){ tone(60,0,0.3,0.12,'square'); } else if (k==='tv'||k==='pc'){ hiss(0,1.2,0.07,2400); } else if (k==='tap'||k==='shower'||k==='jar'){ hiss(0,1.4,0.06,700); } else if (k==='pots'){ tone(880,0,0.3,0.1,'triangle'); tone(660,0.15,0.4,0.08,'triangle'); } else { tone(196,0,1.1,0.06,'triangle'); tone(185,0.1,1.1,0.05,'sine'); } },
    scare:function(){ tone(70,0,0.7,0.2,'sawtooth'); hiss(0,0.6,0.1,300); }, see:function(){ tone(740,0,0.12,0.06,'square'); tone(740,0.16,0.12,0.06,'square'); }, kick:function(){ for (var i=0;i<4;i++) tone(400-i*60,i*0.12,0.18,0.08,'square'); }};
  document.addEventListener('pointerdown',function(){ ac(); },{passive:true});

  // ---------- 入屋／出屋 ----------
  function enterable(g,un){ if (!isHH(un)) return 'no'; var b=A.doorBlock(g,un); if (b) return b; var I=iu(un); if (I.ban>0) return 'ban'; if (I.cd>0) return 'cd'; return true; }
  U.canEnter=function(g,un){ return enterable(g,un)===true; };
  // 由門口入：鬼放入 in 點，經原有 onArrive（計警覺／首次入屋）→ 回調 U.arrive 開室內
  U.enterFromDoor=function(g,un){ var ok=enterable(g,un); if (ok!==true){ blockedMsg(g,un,ok); return false; }
    g.to=null; g.auto=null; g.autoS=null; g.p=0; g.node=un.id; var n=G().nodes[un.id]; g.x=n.x; g.y=n.y; A.onArrive(g); return !!S; };
  function blockedMsg(g,un,why){ var I=un.iu; var t=why==='deity'?'呢度有神明鎮宅，要尊重，我哋唔入':why==='ban'?'呢戶啱啱被趕出嚟，佢哋開晒燈，'+Math.ceil(I.ban)+' 秒後先好再入':why==='cd'?'陰氣未回，'+Math.ceil(I.cd)+' 秒後先入得':(A.BLOCKMSG[why]||'呢戶未入得');
    A.float(un.x,un.y-96,t,'#ffd54a'); if (why==='deity'&&G().wardFx) G().wardFx.push({x:un.x,y:un.y,t:0.9}); }
  // onArrive 去到 in 點時 call：住戶單位就開室內
  U.arrive=function(g,n){ var g0=G(); if (!g0||S||g.i!==g0.active) return false; var un=A.unitOf(n.id); if (!isHH(un)) return false;
    var I=iu(un); if (I.ban>0||I.cd>0){ g.node=un.did; var d=g0.nodes[un.did]; g.x=d.x; g.y=d.y; g.to=null; g.auto=null; blockedMsg(g,un,I.ban>0?'ban':'cd'); return true; }
    open(g,un); return true; };
  function open(g,un){
    var g0=G(), lay=layFor(un), I=iu(un); I.visits++;
    S={un:un, g:g, lay:lay, t:0, limit:LIMIT, gx:lay.door+50, gdir:1, gmv:0, still:1, goX:null, pend:null, joy:null, sc:null, scCd:0, invT:0, stun:0,
       alert:Math.max(0,I.alert-(g0.t-I.leftT)*1.0), calmT:0, flags:{}, actors:[], spots:[], search:[], floats:[], parts:[], fx:[], light:[], dark:[], cam:{x:0,free:null},
       msg:null, msgT:0, task:I.task, searchP:0, searchI:-1, stealP:0, lastSeen:0, kickT:0, flash:0};
    lay.rooms.forEach(function(R,i){ S.light.push(false); S.dark.push(0); });
    lay.spots.forEach(function(p){ if (HOT[p.k]) S.spots.push({k:p.k,x:p.x,y:p.y,room:0,cd:0,t:0}); }); S.spots.forEach(function(p){ p.room=roomAt(p.x); });
    lay.search.forEach(function(p){ S.search.push({x:p.x,y:p.y,n:p.n,room:roomAt(p.x)}); });
    // 任務設定
    var T=S.task; if (T.k==='media'){ var mk=['tv','pc','radio'].find(function(k){ return S.spots.some(function(p){return p.k===k;}); }); if (!mk){ T.k='allout'; } else T.spot=mk; }
    if (T.k==='steal'){ var sp=(lay.steal&&lay.steal[T.at])||null, ac0=lay.acts[T.at]; T.x=sp?sp.x:(ac0?ac0.x:lay.door+120); T.y=sp?sp.y:lay.floor-60; }
    T.t=T.k==='steal'?'偷走'+T.o:T.k==='allout'?'令全屋人走晒（嚇到佢哋奔出屋）':T.k==='room'?(T.room==='bath'?'趁住客沖緊涼，喺'+lay.rooms[3].n+'嚇親佢':'趁住客煮緊嘢食，喺廚房嚇親佢'):
      (T.spot==='tv'?'趁住客睇緊電視，搞部電視':T.spot==='pc'?'趁住客打緊機，搞部電腦':'趁住客聽緊收音機，搞部收音機');
    // 住客
    un.rs.forEach(function(r,i){ if (r.state==='home') S.actors.push(mkActor(r,i,true)); });
    // 燈：醒住嘅人喺邊間，邊間就開燈
    S.actors.forEach(function(a){ if (a.r.awake) S.light[roomAt(a.x)]=true; });
    if (I.lights) S.light=S.light.map(function(){return true;});
    g.inUnit=un; g.to=null; g.auto=null; g.autoS=null; g.taskP=0; g.sc=null; g.still=1;
    S.cam.x=clamp(S.gx-180,0,lay.W); S.invT=2.0;
    SND.door(); hideNative(true);
    var hh=A.HH[un.hh]; msg('入咗'+A.FLN[un.f]+(hh?hh.n:'住戶')+'：熄咗燈嘅房先好郁手；撳作怪點、撳住客嚇人。屋內任務：'+T.t,'#efdcb4'); S.msgT=5.5;
    if (g.d.key==='toyol'&&un.beans&&!un.beansDone){ un.beansDone=true; S.stun=2.6; wfl(S.gx,lay.floor-lay.ph-30,'地下有綠豆！忍唔住坐低數……','#b8f0a0'); }
    if (I.done) S.task.done=true;
  }
  function mkActor(r,i,place){ var a={r:r,i:i,x:S.lay.door+60,dir:1,act:null,actT:0,st:'walk',tx:null,pose:'stand',seeT:0,hitT:-9,goT:0,lightT:0,ex:false};
    if (place){ pickAct(a,true); a.x=a.tx; a.st='act'; a.pose=actPose(a); }
    return a; }
  function actPose(a){ var d=S.lay.acts[a.act]||{}; return d.pose||'stand'; }
  function pickAct(a,first){ var r=a.r, lay=S.lay, k;
    if (!r.awake) k='bed'; else { k=wpick(WANT[r.hh]||[['sofa',1]]); if (!lay.acts[k]) k='sofa'; if (a.act===k&&!first&&k!=='table') k=wpick(WANT[r.hh]||[['sofa',1]]); }
    var d=lay.acts[k]||lay.acts.sofa||{x:lay.door+150}, x=d.x;
    var same=S.actors.filter(function(o){ return o!==a&&o.act===k; }).length;
    if (k==='table'&&d.seats) x=d.seats[a.i%d.seats.length]; else if (same) x+=(same%2?-1:1)*Math.ceil(same/2)*(k==='bed'?110:70);
    a.act=k; a.tx=clamp(x,lay.rooms[0].x0+30,lay.rooms[lay.rooms.length-1].x1-30); a.actT=k==='bed'?1e9:k==='table'?40+rnd()*20:9+rnd()*9; a.st='walk'; a.pose='stand'; }
  U.exit=function(why){ if (!S) return false; var un=S.un, g=S.g, g0=G(), I=iu(un);
    I.alert=S.alert; I.leftT=g0.t; if (why==='kick'){ I.ban=BAN; I.alert=55; } else if (why==='time') I.cd=REIN; else I.cd=1.5;
    g.inUnit=null; g.node=un.did; var d=g0.nodes[un.did]; g.x=d.x; g.y=d.y; g.to=null; g.auto=null; g.autoS=null; g.p=0; g.still=1; g.taskP=0; g.mv=0; g.inv=Math.max(g.inv||0,why==='kick'?0.8:1.4);
    var t=why==='kick'?'被趕出屋！'+BAN+' 秒內呢戶入唔到':why==='time'?'陰氣唔夠，返出走廊透下':'出咗屋';
    A.float(un.x,un.y-90,t,why==='kick'?'#ffb0b0':'#9fd6bf');
    if (why==='kick'){ g0.alert+=1; A.checkAlert(); try{ A.noise(un.did,2); }catch(e){} A.toast(A.FLN[un.f]+'嗰戶開晒燈大嗌，鬼被趕返出走廊——全樓警覺 +1，保安聽到聲過嚟睇。'); }
    S=null; SND.door(); hideNative(false); return true; };

  // ---------- 主推進 ----------
  U.step=function(dt){
    var g0=G(); if (g0!==lastG){ lastG=g0; S=null; hideNative(false); }
    if (g0) g0.units.forEach(function(u){ if (u.iu){ u.iu.ban=Math.max(0,u.iu.ban-dt); u.iu.cd=Math.max(0,u.iu.cd-dt); } });
    if (!S) return; var g=S.g, lay=S.lay, un=S.un;
    if (g.out||g.home||g0.gh.indexOf(g)<0){ S=null; g.inUnit=null; hideNative(false); return; }
    S.t+=dt; S.limit-=dt; S.msgT=Math.max(0,S.msgT-dt); S.scCd=Math.max(0,S.scCd-dt); S.invT=Math.max(0,S.invT-dt); S.stun=Math.max(0,S.stun-dt); S.flash=Math.max(0,S.flash-dt);
    g.inv=Math.max(g.inv||0,0.25); g.node=un.id; g.to=null; g.auto=null; g.autoS=null;
    if (g0.active!==g.i) g0.active=g.i;
    // 鬼移動
    var sp=g.d.sp*g0.mods.spd*2.1, mv=0, jx=S.joy&&S.joy.on?(S.joy.x-S.joy.ox)/58:0;
    if (S.stun>0||S.sc&&S.sc.t<OMEN+0.5) jx=0;
    if (Math.abs(jx)>0.2){ S.goX=null; S.pend=null; mv=clamp(jx,-1,1)*sp*dt; if (S.cam.free) S.cam.free=null; }
    else if (S.goX!=null&&S.stun<=0){ var d=S.goX-S.gx; if (Math.abs(d)<4){ S.goX=null; } else mv=Math.sign(d)*Math.min(Math.abs(d),sp*dt); }
    if (mv){ var nx=clamp(S.gx+mv,lay.rooms[0].x0+10,lay.rooms[lay.rooms.length-1].x1-20); S.gdir=mv>0?1:-1; if (Math.abs(nx-S.gx)>0.1){ S.gmv=0.15; S.still=0; } S.gx=nx;
      if (S.gx<=lay.rooms[0].x0+12&&jx<-0.5){ U.exit('door'); return; } }
    else { S.gmv=Math.max(0,S.gmv-dt); S.still+=dt; }
    if (S.sc&&S.sc.t<OMEN&&S.gmv>0){ wfl(S.gx,lay.floor-lay.ph-20,'一郁就破功','#e6a85a'); S.sc=null; S.scCd=0.4; }
    // 等住嘅動作（撳咗作怪點／住客／搜嘢點 → 行到位先做）
    if (S.pend&&S.goX==null&&S.stun<=0){ var P=S.pend; S.pend=null;
      if (P.k==='hot') trigger(P.p,true); else if (P.k==='scare') scareAt(P.a); }
    // 嚇人招式
    if (S.sc){ var sc=S.sc; sc.t+=dt; if (!sc.hit&&sc.t>=OMEN){ sc.hit=true; strike(sc); } if (sc.t>=OMEN+0.9) S.sc=null; }
    // 搜嘢（企定、靠近）
    searchUpdate(dt);
    // 住客
    actorsUpdate(dt);
    lightsUpdate(dt);
    // 被睇到
    detect(dt);
    thresholds(dt);
    taskCheck();
    // 作怪點計時
    S.spots.forEach(function(p){ p.cd=Math.max(0,p.cd-dt); p.t=Math.max(0,p.t-dt); });
    S.dark=S.dark.map(function(v){ return Math.max(0,v-dt); });
    S.floats.forEach(function(f){ f.life-=dt; f.y-=dt*30; }); S.floats=S.floats.filter(function(f){return f.life>0;});
    S.parts.forEach(function(p){ p.life-=dt; p.x+=p.vx*dt; p.y+=p.vy*dt; if (p.type==='drop'||p.type==='coin'||p.type==='sweat') p.vy+=500*dt; }); S.parts=S.parts.filter(function(p){return p.life>0;});
    if (g0.phase>=3&&!S.flags.dawn){ S.flags.dawn=1; msg('天光喇！住客陸續起身，開晒燈——快啲做完出屋！','#e48a78'); S.actors.forEach(function(a){ a.r.awake=true; a.r.woke=true; }); }
    if (g0.phase>=3) S.alert+=3*dt;
    if (S.alert>=100){ S.alert=100; S.kickT+=dt; if (S.kickT>0.01&&!S.flags.kickSaid){ S.flags.kickSaid=1; var w=S.actors.find(function(a){return a.r.state==='home';}); if (w) sayR(w.r,line('kick')); SND.kick(); }
      if (S.kickT>=1.0){ U.exit('kick'); return; } }
    if (S.limit<=0){ U.exit('time'); return; }
  };
  function searchUpdate(dt){
    var g=S.g, g0=G(), lay=S.lay, un=S.un, near=-1, bd=70;
    if (S.task.k==='steal'&&!S.task.done&&Math.abs(S.gx-S.task.x)<bd){ near=99; }
    else S.search.forEach(function(p,i){ if (Math.abs(p.x-S.gx)<bd&&itemsAt(i).length){ bd=Math.abs(p.x-S.gx); near=i; } });
    var st=S.still>=0.12&&S.stun<=0&&!S.sc&&S.t>0.8;
    if (near<0||!st){ if (S.searchI!==near) S.searchP=0; S.searchI=near; return; }
    if (S.searchI!==near){ S.searchI=near; S.searchP=0; }
    if (near===99){ S.searchP+=dt*g0.mods.task/2.4; if (rnd()<dt*8) part(S.task.x+(rnd()-0.5)*30,S.task.y,(rnd()-0.5)*60,-80,0.6,'dust');
      if (S.searchP>=1){ S.searchP=0; S.task.done=true; taskDone(); } return; }
    var it=itemsAt(near).find(function(k){ var I=A.ITEM[k]; return !I.who||I.who===g.d.key; });
    if (!it){ if (!S.flags['who'+near]){ S.flags['who'+near]=1; var k0=itemsAt(near)[0], w=A.ITEM[k0].who; wfl(S.search[near].x,S.search[near].y-50,(A.ITEM[k0].n)+'要'+({eking:'餓鬼',toyol:'Toyol',tianhua:'天花姐'}[w]||'其他鬼')+'先拎得','#e6a85a'); } return; }
    if (it!=='doll'&&it!=='key'&&it!=='key2'&&it!=='lost'&&g0.bag.length>=A.BAGMAX){ if (!S.flags.full){ S.flags.full=1; wfl(S.gx,lay.floor-lay.ph-20,'收穫格滿咗！','#e48a78'); } return; }
    S.searchP+=dt*g0.mods.task/A.ITEM[it].t;
    if (S.searchP>=1){ S.searchP=0; var ix=un.items.indexOf(it); if (ix>=0){ un.items.splice(ix,1); A.takeItem(g,it,un); wfl(S.search[near].x,S.search[near].y-60,'搜到'+A.ITEM[it].n+'！','#e6a85a'); } }
  }
  // 物件分佈喺各個搜嘢點：un.items 第 j 件放喺第 j%n 個點
  function itemsAt(i){ var n=S.search.length, out=[]; S.un.items.forEach(function(k,j){ if (j%n===i) out.push(k); }); return out; }

  function actorsUpdate(dt){
    var lay=S.lay, un=S.un, door=lay.door, g0=G();
    // 同步：返咗屋企嘅人由門口入嚟
    un.rs.forEach(function(r,i){ if (r.state==='home'&&!(r.fleeAfter>0)&&!S.actors.some(function(a){return a.r===r;})){ var a=mkActor(r,i,false); a.x=door+20; pickAct(a); S.actors.push(a); sayR(r,'返到屋企喇……'); } });
    S.actors.forEach(function(a){ var r=a.r; a.seeT=Math.max(0,a.seeT-dt*0.5); a.lightT=Math.max(0,a.lightT-dt);
      if (r.state!=='home'||r.fleeAfter>0){ // 走：奔出門口
        var run=r.state==='flee'||r.state==='gone'||r.fleeAfter>0; a.pose='stand'; a.st=run?'run':'leave';
        var spd=run?360:110; a.dir=-1; if (a.x>door-30){ a.x=Math.max(door-30,a.x-spd*dt); if (run&&rnd()<dt*10) part(a.x+20,lay.floor-6,40,-20,0.5,'dust'); } else a.hid=true;
        if (r.state!=='home'&&(a.hid||(r.state!=='flee'&&r.state!=='leave'))){ a.gone=true; if (r.state==='flee'||r.state==='gone'){ iu(un).fled++; wfl(door+60,lay.floor-lay.ph-40,'奔咗出屋！','#b2d394'); } } return; }
      if (r.react&&a.st!=='cower'){ a.st='cower'; a.cowT=1.4; }
      if (a.st==='cower'){ a.cowT-=dt; if (a.cowT<=0){ a.st='walk'; if (a.tx==null) pickAct(a); } return; }
      if (!r.awake&&a.act!=='bed'){ pickAct(a); }
      if (r.awake&&a.act==='bed'){ pickAct(a); a.pose='stand'; }
      if (a.st==='walk'||a.st==='go'){ var d=a.tx-a.x, w=r.awake?(a.st==='go'?150:95):95; if (Math.abs(d)<3){ a.x=a.tx; if (a.st==='go'){ a.st='look'; a.lookT=2.6; a.pose='stand'; } else { a.st='act'; a.pose=actPose(a); } } else { a.dir=d>0?1:-1; a.x+=Math.sign(d)*Math.min(Math.abs(d),w*dt); a.pose='stand'; } }
      else if (a.st==='look'){ a.lookT-=dt; a.dir=Math.floor(a.lookT*1.3)%2?1:-1; if (a.lookT<=0){ sayR(r,line('look')); pickAct(a); } }
      else if (a.st==='act'){ a.actT-=dt; var d0=lay.acts[a.act]; if (d0&&d0.look){ var sp=S.spots.find(function(p){return p.k===d0.look;}); if (sp) a.dir=sp.x>a.x?1:-1; } if (a.actT<=0) pickAct(a); }
      // 醒住入咗黑房 → 開燈
      var ri=roomAt(a.x); if (r.awake&&a.st!=='run'&&!S.light[ri]&&S.dark[ri]<=0){ var sleepers=S.actors.some(function(o){ return o!==a&&!o.r.awake&&roomAt(o.x)===ri; });
        if (!sleepers||S.alert>=35){ if (!a.lightT){ a.lightT=1.4; } else if (a.lightT<=0.05){ S.light[ri]=true; a.lightT=0; sayR(r,line('lightOn')); tone(1200,0,0.05,0.05,'square'); } } }
    });
    S.actors=S.actors.filter(function(a){return !a.gone;});
  }
  function lightsUpdate(dt){ var all=S.alert>=85||iu(S.un).lights;
    S.light=S.light.map(function(on,i){ if (S.dark[i]>0) return false; if (all) return true;
      var awake=S.actors.some(function(a){ return a.r.awake&&a.st!=='run'&&roomAt(a.x)===i; });
      if (on&&!awake&&S.alert<35){ S.offT=S.offT||[]; S.offT[i]=(S.offT[i]||0)+dt; if (S.offT[i]>8){ S.offT[i]=0; return false; } } else if (S.offT) S.offT[i]=0;
      return on; }); }
  function facing(a,x){ return Math.sign(x-a.x)===a.dir||Math.abs(x-a.x)<70; }
  function detect(dt){
    var g0=G(), gr=roomAt(S.gx), lit=S.light[gr], any=false, rates=[];
    if (S.invT<=0) S.actors.forEach(function(a){ var r=a.r; if (!r.awake||a.st==='run'||a.st==='cower'||a.act==='shower'&&a.st==='act'||a.act==='bed') return; if (roomAt(a.x)!==gr) return;
      var dx=Math.abs(S.gx-a.x), f=facing(a,S.gx); if (a.st==='act'&&(a.act==='tv'||a.act==='pc'||a.act==='radio')&&dx>=70) f=false;
      var rate=0; if (lit&&f) rate=SEE_LIT; else if (!lit&&f&&dx<110) rate=SEE_DARK; if (!rate) return;
      rate*=(1+0.15*Math.min(3,g0.phase))*(1+(r.brave||0)); any=true; a.seeT=Math.min(3,a.seeT+dt*1.5);
      if (a.seeT>0.8&&!a.saw){ a.saw=true; sayR(r,line('see')); SND.see(); wfl(a.x,S.lay.floor-S.lay.ph*1.15,'！被睇到','#e48a78'); }
      if (a.seeT>0.8) rates.push(rate); });
    // 幾個人一齊睇到：最高嗰個全計，其他人每人加 25%（反應時間：要望實 0.5 秒先開始升）
    rates.sort(function(a,b){return b-a;}); rates.forEach(function(v,i){ S.alert+=(i?v*0.25:v)*dt; });
    S.seenNow=any; if (any) S.calmT=0; else { S.calmT+=dt; S.actors.forEach(function(a){ if (a.seeT<0.1) a.saw=false; }); }
    if (S.calmT>5&&S.alert>0){ var I=iu(S.un); S.alert=Math.max(I.lights?30:0,S.alert-2.5*dt); }
  }
  function thresholds(dt){ var I=iu(S.un), g0=G(), aw=S.actors.filter(function(a){return a.r.awake&&a.st!=='run';});
    if (S.alert>=35&&!S.flags.t35&&aw.length){ S.flags.t35=1; sayR(aw[0].r,'開燈！全部開燈先！'); S.light[roomAt(aw[0].x)]=true; }
    if (S.alert>=55&&!S.flags.t55&&aw.length){ S.flags.t55=1; var sl=S.actors.filter(function(a){return !a.r.awake;}); if (sl.length){ sayR(aw[0].r,line('wake')); sl.forEach(function(a){ a.r.awake=true; a.r.woke=true; a.r.fear=Math.min(95,(a.r.fear||0)+8); }); msg('有人叫醒晒全屋人！','#e48a78'); } }
    if (S.alert>=70&&!I.phoned&&aw.length){ I.phoned=true; sayR(aw[0].r,line('phone')); g0.alert+=1; A.checkAlert(); try{ A.noise(S.un.did,2); }catch(e){} msg('住客打電話去管理處！全樓警覺 +1，保安會去門口睇','#e48a78'); }
    if (S.alert>=85&&!S.flags.t85){ S.flags.t85=1; I.lights=true; if (aw.length) sayR(aw[0].r,line('lights')); msg('佢哋開晒全屋燈！行邊度都會現形','#e48a78'); }
  }

  // ---------- 作怪點 ----------
  function trigger(p,auto){ var g0=G(), g=S.g, H=HOT[p.k];
    if (p.cd>0){ if (!auto) wfl(p.x,p.y-40,H.v+'冷卻緊 '+Math.ceil(p.cd)+' 秒','#ddd2bd'); return false; }
    if (roomAt(S.gx)!==p.room||Math.abs(S.gx-p.x)>RANGE_HOT){ S.goX=clamp(p.x,S.lay.rooms[p.room].x0+20,S.lay.rooms[p.room].x1-20); S.pend={k:'hot',p:p}; return false; }
    if (S.stun>0) return false;
    p.cd=14; p.t=2.6; S.gdir=p.x>S.gx?1:-1; S.alert+=4; S.calmT=0; SND.hot(p.k); wfl(p.x,p.y-50,H.v+'！','#e8a088');
    if (p.k==='lamp'){ S.dark[p.room]=15; S.light[p.room]=false; S.flash=0.4; }
    var hit=0, rm=p.room, media=S.task.k==='media'&&p.k===S.task.spot&&!S.task.done;
    S.actors.forEach(function(a){ var r=a.r; if (r.state!=='home'||a.st==='run') return; var ar=roomAt(a.x), same=ar===rm, adj=Math.abs(ar-rm)===1;
      if (!same&&!(H.loud&&adj)) return;
      var amt=H.f*(same?1:0.35);
      if (media&&same&&a.st==='act'&&(S.lay.acts[a.act]||{}).look===p.k){ S.task.done=true; taskDone(); }
      if (!r.awake){ if (!H.loud&&!same) return; r.awake=true; r.woke=true; amt*=0.6; sayR(r,pick(['咩聲呀……邊個？','發開夢？'])); } else sayR(r,pick(H.ln));
      addRFear(a,amt); hit++;
      if (!same&&a.st!=='go'&&rnd()<0.6){ a.st='go'; a.tx=clamp(p.x+(rnd()-0.5)*60,S.lay.rooms[rm].x0+30,S.lay.rooms[rm].x1-30); sayR(r,line('go')); }
      roomTask(a); });
    if (hit){ A.addFear(2,S.un.x,S.un.y-100); g.energy=Math.min(100,(g.energy||0)+6); }
    for (var i=0;i<8;i++) part(p.x+(rnd()-0.5)*40,p.y+(rnd()-0.5)*30,(rnd()-0.5)*120,-60-rnd()*60,0.8,p.k==='tap'||p.k==='shower'||p.k==='jar'?'drop':'spark');
    return true; }
  function addRFear(a,amt){ var r=a.r, g0=G(); r.fear=(r.fear||0)+amt*g0.mods.pow*(1-(r.brave||0)); r.jumpT=0.5; a.hitT=S.t; if (a.st==='act'||a.st==='walk') { a.st='cower'; a.cowT=0.9; }
    if (r.fear>=100&&!(r.fleeAfter>0)&&r.state==='home'){ r.fleeAfter=0.9; r.fleeG=S.g; } }
  function roomTask(a){ var T=S.task; if (T.k!=='room'||T.done) return; var R=S.lay.rooms[roomAt(a.x)]; if (R.k===T.room&&(a.act===T.act||a.prevAct===T.act)&&(a.st==='act'||a.st==='cower')){ T.done=true; taskDone(); } }
  function taskDone(){ var g=S.g, g0=G(), I=iu(S.un); if (I.done) return; I.done=true; S.task.done=true;
    A.addFear(Math.round(20*g0.mods.fear),S.un.x,S.un.y-110); g.energy=Math.min(100,(g.energy||0)+30); g0.unitCoins=(g0.unitCoins||0)+15; g0.unitTasks=(g0.unitTasks||0)+1;
    A.takeItem(g,'doll',S.un); msg('屋內任務完成：'+S.task.t+'——怕意 +20、能量 +30、替身紙人 +1、冥幣 +15','#b2d394'); S.msgT=4.5; wfl(S.gx,S.lay.floor-S.lay.ph-60,'任務完成！','#b2d394'); tone(523,0,0.3,0.08); tone(784,0.15,0.5,0.08); }
  function taskCheck(){ var T=S.task; if (T.done) return; if (T.k==='allout'){ var rs=S.un.rs; if (rs.length&&rs.every(function(r){ return r.state==='flee'||r.state==='gone'; })&&iu(S.un).fled>0){ T.done=true; taskDone(); } } }

  // ---------- 直接嚇人（用返原本角色嘅嚇人技）----------
  function nearestActor(range){ var gr=roomAt(S.gx), best=null, bd=range; S.actors.forEach(function(a){ if (a.r.state!=='home'||a.st==='run'||a.r.fleeAfter>0) return; var d=Math.abs(a.x-S.gx); if (roomAt(a.x)!==gr&&d>90) return; if (d<bd){ bd=d; best=a; } }); return best; }
  function scareAt(a){ if (!a||a.r.state!=='home'){ return; } if (Math.abs(a.x-S.gx)>RANGE_SCARE||roomAt(a.x)!==roomAt(S.gx)&&Math.abs(a.x-S.gx)>90){ S.goX=a.x+(a.x>S.gx?-80:80); S.pend={k:'scare',a:a}; return; } U.scare(a); }
  U.scare=function(target){ if (!S) return false; var g=S.g;
    if (S.sc) return false; if (S.scCd>0){ wfl(S.gx,S.lay.floor-S.lay.ph-20,'啱啱嚇完，等陣先','#ddd2bd'); return false; }
    if (S.stun>0){ wfl(S.gx,S.lay.floor-S.lay.ph-20,'數緊綠豆，數完先嚇得','#b8f0a0'); return false; }
    var a=target||nearestActor(RANGE_SCARE); if (!a){ var far=nearestActor(2000); if (far){ scareAt(far); wfl(S.gx,S.lay.floor-S.lay.ph-20,'飄過去嚇'+(A.HH[far.r.hh]?A.HH[far.r.hh].n:'住客'),'#e8a088'); return false; } wfl(S.gx,S.lay.floor-S.lay.ph-20,'屋入面冇人喇','#ddd2bd'); return false; }
    S.goX=null; S.pend=null; S.gdir=a.x>S.gx?1:-1; S.still=Math.max(S.still,0.12); S.gmv=0;
    S.sc={t:0,a:a,k:g.d.key,hit:false}; S.scCd=OMEN+1.4; wfl(S.gx,S.lay.floor-S.lay.ph-30,(A.MV[g.d.key]||{n:'嚇！'}).n,'#e8a088'); return true; };
  function strike(sc){ var a=sc.a, r=a.r, g=S.g, gr=roomAt(a.x), lit=S.light[gr];
    if (r.state!=='home') return; var amt=38, tag='';
    if (!lit){ amt*=1.5; tag='黑暗中嚇加倍！'; } if (S.t-a.hitT<5){ amt*=1.3; tag=(tag?tag+' ':'')+'連環嚇！'; }
    a.prevAct=a.act; A.scareRes(r,amt,g); a.hitT=S.t; a.st='cower'; a.cowT=1.6; S.alert+=lit?12:5; S.calmT=0; SND.scare(); S.flash=0.25;
    if (tag) wfl(a.x,S.lay.floor-S.lay.ph*1.2,tag,'#e6a85a');
    for (var i=0;i<10;i++) part(a.x,S.lay.floor-S.lay.ph*0.7,(rnd()-0.5)*200,-100-rnd()*80,0.7,sc.k==='toyol'?'coin':sc.k==='tianhua'?'drop':'crumb');
    roomTask(a); }

  // ---------- 畫 ----------
  var cv=document.createElement('canvas'); cv.id='unit-cv'; cv.style.cssText='position:fixed;z-index:63;left:0;top:0;display:none;touch-action:none';
  document.body.appendChild(cv); var c=cv.getContext('2d'), W=390, H=844, DPR=1, BTN=[], PRESS=null, ptr=null;
  function hideNative(on){ cv.style.display=on?'block':'none'; if (!on){ ptr=null; if (S) S.joy=null; } }
  function layout(){ var r=A.cv.getBoundingClientRect(); DPR=Math.min(2,window.devicePixelRatio||1); W=r.width||A.VW; H=r.height||A.VH;
    cv.style.left=r.left+'px'; cv.style.top=r.top+'px'; cv.style.width=W+'px'; cv.style.height=H+'px';
    var cw=Math.round(W*DPR), ch=Math.round(H*DPR); if (cv.width!==cw||cv.height!==ch){ cv.width=cw; cv.height=ch; } }
  function view(){ var lay=S.lay, top=A.TOP, ph=H-A.TOP-A.BOT, s=ph/(lay.crop[1]-lay.crop[0]); return {top:top,ph:ph,s:s,vw:W/s}; }
  function P(x,y,V){ return {x:(x-S.cam.x)*V.s, y:V.top+(y-S.lay.crop[0])*V.s}; }
  function sprite(k,x,y,h,o){ var im=img(k); if (!im) { c.fillStyle='rgba(30,30,36,'+((o&&o.alpha)||1)+')'; c.fillRect(x-h*0.18,y-h,h*0.36,h); return; } var w=h*im.width/im.height; o=o||{}; c.save(); c.globalAlpha=o.alpha==null?1:o.alpha; c.translate(x,y); if (o.rot) c.rotate(o.rot); c.scale((o.flip?-1:1)*(o.sx||1),o.sy||1); c.drawImage(im,-w/2,-h,w,h); c.restore(); }
  function bubble(x,y,t){ c.font='bold 13px '+A.FONT; var w=Math.min(W-20,c.measureText(t).width+18); x=clamp(x,w/2+6,W-w/2-6); A.crBlit(c,A.crGet(w,24,'note','bar'),x-w/2,y-26); c.save(); c.fillStyle='#2a1e1c'; c.textAlign='center'; c.fillText(t,x,y-9,w-8); c.restore(); }
  function btn(id,x,y,w,h,label,tone,on){ BTN.push({id:id,x:x,y:y,w:w,h:h}); var pz=(ptr&&ptr.btn===id)||(PRESS&&PRESS.id===id&&performance.now()-PRESS.t<220); A.crBtn(c,x,y,w,h,label,tone,pz,on===false); }
  function txt(s,x,y,sz,col,al,mw){ A.crText(c,s,x,y,sz,col,al||'center',mw); }
  function drawBG(V){ var lay=S.lay, im=img(lay.img);
    if (im){ var k=im.width/lay.W, ch=lay.crop[1]-lay.crop[0], srcY=(im.height/k>=lay.H-4?lay.crop[0]:0)*k; c.drawImage(im,S.cam.x*k,srcY,V.vw*k,ch*k,0,V.top,W,V.ph); }
    else { lay.rooms.forEach(function(R,i){ var a=P(R.x0,lay.crop[0],V), b=P(R.x1,lay.crop[1],V); if (b.x<0||a.x>W) return; var RK={living:['room_mahjong','room_shopper'],kitchen:['room_helper'],bed:['room_nurse','room_gamer'],bath:[]}[R.k]||[]; var key=RK.find(function(k){return img(k);});
      if (key) c.drawImage(img(key),a.x,a.y,b.x-a.x,b.y-a.y); else { var gd=c.createLinearGradient(0,a.y,0,b.y); gd.addColorStop(0,'#2a3134'); gd.addColorStop(1,'#151a1c'); c.fillStyle=gd; c.fillRect(a.x,a.y,b.x-a.x,b.y-a.y); c.strokeStyle='rgba(180,200,200,0.12)'; for (var tx=a.x;tx<b.x;tx+=22*V.s){ c.beginPath(); c.moveTo(tx,a.y); c.lineTo(tx,b.y); c.stroke(); } }
      c.fillStyle='#0d0b0e'; c.fillRect(b.x-6*V.s,a.y,12*V.s,(b.y-a.y)*0.35); }); }
  }
  function drawSpot(p,V){ var q=P(p.x,p.y,V), a=p.t>0, T=S.t, s=V.s, k=p.k, r=34*s+10;
    c.save();
    if (a){ c.globalAlpha=Math.min(1,p.t);
      if (k==='tv'||k==='pc'){ for (var i=0;i<60;i++){ c.fillStyle='rgba(230,235,240,'+Math.random()*0.8+')'; c.fillRect(q.x-40*s+Math.random()*80*s,q.y-28*s+Math.random()*50*s,3,2); } c.fillStyle='rgba(10,10,10,0.6)'; c.beginPath(); c.ellipse(q.x,q.y,10*s,14*s,0,0,7); c.fill(); if (k==='pc'){ c.fillStyle='#c0302a'; c.fillRect(q.x-6*s,q.y-4*s,4*s,4*s); c.fillRect(q.x+3*s,q.y-4*s,4*s,4*s); } }
      else if (k==='lamp'){ var on=Math.floor(T*14)%3===0; if (on){ var gr=c.createRadialGradient(q.x,q.y,2,q.x,q.y,120*s); gr.addColorStop(0,'rgba(255,240,190,0.55)'); gr.addColorStop(1,'rgba(255,240,190,0)'); c.fillStyle=gr; c.fillRect(q.x-120*s,q.y-120*s,240*s,240*s); } }
      else if (k==='tap'||k==='shower'){ c.strokeStyle='rgba(170,215,240,0.85)'; c.lineWidth=3; for (var j=0;j<4;j++){ c.beginPath(); var xx=q.x+(j-1.5)*4*s; c.moveTo(xx,q.y); c.lineTo(xx+Math.sin(T*20+j)*2,q.y+(k==='shower'?200:60)*s); c.stroke(); } }
      else if (k==='wardrobe'||k==='fridge'){ var o=Math.abs(Math.sin((2.6-p.t)*1.5))*44*s; c.fillStyle=k==='fridge'?'rgba(200,240,255,0.35)':'rgba(10,6,8,0.85)'; c.beginPath(); c.moveTo(q.x+20*s,q.y-70*s); c.lineTo(q.x+20*s+o,q.y-80*s); c.lineTo(q.x+20*s+o,q.y+90*s); c.lineTo(q.x+20*s,q.y+80*s); c.closePath(); c.fill(); if (k==='wardrobe'){ c.fillStyle='rgba(220,40,40,0.8)'; c.beginPath(); c.arc(q.x+6*s,q.y-20*s,2.5,0,7); c.arc(q.x+14*s,q.y-20*s,2.5,0,7); c.fill(); } }
      else if (k==='mirror'){ c.globalAlpha*=0.5+0.3*Math.sin(T*8); sprite(S.g.d.sprite,q.x,q.y+40*s,90*s,{alpha:0.55}); }
      else if (k==='fan'){ c.strokeStyle='rgba(220,230,235,0.5)'; c.lineWidth=2; for (var j2=0;j2<3;j2++){ c.beginPath(); c.ellipse(q.x,q.y,(50+j2*14)*s,10*s,0,T*30+j2,T*30+j2+2); c.stroke(); } }
      else if (k==='radio'){ c.fillStyle='#e8d2a0'; c.font='bold '+Math.round(22*s+8)+'px '+A.FONT; c.textAlign='center'; c.fillText('♪',q.x-20*s+Math.sin(T*5)*8,q.y-40*s-((T*60)%30)); c.fillText('♫',q.x+20*s,q.y-30*s-((T*60+15)%30)); }
      else if (k==='pots'){ var dy=Math.min(1,(2.6-p.t)*2)*160*s; c.fillStyle='#3a3a3e'; c.beginPath(); c.ellipse(q.x+10*s,q.y+dy,18*s,8*s,(2.6-p.t)*6,0,7); c.fill(); }
      else if (k==='net'){ c.strokeStyle='rgba(235,235,230,0.55)'; c.lineWidth=2; for (var j3=0;j3<6;j3++){ c.beginPath(); var bx=q.x-90*s+j3*36*s; c.moveTo(bx,q.y-110*s); c.quadraticCurveTo(bx+Math.sin(T*6+j3)*24*s,q.y,bx+Math.sin(T*4+j3)*14*s,q.y+110*s); c.stroke(); } }
      else if (k==='jar'){ for (var j4=0;j4<5;j4++){ c.strokeStyle='rgba(180,220,230,0.7)'; c.beginPath(); c.arc(q.x+(j4-2)*10*s,q.y-50*s-((T*80+j4*13)%40)*s,4*s+2,0,7); c.stroke(); } }
      c.globalAlpha=1; }
    // 提示圈（可撳）
    var ready=p.cd<=0, inR=roomAt(S.gx)===p.room&&Math.abs(S.gx-p.x)<=RANGE_HOT;
    c.globalAlpha=ready?(inR?0.85+0.15*Math.sin(T*6):0.45+0.2*Math.sin(T*3)):0.35;
    c.strokeStyle=ready?(inR?'#e6a85a':'#b2d394'):'#7a6e74'; c.lineWidth=inR&&ready?3:2; c.setLineDash(ready?[]:[4,4]); c.beginPath(); c.arc(q.x,q.y,r*0.62,0,7); c.stroke(); c.setLineDash([]);
    if (!ready){ c.strokeStyle='#e8d2a0'; c.lineWidth=3; c.beginPath(); c.arc(q.x,q.y,r*0.62,-Math.PI/2,-Math.PI/2+Math.PI*2*(1-p.cd/14)); c.stroke(); }
    c.globalAlpha=1; c.restore();
    if (ready&&inR) txt(HOT[k].v,q.x,q.y-r*0.62-6,12,'#e6a85a');
  }
  // 住客：用 window.PPLFX（pangsa v10）統一畫法——Q 版高度、驚嚇圖（res_xxx_scared，npc_* 唔換臉）、嚇中跳起／!!／臉青白、驚值高發抖四圍望縮起、驚走舉手＋浮字慘叫
  function drawActor(a,V){ var r=a.r, lay=S.lay, FX=window.PPLFX, run=a.st==='run', scared=!!FX&&((r.shockT>0)||run), h0=lay.ph*(r.h||74)/74*V.s, k2=FX?FX.key(r.sprite,scared):r.sprite, h=FX?FX.hgt(r.sprite,k2,h0):h0, art=k2!==r.sprite,
      q=P(a.x,lay.floor,V), rot=0, sy=1, sx=0, oy=0, al=1, sxs=1, tint=0, flip=a.dir<0, bed=a.act==='bed'&&a.st==='act';
    if (q.x<-80||q.x>W+80||a.hid) return;
    var lit=S.light[roomAt(a.x)];
    if (a.pose==='sit'&&a.st==='act'){ sy=0.86; }
    if (bed){ rot=-1.45; oy=-(lay.acts.bed.lift||60)*V.s; sx=h*0.45; }
    if (a.act==='shower'&&a.st==='act'){ al=0.85; }
    if (a.st==='cower'||r.react){ sx+=Math.sin(S.t*40)*2; sy*=0.94; }
    if (run){ oy-=Math.abs(Math.sin(a.x*0.045))*10; rot=-a.dir*0.18; tint=art?0.12:0.3; }
    if (FX&&r.shockT>0&&!run&&!bed){ var S0=FX.shock(r.shockT,r.shockA||1); sy*=S0.sy; sxs=S0.sx; oy+=S0.jy*h; sx+=S0.sh*h; tint=S0.tint*(art?0.55:1); }
    else if (FX&&r.awake&&(r.fear||0)>=55&&!run&&!bed){ var T0=FX.tremble(r,S.t); sx+=T0.sh*h; sy*=T0.sy; if (a.st!=='walk'&&a.st!=='go'&&T0.flip!=null) flip=T0.flip; tint=T0.tint; }
    else if (!FX&&r.jumpT>0){ oy-=Math.sin((0.5-r.jumpT)/0.5*Math.PI)*16; }
    // 嚇中嗰下：汗滴／淚滴（每次嚇中一次）
    if (FX&&r.shockN&&a.shkN!==r.shockN){ a.shkN=r.shockN; for (var j=0;j<5;j++) part(a.x+(Math.random()-0.5)*30,lay.floor-lay.ph*0.85,(Math.random()-0.5)*220,-120-Math.random()*90,0.8,'drop'); }
    c.fillStyle='rgba(0,0,0,0.45)'; c.beginPath(); c.ellipse(q.x,q.y,26*V.s+6,6,0,0,7); c.fill();
    if (FX&&run&&!art) FX.arms(c,q.x+sx,q.y+oy,h,a.dir,S.t);
    if (FX) FX.draw(c,r.sprite,k2,q.x+sx,q.y+oy,h,{flip:flip,rot:rot,sy:sy,sx:sxs,alpha:al,tint:tint});
    else sprite(r.sprite,q.x+sx,q.y+oy,h,{flip:flip,rot:rot,sy:sy,alpha:al});
    if (a.act==='shower'&&a.st==='act'){ for (var i=0;i<3;i++){ c.fillStyle='rgba(220,230,235,0.18)'; c.beginPath(); c.arc(q.x+(i-1)*30*V.s,q.y-h*(0.4+0.2*i)-((S.t*20+i*10)%20),24*V.s+8,0,7); c.fill(); } }
    if (bed&&!r.awake){ txt('Z',q.x+h*0.5,q.y+oy-h*0.25-((S.t*14)%14),15,'#c8d8ff'); txt('z',q.x+h*0.6,q.y+oy-h*0.35-((S.t*14+7)%14),11,'#c8d8ff'); }
    var top=q.y+oy-(bed?h*0.35:h*Math.min(1,sy));
    if (FX&&r.shockT>0) FX.bang(c,q.x+sx,top-10,1-r.shockT/0.9,1.1);
    else if (FX&&run) FX.bang(c,q.x,top-8,0.5,0.9);
    if (r.fear>0&&!run) A.crBar(c,q.x-24,top-12,48,8,r.fear/100,'red');
    if (a.saw&&a.seeT>0.2&&!(r.shockT>0)){ txt('！',q.x,top-18,26,'#ffe25a'); }
    if (FX&&r.scream) FX.scream(c,clamp(q.x,90,W-90),top-24,r.scream,1.15);
    if (r.say) bubble(q.x,top-(r.fear>0?18:6),r.say);
  }
  function drawGhost(V){ var g=S.g, lay=S.lay, gr=roomAt(S.gx), lit=S.light[gr]&&S.invT<=0, h=lay.ph*0.74*(g.d.h/76)*V.s, q=P(S.gx,lay.floor,V), key=g.d.sprite, by=q.y, sy=1, rot=0, ox=0, oy=0;
    var al=S.invT>0?0.25:lit?0.92:0.5;
    if (g.d.key==='tianhua'&&S.gmv<=0&&img('tianhua_hang')){ key='tianhua_hang'; by=P(0,lay.ceil+20,V).y+h*1.05; }
    else if (S.gmv>0){ oy=-Math.abs(Math.sin(S.t*12))*6; rot=S.gdir*0.08; } else { oy=Math.sin(S.t*2.5)*4-4; }
    if (S.sc){ var t=S.sc.t; if (t<OMEN){ var k=t/OMEN; c.fillStyle={eking:'rgba(210,90,40,',toyol:'rgba(120,220,140,',tianhua:'rgba(110,190,255,'}[g.d.key]+(0.3*k)+')'; c.beginPath(); c.arc(q.x,by-h*0.5,h*0.6*(0.6+0.4*k),0,7); c.fill(); sy=1-0.08*k; } else { ox=S.gdir*30*V.s*Math.sin(Math.min(1,(t-OMEN)/0.3)*Math.PI); } }
    if (S.stun>0){ txt('一、二、三……',q.x,by-h-10,14,'#b8f0a0'); }
    c.save(); c.shadowColor='rgba(140,255,200,0.85)'; c.shadowBlur=lit?4:14; sprite(key,q.x+ox,by+oy,h,{flip:S.gdir<0,alpha:al,rot:rot,sy:sy}); c.restore();
    c.fillStyle='rgba(110,255,190,0.35)'; c.beginPath(); c.ellipse(q.x,q.y,30*V.s+8,7,0,0,7); c.fill();
    if (!lit&&S.invT<=0){ txt('黑暗中',q.x,q.y+16,11,'#a9c79a'); } else if (lit&&S.invT<=0){ txt('現形！燈著咗',q.x,q.y+16,12,'#e48a78'); }
    if (S.searchP>0){ var sq=S.searchI===99?P(S.task.x,S.task.y,V):S.search[S.searchI]?P(S.search[S.searchI].x,S.search[S.searchI].y,V):q; c.strokeStyle='#b2d394'; c.lineWidth=5; c.beginPath(); c.arc(sq.x,sq.y-30,16,-Math.PI/2,-Math.PI/2+Math.PI*2*S.searchP); c.stroke(); }
    // 招式效果
    if (S.sc&&S.sc.t>=OMEN){ var a=S.sc.a, aq=P(a.x,lay.floor,V), u=Math.min(1,(S.sc.t-OMEN)/0.4), k2=g.d.key, ah=lay.ph*V.s;
      if (k2==='eking'){ c.save(); c.globalAlpha=1-Math.max(0,(S.sc.t-OMEN-0.5)/0.4); c.fillStyle='#120808'; c.beginPath(); c.ellipse(aq.x,aq.y-ah*0.55,ah*0.5*u,ah*0.38*u,0,0,7); c.fill(); c.fillStyle='#7a0e0e'; c.beginPath(); c.ellipse(aq.x,aq.y-ah*0.55,ah*0.4*u,ah*0.24*u*Math.abs(Math.sin(S.t*12)),0,0,7); c.fill(); c.fillStyle='#e8e0cc'; for (var i=0;i<7;i++){ var tx=aq.x-ah*0.32*u+i*ah*0.1*u; c.beginPath(); c.moveTo(tx,aq.y-ah*0.55-ah*0.2*u); c.lineTo(tx+ah*0.05*u,aq.y-ah*0.55-ah*0.08*u); c.lineTo(tx+ah*0.1*u,aq.y-ah*0.55-ah*0.2*u); c.fill(); } c.restore(); }
      if (k2==='tianhua'){ c.strokeStyle='rgba(12,12,14,0.9)'; c.lineWidth=2.4; var cy=P(0,lay.ceil+10,V).y; for (var hx=-60;hx<=60;hx+=7){ c.beginPath(); c.moveTo(aq.x+hx*V.s,cy); c.quadraticCurveTo(aq.x+hx*V.s+Math.sin(S.t*6+hx)*10,cy+(aq.y-cy)*0.5*u,aq.x+hx*V.s,cy+(aq.y-cy)*0.85*u); c.stroke(); } }
      if (k2==='toyol'){ for (var j=0;j<6;j++){ c.fillStyle='rgba(40,30,20,0.8)'; c.beginPath(); c.ellipse(aq.x-80*V.s+j*28*V.s,aq.y-4,6,3,0,0,7); c.fill(); } sprite('toyol',aq.x+Math.sin(S.t*20)*20,aq.y-ah*0.6,ah*0.45,{alpha:0.8}); } }
  }
  function draw(){
    layout(); c.setTransform(DPR,0,0,DPR,0,0); c.fillStyle='#0b0b0d'; c.fillRect(0,0,W,H); BTN=[];
    var V=view(), lay=S.lay, g0=G();
    // 鏡頭
    var fx=S.gx; if (S.sc&&S.sc.a) fx=(S.gx+S.sc.a.x)/2; var tgt=S.cam.free!=null?S.cam.free:fx-V.vw/2; tgt=clamp(tgt,0,Math.max(0,lay.W-V.vw)); S.cam.x+=(tgt-S.cam.x)*0.18; if (Math.abs(tgt-S.cam.x)<0.5) S.cam.x=tgt;
    c.save(); c.beginPath(); c.rect(0,V.top,W,V.ph); c.clip();
    if (S.flash>0){ c.translate((Math.random()-0.5)*8*S.flash,0); }
    drawBG(V);
    // 房燈：熄燈嘅房暗晒
    lay.rooms.forEach(function(R,i){ var a=P(R.x0,lay.crop[0],V), b=P(R.x1,lay.crop[1],V); if (b.x<0||a.x>W) return;
      if (!S.light[i]){ c.fillStyle='rgba(4,4,14,'+(S.dark[i]>0?0.74:0.6)+')'; c.fillRect(a.x,a.y,b.x-a.x,b.y-a.y); }
      else { var gr=c.createRadialGradient((a.x+b.x)/2,a.y+30,10,(a.x+b.x)/2,a.y+30,(b.x-a.x)*0.8); gr.addColorStop(0,'rgba(255,226,160,0.12)'); gr.addColorStop(1,'rgba(255,226,160,0)'); c.fillStyle=gr; c.fillRect(a.x,a.y,b.x-a.x,b.y-a.y); }
      txt(R.n+(S.light[i]?'・燈著':'・黑'),(a.x+b.x)/2,a.y+20,12,S.light[i]?'#e8d2a0':'#8a7e84'); });
    // 門口
    var dq=P(lay.door,lay.floor,V); c.fillStyle='rgba(120,255,190,'+(0.2+0.15*Math.sin(S.t*4))+')'; c.fillRect(dq.x-16,dq.y-lay.ph*V.s*1.05,32,lay.ph*V.s*1.05); txt('門口',dq.x,dq.y-lay.ph*V.s*1.05-6,12,'#a9c79a');
    S.spots.forEach(function(p){ drawSpot(p,V); });
    // 搜嘢點
    S.search.forEach(function(p,i){ var its=itemsAt(i); if (!its.length) return; var q=P(p.x,p.y,V); c.fillStyle='rgba(230,168,90,'+(0.5+0.3*Math.sin(S.t*3+i))+')'; c.beginPath(); c.arc(q.x,q.y,6,0,7); c.fill();
      var cnt={}, ord=[]; its.forEach(function(k){ if (!cnt[k]){ cnt[k]=0; ord.push(k); } cnt[k]++; }); txt('✦'+ord.map(function(k){ return A.ITEM[k].n+(cnt[k]>1?'×'+cnt[k]:''); }).join(' '),q.x,q.y-12,11,'#e6dcc6'); });
    if (S.task.k==='steal'&&!S.task.done){ var tq=P(S.task.x,S.task.y,V); c.strokeStyle='rgba(178,211,148,'+(0.6+0.3*Math.sin(S.t*5))+')'; c.lineWidth=3; c.beginPath(); c.arc(tq.x,tq.y,14,0,7); c.stroke(); txt('任務：'+S.task.o,tq.x,tq.y-20,12,'#b2d394'); }
    S.actors.slice().sort(function(a,b){ return a.act==='bed'?-1:0; }).forEach(function(a){ drawActor(a,V); });
    drawGhost(V);
    S.parts.forEach(function(p){ var q=P(p.x,p.y,V), a=p.life/p.max; c.globalAlpha=Math.min(1,a*1.4); c.fillStyle=p.type==='drop'?'#9fd0f0':p.type==='coin'?'#e6c25a':p.type==='dust'?'rgba(180,170,150,0.6)':p.type==='crumb'?'#e8c07a':'#f0e0b0'; c.beginPath(); c.arc(q.x,q.y,p.type==='dust'?6*(1-a)+2:3,0,7); c.fill(); c.globalAlpha=1; });
    S.floats.forEach(function(f){ var q=P(f.x,f.y,V); c.globalAlpha=Math.min(1,f.life); txt(f.t,clamp(q.x,80,W-80),q.y,15,f.c); c.globalAlpha=1; });
    if (S.flash>0){ c.fillStyle='rgba(255,250,230,'+(S.flash*0.5)+')'; c.fillRect(0,V.top,W,V.ph); }
    c.restore();
    if (S.cam.free!=null) btn('follow',W/2-66,V.top+8,132,46,'◎ 跟返隻鬼','moss');
    drawHUD(V,g0);
    drawJoy();
  }
  function drawHUD(V,g0){ var lay=S.lay, un=S.un, T=A.TOP, hh=A.HH[un.hh];
    A.crPanel(c,-8,-8,W+16,T+8,'paper');
    var fr=Math.min(1,g0.t/(A.PHT*3)); A.crBar(c,12,8,W-24,13,fr,'dawn');
    txt(A.FLN[un.f]+'・'+(hh?hh.n:'住戶')+'　'+(g0.phase<3?A.PH[g0.phase]:'天光')+'　屋內剩 '+Math.max(0,Math.ceil(S.limit))+' 秒',12,40,14,S.limit<15?'#e48a78':'#efe5cf','left',W-120);
    txt('屋企人警覺',12,70,13,S.alert>=70?'#e48a78':'#cfc4b0','left'); A.crBar(c,98,58,W-216,15,S.alert/100,'red'); txt(Math.round(S.alert)+'',98+(W-216)/2,71,11,'#efe5cf');
    btn('out',W-108,32,98,52,'出屋','moss');
    var y0=H-A.BOT; A.crPanel(c,-8,y0,W+16,A.BOT+8,'paper');
    if (S.msgT>0&&S.msg){ var mh=56; A.crPanel(c,10,y0-mh-6,W-20,mh,'sheet'); c.font='bold 13px '+A.FONT; wrapT(S.msg,20,y0-mh+14,W-40,17,S.msgC); }
    // 房間條（撳＝睇嗰間）
    var n=lay.rooms.length, tw=(W-20-(n-1)*6)/n, gr=roomAt(S.gx);
    lay.rooms.forEach(function(R,i){ var x=10+i*(tw+6), ppl=S.actors.filter(function(a){return roomAt(a.x)===i&&a.st!=='run';}).length;
      btn('room'+i,x,y0+8,tw,36,'',i===gr?'moss':S.light[i]?'rust':'ink'); txt(R.n+(ppl?' '+ppl+'人':''),x+tw/2,y0+24,12,'#efe5cf','center',tw-6); txt(S.light[i]?'燈著':'黑',x+tw/2,y0+39,10,S.light[i]?'#efdcb4':'#9a8e92','center'); });
    var T2=S.task; txt((T2.done?'✓ 任務完成：':'任務：')+T2.t,12,y0+64,13,T2.done?'#b2d394':'#e8d2a0','left',W-24);
    // 掣
    var g=S.g, bx=10, by=y0+76;
    btn('scare',bx,by,104,58,S.scCd>0&&!S.sc?'嚇！'+Math.ceil(S.scCd):'嚇！','red');
    btn('inv',bx+112,by,84,58,g.invCd>0?'隱身 '+Math.ceil(g.invCd):'隱身','violet',g.invCd<=0);
    var C=ctxBtn(); if (C) btn('ctx',bx+204,by,W-bx-214,58,C.t,C.tone,C.on!==false); else txt('行近發光圈＝作怪點',bx+204+(W-bx-214)/2,by+34,12,'#9a8e92','center',W-bx-220);
    txt('怕意 '+g0.fear+'　收穫 '+g0.bag.length+'/'+A.BAGMAX+'　紙人 '+g0.dolls+'/6　匙 紅'+(g0.keys.key||0)+' 黃'+(g0.keys.key2||0),12,y0+156,12,'#cfc4b0','left',W-24);
    txt('拖動＝移動；撳作怪點／住客＝飄過去做；企定喺✦先搜得嘢',W/2,H-14,12,'#9a8e92','center',W-16);
  }
  function ctxBtn(){ var g=S.g, a=null; try{ a=A.ctxAction(g); }catch(e){}
    if (a&&a.k==='deliver') return {k:'deliver',t:a.t,tone:'moss'};
    var gr=roomAt(S.gx), best=null, bd=RANGE_HOT+1; S.spots.forEach(function(p){ if (p.room!==gr) return; var d=Math.abs(p.x-S.gx); if (d<bd){ bd=d; best=p; } });
    if (best) return best.cd>0?{k:'hot',p:best,t:HOT[best.k].v+' '+Math.ceil(best.cd)+'s',tone:'ink',on:false}:{k:'hot',p:best,t:'作怪：'+HOT[best.k].v,tone:'rust'};
    if (S.searchI>=0) return {k:'search',t:'搜緊……企定',tone:'ink',on:false};
    return null; }
  function wrapT(t,x,y,w,lh,col){ var ln='',yy=y; for (var i=0;i<t.length;i++){ var tt=ln+t[i]; if (c.measureText(tt).width>w){ txt(ln,x,yy,13,col,'left'); ln=t[i]; yy+=lh; if (yy>y+lh*1.5) { ln=''; break; } } else ln=tt; } if (ln) txt(ln,x,yy,13,col,'left'); }
  function drawJoy(){ if (!S||!S.joy||!S.joy.on) return; var j=S.joy, dx=clamp(j.x-j.ox,-58,58); c.save(); c.globalAlpha=0.7; A.crBlit(c,A.crGet(116,116,'paper','ring'),j.ox-58,j.oy-58); c.globalAlpha=0.92; A.crBlit(c,A.crGet(48,48,'bone','ring2'),j.ox+dx-24,j.oy-24); c.restore(); }

  // ---------- 輸入 ----------
  function pt(e){ var r=cv.getBoundingClientRect(); return {x:e.clientX-r.left,y:e.clientY-r.top}; }
  function hit(x,y){ var best=null, bd=1e9, PAD=10; for (var i=BTN.length-1;i>=0;i--){ var b=BTN[i]; if (x>=b.x-PAD&&x<=b.x+b.w+PAD&&y>=b.y-PAD&&y<=b.y+b.h+PAD){ var d=(x>=b.x&&x<=b.x+b.w&&y>=b.y&&y<=b.y+b.h)?-1:Math.hypot(x-(b.x+b.w/2),y-(b.y+b.h/2)); if (d<bd){ bd=d; best=b; } } } return best; }
  cv.addEventListener('pointerdown',function(e){ e.stopPropagation(); e.preventDefault(); ac(); if (!S) return; var p=pt(e), b=hit(p.x,p.y);
    if (b){ PRESS={id:b.id,t:performance.now()}; try{ navigator.vibrate&&navigator.vibrate(10); }catch(_){} ptr={id:e.pointerId,btn:b.id,sx:p.x,sy:p.y}; S.joy=null; try{cv.setPointerCapture(e.pointerId);}catch(_){} return; }
    var inPlay=p.y>A.TOP&&p.y<H-A.BOT; ptr={id:e.pointerId,sx:p.x,sy:p.y,drag:false,hud:!inPlay}; if (inPlay) S.joy={ox:p.x,oy:p.y,x:p.x,y:p.y,on:false}; try{cv.setPointerCapture(e.pointerId);}catch(_){} });
  cv.addEventListener('pointermove',function(e){ e.stopPropagation(); if (!S||!ptr||ptr.id!==e.pointerId) return; var p=pt(e); if (!ptr.btn&&Math.hypot(p.x-ptr.sx,p.y-ptr.sy)>12) ptr.drag=true; if (S.joy){ S.joy.x=p.x; S.joy.y=p.y; if (ptr.drag) S.joy.on=true; } });
  cv.addEventListener('pointerup',function(e){ e.stopPropagation(); if (!S){ ptr=null; return; } if (ptr&&ptr.id!==e.pointerId) return; var p=pt(e), was=ptr; ptr=null; var j=S.joy&&S.joy.on; S.joy=null;
    if (!was) return; if (was.btn){ var b=hit(p.x,p.y); if ((b&&b.id===was.btn)||Math.hypot(p.x-was.sx,p.y-was.sy)<24) press(was.btn); return; }
    if (!was.drag&&!j&&!was.hud) worldTap(p.x,p.y); });
  cv.addEventListener('pointercancel',function(e){ ptr=null; if (S) S.joy=null; });
  ['touchstart','touchmove','touchend','click','contextmenu'].forEach(function(ev){ cv.addEventListener(ev,function(e){ e.stopPropagation(); if (ev!=='touchstart') e.preventDefault(); },{passive:false}); });
  function press(id){ if (!S) return; var g0=G(), g=S.g;
    if (id==='out'){ U.exit('door'); return; }
    if (id==='follow'){ S.cam.free=null; return; }
    if (id.indexOf('room')===0){ var R=S.lay.rooms[+id.slice(4)], V=view(); S.cam.free=clamp((R.x0+R.x1)/2-V.vw/2,0,Math.max(0,S.lay.W-V.vw)); return; }
    if (id==='scare'){ S.cam.free=null; U.scare(); return; }
    if (id==='inv'){ if (g.invCd>0) return; S.invT=g0.mods.inv; g.invCd=g0.mods.inv+9; wfl(S.gx,S.lay.floor-S.lay.ph-20,'隱身','#a9a0d8'); return; }
    if (id==='ctx'){ var C=ctxBtn(); if (!C) return; if (C.k==='deliver'){ A.actPress(); msg('交還咗失物，佢哋好似冇咁驚喇','#b2d394'); return; } if (C.k==='hot') trigger(C.p,false); return; }
  }
  function worldTap(x,y){ var V=view(), wx=x/V.s+S.cam.x, wy=(y-V.top)/V.s+S.lay.crop[0], lay=S.lay;
    S.cam.free=null;
    var hs=null, hd=60/V.s; S.spots.forEach(function(p){ var d=Math.hypot(p.x-wx,p.y-wy); if (d<hd){ hd=d; hs=p; } });
    if (hs){ trigger(hs,false); return; }
    var ta=null, td=1e9; S.actors.forEach(function(a){ if (a.st==='run') return; var h=lay.ph*(a.act==='bed'&&a.st==='act'?0.5:1); if (Math.abs(wx-a.x)<70&&wy<lay.floor+20&&wy>lay.floor-h-30){ var d=Math.abs(wx-a.x); if (d<td){ td=d; ta=a; } } });
    if (ta){ scareAt(ta); return; }
    if (Math.abs(wx-lay.door)<50){ S.goX=lay.door+4; S.pend=null; wfl(lay.door,lay.floor-lay.ph-10,'行去門口（撳「出屋」就走得）','#a9c79a'); return; }
    S.goX=clamp(wx,lay.rooms[0].x0+14,lay.rooms[lay.rooms.length-1].x1-20); S.pend=null; }

  // ---------- 大樓剖面（hook 喺 pangsa draw 世界座標入面 call）----------
  // 住戶門口：可以入 → 綠光＋「入屋」掣；神明鎮宅 → 柔和紅燈（尊重，唔入）；已完成任務／走晒人 → 標記
  U.drawWorld=function(ctx){ var g0=G(); if (!g0) return; var g=g0.gh[g0.active], T=g0.t, nearU=null, nd=150, gn=g&&g0.nodes[g.node];
    if (gn&&!g.inUnit) g0.units.forEach(function(un){ if (un.f!==gn.f||!isHH(un)) return; var d=Math.abs(un.x-g.x); if (d<nd&&enterable(g,un)===true){ nd=d; nearU=un; } });
    g0.units.forEach(function(un){ var x=un.x, y=un.y; un._ib=null;
      if (un.ot==='deity'){ var gr=ctx.createRadialGradient(x,y-60,2,x,y-60,46); gr.addColorStop(0,'rgba(220,60,40,'+(0.32+0.08*Math.sin(T*2))+')'); gr.addColorStop(1,'rgba(220,60,40,0)'); ctx.fillStyle=gr; ctx.fillRect(x-46,y-106,92,92); ctx.fillStyle='rgba(200,40,30,0.85)'; ctx.fillRect(x-4,y-104,8,4); return; }
      if (!isHH(un)) return; var I=un.iu;
      var tags=[]; if (I&&I.done) tags.push('✓任務'); if (un.rs.length&&un.rs.every(function(r){return r.state==='flee'||r.state==='gone';})) tags.push('走晒'); if (I&&I.ban>0) tags.push('封 '+Math.ceil(I.ban)+'s');
      if (tags.length){ ctx.font='bold 11px '+A.FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; var tt=tags.join(' '); ctx.strokeText(tt,x,y-72); ctx.fillStyle=I&&I.ban>0?'#e48a78':'#b2d394'; ctx.fillText(tt,x,y-72); }
      if (!g||g.home||g.out||g.inUnit||un!==nearU) return;
      var ok=enterable(g,un)===true; if (!ok) return;
      ctx.save(); ctx.globalAlpha=0.35+0.25*Math.sin(T*5); ctx.fillStyle='#78ffbe'; ctx.fillRect(x-13,y-62,26,58); ctx.restore();
      var bw=70, bh=34, bxw=x-bw/2, byw=y-112; A.crBlit(ctx,A.crGet(bw,bh,'moss','n'),bxw,byw); A.crText(ctx,'入屋',x,byw+bh/2+1,16,'#e4ecd2','center',bw-8,true);
      un._ib={x:bxw,y:byw,w:bw,h:bh}; });
  };
  // 大樓剖面撳嘢：撳「入屋」掣或者撳住戶門
  U.worldTap=function(wx,wy){ var g0=G(); if (!g0) return false; var g=g0.gh[g0.active]; if (!g||g.home||g.out) return false;
    var hitU=null; g0.units.forEach(function(un){ if (hitU) return; var b=un._ib; var onBtn=b&&wx>=b.x-8&&wx<=b.x+b.w+8&&wy>=b.y-8&&wy<=b.y+b.h+8; var onDoor=Math.abs(wx-un.x)<24&&wy>un.y-70&&wy<un.y+6; if (onBtn||onDoor) hitU=un; });
    var un=hitU; if (!un) return false;
    if (un.ot==='deity'){ blockedMsg(g,un,'deity'); return true; }
    if (!isHH(un)) return false;
    var ok=enterable(g,un); if (ok!==true){ blockedMsg(g,un,ok); return true; }
    if (g.node===un.did&&!g.to){ U.enterFromDoor(g,un); return true; }
    if (A.gotoNode(g,un.id)){ g.autoS=null; A.float(un.x,un.y-96,'行去入屋','#9fd6bf'); return true; }
    A.float(un.x,un.y-96,'去唔到','#ffb0b0'); return true; };
  // ctxAction：門口嘅互動掣
  U.action=function(g,n){ if (n.kind!=='door') return null; var un=null, g0=G(); g0.units.forEach(function(u){ if (u.did===n.id) un=u; }); if (!un) return null;
    if (un.ot==='deity') return {k:'unitRespect',t:'（神明鎮宅：要尊重，唔入）'};
    if (!isHH(un)) return null; var ok=enterable(g,un);
    if (ok===true) return {k:'unitIn',t:'入屋：'+(A.HH[un.hh]?A.HH[un.hh].n:'住戶'),un:un};
    if (ok==='ban'||ok==='cd') return {k:'unitBan',t:'（'+(ok==='ban'?'佢哋開晒燈守住':'陰氣未回')+'：'+Math.ceil(ok==='ban'?un.iu.ban:un.iu.cd)+' 秒）',un:un};
    return null; };
  U.act=function(g,a){ if (a.k==='unitIn'){ U.enterFromDoor(g,a.un); return true; } if (a.k==='unitRespect'){ var g0=G(), un=g0.units.find(function(u){return u.did===g.node;}); if (un) blockedMsg(g,un,'deity'); return true; } if (a.k==='unitBan'){ blockedMsg(g,a.un,a.un.iu.ban>0?'ban':'cd'); return true; } return false; };
  U.holds=function(g){ return !!(S&&S.g===g); };
  U.covering=function(){ return visible(); };
  U.on=function(){ return !!S; };

  // ---------- 自己嘅迴圈 ----------
  var last=0;
  function loop(ts){ requestAnimationFrame(loop); var dt=last?Math.min(0.1,(ts-last)/1000):0; last=ts;
    try{
      if (G()!==lastG){ lastG=G(); S=null; hideNative(false); }
      if (running()&&!U.manual) U.step(dt);
      var vis=visible(); if (vis){ if (cv.style.display==='none') cv.style.display='block'; draw(); } else if (cv.style.display!=='none'){ cv.style.display='none'; ptr=null; if (S) S.joy=null; }
    }catch(e){ if (!U._err){ U._err=String(e&&e.stack||e); console.error('[unit]',e); } }
  }
  requestAnimationFrame(loop);
  // ---------- 測試介面 ----------
  U.state=function(){ if (!S) return null; return {un:S.un.id, hh:S.un.hh, lay:S.lay.key, gx:Math.round(S.gx), room:roomAt(S.gx), alert:Math.round(S.alert*10)/10, limit:Math.round(S.limit), light:S.light.slice(), dark:S.dark.map(Math.round), task:{k:S.task.k,t:S.task.t,done:!!S.task.done,spot:S.task.spot,x:S.task.x},
    actors:S.actors.map(function(a){ return {hh:a.r.hh, x:Math.round(a.x), room:roomAt(a.x), act:a.act, st:a.st, awake:!!a.r.awake, fear:Math.round(a.r.fear||0), rstate:a.r.state}; }),
    spots:S.spots.map(function(p){ return {k:p.k,x:p.x,y:p.y,room:p.room,cd:Math.round(p.cd)}; }), search:S.search.map(function(p,i){ return {x:p.x,y:p.y,items:itemsAt(i)}; }), err:U._err||null, sc:!!S.sc, scCd:S.scCd, invT:S.invT, stun:S.stun}; };
  U.toScreen=function(x,y){ if (!S) return null; var V=view(), q=P(x,y,V), r=cv.getBoundingClientRect(); return {x:q.x+r.left,y:q.y+r.top}; };
  U.camSnap=function(){ if (!S) return; var V=view(); S.cam.x=clamp((S.cam.free!=null?S.cam.free:S.gx-V.vw/2),0,Math.max(0,S.lay.W-V.vw)); };
  U.btns=function(){ var r=cv.getBoundingClientRect(); return BTN.map(function(b){ return {id:b.id,x:b.x+r.left,y:b.y+r.top,w:b.w,h:b.h}; }); };
  U.setAlert=function(v){ if (S) S.alert=v; };
  U.setGX=function(x){ if (S){ S.gx=x; S.goX=null; } };
  U.trig=function(i){ return S?trigger(S.spots[i],false):false; };
  U.press=press; U.layFor=layFor; U.HOT=HOT;
  U._S=function(){ return S; };
  return U;
};
})();

// ===================== 樓裡有鬼（由 /home/claude/lyg 獨立版移植；用 tools/port_tower.py 重新生成，唔好直接改）=====================
// 樓裡有鬼 — 組屋關（rumah pangsa）：橫切五層樓 + 天台，路徑點網絡，我哋係鬼
const Tower=(function(){
  var OPEN=false, RAF=0, ROOT=document.createElement('section'); ROOT.id='tw-root'; ROOT.className='tw-root';
  var _cv=document.createElement('canvas'); _cv.className='tw-cv'; ROOT.appendChild(_cv); document.body.appendChild(ROOT);
  function TS(){ if (!S.tower) S.tower={unlocked:true,cleared:{},best:0,nights:0}; S.tower.cleared=S.tower.cleared||{}; return S.tower; }
  if (typeof World!=='undefined') World.ICON.tower='樓';
  var FONT='"PingFang HK","PingFang TC","Noto Sans CJK TC","Noto Sans TC","Microsoft JhengHei",sans-serif';
  var cv=_cv, ctx=cv.getContext('2d');
  var DPR=Math.min(2,window.devicePixelRatio||1), VW=390, VH=844, TOP=96, BOT=240;
  var IMG={}, Q=new URLSearchParams(location.search);
  var WW=600, WH=900, BOTX=0;                               // 世界 = 背景圖 (1024x1536 縮放)
  var FL=5;
  var FYS, SX, LX, GLX, PX0, LV, STORY, TRUTH, FLN, LV0;
  // 兩棟樓：路徑對準背景圖每層地板；units = [層,戶,鎮宅,任務,住戶圖,故事序號(-1無),名,門x,房範圍]
  var LEVELS={
    flat:{name:'組屋', bg:'flatbg', FL:5, FYS:[873,711,549,405,261,117], SX:45, LX:555, GLX:555, PX0:105, guard0:'f0_d2',
      fln:['地下','二樓','三樓','四樓','五樓','天台'],
      units:[[0,1,'zha','money','npc_ken',0,'雜貨舖',330,[255,405]],[0,2,'datuk',null,null,-1,'保安亭',470,[405,520]],
        [1,0,null,'food','npc_it',-1,'學生房',226,[78,240]],[1,1,'nuomi','comb','npc_auntie',1,'老夫妻',366,[240,378]],[1,2,null,null,null,-1,'空置單位',496,[378,516]],
        [2,0,null,'food','npc_ken',2,'大家庭',226,[78,240]],[2,1,'nuomi','comb','npc_mis',-1,'家庭理髮',366,[240,378]],[2,2,'zha','money','npc_boss',-1,'麻雀館',496,[378,516]],
        [3,0,'menshen',null,null,-1,'夜班護士',226,[78,240]],[3,1,'zha','money','npc_ken',-1,'囤積屋',366,[240,378]],[3,2,null,'food','npc_mis',3,'卡拉OK',496,[378,516]],
        [4,0,'fu',null,null,-1,'封咗嘅單位',226,[78,240]],[4,1,null,null,'npc_boss',4,'養雀伯伯',366,[240,378]],[4,2,'nuomi','comb','npc_auntie',-1,'新婚夫婦',496,[378,516]]],
      story:['地庫：管理員話，停車場盡頭成日有部單車自己響鈴，佢話係陳伯以前架單車。',
        '地下：管理處話，頂樓嗰個貼滿紅紙嘅單位封咗好多年，但係夜晚成日有收音機聲。',
        '二樓：以前陳伯朝朝喺走廊淋花，見到人就問「食咗飯未呀？」',
        '三樓：有年七月，陳伯敲過我哋門借鹽，我扮唔喺屋企，冇開門……',
        '四樓：之後成座樓都聞到陣怪味，大家都以為係垃圾槽。',
        '五樓：陳伯隻雀仔而家我養住，佢一聽到收音機聲就唱歌，好似等緊有人敲門。',
        '六樓：天台門口有張舊相，係陳伯同成座樓街坊嘅中秋合照，個個都笑到見牙唔見眼。',
        '天台：陳伯以前晚晚上嚟淋花，佢話「花要有人睇住，人都係」。'],
      hint:['地下','二樓','三樓','四樓','五樓'],
      truth:'呢座樓唔係真係鬧鬼——係有個伯伯等咗好耐，想有人記得佢。今晚之後，總算有人知道陳伯嘅名。'},
    shop:{name:'老店屋', bg:'shopbg', FL:4, FYS:[812,585,420,262,74], SX:62, LX:552, GLX:520, PX0:122, guard0:'f0_d1',
      fln:['地下','二樓','三樓','四樓','天台'],
      units:[[0,0,null,'food','npc_ken',0,'茶餐室',232,[100,370]],[0,1,'datuk',null,null,-1,'後廚',430,[380,560]],
        [1,0,'zha','money','npc_boss',-1,'中藥舖',205,[100,310]],[1,1,'nuomi','comb','npc_auntie',1,'老租客房',420,[320,530]],
        [2,0,null,'food','npc_it',2,'工人房',210,[100,320]],[2,1,'zha','money','npc_mis',3,'麻雀房',430,[330,530]],
        [3,0,null,null,'npc_ken',4,'雜物房',232,[100,370]],[3,1,'fu',null,null,-1,'封咗嘅房',445,[380,530]]],
      story:['地庫：貨倉入面有部舊衣車，車針仲插住半件未補好嘅工衣。',
        '地下：茶餐室阿叔話，以前四樓住咗個車衫嘅芳姐，成條街啲工人都搵佢補衫。',
        '二樓：芳姐同我做咗三十年鄰居，佢話呢間屋就係佢一世，點都唔肯搬。',
        '三樓：收樓嗰年芳姐病咗入院，之後佢間房就封咗，門口貼滿紅紙。',
        '三樓：之後打麻雀打到三更，成日聽到樓上有車衣車聲，嗒嗒嗒咁響。',
        '四樓：我執雜物嗰陣搵到佢本記帳簿，最後一頁寫住「仲有十件衫未補完」。',
        '五樓：涼茶舖老闆娘話，芳姐每年冬至都會煲一大煲湯，逐層逐戶咁送。',
        '天台：芳姐以前喺天台曬衫，曬好就摺得四四正正，放喺各家門口。'],
      hint:['地下茶餐室','二樓老租客','三樓工人房','三樓麻雀房','四樓雜物房'],
      truth:'芳姐唔係嚟嚇人——佢只係想做完手上最後嗰幾件衫。今晚之後，會有人幫佢將衫交返俾街坊。'}
  };
  LV0=LEVELS;
  function useLevel(k){ var T=LEVELS[k]; LV=genLevel(k); LV.story=T.story; LV.truth=T.truth; LV.hint=T.story.map(function(_,i){return '第 '+(i+1)+' 段';}); FL=LV.FL; FYS=LV.FYS; SX=LV.SX; LX=LV.LX; GLX=LV.GLX; PX0=LV.PX0; STORY=LV.story; TRUTH=LV.truth; FLN=LV.fln; WW=LV.WW; WH=LV.WH; }
  var NIGHT=+(Q.get('night')||150);                   // 一晚秒數（三個時辰）
  var PH=['子時','丑時','寅時'];
  function fy(f){ return FYS[f]; }

  // ---------- 小工具 ----------
  var seed=1; function rnd(){ seed=(seed*16807)%2147483647; return (seed-1)/2147483646; }
  function pick(a){ return a[Math.floor(rnd()*a.length)]; }
  function shuffle(a){ a=a.slice(); for(var i=a.length-1;i>0;i--){ var j=Math.floor(rnd()*(i+1)); var t=a[i]; a[i]=a[j]; a[j]=t; } return a; }
  function clamp(v,a,b){ return v<a?a:v>b?b:v; }

  // ---------- 文字（港式粵語）----------
  var LINES={
    afraid:['咦？頭先咩聲嚟㗎？','做咩部電視自己閃吓閃吓……','我成身起晒雞皮，真係','係咪隔籬屋喺度敲牆呀？','唔好玩啦，邊個喺度？','點解間屋凍到咁嘅？','我好似見到有嘢郁咗一下','背脊涼颼颼，唔對路','冇嘢嘅冇嘢嘅，自己嚇自己','頭先個影係咪你嚟㗎？'],
    flee:['鬼呀——！走先！','救命呀！屋企有嘢呀！','唔理啦，我落樓先！','開門開門！我要出去！','死啦死啦，真係有鬼！','拖鞋都唔要啦，走呀！','保安！保安！快啲上嚟！','唔好追我呀——！'],
    brave:['嚇邊個呀？我見得多','又係風啫，瞓覺','想嚇我？等下世啦','我後生做過夜更㗎'],
    guard:['巡樓囉，三樓啲燈又壞','呢座樓夜晚真係陰陰哋','巡完呢轉我要飲杯咖啡','又要行樓梯，腳都軟埋'],
    guardHit:['照到喇！邊個喺度？','手電筒照住你！唔好走！','嗰度有嘢！我睇到！'],
    wake:['我開燈先，唔該晒','念番兩句先瞓得著','開晒啲燈佢就唔敢嚟']
  };
  var used={}; function line(k){ var p=LINES[k]; used[k]=used[k]||shuffle(p.map(function(_,i){return i;})); if(!used[k].length) used[k]=shuffle(p.map(function(_,i){return i;})); return p[used[k].pop()]; }

  // ---------- 鬼 ----------
  var GH=[
    {key:'eking', name:'餓鬼', sprite:'eguiking', h:76, sp:104, task:'food', cross:{}, tip:'餓鬼：入屋搵宵夜，站喺金圈讀條。'},
    {key:'toyol', name:'Toyol', sprite:'toyol', h:70, sp:132, task:'money', cross:{zha:1}, tip:'Toyol：細隻，鐵閘罅都鑽得過，專偷銀包。'},
    {key:'tianhua', name:'天花姐', sprite:'tianhua', h:74, sp:114, task:'comb', cross:{nuomi:1}, tip:'天花姐：喺天花爬，地下撒嘅糯米攔佢唔住。'}
  ];
  var WARD={
    fu:{n:'紅紙符', m:'門頂貼住紅紙符，入唔到，繞路啦'},
    menshen:{n:'門神', m:'門神守住度門，我哋唔好亂嚟，繞路'},
    zha:{n:'鐵閘', m:'鐵閘鎖住，得 Toyol 鑽得入'},
    nuomi:{n:'糯米', m:'門口撒咗糯米，得天花姐過得去'},
    datuk:{n:'拿督公神位', m:'門口供住拿督公，要尊重，唔好入'}
  };
  var CARDS=[
    {id:'spd', t:'鬼步加速', d:'全部鬼移動快 20%'},
    {id:'pow', t:'嚇人加倍', d:'嚇人威力 +40%'},
    {id:'inv', t:'隱身延長', d:'隱身時間 +2 秒'},
    {id:'task', t:'手快腳快', d:'讀條快 35%'},
    {id:'arm', t:'陰氣護體', d:'被手電照到損失減半'},
    {id:'fear', t:'怕意加成', d:'嚇走人掉多 30% 怕意'}
  ];

  // ---------- 遊戲狀態 ----------
  var G=null, scene='title', paused=false;
  var PHT=60;                                         // 每個時辰秒數
  var HUM={collector:{n:'收數佬',sp:0,spr:'res_collector',h:76}, guard:{n:'保安',sp:43,spr:'res_guard',h:78}, compass:{n:'羅盤保安',sp:45,spr:'npc_guard',h:78}, mirror:{n:'鏡子道士',sp:38,spr:'npc_boss',h:76}, decoy:{n:'道士',sp:37,spr:'npc_boss',h:76},   /* PEOPLE HOOK：舊 74/78/66/64 ×0.58 */ dog:{n:'看門狗',sp:230,spr:null,h:38}};
  var ITEM={food:{n:'宵夜',t:0.8,who:'eking'}, money:{n:'銀包',t:1.3,who:'toyol'}, comb:{n:'木梳',t:1.6,who:'tianhua'}, doll:{n:'替身紙人',t:2.0}, key:{n:'紅鎖匙',t:2.6}, key2:{n:'黃鎖匙',t:2.6}, lost:{n:'失物',t:1.5}};
  var BAGMAX=10;
  function newGame(s,lv){
    if (lv) curLv=lv; seed=s||((Date.now()%100000)+7); used={}; useLevel(curLv);
    G={t:0, phase:0, nodes:{}, edges:[], units:[], res:[], guards:[], floats:[], fear:0, fearNext:30, fearTotal:0,
       mods:{spd:1,pow:1,inv:3,task:1,arm:1,fear:1}, story:[], active:0, over:null, choice:null, toast:null, toastT:0, alarm:[],
       alert:0, alertLv:0, bag:[], dolls:0, keys:{}, wave:0, waveT:20, gate:null, gateCharge:0, captured:0};
    buildMap2(); placeUnits2();
    G.gh=GH.map(function(d,i){ return {d:d, i:i, node:'f0_e', to:null, p:0, x:0, y:0, dir:1, loot:0, taskP:0, inv:0, invCd:0, stun:0, scareCd:0, home:false, energy:0, actT:0, hitT:0, bounceT:0, mv:0, ph:Math.random()*6, still:1, caught:0, out:false, mirrored:0}; });
    G.gh.forEach(function(g){ var n=G.nodes[g.node]; g.x=n.x; g.y=n.y; });
    cam.z=1; cam.free=null; cam.s=VW/((LV&&LV.camW)||600);
    G.parts=[]; G.ult=null; G.wardFx=[]; G.dark={};
    spawnZoneGuards(); initSafe(); G.pdrops=[];   // PEOPLE HOOK
    scene='play'; paused=false;
    toast(LV.name+'（'+(FL-1)+' 層＋地庫＋天台）：鬆手企定先嚇得人、搜得嘢。保安唔係捉鬼師傅——附身電器、敲水管、叫𨋢可以引開佢哋。左上細地圖撳一下睇全棟。');
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
      else if (w==='zha'){ un.open=false; un.ot=2; un.cost=f<=1?8:12; }
      else if (w==='nuomi'){ un.open=false; un.ot=2; un.cost=f<=1?6:9; }
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
    var dc=G.units.filter(function(u){return u.res&&u.ot===0&&u.f>0;}); if (dc.length>=2) dc[dc.length-1].door=true;
    // 黑屋伏擊：一戶冇人嘅屋有隻醒住嘅看門狗
    var amb=G.units.filter(function(u){return !u.res&&u.ot!=='deity';})[0]||G.units.filter(function(u){return u.ot===2;})[0];
    if (amb) amb.ambush='dog';
    G.units.forEach(function(u){ u.seen=(u.ot===0||u.ot==='deity')&&!u.ambush; });
  }
  function unitByDoor(did){ for (var i=0;i<G.units.length;i++) if (G.units[i].did===did) return G.units[i]; return null; }
  function unitOf(id){ for (var i=0;i<G.units.length;i++) if (G.units[i].id===id) return G.units[i]; return null; }
  function mkHuman(kind,nodeId,extra){ var n=G.nodes[nodeId]; var h={kind:kind,node:nodeId,to:null,p:0,x:n.x,y:n.y,dir:1,wait:1,talkT:3+rnd()*5,courage:kind==='compass'?5:kind==='decoy'?2:1,path:null,repath:0,chase:null,alertT:0,state:'patrol'}; for (var k in extra||{}) h[k]=extra[k]; return h; }
  function spawnZoneGuards(){ var nz=Math.max(2,Math.round((FL-1)/3)), span=(FL-1)/nz; for (var i=0;i<nz;i++){ var a=1+Math.round(i*span), b=Math.min(FL-1,Math.round((i+1)*span)); var h=mkHuman('guard','f'+a+'_'+(i%2?'b':'s')); h.zone=[a,b]; G.guards.push(h); } }
  function inZone(h,f,pad){ return !h.zone||(f>=h.zone[0]-(pad||0)&&f<=h.zone[1]+(pad||0)); }
  function toast(m){ G.toast=m; G.toastT=5.5; }
  function float(x,y,t,c){ if (!G) return; var now=performance.now(), fc=G.fcd||(G.fcd={}), L0=fc[t];
    // 同一句：1.5 秒內喺附近唔再出；仲喺畫面上就唔再疊
    if (L0 && now-L0.t<1500 && Math.abs(L0.x-x)<260 && Math.abs(L0.y-y)<200) return;
    if (G.floats.some(function(f){ return f.t===t && Math.abs(f.x-x)<260 && Math.abs(f.y0-y)<200; })) return;
    fc[t]={t:now,x:x,y:y};
    // 唔同句喺同一位：自動向上錯開，唔會疊埋一舊
    var yy=y, k=0; while (k<4 && G.floats.some(function(f){ return Math.abs(f.x-x)<120 && Math.abs(f.y-yy)<17; })){ yy-=18; k++; }
    G.floats.push({x:x,y:yy,y0:y,t:t,c:c||'#fff',life:1.6}); if (G.floats.length>10) G.floats.shift(); }

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
  function humanPass(h,e){ if (e.pipe) return false; if (e.fire && e.fire.shut>0) return false; if (h.kind==='dog' && e.door && e.unit.door && e.unit.doorOpen<=0) return false; if (e.door && e.unit.ot==='deity') return false; return true; }

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
    if (UNIT&&n.kind==='in') UNIT.arrive(g,n);   // UNIT HOOK 3：入住戶 → 室內介面
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
      G.nodes[u].links.forEach(function(l){ if (!humanPass(h,l.e)) return; if (safeNode(l.to)&&!safeNode(src)) return; var a=G.nodes[u], b=G.nodes[l.to], w=Math.hypot(a.x-b.x,a.y-b.y); if (dist[u]+w<dist[l.to]){ dist[l.to]=dist[u]+w; prev[l.to]=u; } }); }
    if (dist[dst]>=1e9) return null; var p=[dst]; while(p[0]!==src) p.unshift(prev[p[0]]); return p.slice(1);
  }
  function humanPassTo(h,a,b){ var l=a.links.find(function(l){return l.to===b.id;}); return !l||humanPass(h,l.e); }
  function nearNode(o){ var best=null,bd=1e9; for (var k in G.nodes){ var n=G.nodes[k]; if (n.kind==='in') continue; var d=Math.abs(n.x-o.x)+Math.abs(n.y-o.y)*3; if (d<bd){bd=d;best=k;} } return best; }
  function mirrorOn(g){ if (inSafe(g)) return null; var m=null; G.guards.forEach(function(h){ if (h.kind!=='mirror'||h.state==='gone') return; if (Math.abs(h.y-g.y)>40) return; var dx=g.x-h.x; if (Math.abs(dx)>220) return; if (Math.sign(dx)===h.dir && g.dir===-h.dir) m=h; }); return m; }

  // ---------- 主更新 ----------
  function update(dt){
    if (G.over||G.choice||paused) return;
    if (G.ult){ G.ult.t+=dt; if (G.ult.t<1.3){ stepFx(dt); return; } if (!G.ult.done){ G.ult.done=true; applyUlt(G.ult); } if (G.ult.t>4){ G.ult=null; G.ultCool=1.5; } }
    G.t+=dt; var np=Math.min(3,Math.floor(G.t/PHT));
    if (np!==G.phase){ G.phase=np; toast(np<3?PH[np]+'到喇——巡邏加派，越近天光人越精。':'天光喇！樓下開始有人起身，追兵越嚟越快，快啲走！'); }
    G.toastT-=dt; if (!G.traces) G.traces=[]; setupBeans();
    // 波次：每個時辰入面定時加派巡邏，天光後指數加強
    G.waveT-=dt; if (G.waveT<=0 && !G.gate){ G.wave++; G.waveT=G.phase>=3?18:30; var f=1+Math.floor(rnd()*(FL-1)); var h=mkHuman('guard','f'+f+'_'+(rnd()<0.5?'s':'l')); h.zone=[Math.max(1,f-1),Math.min(FL-1,f+1)]; h.boost=G.phase>=3?Math.pow(1.15,G.wave):1; G.guards.push(h); float(h.x,h.y-80,'加派保安','#ffb0b0'); }
    G.gh.forEach(function(g){ if (g.home||g.out) return;
      g.blockT=(g.blockT||0)-dt; g.inv=Math.max(0,g.inv-dt); g.invCd=Math.max(0,g.invCd-dt); g.stun=Math.max(0,g.stun-dt); g.scareCd=Math.max(0,g.scareCd-dt);
      g.actT=Math.max(0,g.actT-dt); g.hitT=Math.max(0,g.hitT-dt); g.bounceT=Math.max(0,g.bounceT-dt); g.sealT=Math.max(0,(g.sealT||0)-dt); g.dropT=Math.max(0,(g.dropT||0)-dt);
      if (g.inUnit) return;   // UNIT HOOK 2：鬼喺屋入面，由 unit.js 推進
      moveUpdate(g,dt); beansCheck(g,dt);
      if (g.d.key==='toyol'){ g.flipT=Math.max(0,(g.flipT||0)-dt); if (g.mv>0){ g.flipCd=(g.flipCd==null?1.2:g.flipCd)-dt; if (g.flipCd<=0){ g.flipT=0.55; g.flipCd=2.2+rnd()*1.5; } } }
      if (g.auto&&g.auto.length){ var nx=g.auto[0];
        if (!g.to){ if (g.node===nx) g.auto.shift(); else { var ln=G.nodes[g.node].links.find(function(l){return l.to===nx;}); if (ln&&canPass(g,ln.e)===true){ g.to=nx; g.p=0; } else g.auto=null; } }
        if (g.to){ var a=G.nodes[g.node], b=G.nodes[g.to], D=Math.hypot(b.x-a.x,b.y-a.y); g.p+=g.d.sp*G.mods.spd*dt/D; g.still=0; g.taskP=0; if (b.x!==a.x) g.dir=b.x>a.x?1:-1; if (g.p>=1){ g.node=g.to; g.to=null; g.p=0; if (g.auto&&g.auto[0]===g.node) g.auto.shift(); onArrive(g); } } }
      var p=posOf(g); g.mv=Math.max(0,g.mv-dt); if (Math.abs(p.x-g.x)+Math.abs(p.y-g.y)>0.2){ g.mv=0.18; g.still=0; } else g.still+=dt; g.x=p.x; g.y=p.y;
      if (g.autoS && !g.to && !(g.auto&&g.auto.length) && g.still>=0.12 && g.stun<=0 && g.scareCd<=0){ g.autoS=null; if (G.active===g.i && g.scareCd<=0) scarePress(); }
      var n=G.nodes[g.node], st=!g.to&&g.still>=0.1&&g.stun<=0&&!mirrorOn(g);
      // 搜刮讀條：逐件、越值錢越耐、收穫有格數上限
      if (st && n.kind==='in'){ var un=unitOf(n.id);
        if (un.lit){ float(g.x,g.y-70,'開咗燈！被逼返出去','#ffb0b0'); g.node=un.did; g.stun=0.6; loseLoot(g,0.3); }
        else { var it=un.items.find(function(k){ var I=ITEM[k]; return !I.who||I.who===g.d.key; });
          if (it){ if (it!=='doll'&&it!=='key'&&it!=='key2'&&it!=='lost'&&G.bag.length>=BAGMAX){ if (!g.fullT||g.fullT<=0){ float(g.x,g.y-80,'收穫格滿咗！','#ffb0b0'); g.fullT=2; } g.fullT-=dt; }
            else { g.taskP+=dt*G.mods.task/ITEM[it].t; if (rnd()<dt*14){ if (g.d.key==='toyol'){ var pn={x:g.x+g.dir*30,y:g.y-36,vx:rnd(),vy:0,life:0.7,max:0.7,type:'note'}; pn.tx=g.x; pn.ty=g.y-g.d.h*0.45; G.parts.push(pn); } else if (g.d.key==='tianhua') part(g.x+(rnd()-0.5)*20,g.y-g.d.h*0.5,(rnd()-0.5)*60,-40-rnd()*40,0.7,'hair'); }
              if (g.taskP>=1){ g.taskP=0; un.items.splice(un.items.indexOf(it),1); takeItem(g,it,un); } } }
          if (un.res && un.res.state==='home'){ un.res.fear+=dt*3*G.mods.pow; if (un.res.fear>=100) flee(un.res,g); } } }
      else if (!st) g.taskP=0;
      // 破鎮宅：企喺門口 0.5 秒後每 0.1 秒注入 1 點怕意，離開保留進度
      if (!g.to && n.kind==='door'){ var du=unitByDoor(n.id); g.injT=st?(g.injT||0)+dt:0; if (du && !du.open && du.ot===2 && g.injT>=0.5){ g.injAcc=(g.injAcc||0)+dt; while (g.injAcc>=0.1 && G.fear>0 && du.paid<du.cost){ g.injAcc-=0.1; G.fear--; du.paid++; if (rnd()<0.6) part(g.x,g.y-40,(du.x-g.x)*2,-20,0.5,'suck'); }
          if (du.paid>=du.cost){ unlockUnit(du,'鎮宅破咗！'); } else if (G.fear<=0 && (!g.blockT||g.blockT<=0)){ float(g.x,g.y-80,'怕意唔夠，去嚇多啲人','#ffd54a'); g.blockT=6; } }
        if (du && !du.open && du.ot===11 && st && G.keys[du.keyNeed]){ G.keys[du.keyNeed]--; unlockUnit(du,'用'+ITEM[du.keyNeed].n+'開咗門'); } }
      else g.injT=0;
    });
    // 住客：夜晚行出門口（開門窗口）、逃走
    G.res.forEach(function(r){
      pplResTick(r,dt); r.jumpT=Math.max(0,(r.jumpT||0)-dt); r._pj=r.jumpT; r.tangle=Math.max(0,(r.tangle||0)-dt);
      if (r.state==='flee'){ if (r.tripT>0){ r.tripT-=dt; r.x+=r.vx*0.18*dt; } else r.x+=r.vx*dt; if (r.x<SX||r.x>LX) r.state='gone'; if (rnd()<dt*8) part(r.x-Math.sign(r.vx)*10,r.y-4,-r.vx*0.1,-10,0.5,'dust'); }
      if (r.state==='home' && r.unit.door){ r.doorT-=dt; if (r.doorT<=0){ r.unit.doorOpen=2.6; r.doorT=12+rnd()*8; say(r,pick(['出去倒杯水先','邊個喺門口？','開門透下氣'])); } }
      if (r.unit.doorOpen>0) r.unit.doorOpen-=dt;
    });
    if (G.phase>=2) G.units.forEach(function(un){ un.litT-=dt; if (un.res&&un.res.state==='home'&&!un.lit&&rnd()<dt*0.04){ un.lit=true; un.litT=7; say(un.res,line('wake')); } if (un.lit&&un.litT<=0) un.lit=false; });
    traceUpdate(dt); G.phoneCd=Math.max(0,(G.phoneCd||0)-dt);
    resUpdate2(dt); pplTick(dt);   // PEOPLE HOOK
    G.guards.forEach(function(h){ humanUpdate(h,dt); }); G.guards=G.guards.filter(function(h){return h.state!=='gone';});
    G.ultCool=Math.max(0,(G.ultCool||0)-dt);
    if (G.choiceQ>0 && !G.ult && G.ultCool<=0){ G.choiceQ--; G.choice=shuffle(CARDS).slice(0,3); }
    checkAlert(); taoUpdate(dt); gateUpdate(dt);
    stepFx(dt);
    G.floats.forEach(function(f){ f.life-=dt; f.y-=dt*22; }); G.floats=G.floats.filter(function(f){return f.life>0;});
    G.res.forEach(function(r){ if (r.say){ r.sayT-=dt; if (r.sayT<=0) r.say=null; } });
    if (G.gh.every(function(g){return g.out;})) endNight('fail');
  }
  function takeItem(g,it,un){
    if (it==='doll'){ G.dolls++; float(g.x,g.y-90,'替身紙人 '+G.dolls+'/6','#e8d8b0'); if (G.dolls===6) toast('替身紙人夠 6 個！隨時可以按「替身遁走」，但係故事碎片同部分收穫會留低。'); return; }
    if (it==='key'||it==='key2'){ G.keys[it]=(G.keys[it]||0)+1; float(g.x,g.y-90,'偷到'+ITEM[it].n+'！','#ffd54a'); return; }
    if (it==='lost'){ G.carry='lost'; var q=(G.quests||[]).find(function(q){return q.id==='lost';}); float(g.x,g.y-90,'搵到'+(q?q.thing:'失物')+'！帶返去俾'+(q?FLN[q.owner.f]:'')+'嘅主人','#8affc8'); return; }
    if (it==='food'&&g.d.key==='eking'){ g.fat=Math.min(0.3,(g.fat||0)+0.06); float(g.x,g.y-g.d.h-30,'越食越餓……','#ffb7a0'); } G.bag.push({t:it,o:g.i}); g.loot++; g.energy=Math.min(100,g.energy+12); float(g.x,g.y-90,'收到'+ITEM[it].n+'（'+G.bag.length+'/'+BAGMAX+'）','#ffd54a');
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

  // ===== PEOPLE HOOK（tools/patch_v10_people.py）：鬼初始點安全區、人物統一畫法、嚇親反應 =====
  var PPL_META={"res_gamer": {"n": {"foot": 0.0}, "s": {"k": 1.031, "foot": 0.0}}, "res_uncle": {"n": {"foot": 0.0}, "s": {"k": 1.0167, "foot": 0.0}}, "res_granny": {"n": {"foot": 0.0}, "s": {"k": 1.0071, "foot": 0.0}}, "res_helper": {"n": {"foot": 0.0}, "s": {"k": 1.0238, "foot": 0.0}}, "res_mjaunty": {"n": {"foot": 0.0}, "s": {"k": 0.9929, "foot": 0.0}}, "res_shopper": {"n": {"foot": 0.0}, "s": {"k": 0.9548, "foot": 0.0}}, "res_collector": {"n": {"foot": 0.0}, "s": {"k": 0.9167, "foot": 0.0}}, "res_guard": {"n": {"foot": 0.0}, "s": {"k": 0.9429, "foot": 0.0}}, "res_ot": {"n": {"foot": 0.0}, "s": {"k": 0.9262, "foot": 0.0}}, "res_gym": {"n": {"foot": 0.0}, "s": {"k": 0.9429, "foot": 0.0}}};
  var SAFE=null, SAFE_R=150;
  function initSafe(){ var n=G.nodes['f0_e']; SAFE=null; if (!n) return; SAFE={node:'f0_e',x:n.x,y:n.y,f:n.f,r:SAFE_R,nodes:{},a:1,was:true}; for (var k in G.nodes){ var m=G.nodes[k]; if (m.f===n.f&&Math.abs(m.x-n.x)<=SAFE_R) SAFE.nodes[k]=1; } }
  function safeOn(){ return !!(G&&SAFE&&!(G.gate&&G.gate.node===SAFE.node)); }
  function inSafeXY(x,y){ return safeOn()&&Math.abs(y-SAFE.y)<30&&Math.abs(x-SAFE.x)<=SAFE.r; }
  function inSafe(g){ if (!g||g.home||g.out) return false; if (inSafeXY(g.x,g.y)){ g._sgT=G.t; return true; } return safeOn()&&g._sgT!=null&&(G.t-g._sgT)<2&&Math.abs(g.y-SAFE.y)<30&&Math.abs(g.x-SAFE.x)<=SAFE.r+110; }   // 出咗陰氣地仲有 2 秒餘蔭，保安守唔死出口
  function safeNode(id){ return safeOn()&&!!SAFE.nodes[id]; }
  function nearSafe(h){ return !!SAFE&&Math.abs(h.y-SAFE.y)<200&&Math.abs(h.x-SAFE.x)<SAFE.r+340; }
  function nearestAny(h){ var best=null, bd=1e9; G.gh.forEach(function(g){ if (g.home||g.out||g.inv>0) return; var d=Math.abs(g.x-h.x)+Math.abs(g.y-h.y)*1.5; if (d<bd){ bd=d; best=g; } }); return best; }
  function nearNodeH(h){ var best=null,bd=1e9; for (var k in G.nodes){ var n=G.nodes[k]; if (n.kind==='in'||safeNode(k)) continue; var d=Math.abs(n.x-h.x)+Math.abs(n.y-h.y)*3; if (d<bd){bd=d;best=k;} } return best; }
  // 同一晚唔會兩個人講同一句（慘叫、保安嚇親、安全區放棄）
  function uniq(pool){ var U=G._uq||(G._uq={}); var free=pool.filter(function(t){ return t&&!U[t]; }); if (!free.length) return null; var t=free[Math.floor(Math.random()*free.length)]; U[t]=1; return t; }
  var SCREAM=['鬼呀——！走先！','救命呀！屋企有嘢呀！','唔理啦，我落樓先！','開門開門！我要出去！','死啦死啦，真係有鬼！','拖鞋都唔要啦，走呀！','保安！保安！快啲上嚟！','唔好追我呀——！',
    '媽呀——！','嘩——！唔關我事㗎！','我唔住喇！聽日搬！','走呀走呀！咪理銀包喇！','有鬼呀！真係有鬼呀！','我仲未想死呀——！','乜嘢嚟㗎嗰樣嘢？！走！','唔好搵我呀，我好人嚟㗎！',
    '頂唔順喇，走為上着！','喂！等埋我呀——！','我以後唔夜瞓喇！','唔好過嚟呀——！','救命呀！有冇人呀？！','我對腳軟晒……走呀！','今晚去酒店瞓好過！','係咪我眼花……唔理喇走！',
    '嗚哇——！嚇死人咩！','我發誓以後唔講粗口！','快啲快啲，落樓梯！','唔好捉我呀——！','咩鬼嘢呀！走呀！','喊都喊唔出呀！','我要返鄉下！','頭先嗰個……唔係人嚟！',
    '電話呢？算啦，走先！','我心口好翳……走呀！','冇眼睇喇，閃！','條頸凍晒，走呀！','唔玩喇唔玩喇！','鬼打牆呀——！','我以後晚晚開晒燈！','快啲開門呀——！',
    '嘩呀——！頂唔順！','救命呀——！鬼呀！','我唔要命呀……唔係，我要命呀！','走啦走啦，唔好望！','阿媽救我呀——！','嗰度有對眼呀——！','我條腳唔聽話呀！','落樓！落樓！快啲！','冇得傾，我走先！','唔好掂我呀——！','咩呀咩呀咩呀——！','我好驚呀——！','點解會咁㗎——！','我錯喇我錯喇！','唔好嚇我呀大佬！','走得快好世界！','我出去搵人幫手先！','救我呀，邊個都好！','嘩，佢望住我呀！','我今晚唔返嚟瞓喇！','頭皮發晒麻呀！','我要報警呀——！','佢喺我後面呀——！','唔好再跟住我呀！','我以後唔睇鬼片喇！','嚇到魂都冇埋！','係真㗎！係真㗎！','我唔信邪……但我信喇！','快走，唔好回頭！','我把聲都震晒呀！','佢冇腳㗎——！','好凍呀！好凍呀！','開燈呀！開晒啲燈呀！','唔好笑呀——！','我唔識你呀——！','冇得頂！','我寧願返工都唔留喺度！','呢間屋有嘢㗎！','我仲有供樓未還㗎！','我唔玩捉迷藏呀！','我隻手凍到冇知覺！','跑呀，唔好企喺度！','我眼花，一定係眼花……走！','邊個喺度笑呀——！','我隻拖鞋呢？唔要喇！','我發夢……一定係發夢！','我收工喇！收工喇！','鬼呀鬼呀鬼呀——！','唔好拉我呀——！','我未食飯㗎，唔好食我！','嗰把聲喺耳邊呀——！','啲燈熄晒喇，走呀！','我唔夠膽再望多一眼！','我腳都軟埋——走！','唔關事，真係唔關事！','我出去瞓街好過！','隻手！有隻手呀——！','我啲寒毛企晒起身！','我同你冇仇㗎——！','嗚嗚嗚，我要返屋企……','我錯晒，我以後早啲瞓！','快啲搵人嚟呀——！','我把心跳到出嚟！','嗰陣味好臭呀，走！','個天花板有嘢呀——！','我唔做呢份工喇！','邊度走得最快呀？！','我出去等天光！','佢叫咗我個名呀——！','唔好企喺門口呀，走！'];
  var SPOOKL=['嘩！！','乜……乜嘢嚟㗎？！','我唔做喇……','嘩！有嘢喺我後面！','咩、咩聲呀？！','手電筒點解閃㗎？！','冇嘢嘅冇嘢嘅……','頭先係咪有嘢掂我？','我……我去飲杯水先','邊個喺度？！出嚟！',
    '唔好玩嘢呀！','份人工唔包驚㗎！','對講機！對講機呢？！','我對腳震緊……','係風……一定係風……','老細冇講過有呢樣嘢㗎！','佢、佢郁咗！','我要加人工先得！','嚇到我心都離一離','背脊涼晒……'];
  var BALKL=['頂……嗰邊陰陰森森，唔過去喇','嗰度凍到入骨，我唔行埋去','老細話過嗰邊夜晚唔好去……','算數，嗰度我唔跟喇','嗰邊陰風陣陣……返轉頭先','唔通真係有嘢？我返轉頭好過','嗰度啲燈成日閃，唔去喇','我條命緊要過份工','嗰邊冇人去㗎，我都唔去','唔該，嗰度我真係唔敢入'];
  function pplScream(o){ var t=uniq(SCREAM); o.scream=t?{t:t,T:1.9}:null; if (t) { o.say=null; o.sayT=0; } }
  function balk(h,talk){ h.state='balk'; h.balkT=2.6; h.balkTurn=0; h.path=null; h.lostT=0; h.alertT=0; h.dir=SAFE&&SAFE.x>h.x?1:-1; if (talk){ var t=uniq(BALKL); if (t){ h.say=t; h.sayT=2.6; } } }
  // 跌嘢（冇驚嚇圖嘅角色先用；Q 版驚嚇圖本身已經畫咗飛出去嘅物件）
  var DROPK={couple:'cup',mahjong:'tile',taxi:'cup',cook:'bowl',insomnia:'cup',nurse:'cup',debt:'cup',gamer:'pad',granny:'fan',elder:'cup',helper:'cup',shopper:'box',ot:'cup',gym:'cup'};
  function startShock(r,amp){ r.shockT=0.9; r.shockA=amp; r.shockN=(r.shockN||0)+1; var H=(r.h||66)*1.12;
    for (var k=0;k<(amp>=1?5:3);k++) part(r.x+(Math.random()-0.5)*24,r.y-H*0.82,(Math.random()-0.5)*150,-90-Math.random()*70,0.75,k%2?'tear':'sweat');
    if (amp>=1&&!r.dropped&&r.state==='home'&&!PPLFX.hasScared(r.sprite)&&DROPK[r.hh]){ r.dropped=1; (G.pdrops||(G.pdrops=[])).push({k:DROPK[r.hh],x:r.x+(r.vx<0?-10:10),y:r.y-H*0.5,fy:r.y,vx:(Math.random()<0.5?-1:1)*(40+Math.random()*50),vy:-140,rot:0,vr:(Math.random()-0.5)*14,life:3.2}); } }
  function pplResTick(r,dt){ if ((r.jumpT||0)>(r._pj||0)+0.001) startShock(r,r.jumpT>=0.5?1:0.65);
    r.shockT=Math.max(0,(r.shockT||0)-dt); if (r.scream){ r.scream.T-=dt; if (r.scream.T<=0) r.scream=null; }
    if (r.state==='home'&&r.awake&&(r.fear||0)>=55&&Math.random()<dt*1.1) part(r.x+(Math.random()<0.5?-12:12),r.y-(r.h||66)*0.95,(Math.random()-0.5)*30,-20,0.6,'sweat'); }
  function pplTick(dt){ (G.pdrops||[]).forEach(function(d){ d.life-=dt; d.vy+=520*dt; d.x+=d.vx*dt; d.y+=d.vy*dt; d.rot+=d.vr*dt; if (d.y>=d.fy-3){ d.y=d.fy-3; d.vy=-Math.abs(d.vy)*0.28; d.vx*=0.55; d.vr*=0.4; if (Math.abs(d.vy)<20) d.vy=0; } }); if (G.pdrops) G.pdrops=G.pdrops.filter(function(d){return d.life>0;});
    if (SAFE){ var on=safeOn(); if (SAFE.was&&!on) float(SAFE.x,SAFE.y-110,'陰門一開，陰氣散晒——保安殺到！','#d8b8ff'); SAFE.was=on; } }
  function drawDrops(){ (G.pdrops||[]).forEach(function(d){ ctx.save(); ctx.globalAlpha=Math.min(1,d.life/0.6); ctx.translate(d.x,d.y); ctx.rotate(d.rot); ctx.lineWidth=1.5; ctx.strokeStyle='#1a1418';
      if (d.k==='cup'){ ctx.fillStyle='#e8e2d4'; ctx.fillRect(-4,-5,8,9); ctx.strokeRect(-4,-5,8,9); ctx.beginPath(); ctx.arc(5,-1,3,-1.4,1.4); ctx.stroke(); }
      else if (d.k==='tile'){ ctx.fillStyle='#f2efe2'; ctx.fillRect(-4,-6,8,11); ctx.strokeRect(-4,-6,8,11); ctx.fillStyle='#3a8a5a'; ctx.fillRect(-2,-3,4,4); }
      else if (d.k==='bowl'){ ctx.fillStyle='#f0e8d8'; ctx.beginPath(); ctx.arc(0,-2,6,0,Math.PI); ctx.closePath(); ctx.fill(); ctx.stroke(); }
      else if (d.k==='pad'){ ctx.fillStyle='#2a2a34'; ctx.fillRect(-7,-3,14,7); ctx.strokeRect(-7,-3,14,7); }
      else if (d.k==='fan'){ ctx.fillStyle='#d8c08a'; ctx.beginPath(); ctx.moveTo(0,4); ctx.arc(0,4,10,-2.6,-0.5); ctx.closePath(); ctx.fill(); ctx.stroke(); }
      else { ctx.fillStyle='#c89a5a'; ctx.fillRect(-6,-5,12,10); ctx.strokeRect(-6,-5,12,10); }
      ctx.restore(); }); }
  // 鬼初始點安全區：地上淡紫陰氣
  function drawSafe(){ if (!SAFE) return; var on=safeOn(); SAFE.a+=((on?1:0)-SAFE.a)*0.06; var A0=SAFE.a; if (A0<0.02) return; var x=SAFE.x, y=SAFE.y, R=SAFE.r;
    ctx.save(); var gr=ctx.createRadialGradient(x,y-6,6,x,y-6,R); gr.addColorStop(0,'rgba(150,95,205,'+(0.24*A0)+')'); gr.addColorStop(0.65,'rgba(125,75,185,'+(0.11*A0)+')'); gr.addColorStop(1,'rgba(110,60,170,0)'); ctx.fillStyle=gr; ctx.beginPath(); ctx.ellipse(x,y-5,R,20,0,0,7); ctx.fill();
    for (var k=0;k<7;k++){ var u=((G.t*8+k*13)%46)/46, px=x+Math.sin(G.t*0.45+k*2.1)*R*0.78, py=y-8-u*46; ctx.fillStyle='rgba(190,150,235,'+((1-u)*0.15*A0)+')'; ctx.beginPath(); ctx.ellipse(px,py,18+(k%3)*7,4.5,0,0,7); ctx.fill(); }
    ctx.strokeStyle='rgba(195,160,240,'+(0.2*A0)+')'; ctx.setLineDash([5,7]); ctx.lineWidth=1.5; ctx.beginPath(); ctx.ellipse(x,y-5,R,13,0,0.08,Math.PI-0.08); ctx.stroke(); ctx.setLineDash([]);
    ctx.globalAlpha=0.5*A0; ctx.font='bold 10px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#120c16'; ctx.strokeText('陰氣地・保安止步',x,y+14); ctx.fillStyle='#d6c0f2'; ctx.fillText('陰氣地・保安止步',x,y+14); ctx.restore(); }
  // 人物共用畫法（大樓、入屋、電梯共用）：Q 版高度、驚嚇圖、臉青白、跳起、!!、舉手、浮字慘叫
  var PPLFX=window.PPLFX=(function(){ var CHIBI_K=1.12, TC={};
    function im(k){ var i=k&&IMG[k]; return i&&i.width?i:null; }
    function hasScared(k){ return !!k&&k.indexOf('res_')===0&&!!im(k+'_scared'); }
    function key(k,scared){ return scared&&hasScared(k)?k+'_scared':k; }
    function chibi(k){ var i=im(k); return !!i&&i.width/i.height>=0.42; }
    function hgt(base,k2,h){ var m=PPL_META[base]; return h*(chibi(base)?CHIBI_K:1)*(k2!==base&&m&&m.s?m.s.k:1); }
    function foot(base,k2){ var m=PPL_META[base]; if (!m) return 0; return k2!==base?(m.s&&m.s.foot||0):(m.n&&m.n.foot||0); }
    function tintCv(k){ var i=im(k); if (!i) return null; var c=TC[k]; if (c&&c._src===i) return c; c=document.createElement('canvas'); var s=Math.min(1,220/i.height); c.width=Math.max(1,Math.round(i.width*s)); c.height=Math.max(1,Math.round(i.height*s)); var x=c.getContext('2d'); x.drawImage(i,0,0,c.width,c.height); x.globalCompositeOperation='source-atop'; x.fillStyle='rgb(178,222,236)'; x.fillRect(0,0,c.width,c.height); c._src=i; TC[k]=c; return c; }
    function blit(c2,i,x,y,h,o){ var w=h*i.width/i.height; c2.save(); c2.globalAlpha=(o.alpha==null?1:o.alpha); c2.translate(x,y); if (o.rot) c2.rotate(o.rot); c2.scale((o.flip?-1:1)*(o.sx||1),o.sy||1); c2.drawImage(i,-w/2,-h,w,h); c2.restore(); }
    // k2＝已揀好嘅圖、h＝已計好嘅顯示高度；腳底以下有飛出物件時按 meta 下移
    function draw(c2,base,k2,x,y,h,o){ o=o||{}; var i=im(k2); if (!i) return; var fy0=y+foot(base,k2)*h; blit(c2,i,x,fy0,h,o);
      if (o.tint>0.02){ var t=tintCv(k2); if (t){ var sb=c2.shadowBlur; c2.shadowBlur=0; blit(c2,t,x,fy0,h,{flip:o.flip,rot:o.rot,sx:o.sx,sy:o.sy,alpha:(o.alpha==null?1:o.alpha)*Math.min(0.4,o.tint*0.45)}); c2.shadowBlur=sb; } } }
    // 嚇中瞬間：先縮（squash）→ 彈起拉長（stretch）→ 落地震；回傳比例（jy／sh 係身高嘅分率）
    function shock(t,amp){ var q=1-t/0.9, a=amp||1, o={sx:1,sy:1,jy:0,sh:0,tint:0.95*(1-q*0.55)};
      if (q<0.12){ var c=q/0.12; o.sy=1-0.22*c*a; o.sx=1+0.16*c*a; }
      else if (q<0.5){ var c2=(q-0.12)/0.38; o.jy=-Math.sin(c2*Math.PI)*0.3*a; o.sy=1+(0.17*(1-c2))*a; o.sx=1-(0.11*(1-c2))*a; }
      else { var c3=(q-0.5)/0.5; o.sy=1-0.07*Math.sin(c3*Math.PI)*(1-c3)*a; o.sx=1+0.05*Math.sin(c3*Math.PI)*(1-c3)*a; o.sh=Math.sin(performance.now()/1000*62)*0.032*(1-c3); }
      return o; }
    // 驚值高未走：發抖、四圍望、縮起
    function tremble(r,t){ var ph=Math.floor((t+((r.x||0)%5))*1.15); return {sh:Math.sin(t*47+(r.x||0))*0.018, sy:0.93, flip:ph%3===2?null:ph%3===1, tint:0.16}; }
    function bang(c2,x,y,q,s){ s=s||1; var pop=1+0.7*Math.max(0,1-q/0.16), al=q>0.8?Math.max(0,(1-q)/0.2):1; c2.save(); c2.globalAlpha=al; c2.translate(x,y); c2.rotate(-0.12); c2.scale(pop*s,pop*s); c2.font='900 22px '+FONT; c2.textAlign='center'; c2.lineJoin='round'; c2.lineWidth=5; c2.strokeStyle='#160c10'; c2.strokeText('!!',0,0); c2.fillStyle='#ffe25a'; c2.fillText('!!',0,0);
      c2.strokeStyle='#ffe25a'; c2.lineWidth=2; for (var i=0;i<3;i++){ var an=-2.5+i*0.5; c2.beginPath(); c2.moveTo(Math.cos(an)*15-2,Math.sin(an)*15-8); c2.lineTo(Math.cos(an)*22-2,Math.sin(an)*22-8); c2.stroke(); var an2=-0.65-i*0.5; c2.beginPath(); c2.moveTo(Math.cos(an2)*15+2,Math.sin(an2)*15-8); c2.lineTo(Math.cos(an2)*22+2,Math.sin(an2)*22-8); c2.stroke(); } c2.restore(); }
    // 狂奔雙手舉高（畫喺身後，得手掌露出頭頂兩邊）：只用喺冇驚嚇圖嘅角色（老闆原創 npc_* 唔改佢張臉）
    function arms(c2,x,y,h,dir,t){ var sh=y-h*0.5; c2.save(); c2.lineCap='round'; for (var s=-1;s<=1;s+=2){ var w=Math.sin(t*19+s)*h*0.035, hx=x+s*h*0.3+w, hy=y-h*0.97+Math.cos(t*19+s)*h*0.02, sx0=x+s*h*0.12;
      c2.strokeStyle='#1a1214'; c2.lineWidth=Math.max(3,h*0.075); c2.beginPath(); c2.moveTo(sx0,sh); c2.lineTo(hx,hy); c2.stroke(); c2.strokeStyle='#f0c8a4'; c2.lineWidth=Math.max(1.6,h*0.045); c2.beginPath(); c2.moveTo(sx0,sh); c2.lineTo(hx,hy); c2.stroke();
      c2.fillStyle='#f0c8a4'; c2.strokeStyle='#1a1214'; c2.lineWidth=1.5; c2.beginPath(); c2.arc(hx,hy,Math.max(2.5,h*0.05),0,7); c2.fill(); c2.stroke(); } c2.restore(); }
    // 浮字慘叫：跟住個人、慢慢升、淡出
    function scream(c2,x,y,sc,s){ if (!sc) return; s=s||1; var u=1-sc.T/1.9; c2.save(); c2.globalAlpha=Math.min(1,sc.T/0.45); c2.font='900 '+Math.round(14*s)+'px '+FONT; c2.textAlign='center'; c2.lineJoin='round'; c2.lineWidth=4; c2.strokeStyle='#14080a'; var yy=y-u*22*s; c2.strokeText(sc.t,x,yy); c2.fillStyle='#ff9a86'; c2.fillText(sc.t,x,yy); c2.restore(); }
    function uq(){ return uniq(SCREAM); }
    return {key:key, hasScared:hasScared, chibi:chibi, hgt:hgt, foot:foot, draw:draw, shock:shock, tremble:tremble, bang:bang, arms:arms, scream:scream, screamOn:function(o){ pplScream(o); }, tint:tintCv, CHIBI_K:CHIBI_K, uniqScream:uq};
  })();
  // 住客（大樓剖面）
  function pplDrawRes(r,viewW,viewH){ if (r.state==='gone'||r.state==='away') return; if (r.x<cam.x-60||r.x>cam.x+viewW+60||r.y<cam.y-20||r.y>cam.y+viewH+120) return; if (r.state==='leave'||r.state==='back') r.vx=r.vx||1;
    var home=r.state==='home', F=r.fear||0, flee=r.state==='flee', scared=(r.shockT>0)||flee, k2=PPLFX.key(r.sprite,scared), H=PPLFX.hgt(r.sprite,k2,r.h||58), art=k2!==r.sprite;
    ctx.fillStyle='rgba(0,0,0,0.45)'; ctx.beginPath(); ctx.ellipse(r.x,r.y-1,PPLFX.chibi(r.sprite)?20:16,4,0,0,7); ctx.fill();
    var jy=0, sh=0, ro=0, sy=1, sx=1, flip=r.vx<0, tint=0, arms=false;
    if (r.shockT>0){ var S0=PPLFX.shock(r.shockT,r.shockA||1); sx=S0.sx; sy=S0.sy; jy=S0.jy*H; sh=S0.sh*H; tint=S0.tint*(art?0.18:0.7); }
    else if (home&&r.awake&&F>=55){ var T0=PPLFX.tremble(r,G.t); sh=T0.sh*H; sy=T0.sy; if (T0.flip!=null) flip=T0.flip; tint=T0.tint; }
    else if (home&&F>60) sh=Math.sin(G.t*40)*1.6;
    if (flee){ if (r.tripT>0){ ro=(r.vx>0?1:-1)*1.25; jy=-6; } else { jy=-Math.abs(Math.sin(r.x*0.12))*7; ro=(r.vx>0?1:-1)*0.18; arms=!art; } tint=Math.max(tint,art?0:0.15); }
    if (r.tangle>0){ sh+=Math.sin(G.t*30)*2; sy*=0.96; }
    if (r.state==='leave'||r.state==='back'){ jy=-Math.abs(Math.sin(r.x*0.2))*3; }
    if (home&&!r.awake&&!r.react){ ro=-1.45; jy=-8; ctx.fillStyle='rgba(200,220,255,0.8)'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.fillText('Z',r.x+18,r.y-30-((G.t*12)%10)); ctx.font='bold 9px '+FONT; ctx.fillText('z',r.x+26,r.y-40-((G.t*12+5)%10)); }
    var P={sh:0,jy:0,ro:0,sy:1}; reactPose(r,P); sh+=P.sh; jy+=P.jy; ro+=P.ro; sy*=P.sy;
    var by=r.y+jy+(r.dy||0);
    if (arms) PPLFX.arms(ctx,r.x+sh,by,H,r.vx>0?1:-1,G.t);
    ctx.shadowColor='rgba(255,236,200,0.75)'; ctx.shadowBlur=5;
    PPLFX.draw(ctx,r.sprite,k2,r.x+sh,by,H,{flip:flip,rot:ro,sx:sx,sy:sy,tint:tint}); ctx.shadowBlur=0; reactProps(r,P);
    var top=by-H*Math.min(1,sy);
    if (r.shockT>0) PPLFX.bang(ctx,r.x+sh+(art?0:4),top-8,1-r.shockT/0.9,0.9);
    else if (flee&&!r.tripT) PPLFX.bang(ctx,r.x,top-6,0.5,0.7);
    if (home&&F>0) crBar(ctx,r.x-20,top-10,40,7,F/100,'red');
    if (r.scream) PPLFX.scream(ctx,r.x,top-16,r.scream,1);
    if (r.say) bubble(r.x,top-12-(home&&F>0?6:0),r.say); }
  // 保安：步頻跟實際行咗幾遠（唔會腳快身慢）
  function pplStep(s){ var d=s._lx==null?0:Math.hypot(s.x-s._lx,s.y-s._ly); s._lx=s.x; s._ly=s.y; if (d>40) d=0; var run=s.state==='flee'||(s.state==='scared'&&(s.scT||0)<1.7);
    s.stepPh=(s.stepPh||0)+d*Math.PI/(run?26:17); if (d>0.05) s.mvT=0.15; else s.mvT=Math.max(0,(s.mvT||0)-1/60);
    if (s.mvT>0){ s._sway=Math.sin(s.stepPh)*0.035; return -Math.abs(Math.sin(s.stepPh))*(run?4:2.4); } s._sway=0; return Math.sin(G.t*1.8+s.x)*0.6-0.6; }
  function pplGuard(s,H,bob,fl){ var scared=s.shockT>0||s.state==='scared'||s.state==='flee', k2=PPLFX.key(H.spr,scared), HH=PPLFX.hgt(H.spr,k2,H.h), art=k2!==H.spr;
    var sx=1, sy=1, jy=0, sh=0, ro=s._sway||0, tint=0;
    if (s.shockT>0){ var S0=PPLFX.shock(s.shockT,1); sx=S0.sx; sy=S0.sy; jy=S0.jy*HH; sh=S0.sh*HH; tint=S0.tint*(art?0.18:0.7); }
    else if (s.state==='scared'){ sh=Math.sin(G.t*45+s.x)*1.3; sy=0.95; tint=0.22; }
    if (s.state==='flee'){ ro=s.vx>0?0.2:-0.2; tint=Math.max(tint,art?0:0.15); if (!art) PPLFX.arms(ctx,s.x,s.y+bob+jy,HH,s.vx>0?1:-1,G.t); }
    PPLFX.draw(ctx,H.spr,k2,s.x+sh,s.y+bob+jy,HH,{flip:fl,alpha:s.kind==='decoy'?0.88:1,rot:ro,sx:sx,sy:sy,tint:tint});
    var top=s.y+bob+jy-HH*Math.min(1,sy);
    if (s.shockT>0) PPLFX.bang(ctx,s.x+sh,top-8,1-s.shockT/0.9,0.9);
    if (s.scream) PPLFX.scream(ctx,s.x,top-34,s.scream,1); }
  // ---------- 人類 ----------
  function nearestGhost(h){ var best=null, bd=1e9; G.gh.forEach(function(g){ if (g.home||g.out||g.inv>0||inSafe(g)) return; var d=Math.abs(g.x-h.x)+Math.abs(g.y-h.y)*1.5; if (d<bd){ bd=d; best=g; } }); return best; }
  function humanUpdate(h,dt){
    var H=HUM[h.kind]; h.alertT=Math.max(0,h.alertT-dt); h.shockT=Math.max(0,(h.shockT||0)-dt); if (h.scream){ h.scream.T-=dt; if (h.scream.T<=0) h.scream=null; } h.talkT-=dt; if (h.sayT>0) h.sayT-=dt; else h.say=null;
    if (h.state==='flee'){ if (inSafeXY(h.x+h.vx*dt,h.y)) h.vx*=-1; if (Math.random()<dt*8) part(h.x-Math.sign(h.vx)*10,h.y-4,-h.vx*0.1,-10,0.5,'dust'); h.x+=h.vx*dt; if (h.x<SX-20||h.x>LX+20) h.state='gone'; return; }
    if (h.state==='scared'){ h.scT-=dt; var bk=h.scT>1.7; if (h.scAway){ h.vx=h.scAway*(bk?55:95); h.dir=bk?-h.scAway:h.scAway; } var nx=h.x+h.vx*dt; if (nx<SX||nx>LX||inSafeXY(nx,h.y)){ h.vx*=-1; if (h.scAway) h.scAway*=-1; } else h.x=nx; if (h.scT<=0){ h.state='patrol'; var nn=nearNodeH(h); h.node=nn; h.to=null; h.p=0; var q0=G.nodes[nn]; h.x=q0.x; h.y=q0.y; } return; }
    if (h.state==='shift'||h.state==='inv'){ if (!h.to){ if (!h.path||!h.path.length){ if (h.state==='shift'){ h.state='gone'; return; } h.state='puzzle'; h.puzzleT=3.5; h.say=pick(['咩都冇喎……','係咪我聽錯？','奇怪……啱啱明明有聲']); h.sayT=2.4; return; } h.to=h.path.shift(); h.p=0; }
      var a0=G.nodes[h.node], b0=G.nodes[h.to]; if (!humanPassTo(h,a0,b0)){ h.to=null; h.path=dijkstra(h,h.node,h.state==='shift'?'f1_s':h.invNode); if (!h.path){ h.state='patrol'; } return; }
      var D0=Math.max(1,Math.hypot(b0.x-a0.x,b0.y-a0.y)); h.p+=H.sp*0.7*dt/D0; if (b0.x!==a0.x) h.dir=b0.x>a0.x?1:-1; if (h.p>=1){ h.node=h.to; h.to=null; h.p=0; } var p0=posOf(h); h.x=p0.x; h.y=p0.y;
      if (h.state==='inv'){ var tg0=nearestGhost(h); if (tg0 && Math.abs(tg0.y-h.y)<40 && (tg0.x-h.x)*h.dir>0 && Math.abs(tg0.x-h.x)<150){ h.state='chase'; h.alertT=1.2; h.say=line('guardHit'); h.sayT=2; } }
      return; }
    if (h.state==='balk'){ h.balkT-=dt; if (h.balkT<1.3&&!h.balkTurn){ h.balkTurn=1; h.dir=-h.dir; } if (h.balkT<=0){ h.state='patrol'; h.wait=0.2; h.repath=0; h.path=null; h.balkCd=6; } return; }
    if (h.state==='puzzle'){ h.puzzleT-=dt; h.dir=Math.floor(h.puzzleT*1.2)%2?1:-1; var tg1=nearestGhost(h); if (tg1 && Math.abs(tg1.y-h.y)<40 && (tg1.x-h.x)*h.dir>0 && Math.abs(tg1.x-h.x)<130){ h.state='chase'; h.alertT=1.2; h.say=line('guardHit'); h.sayT=2; } else if (h.puzzleT<=0){ h.state='patrol'; h.wait=0.5; } return; }
    if (h.kind==='collector'){ return; }
    var tgS=nearestAny(h); h.balkCd=Math.max(0,(h.balkCd||0)-dt);   // PEOPLE HOOK：追到陰氣地邊就停低、講句、返轉頭
    if (tgS&&inSafe(tgS)&&!(h.balkCd>0)&&nearSafe(h)&&(h.state==='chase'||(h.kind!=='guard'&&h.kind!=='collector'&&!(h.kind==='decoy'&&!h.real)))){ balk(h,h.kind!=='dog'); return; }
    if (h.state==='chase'&&tgS&&inSafe(tgS)){ balk(h,false); return; }
    if (h.state==='chase'){ var tg2=nearestGhost(h); var far=!tg2||Math.abs(G.nodes[tg2.node].f-G.nodes[h.node].f)>=2||Math.abs(tg2.x-h.x)>460; if (tg2&&!inZone(h,G.nodes[tg2.node].f,1)) h.lostT=(h.lostT||0)+dt*3; h.lostT=far?(h.lostT||0)+dt:0; if (h.lostT>8){ h.state='patrol'; h.lostT=0; h.path=null; h.say=pick(['走甩咗……','跑得咁快？算數','嗰樣嘢去咗邊？']); h.sayT=2.2; } }
    if (h.talkT<=0 && h.kind!=='dog'){ h.say=h.kind==='guard'?line('guard'):h.kind==='compass'?pick(['羅盤指住呢邊……','針震緊，有嘢喺附近']):pick(['照妖鏡在此，莫要亂來','鏡光到處，邪靈退後']); h.sayT=2.4; h.talkT=8+rnd()*8; }
    var tg=nearestGhost(h), chaser=h.kind!=='guard'||h.state==='chase';
    if (h.kind==='guard' && tg && Math.abs(tg.y-h.y)<40 && (tg.x-h.x)*h.dir>0 && Math.abs(tg.x-h.x)<150 && h.state!=='chase'){ h.state='chase'; h.alertT=1.2; h.say=line('guardHit'); h.sayT=2; }
    if (h.kind==='decoy' && !h.real) chaser=false;
    if (!h.to){ h.wait-=dt; if (h.wait>0) return; h.repath-=dt;
      if (chaser && tg){ var tn=tg.to? (Math.abs(G.nodes[tg.node].x-tg.x)<Math.abs(G.nodes[tg.to].x-tg.x)?tg.node:tg.to) : tg.node; if (safeNode(tn)){ balk(h,h.kind!=='dog'&&nearSafe(h)&&!(h.balkCd>0)); return; } if (h.repath<=0||!h.path){ h.path=dijkstra(h,h.node,tn); h.repath=0.5; } if (h.path&&h.path.length){ h.to=h.path.shift(); h.p=0; } }
      if (!h.to){ var n=G.nodes[h.node], zm=h.zone?(h.zone[0]+h.zone[1])/2:0, opts=n.links.filter(function(l){ var m=G.nodes[l.to]; return m.kind!=='in' && m.kind!=='portal' && !safeNode(l.to) && humanPass(h,l.e) && (inZone(h,m.f)||(!inZone(h,n.f)&&Math.abs(m.f-zm)<Math.abs(n.f-zm))); }); if (opts.length){ h.to=pick(opts).to; h.p=0; } } }
    var a=G.nodes[h.node], b=G.nodes[h.to]; if (!b){ h.to=null; return; } var D=Math.max(1,Math.hypot(b.x-a.x,b.y-a.y));
    var sp=H.sp*(h.boost||1)*(G.gate?(G.gate.t>20?1.4:1.2):1)*(1+0.08*G.phase); if (tg&&chaser){ sp*=1.05*Math.pow(1.15,Math.abs(G.nodes[tg.node].f-a.f)); sp=Math.min(sp,tg.d.sp*G.mods.spd*0.85); } else sp*=0.45; h.walkSp=sp;
    h.p+=sp*dt/D; if (b.x!==a.x) h.dir=b.x>a.x?1:-1;
    if (h.p>=1){ h.node=h.to; h.to=null; h.p=0; h.wait=chaser?0:0.3+rnd()*0.8; }
    var p=posOf(h); h.x=p.x; h.y=p.y;
    // 撞到鬼
    G.gh.forEach(function(g){ if (g.home||g.out||g.inv>0||g.stun>0||(h.catchCd||0)>0||inSafe(g)) return; if (Math.abs(g.y-h.y)>30||Math.abs(g.x-h.x)>18) return;
      if (h.kind==='dog'){ g.stun=1; G.alert+=1; checkAlert(); float(g.x,g.y-80,'狗吠到成棟樓醒晒！','#ffb0b0'); h.catchCd=2; return; }
      if (h.kind==='decoy'&&!h.real) return; if (h.kind==='guard'&&h.state!=='chase') return;
      catchGhost(g,h); h.catchCd=2.2; });
    h.catchCd=Math.max(0,(h.catchCd||0)-dt);
  }
  function catchGhost(g,h){
    if (inSafe(g)) return;   // PEOPLE HOOK：陰氣地入面唔會被捉
    var near=G.guards.filter(function(o){ return o.state!=='flee'&&o.kind!=='dog'&&!(o.kind==='decoy'&&!o.real)&&Math.abs(o.y-g.y)<30&&Math.abs(o.x-g.x)<90; }).length;
    g.caught+= near>=2?3:1; if (near>=2) float(g.x,g.y-110,'被圍！','#ff5a4a');
    g.hitT=0.8; g.hitDir=h.dir; g.stun=1.5; g.to=null; g.auto=null; h.alertT=1.3; h.say=line('guardHit'); h.sayT=2; G.shake=0.35;
    for (var k=0;k<10;k++) part(g.x,g.y-g.d.h*0.5,(rnd()-0.5)*50+h.dir*40,-30-rnd()*40,0.9,'smoke');
    if (g.caught>=3){ g.out=true; var lost=G.bag.filter(function(b){return b.o===g.i;}).length; G.bag=G.bag.filter(function(b){return b.o!==g.i;}); g.loot=0; float(g.x,g.y-100,g.d.name+'被收服！','#ff7a5a'); toast(g.d.name+'畀人收服咗，佢身上 '+lost+' 件收穫冇埋。'+(G.gh.some(function(o){return !o.out;})?'快啲切去其他鬼！':'')); if (G.active===g.i){ var nx=G.gh.find(function(o){return !o.out&&!o.home;}); if (nx) G.active=nx.i; } }
    else { loseLoot(g,0.34); float(g.x,g.y-80,'被捉住！（'+g.caught+'/3）','#ffb0b0'); var back=G.nodes[g.node].links.map(function(l){return G.nodes[l.to];}).filter(function(m){return m.kind!=='in'&&(m.x-h.x)*h.dir>0;})[0]; if (back) g.node=back.id; }
  }
  function loseLoot(g,frac){ var mine=G.bag.filter(function(b){return b.o===g.i;}); var l=Math.ceil(mine.length*frac*(G.mods.arm<1?0.5:1)); for (var k=0;k<l;k++){ var i=G.bag.indexOf(mine[k]); G.bag.splice(i,1); } g.loot=Math.max(0,g.loot-l); if (l>0) float(g.x,g.y-95,'跌咗收穫 -'+l,'#ff9a9a'); }
  // ---------- 天師（鈴聲逼退，尊重用語）----------
  var TAOL=['鈴……鈴……各位街坊安心瞓','天師巡樓，邪氣退散','聽住鈴聲，唔好亂走','鈴聲到處，夜路平安'];
  function spawnTao(f,x){ G.tao={x:x, f:f, dir:x<WW/2?1:-1, ringT:2.2, life:26, waves:[], say:pick(TAOL), sayT:2.6}; float(x,fy(f)-90,'天師嚟咗！','#ffd54a'); }
  function taoUpdate(dt){
    if (G.taoWant && !G.tao && !G.gate){ G.taoCd=(G.taoCd==null?2:G.taoCd)-dt; if (G.taoCd<=0){ var f=1+Math.floor(rnd()*(FL-1)); spawnTao(f,rnd()<0.5?SX:LX); } }
    var T=G.tao; if (!T) return;
    T.life-=dt; T.x+=T.dir*36*dt; if (T.x>LX-10||T.x<SX+10) T.dir*=-1; T.sayT-=dt;
    T.ringT-=dt; if (T.ringT<=0){ T.ringT=4; T.waves.push({r:10,t:1}); T.say=pick(TAOL); T.sayT=2.4;
      G.gh.forEach(function(g){ if (g.home||g.out) return; if (g.inUnit) return; if (inSafe(g)) return; if (G.nodes[g.node].f!==T.f) return; if (Math.abs(g.x-T.x)>140) return;
        g.sealT=3; g.hitT=0.8; g.hitDir=g.x>T.x?1:-1; g.to=null; g.auto=null; g.taskP=0;
        var n=G.nodes[g.node], away=n.links.map(function(l){return G.nodes[l.to];}).filter(function(m){return m.kind!=='in'&&(m.x-T.x)*(g.x-T.x)>=0&&Math.abs(m.x-T.x)>Math.abs(n.x-T.x);})[0];
        if (n.kind==='in') g.node=n.id.replace('_i','_d'); else if (away) g.node=away.id;
        float(g.x,g.y-90,'鈴聲逼退，暫時嚇唔到人','#ffe9a0'); for (var k=0;k<8;k++) part(g.x,g.y-30,(rnd()-0.5)*60,-30-rnd()*40,0.9,'smoke'); }); }
    T.waves.forEach(function(w){ w.t-=dt; w.r+=180*dt; }); T.waves=T.waves.filter(function(w){return w.t>0;});
    if (T.life<=0){ G.tao=null; G.taoCd=16+rnd()*10; }
  }
  // ---------- 撤離 ----------
  function gatePress(){ var g=G.gh[G.active], n=G.nodes[g.node]; if (G.gate||g.to||n.kind!=='portal') return; standStill(g); calm(g); G.gateCharge=0.001; G.gateG=g.i; }
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
    try{ var sv=TS(), first=why==='gate'&&!sv['gate_'+curLv]; if (first) sv['gate_'+curLv]=1; sv.nights=(sv.nights||0)+1; var rw=(why==='gate'?40+15*kept+25*story:why==='doll'?20+8*kept:0)+(why!=='fail'?(G.unitCoins||0):0); if (first) rw+=100; if (why!=='fail'){ sv.best=Math.max(sv.best||0,kept); sv.cleared[curLv]=1; } G.over.reward=rw; S.res.coins+=rw; save(); }catch(e){ console.error(e); }
  }
  // ---------- 嚇人（要企定）----------
  function say(r,t){ r.say=t; r.sayT=2.6; }
  function scareRes(r,amt,g){ if (r.state!=='home') return; if (!r.awake){ r.awake=true; r.woke=true; amt*=0.6; } r.fear+=amt*G.mods.pow*(1-r.brave); if (r.unit&&r.unit.rs) r.unit.rs.forEach(function(o){ if (o!==r&&o.state==='home'){ o.awake=true; o.woke=true; o.fear+=amt*0.35*(1-o.brave); o.jumpT=0.4; if (o.fear>=100&&!(o.fleeAfter>0)){ o.fleeAfter=1; o.fleeG=g; } } }); r.jumpT=0.5; if (g) g.energy=Math.min(100,g.energy+(r.brave?8:18)); for (var k=0;k<5;k++) part(r.x,r.y-48,(rnd()-0.5)*90,-60-rnd()*40,0.6,'sweat'); doReact(r,g); if (r.fear>=100 && !(r.fleeAfter>0)){ r.fleeAfter=0.9; r.fleeG=g; } }
  function flee(r,g){
    r.state='flee'; r.y=fy(r.unit.f); r.vx=(r.x<WW/2?-1:1)*150; chain(r.unit,16,r.chainD||0); r.tripT=rnd()<0.35?0.9:0; pplScream(r); if (g) g.energy=Math.min(100,g.energy+20);
    addFear(Math.round(15*G.mods.fear),r.x,r.y-80);
    G.units.forEach(function(u){ if (u.ot===1&&u.dep===r.unit&&!u.open){ unlockUnit(u,'隔籬人心惶惶，入得喇（黑屋）'); } });
    if (r.unit.story && G.story.indexOf(r.unit.si)<0){ G.story.push(r.unit.si); G.story.sort(); toast('收集到故事碎片——'+STORY[r.unit.si]+'（要正規經陰門返去先帶得走）'); }
  }
  function addFear(a,x,y){ G.fear+=a; G.fearTotal+=a; float(x,y,'怕意 +'+a,'#9fd6bf'); if (G.fearTotal>=G.fearNext){ G.fearNext+=30; G.choiceQ=(G.choiceQ||0)+1; } }
  // 停低：取消搖桿、自動行；企定計時當已企定（撳掣嗰下鬼即刻停）
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
    g.scareCd=1.2; g.actT=0.9; g.dir=h.x>g.x?1:-1; G.shake=0.25;
    if (h.kind==='mirror' && Math.sign(g.x-h.x)===h.dir){ float(h.x,h.y-90,'正面對住面鏡，嚇唔到！兜去背後','#ffe9a0'); return; }
    if (h.kind==='decoy' && !h.real){ h.state='gone'; for (var k=0;k<12;k++) part(h.x,h.y-30,(rnd()-0.5)*120,-60-rnd()*60,0.9,'paper'); float(h.x,h.y-80,'紙人替身！','#e8d8b0'); return; }
    if (h.kind==='guard'){ spook(h,pick(['嘩！有嘢喺我後面！','乜……乜嘢嚟㗎？！'])); g.energy=Math.min(100,g.energy+15); return; }
    h.courage--; h.alertT=0.8; h.shockT=0.9; float(h.x,h.y-90,h.kind==='compass'?'羅盤保安膽量 -1（剩 '+Math.max(0,h.courage)+'）':'嚇！','#ff7a5a');
    if (h.courage<=0){ h.state='flee'; h.vx=(h.x<WW/2?-1:1)*170; pplScream(h); addFear(h.kind==='dog'?6:12,h.x,h.y-80); g.energy=Math.min(100,g.energy+20); }
  }
  function part(x,y,vx,vy,life,type){ if (G.parts.length<260) G.parts.push({x:x,y:y,vx:vx,vy:vy,life:life,max:life,type:type}); }
  function stepFx(dt){ G.parts.forEach(function(p){ p.life-=dt; p.x+=p.vx*dt; p.y+=p.vy*dt; if (p.type==='coin'||p.type==='crumb'||p.type==='sweat'||p.type==='tear'||p.type==='paper'||p.type==='drip') p.vy+=220*dt; if (p.type==='smoke') { p.vx*=0.96; p.vy*=0.96; } if (p.tx!=null){ p.x+=(p.tx-p.x)*dt*3; p.y+=(p.ty-p.y)*dt*3; } }); G.parts=G.parts.filter(function(p){return p.life>0;});
    G.wardFx.forEach(function(w){ w.t-=dt; }); G.wardFx=G.wardFx.filter(function(w){return w.t>0;}); G.shake=Math.max(0,(G.shake||0)-dt);
    G.units.forEach(function(u){ if (u.unlockFx>0) u.unlockFx-=dt; });
    for (var k in G.dark){ G.dark[k]-=dt; if (G.dark[k]<=0) delete G.dark[k]; } }
  var ULT={eking:{n:'大胃王',d:'整層熄燈，黑暗中得返一張巨口！'},toyol:{n:'一掃光',d:'分身滿層亂竄，偷到一個唔留！'},tianhua:{n:'千絲垂髮',d:'頭髮沿走廊爬去隔籬屋，纏實成層人！'}};
  function ultPress(i){ var g=G.gh[i]; if (g.energy<100||g.home||g.out||G.ult) return false; g.energy=0; G.ult={g:g,t:0,f:G.nodes[g.node].f,done:false}; return true; }
  function applyUlt(U){ var g=U.g, f=U.f, k=g.d.key, rs=G.res.filter(function(r){return r.unit.f===f&&r.state==='home';}), hs=G.guards.filter(function(h){return G.nodes[h.node].f===f&&h.state!=='flee';});
    if (k==='eking'){ G.dark[f]=3.2; rs.forEach(function(r){ scareRes(r,130,g); for (var q=0;q<6;q++){ var p={x:r.x,y:r.y-30,vx:0,vy:0,life:1.4,max:1.4,type:'suck'}; p.tx=g.x; p.ty=g.y-30; G.parts.push(p); } }); hs.forEach(function(h){ h.wait=3; }); }
    if (k==='toyol'){ U.clones=[0,1,2,3,4].map(function(j){ return {x:Math.max(60,G.gh[0].x-260)+j*110,v:(j%2?1:-1)*(220+j*30)}; }); var got=0; G.units.forEach(function(u){ if (u.f===f&&u.open){ for (var q=u.items.length-1;q>=0;q--){ var it=u.items[q]; if ((it==='money'||it==='key'||it==='doll')&&(it!=='money'||G.bag.length<BAGMAX)){ u.items.splice(q,1); takeItem(g,it,u); got++; } } } }); float(g.x,g.y-100,'一掃光！攞到 '+got+' 件','#ffd54a'); rs.forEach(function(r){ scareRes(r,85,g); }); }
    if (k==='tianhua'){ rs.forEach(function(r){ r.tangle=3.2; scareRes(r,105,g); }); hs.forEach(function(h){ h.wait=3.2; h.to=null; }); }
    G.shake=0.5;
  }
  function invPress(){ var g=G.gh[G.active]; if (g.invCd>0||g.out) return; g.inv=G.mods.inv; g.invCd=G.mods.inv+9; float(g.x,g.y-90,'隱身','#9fe0ff'); }
  function chooseCard(i){
    var c=G.choice[i]; if (!c) return; var m=G.mods;
    if (c.id==='spd') m.spd*=1.2; if (c.id==='pow') m.pow*=1.4; if (c.id==='inv') m.inv+=2; if (c.id==='task') m.task*=1.35; if (c.id==='arm') m.arm=0.5; if (c.id==='fear') m.fear*=1.3;
    G.choice=null; toast('揀咗「'+c.t+'」：'+c.d);
  }


  // ---------- 三隻鬼嘅招式：預兆 → 出手 → 餘痕（民間依據見審閱頁） ----------
  var MV={
    eking:{n:'碗筷自己郁・米缸巨口', omen:'叮叮噹噹……', tr:'food'},
    toyol:{n:'細腳印・床底搶嘢', omen:'嘻嘻……嘻嘻……', tr:'mess'},
    tianhua:{n:'天花滲水・倒吊貼面', omen:'嘀……嘀……', tr:'hair'}
  };
  var OMEN=0.75, STRIKE=0.65, AFTER=0.6;
  var REACT={
    scream:['啊——！！','嘩呀——！！','救——命——！'], kneel:['唔好搵我……我冇做壞事㗎','放過我啦……','我同你無仇無怨㗎……'],
    cover:['睇唔到睇唔到睇唔到……','唔好望唔好望……'], fall:['哎呀！','跌親呀——'],
    phone:['喂？管理處呀！有嘢呀！','喂喂喂！快啲上嚟！'], slipper:['打死你！打死你！','睇我隻拖鞋！'], push:['你行先！','唔好推我呀！']
  };
  function startMove(g,r,un){
    g.scareCd=OMEN+STRIKE+AFTER+0.3; g.dir=r.x>g.x?1:-1;
    var ceil=fy(un.f+1)+16, side=(r.x-un.rx[0]<(un.rx[1]-un.rx[0])/2)?1:-1;
    g.sc={t:0,r:r,un:un,k:g.d.key,hit:false,tr:false,ceil:ceil,side:side,sx:r.x+side*42};
    float(g.x,g.y-g.d.h-18,MV[g.d.key].n,'#ffb7a0');
  }
  function moveUpdate(g,dt){
    var S=g.sc; if (!S) return;
    if (S.t<OMEN && (g.to||g.mv>0.05)){ float(g.x,g.y-80,'一郁就破功','#ffd54a'); g.sc=null; g.scareCd=0.4; return; }
    var t0=S.t; S.t+=dt; var r=S.r, k=S.k;
    if (S.t<OMEN){ // 預兆粒子
      if (k==='tianhua' && rnd()<dt*9) part(r.x+(rnd()-0.5)*30,S.ceil+4,0,30,0.8,'drip');
      if (k==='toyol' && Math.floor(S.t*8)!==Math.floor(t0*8)){ var q=Math.floor(S.t*8); (S.prints=S.prints||[]).push({x:S.sx+(r.x-S.sx)*q/6+(q%2?4:-4),y:r.y-2}); }
    }
    if (!S.hit && S.t>=OMEN){ S.hit=true; G.shake=0.35; g.actT=0;
      if (k==='toyol'){ for (var q=0;q<6;q++){ var p={x:r.x,y:r.y-34,vx:0,vy:0,life:0.9,max:0.9,type:'note'}; p.tx=S.sx; p.ty=r.y-14; G.parts.push(p); } }
      if (k==='eking'){ for (var q=0;q<8;q++) part(S.sx,r.y-30,(rnd()-0.5)*160,-80-rnd()*60,0.8,'crumb'); }
      if (k==='tianhua'){ for (var q=0;q<10;q++) part(r.x,r.y-50,(rnd()-0.5)*80,-20,0.7,'drip'); }
      scareRes(r,38,g); }
    if (!S.tr && S.t>=OMEN+STRIKE){ S.tr=true; addTrace(MV[k].tr,S,g); if (k==='tianhua'){ g.dropT=2.3; g.stun=Math.max(g.stun,2.3); g.to=null; g.auto=null; float(g.x,g.y-70,'哎吔……腰骨痛','#e8d8b0'); } }
    if (S.t>=OMEN+STRIKE+AFTER) g.sc=null;
  }
  function addTrace(kind,S,g){ var un=S.un;
    var T={k:kind,f:un.f,un:un,x:kind==='hair'?un.x:S.r.x,y:fy(un.f),life:kind==='hair'?40:22,used:false,t:0};
    G.traces.push(T);
    if (kind==='mess'){ G.alert+=1; float(un.x,un.y-96,'翻箱倒櫃好嘈！全樓警覺 +1','#ffb0b0'); checkAlert();
      var best=null,bd=1e9; G.guards.forEach(function(h){ if (h.kind!=='guard'||h.state==='flee') return; var hf=G.nodes[h.node].f; var d=Math.abs(hf-un.f)*400+Math.abs(h.x-un.x); if (d<bd){bd=d;best=h;} });
      if (best){ best.state='chase'; best.alertT=1.2; best.say='邊度咁嘈？上去睇睇！'; best.sayT=2.4; }
      if (S.r.state==='home'){ S.r.hunt=4; say(S.r,pick(['我啲錢呢？！','銀包去咗邊呀？！','邊個翻亂晒啲嘢？'])); } }
    if (kind==='food') T.wait=3.2;
    if (kind==='hair') float(un.x,un.y-96,'門框留低濕頭髮……','#9fe0ff');
  }
  function traceUpdate(dt){
    G.traces.forEach(function(T){ T.life-=dt; T.t+=dt;
      if (T.k==='food' && !T.used){ var r=T.un.res;
        if (r && r.state==='home'){ T.wait-=dt; if (T.wait<=0){ T.used=true; say(r,'邊個搞到成地都係飯……'); r.tidy=1.2; r.tidyCb=function(){ r.jumpT=0.5; say(r,'嘩！碗入面有隻眼！'); scareRes(r,30,null); addFear(6,r.x,r.y-90); float(r.x,r.y-110,'二次嚇！','#ff7a5a'); }; } }
        else G.guards.forEach(function(h){ if (T.used||h.state==='flee'||h.kind==='dog') return; if (G.nodes[h.node].f!==T.f||Math.abs(h.x-T.x)>26) return; T.used=true; h.wait=1.6; h.to=null; h.say='成地都係飯……咦？碗郁咗！'; h.sayT=2.2; h.alertT=1; addFear(6,h.x,h.y-90); float(h.x,h.y-110,'二次嚇！','#ff7a5a'); }); }
      if (T.k==='hair' && !T.used){ var vic=null;
        G.guards.forEach(function(h){ if (!vic&&h.state!=='flee'&&h.kind!=='dog'&&Math.abs(h.y-T.y)<30&&Math.abs(h.x-T.x)<18) vic=h; });
        G.res.forEach(function(r){ if (!vic&&r.state==='flee'&&Math.abs(r.y-T.y)<30&&Math.abs(r.x-T.x)<18) vic=r; });
        if (vic){ T.used=true; T.life=Math.min(T.life,2.5); vic.tangle=2.2; if (vic.state==='flee'){ vic.tripT=1.2; } else { vic.wait=2.2; vic.to=null; vic.path=null; } vic.say='咩嘢纏住我隻腳呀？！濕㗎！'; vic.sayT=2.2; addFear(6,vic.x,vic.y-90); float(vic.x,vic.y-112,'濕髮纏腳！','#9fe0ff'); } }
    });
    G.traces=G.traces.filter(function(T){return T.life>0;});
    G.res.forEach(function(r){
      if (r.hunt>0){ r.hunt-=dt; if (r.state==='home'){ r.fear+=dt*5; if (r.fear>=100) flee(r,null); } }
      if (r.tidy>0){ r.tidy-=dt; if (r.tidy<=0&&r.tidyCb){ var cb=r.tidyCb; r.tidyCb=null; cb(); } }
      if (r.react){ r.react.t-=dt; if (r.react.t<=0) r.react=null; }
      if (r.fleeAfter>0){ r.fleeAfter-=dt; if (r.fleeAfter<=0 && r.state==='home'){ r.fleeAfter=0; flee(r,r.fleeG); } }
    });
    G.guards.forEach(function(h){ if (h.tangle>0) h.tangle-=dt; });
  }
  function pickReact(r,g){
    if (r.brave) return 'slipper';
    var opts=['scream','kneel','cover','fall','phone'];
    var near=G.guards.concat(G.res).some(function(o){ return o!==r && o.state!=='flee' && o.state!=='gone' && Math.abs(o.y-r.y)<30 && Math.abs(o.x-r.x)<130; });
    if (near) opts.push('push','push');
    var k=pick(opts); if (k===r.lastReact) k=pick(opts); r.lastReact=k; return k;
  }
  function doReact(r,g){ var k=pickReact(r,g); r.react={k:k,t:1.7}; say(r,pick(REACT[k]));
    if (k==='phone'){ var ok=(G.phoneCd||0)<=0 && !(G.ult&&G.ult.phoned); if (ok){ G.alert+=1; G.phoneCd=8; if (G.ult) G.ult.phoned=true; float(r.x,r.y-100,'打電話求救！警覺 +1','#ffb0b0'); } else float(r.x,r.y-100,'電話打唔通……','#e8d8b0'); }
    if (k==='slipper'&&g){ g.bounceT=0.45; float(g.x,g.y-g.d.h-6,'拖鞋打空氣','#e8d8b0'); }
    if (k==='push'){ var o=null; G.guards.concat(G.res).forEach(function(q){ if (!o&&q!==r&&q.state!=='flee'&&q.state!=='gone'&&Math.abs(q.y-r.y)<30&&Math.abs(q.x-r.x)<130) o=q; }); if (o){ r.pushTo=o.x>r.x?1:-1; o.jumpT=0.5; if (o.unit){ o.fear+=10; } else { o.wait=Math.max(o.wait||0,0.9); } } }
  }
  // 綠豆 / 玩具：馬來民間話放一兜綠豆，Toyol 會忍唔住坐低逐粒數
  function setupBeans(){ if (G.beansInit) return; G.beansInit=true; var c=0;
    G.units.forEach(function(u){ if (c<2 && u.res && u.ot!=='deity' && u.f>0 && (u.f+u.u)%2===1){ u.beans=true; c++; } });
    if (!c){ var u=G.units.find(function(u){return u.res&&u.ot!=='deity';}); if (u) u.beans=true; } }
  var COUNT=['一','二','三','四','五','六','七','八','九','十'];
  function beansCheck(g,dt){ if (g.d.key!=='toyol') return; var n=G.nodes[g.node];
    if (g.countT>0){ g.countT-=dt; g.cntAcc=(g.cntAcc||0)+dt; if (g.cntAcc>0.32){ g.cntAcc=0; g.cntN=(g.cntN||0)+1; } return; }
    if (n.kind==='in' && !g.to){ var un=unitOf(n.id); if (un.beans && !un.beansDone){ un.beansDone=true; g.countT=2.6; g.stun=2.6; g.cntN=0; g.taskP=0; g.sc=null; float(g.x,g.y-g.d.h-20,'地下有綠豆！忍唔住坐低數……','#b8f0a0'); } } }

  // ---------- 畫招式 ----------
  function drawBowl(x,y,fill){ ctx.fillStyle='#d8d0c0'; ctx.beginPath(); ctx.moveTo(x-9,y-6); ctx.quadraticCurveTo(x,y+5,x+9,y-6); ctx.closePath(); ctx.fill(); ctx.strokeStyle='#6a4a2a'; ctx.lineWidth=1; ctx.stroke(); if (fill>0){ ctx.fillStyle='#f0e6c8'; ctx.beginPath(); ctx.ellipse(x,y-6,8*fill,2.6,0,0,7); ctx.fill(); } }
  function drawMouth(x,y,R,open,dir){ ctx.save(); ctx.translate(x,y); ctx.scale(dir,1);
    ctx.fillStyle='#120808'; ctx.beginPath(); ctx.ellipse(0,0,R*1.1,R*0.85,0,0,7); ctx.fill();
    ctx.fillStyle='#7a0e0e'; ctx.beginPath(); ctx.ellipse(R*0.15,0,R*0.85,R*0.62*open+2,0,0,7); ctx.fill();
    ctx.fillStyle='#e8e0cc'; var n=7; for (var i=0;i<n;i++){ var tx=-R*0.65+i*R*1.6/n; ctx.beginPath(); ctx.moveTo(tx,-R*0.62*open); ctx.lineTo(tx+R*0.11,-R*0.62*open+R*0.28); ctx.lineTo(tx+R*0.22,-R*0.62*open); ctx.fill(); ctx.beginPath(); ctx.moveTo(tx,R*0.62*open); ctx.lineTo(tx+R*0.11,R*0.62*open-R*0.26); ctx.lineTo(tx+R*0.22,R*0.62*open); ctx.fill(); }
    ctx.fillStyle='#d0c060'; ctx.beginPath(); ctx.arc(-R*0.55,-R*0.9,R*0.12,0,7); ctx.arc(R*0.35,-R*0.95,R*0.12,0,7); ctx.fill(); ctx.restore(); }
  function txt(s,x,y,c,sz){ crText(ctx,s,x,y,sz||12,c,'center'); }
  function drawMoves(){
    G.gh.forEach(function(g){ var S=g.sc; if (!S||g.home||g.out) return; var r=S.r, un=S.un, top=fy(un.f+1)+10, flo=fy(un.f), k=S.k, t=S.t;
      ctx.save(); ctx.beginPath(); ctx.rect(un.rx[0]-40,top,un.rx[1]-un.rx[0]+80,flo-top+2); ctx.clip();
      if (t<OMEN){ var o=t/OMEN;
        if (k==='eking'){ for (var i=0;i<3;i++){ var bx=r.x-S.side*(14+i*14), by=r.y-22-Math.abs(Math.sin(G.t*18+i*2))*7*o; ctx.save(); ctx.translate(bx,by); ctx.rotate(Math.sin(G.t*22+i)*0.35*o); drawBowl(0,0,1); ctx.restore(); ctx.strokeStyle='#c8a050'; ctx.lineWidth=1.5; ctx.beginPath(); ctx.moveTo(bx+6,by-8-Math.sin(G.t*30+i)*4); ctx.lineTo(bx+14,by-18); ctx.stroke(); }
          txt(MV.eking.omen,r.x-S.side*28,r.y-72-o*6,'#ffe9a0',11); }
        if (k==='toyol'){ (S.prints||[]).forEach(function(p,i){ ctx.fillStyle='rgba(120,200,150,'+(0.55)+')'; ctx.beginPath(); ctx.ellipse(p.x,p.y,2.6,1.5,0,0,7); ctx.fill(); ctx.beginPath(); ctx.ellipse(p.x+3,p.y-3,1,1,0,0,7); ctx.fill(); });
          ctx.fillStyle='#3a2a1e'; ctx.fillRect(S.sx-26,flo-18,52,10); ctx.fillStyle='#7a6a5a'; ctx.fillRect(S.sx-28,flo-24,56,7);
          txt(MV.toyol.omen,S.sx,flo-36-Math.sin(G.t*9)*3,'#b8f0a0',11); }
        if (k==='tianhua'){ ctx.fillStyle='rgba(60,90,110,'+(0.55*o)+')'; ctx.beginPath(); ctx.ellipse(r.x,S.ceil+2,10+o*26,4+o*4,0,0,7); ctx.fill();
          txt(MV.tianhua.omen,r.x+22,S.ceil+22,'#9fe0ff',11); }
      } else if (t<OMEN+STRIKE){ var s=(t-OMEN)/STRIKE, e=s<0.35?s/0.35:1;
        if (k==='eking'){ ctx.fillStyle='#2a2e32'; ctx.fillRect(S.sx-15,flo-60,30,58); ctx.strokeStyle='#8a9aa0'; ctx.lineWidth=1.5; ctx.strokeRect(S.sx-15,flo-60,30,58); ctx.beginPath(); ctx.moveTo(S.sx-15,flo-38); ctx.lineTo(S.sx+15,flo-38); ctx.stroke();
          ctx.fillStyle='rgba(255,240,200,'+(0.5*e)+')'; ctx.fillRect(S.sx-15,flo-60,4,58);
          drawMouth(S.sx+(r.x-S.sx)*0.45*e,flo-40,10+28*e,0.35+0.65*Math.abs(Math.sin(s*Math.PI*3)),r.x>S.sx?1:-1); }
        if (k==='toyol'){ ctx.fillStyle='#3a2a1e'; ctx.fillRect(S.sx-26,flo-18,52,10); spr('toyol',S.sx+(r.x-S.sx)*0.4*e,flo-6+18*(1-e),40,{flip:r.x<S.sx,rot:(r.x>S.sx?1:-1)*0.3*(1-e)}); ctx.fillStyle='#7a6a5a'; ctx.fillRect(S.sx-28,flo-24,56,7);
          if (s>0.3) txt('搶咗！',S.sx,flo-62,'#ffd54a',13); }
        if (k==='tianhua'){ var yb=S.ceil+8+(r.y-30-S.ceil-8)*e, hx=r.x+(r.x>g.x?-14:14); ctx.strokeStyle='rgba(14,14,18,0.9)'; ctx.lineWidth=1.6; for (var i=0;i<10;i++){ ctx.beginPath(); ctx.moveTo(hx-12+i*2.6,S.ceil); ctx.quadraticCurveTo(hx-12+i*2.6+Math.sin(G.t*6+i)*3,(S.ceil+yb)/2,hx-14+i*3,yb-20); ctx.stroke(); }
          spr('tianhua_hang',hx,yb,74,{flip:r.x<g.x,rot:Math.sin(G.t*4)*0.05}); for (var i=0;i<3;i++){ ctx.fillStyle='#9fe0ff'; ctx.beginPath(); ctx.arc(hx-8+i*8,yb+4+((G.t*60+i*9)%22),1.8,0,7); ctx.fill(); } }
      } else { var a=1-(t-OMEN-STRIKE)/AFTER;
        if (k==='eking'){ ctx.globalAlpha=a; ctx.fillStyle='#2a2e32'; ctx.fillRect(S.sx-15,flo-60,30,58); ctx.globalAlpha=1; }
        if (k==='toyol'){ ctx.globalAlpha=a; ctx.fillStyle='#3a2a1e'; ctx.fillRect(S.sx-26,flo-18,52,10); ctx.globalAlpha=1; }
      }
      ctx.restore(); });
  }
  function drawTraces(){
    G.traces.forEach(function(T){ var a=Math.min(1,T.life/2); ctx.globalAlpha=a;
      if (T.k==='food'){ for (var i=0;i<9;i++){ var px=T.x-26+((i*37)%52), py=T.y-3-(i%3); ctx.fillStyle=i%3?'#e8d8a0':'#c8784a'; ctx.beginPath(); ctx.ellipse(px,py,3+(i%2)*2,1.6,0,0,7); ctx.fill(); }
        ctx.save(); ctx.translate(T.x+10,T.y-6); ctx.rotate(1.3); drawBowl(0,0,0); ctx.restore(); ctx.save(); ctx.translate(T.x-18,T.y-5); ctx.rotate(-2.2); drawBowl(0,0,0); ctx.restore();
        ctx.strokeStyle='#c8a050'; ctx.lineWidth=1.4; ctx.beginPath(); ctx.moveTo(T.x-4,T.y-2); ctx.lineTo(T.x+14,T.y-5); ctx.moveTo(T.x-2,T.y-1); ctx.lineTo(T.x+12,T.y+1); ctx.stroke();
        var r=T.un.res; if (r&&r.tidy>0){ txt('執緊……',r.x,r.y-80,'#e8d8b0',11); } }
      if (T.k==='mess'){ for (var i=0;i<10;i++){ var px=T.x-34+((i*29)%68), py=T.y-3-(i%2)*2; ctx.save(); ctx.translate(px,py); ctx.rotate(i*0.7); ctx.fillStyle=i%2?'#e8e2d0':'#9cc89c'; ctx.fillRect(-4,-2.5,8,5); ctx.restore(); }
        ctx.fillStyle='#4a3424'; ctx.save(); ctx.translate(T.x+24,T.y-8); ctx.rotate(0.5); ctx.fillRect(-10,-5,20,10); ctx.restore(); if (T.t<4) txt('乒乒乓乓',T.x,T.y-84-Math.sin(G.t*14)*2,'#ffb0b0',11); }
      if (T.k==='hair'){ var top=fy(T.f+1)+16; ctx.strokeStyle=T.used?'rgba(30,30,36,0.5)':'rgba(20,22,28,0.92)'; ctx.lineWidth=1.4; for (var i=0;i<8;i++){ var hx=T.x-14+i*1.6+(i>3?24:0); ctx.beginPath(); ctx.moveTo(hx,top+4); ctx.quadraticCurveTo(hx+Math.sin(G.t*2+i)*4,top+30,hx+Math.sin(G.t*1.5+i)*3,top+44+i%3*8); ctx.stroke(); }
        if (!T.used){ ctx.fillStyle='rgba(159,224,255,0.7)'; ctx.beginPath(); ctx.arc(T.x-10,top+50+((G.t*40)%24),1.6,0,7); ctx.fill(); } }
      ctx.globalAlpha=1; });
    G.units.forEach(function(u){ if (!u.beans||!u.open) return; var cx=(u.rx[0]+u.rx[1])/2+18, y=u.y-3; for (var i=0;i<16;i++){ ctx.fillStyle=u.beansDone?'#5a7a3a':'#7ac04a'; ctx.beginPath(); ctx.arc(cx-16+((i*13)%32),y-(i%3)*1.4,1.7,0,7); ctx.fill(); }
      ctx.fillStyle='#d24a3a'; ctx.beginPath(); ctx.arc(cx+20,y-4,4,0,7); ctx.fill(); ctx.fillStyle='#ffd54a'; ctx.fillRect(cx+24,y-8,6,6);
      if (u.seen) txt(u.beansDone?'綠豆（數過）':'綠豆・玩具',cx,y-14,'#b8f0a0',10); });
  }
  // 住戶反應姿勢（畫 sprite 前調整）
  function reactPose(r,P){ var R=r.react; if (!R||r.state!=='home') return; var q=1-R.t/1.7;
    if (R.k==='scream'){ P.sh=Math.sin(G.t*50)*2.4; P.jy=-Math.abs(Math.sin(q*Math.PI*2))*8; }
    if (R.k==='kneel'){ P.sy=0.66; P.jy=2; P.ro=Math.sin(G.t*6)*0.05; }
    if (R.k==='cover'){ P.sy=0.86; P.sh=Math.sin(G.t*30)*1.4; P.hands=true; }
    if (R.k==='fall'){ P.ro=(r.x<WW/2?-1:1)*Math.min(1.35,q*5); P.jy=Math.min(1,q*5)*10; }
    if (R.k==='phone'){ P.phone=true; P.sh=Math.sin(G.t*20)*1; }
    if (R.k==='slipper'){ P.slip=true; P.ro=Math.sin(G.t*16)*0.12; }
    if (R.k==='push'){ P.ro=(r.pushTo||1)*0.3*Math.abs(Math.sin(G.t*10)); P.sh=(r.pushTo||1)*Math.abs(Math.sin(G.t*10))*8; }
    if (r.tidy>0){ P.sy=0.78; P.ro=0.25; }
  }
  function reactProps(r,P){ var R=r.react; if (!R||r.state!=='home') return;
    if (P.hands){ ctx.fillStyle='#e8c0a0'; ctx.beginPath(); ctx.arc(r.x-8,r.y-46,5,0,7); ctx.arc(r.x+8,r.y-46,5,0,7); ctx.fill(); }
    if (P.phone){ ctx.fillStyle='#202428'; ctx.fillRect(r.x+9,r.y-50,6,11); ctx.fillStyle='#9fe0ff'; ctx.fillRect(r.x+10,r.y-49,4,7); for (var i=0;i<2;i++){ ctx.strokeStyle='rgba(159,224,255,'+(0.8-i*0.3)+')'; ctx.lineWidth=1.5; ctx.beginPath(); ctx.arc(r.x+12,r.y-45,9+i*6+((G.t*20)%5),-0.8,0.8); ctx.stroke(); } }
    if (P.slip){ var a=Math.sin(G.t*16)*1.2; ctx.save(); ctx.translate(r.x,r.y-42); ctx.rotate(a); ctx.fillStyle='#3a6ad0'; ctx.fillRect(14,-4,16,7); ctx.restore(); ctx.strokeStyle='rgba(255,255,255,0.5)'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(r.x,r.y-42,26,-1.2,1.2); ctx.stroke(); }
    if (R.k==='scream'){ ctx.strokeStyle='rgba(255,255,255,0.75)'; ctx.lineWidth=2; for (var i=0;i<3;i++){ var an=-2.2+i*0.6; ctx.beginPath(); ctx.moveTo(r.x+Math.cos(an)*24,r.y-46+Math.sin(an)*24); ctx.lineTo(r.x+Math.cos(an)*34,r.y-46+Math.sin(an)*34); ctx.stroke(); var an2=-0.95+i*0.6; ctx.beginPath(); ctx.moveTo(r.x+Math.cos(an2)*24,r.y-46+Math.sin(an2)*24); ctx.lineTo(r.x+Math.cos(an2)*34,r.y-46+Math.sin(an2)*34); ctx.stroke(); } }
  }
  // 鬼嘅讀條道具
  function drawTaskProps(o,by){ if (!(o.taskP>0)) return; var n=G.nodes[o.node]; if (n.kind!=='in') return; var k=o.d.key, d=o.dir, p=o.taskP;
    if (k==='eking'){ var bx=o.x+d*36, byy=o.y-14; drawBowl(bx,byy,1-p); var mx=o.x+d*6, my=by-o.d.h*0.6; ctx.strokeStyle='#5a3a2c'; ctx.lineWidth=3.2; ctx.beginPath(); ctx.moveTo(mx,my); ctx.quadraticCurveTo(o.x+d*30,my-16+Math.sin(G.t*6)*3,bx,byy-6); ctx.stroke(); ctx.strokeStyle='#8a5a44'; ctx.lineWidth=1.4; ctx.stroke();
      var q=(G.t*2.2)%1, qx=bx+(mx-bx)*q, qy=(byy-6)+(my-byy+6)*q-Math.sin(q*Math.PI)*14; ctx.fillStyle='#f0e6c8'; ctx.beginPath(); ctx.arc(qx,qy,3.2,0,7); ctx.fill(); }
    if (k==='toyol'){ var dx=o.x+d*30, dy=o.y-34, out=6+Math.abs(Math.sin(G.t*7))*8; ctx.fillStyle='#4a3424'; ctx.fillRect(dx-16,dy-10,32,26); ctx.fillStyle='#6a4a30'; ctx.fillRect(dx-14+d*out,dy-6,28,10); ctx.fillStyle='#c8a050'; ctx.fillRect(dx-2+d*out,dy-2,4,2); }
    if (k==='tianhua'){ var mx=o.x+d*34, my=o.y-62; ctx.fillStyle='#c8a050'; ctx.fillRect(mx-13,my-20,26,40); ctx.fillStyle='#1a2a30'; ctx.fillRect(mx-10,my-17,20,34); ctx.save(); ctx.beginPath(); ctx.rect(mx-10,my-17,20,34); ctx.clip(); spr('tianhua',mx,my+20,40,{flip:d>0,alpha:Math.min(0.9,p*2.6)}); ctx.restore(); ctx.fillStyle='rgba(220,245,255,0.25)'; ctx.fillRect(mx-10,my-17,5,34);
      var cy=by-o.d.h*0.8+((G.t*40)%(o.d.h*0.5)); ctx.fillStyle='#d8b878'; ctx.fillRect(o.x-d*10-5,cy,10,3); }
  }


  // ===================== 大樓生成（參考離冥殺機 rooms＋pathPoints：每層一排單位，多條垂直路線）=====================
  // 樓層 0 = 地庫（陰門）、1 = 地下、…、FL = 天台（陰門）。背景用原本兩張樓景圖逐格剪貼重砌（唔重畫）。
  var BLD={
    flat:{name:'組屋', skin:'flatbg', FH:184, ROOF:150, camW:400,
      levels:['地庫','地下','一樓','二樓','三樓','四樓','五樓','六樓','七樓','八樓','九樓','十樓','天台'],
      cols:[['stair',112],['u',180],['u',180],['u',180],['u',180],['lift',124],['u',180],['u',180],['u',180],['u',180],['back',112]],
      src:{ stair:[0,78,261,405], lift:[516,600,261,405], back:[0,78,261,405,1], gstair:[0,78,711,873], glift:[520,600,711,873], roof:[0,600,0,117],
        res:[[78,240,117,261],[240,378,117,261],[378,516,117,261],[78,240,261,405],[240,378,261,405],[378,516,261,405],[78,240,405,549],[240,378,405,549],[378,516,405,549],[78,240,549,711],[240,378,549,711],[378,516,549,711]],
        deity:[[78,240,117,261]], ground:[[78,240,711,873],[240,405,711,873],[405,520,711,873]] },
      ground:['信箱大堂','士多','管理處','茶餐廳','單車房','垃圾房','藥房','洗衣舖'], base:['停車場','機房','水錶房','貨倉','雜物房','停車場','冷氣機房','電錶房'],
      pipes:[[2,4,3],[4,7,6],[1,3,0],[5,7,2],[7,10,5],[9,12,1],[8,11,7]],                  // [由層,到層,喺第幾格單位右邊]：外牆雨水喉（得鬼爬得）
      lift:true },
    shop:{name:'老店屋', skin:'shopbg', FH:194, ROOF:140, camW:500,
      levels:['地庫','地下','一樓','二樓','三樓','四樓','五樓','六樓','七樓','八樓','天台'],
      cols:[['stair',124],['u',236],['u',236],['u',236],['lift',116],['u',236],['u',236],['back',96]],
      src:{ stair:[0,100,262,420], lift:[0,100,420,585,1], back:[530,600,262,420], gstair:[0,100,585,812], glift:[0,100,585,812,1], roof:[0,600,0,74],
        res:[[100,320,262,420],[320,530,262,420],[100,320,420,585],[320,530,420,585],[100,320,74,262]],
        deity:[[320,530,74,262]], ground:[[100,320,585,812],[320,530,585,812]] },
      ground:['茶餐室','中藥舖','車衣舖','五金舖','涼茶舖'], base:['貨倉','雜物房','米倉','舊工場','冷房'],
      pipes:[[1,3,2],[3,6,4],[2,5,0],[5,8,1],[7,10,3]],
      lift:false }
  };
  // 住戶種類（唔准有細路仔做嚇人對象）：sp 原圖、awake 子丑寅醒唔醒、props 可附身嘅嘢、items 屋入面搜到乜
  var HH={
    gamer:{n:'打機青年', sp:['res_gamer'], awake:[1,1,1], brave:0.25, props:['pc','fridge'], items:['food','food'], idle:['再打多鋪先瞓','隊友又送頭……','聽日唔使返工，打通宵！']},
    nurse:{n:'夜班護士', sp:['npc_mis'], awake:[1,0,0], leave:0.55, props:['phone','kettle'], items:['money','comb'], idle:['今晚又返通宵','飲杯熱水先出門']},
    elder:{n:'獨居伯伯', sp:['res_uncle'], awake:[0,0,1], leave:2.35, props:['radio','ancestor'], items:['comb','food'], idle:['唉，又瞓唔著','聽朝早啲去飲茶']},
    granny:{n:'婆婆', sp:['res_granny'], awake:[0,0,1], props:['radio','fan'], items:['food','comb'], idle:['個仔又冇打電話嚟……','風扇開細啲先']},
    couple:{n:'新婚夫婦', sp:['npc_ken','npc_mis'], awake:[1,0,0], props:['tv','fridge'], items:['food','comb'], idle:['睇埋呢集先瞓','聽日去邊度食早餐？']},
    mahjong:{n:'麻雀腳', sp:['res_mjaunty','npc_boss','npc_ken','npc_mis'], awake:[1,1,1], props:['mahjong','fan'], items:['money','money','food'], noisy:1, idle:['碰！','食糊！自摸！','到你出牌喇','今晚手氣真係差']},
    shopper:{n:'網購狂', sp:['res_shopper'], awake:[1,1,0], props:['doorbell','tv'], items:['money','comb'], idle:['又有速遞到？','買多件先，平呀嘛']},
    taxi:{n:'夜更的士佬', sp:['npc_ken'], awake:[1,1,1], away:1.35, props:['fridge','tv'], items:['food','money'], idle:['收工喇，攰到死','今晚載咗個好奇怪嘅客……']},
    cook:{n:'宵夜佬', sp:['npc_ken_sit'], awake:[1,1,0], props:['rice','fridge'], items:['food','food'], idle:['煮個公仔麵先','加隻蛋！']},
    insomnia:{n:'失眠阿叔', sp:['npc_boss'], awake:[1,1,1], brave:0.4, props:['radio','fan'], items:['money'], idle:['我喺呢度住咗四十年，咩未見過','收音機陪我瞓']},
    helper:{n:'家務姐姐', sp:['res_helper'], awake:[1,1,0], props:['washer','fridge'], items:['food','comb'], idle:['仲有一籃衫未熨……','聽朝一早要陪婆婆睇醫生','洗埋呢籃先瞓']},
    ot:{n:'加班族', sp:['res_ot'], awake:[1,1,0], away:0.75, props:['pc','tv'], items:['food','food'], idle:['又OT到咁夜……','食完個外賣就瞓','老細仲WhatsApp我？']},
    gym:{n:'健身仔', sp:['res_gym'], awake:[1,1,1], brave:0.5, props:['radio','fan'], items:['food'], idle:['再做多十下！','練完先食宵夜','今晚練胸']},
    debt:{n:'欠債人家', sp:['npc_ken','npc_auntie'], awake:[1,1,0], props:['phone','tv'], items:['food'], idle:['唔好出聲，佢哋又嚟……','下個月一定還到']}
  };
  var HHW=[['gamer',3],['nurse',2],['elder',2],['granny',2],['couple',3],['mahjong',1],['shopper',2],['taxi',1],['cook',2],['insomnia',1],['helper',1],['ot',2],['gym',1]];
  var PROP={
    tv:{n:'電視',v:'附身電視',lv:1,f:24}, fan:{n:'風扇',v:'附身風扇',lv:1,f:18}, fridge:{n:'雪櫃',v:'附身雪櫃',lv:1,f:22}, pc:{n:'電腦',v:'附身電腦',lv:1,f:26},
    radio:{n:'收音機',v:'開收音機',lv:2,f:20}, phone:{n:'電話',v:'整響電話',lv:2,f:22}, mahjong:{n:'麻雀枱',v:'自動洗牌',lv:2,f:30}, doorbell:{n:'門鐘',v:'撳門鐘',lv:2,f:20},
    kettle:{n:'水煲',v:'自己煲水',lv:1,f:16}, washer:{n:'洗衣機',v:'洗衣機自己轉',lv:2,f:20}, rice:{n:'電飯煲',v:'電飯煲跳掣',lv:1,f:16}, ancestor:{n:'祖先牌位',v:null}
  };
  var PROPLINE={tv:['部電視做咩自己開咗？！','雪花……入面好似有個人影'], fan:['風扇自己轉到咁大力？！','窗簾吹到飛晒起……'], fridge:['雪櫃門自己開咗！','點解咁凍……'], pc:['電腦彈咗張鬼臉出嚟！','我隻角色自己行開咗？！'],
    radio:['收音機自己播粵曲……','邊個開咗收音機？'], phone:['三點幾有人打嚟……冇聲嘅','喂？喂？邊位呀？'], mahjong:['啲牌自己洗緊！','邊個郁咗我啲牌？！'], doorbell:['叮噹——門口冇人㗎喎','又係速遞？咁夜？'],
    kettle:['水煲自己嗚嗚叫……','我冇煲水㗎喎'], washer:['洗衣機自己開咗？！','入面啲衫……好似有隻手'], rice:['電飯煲自己跳掣？','啲飯冇咗一半！']};

  function genLevel(k){
    var B=BLD[k], R=rnd; var NL=B.levels.length, FLn=NL-1, FH=B.FH;
    var W=0; B.cols.forEach(function(c){ W+=c[1]; });
    var H=30+FLn*FH+B.ROOF+40;
    var ys=[]; for (var f=0;f<=FLn;f++) ys.push(H-30-f*FH);
    var xs=[], x=0; B.cols.forEach(function(c){ xs.push([x,x+c[1],c[0]]); x+=c[1]; });
    var colX=function(kind){ var c=xs.find(function(q){return q[2]===kind;}); return c?(c[0]+c[1])/2:null; };
    var ucols=xs.filter(function(q){return q[2]==='u';});
    var LVg={camW:B.camW, name:B.name, key:k, bg:null, B:B, FL:FLn, FYS:ys, WW:W, WH:H, SX:colX('stair'), LX:colX('back'), GLX:colX('lift'), MX:colX('lift'), PX0:ucols[0][0]+30, fln:B.levels, xs:xs, ucols:ucols, units:[], pipes:B.pipes, lift:B.lift};
    // 單位表：[層,戶,鎮宅,任務,住戶種類,故事序號,名,門x,範圍]
    var storyF=[], si=0;
    for (var f=0;f<FLn;f++){
      var wardsF={}, nU=ucols.length;
      if (f>=2){ var idx=shuffle(ucols.map(function(_,i){return i;})); wardsF[idx[0]]=pick(['fu','menshen','datuk']); wardsF[idx[1]]='zha'; wardsF[idx[2]]='nuomi'; if (f%2===0) wardsF[idx[3]]=pick(['zha','nuomi']); if (nU>=8&&f%3===1) wardsF[idx[4]]='zha'; }
      if (f===1){ wardsF[2]='datuk'; wardsF[5]='zha'; }
      if (f===0){ wardsF[1]='zha'; }
      ucols.forEach(function(c,u){
        var w=wardsF[u]||null, deity=w==='fu'||w==='menshen'||w==='datuk', nm, hh=null, task=null;
        if (f===0){ nm=B.base[u%B.base.length]; hh=null; }
        else if (f===1){ nm=B.ground[u%B.ground.length]; hh=(u===0||deity)?null:(R()<0.5?pick(['insomnia','cook','gamer']):null); }
        else { hh=deity?null:(R()<0.96?wpick(HHW):null); nm=hh?HH[hh].n:'空置單位'; }
        var doorX=Math.round(c[0]+(c[1]-c[0])*(u%2?0.24:0.78));
        LVg.units.push([f,u,w,null,hh,-1,nm,doorX,[c[0],c[1]]]);
      });
    }
    // 欠債人家：揀一戶改做（支線：嚇走收數佬）
    var cands=LVg.units.filter(function(L){ return L[4]&&L[0]>=3&&!L[2]; }); if (cands.length){ var d=pick(cands); d[4]='debt'; d[6]=HH.debt.n; }
    // 故事戶：每層（地下起）揀一戶有人住嘅（唔係神明戶）
    var STN=LV0[k].story.length;
    for (var f=1;f<FLn&&si<STN;f++){ var c=shuffle(LVg.units.filter(function(L){return L[0]===f&&L[4]&&!L[2];}))[0]; if (c){ c[5]=si++; } }
    while (si<STN){ var c2=shuffle(LVg.units.filter(function(L){return L[4]&&L[5]<0&&!L[2];}))[0]; if (!c2) break; c2[5]=si++; }
    return LVg;
  }
  function wpick(a){ var t=0; a.forEach(function(p){t+=p[1];}); var r=rnd()*t; for (var i=0;i<a.length;i++){ r-=a[i][1]; if (r<=0) return a[i][0]; } return a[0][0]; }

  // 地圖節點：每層走廊一條橫線；樓梯（左）、後樓梯（右）、𨋢／中間樓梯、外牆水喉（得鬼過）
  function buildMap2(){
    var B=LV.B;
    for (var f=0;f<=FL;f++){
      var y=fy(f), stops=[];
      node('f'+f+'_s',SX,y,f,'stair');
      if (f>=1||!B.lift) node('f'+f+'_b',LX,y,f,'stair');
      node('f'+f+'_l',LV.MX,y,f,B.lift?'lift':'stair');
      if (f<FL){ LV.units.filter(function(L){return L[0]===f;}).forEach(function(L){ stops.push({x:L[7],u:L[1]}); });
        if (f===0) stops.push({x:LV.PX0,p:1});
        LV.pipes.forEach(function(P,i){ if (P[0]===f||P[1]===f){ var c=LV.ucols[P[2]]; stops.push({x:c[1]-6,pipe:i}); } });
      } else { stops.push({x:Math.round(WW*0.5)+40,p:2}); LV.pipes.forEach(function(P,i){ if (P[1]===f){ var c=LV.ucols[P[2]]; stops.push({x:c[1]-6,pipe:i}); } }); }
      stops.push({x:LV.MX,lift:1}); if (G.nodes['f'+f+'_b']) stops.push({x:LX,back:1});
      stops.sort(function(a,b){return a.x-b.x;});
      var prev='f'+f+'_s', first=true;
      stops.forEach(function(st){ var id;
        if (st.p===1){ id='f0_e'; node(id,st.x,y,0,'portal'); }
        else if (st.p===2){ id='f'+FL+'_p'; node(id,st.x,y,f,'portal'); }
        else if (st.lift){ id='f'+f+'_l'; }
        else if (st.back){ id='f'+f+'_b'; }
        else if (st.pipe!=null){ id='f'+f+'_q'+st.pipe; node(id,st.x,y,f,'pipe'); }
        else { id='f'+f+'_d'+st.u; node(id,st.x,y,f,'door'); node('f'+f+'_i'+st.u,st.x-14,y-34,f,'in'); var e=link(id,'f'+f+'_i'+st.u); e.door=true; }
        var le=link(prev,id); if (first){ le.fire={shut:0,cd:0,x:(G.nodes[prev].x+G.nodes[id].x)/2,f:f}; first=false; } prev=id; });
      if (prev==='f'+f+'_b'){ var lastE=G.nodes[prev].links[G.nodes[prev].links.length-1].e; lastE.fire={shut:0,cd:0,x:(G.nodes[lastE.a].x+G.nodes[lastE.b].x)/2,f:f}; }
      if (f>0){ link('f'+(f-1)+'_s','f'+f+'_s').vert=true; var le2=link('f'+(f-1)+'_l','f'+f+'_l'); le2.vert=true; if (B.lift) le2.lift=true;
        if (G.nodes['f'+(f-1)+'_b']&&G.nodes['f'+f+'_b']) link('f'+(f-1)+'_b','f'+f+'_b').vert=true; }
    }
    LV.pipes.forEach(function(P,i){ var e=link('f'+P[0]+'_q'+i,'f'+P[1]+'_q'+i); e.vert=true; e.pipe=true; });
  }
  // 住戶、物件、支線
  function placeUnits2(){
    G.traces=[];
    LV.units.forEach(function(L){ var f=L[0],u=L[1],w=L[2], hh=L[4]?HH[L[4]]:null;
      var id='f'+f+'_i'+u, did='f'+f+'_d'+u, e=G.nodes[did].links.find(function(l){return l.to===id;}).e; e.ward=w;
      var un={f:f,u:u,id:id,did:did,ward:w,task:null,story:L[5]>=0,si:L[5],name:L[6],x:G.nodes[did].x,y:fy(f),rx:L[8],lit:false,litT:0,hh:L[4],
        open:true,ot:0,cost:0,paid:0,seen:false,entered:false,plus:L[5]>=0?2:1,items:[],door:false,doorOpen:0,ambush:null,dep:null,keyNeed:null,rs:[],props:[]};
      if (w==='fu'||w==='menshen'||w==='datuk'){ un.open=false; un.ot='deity'; }
      else if (w==='zha'){ un.open=false; un.ot=2; un.cost=4+f; }
      else if (w==='nuomi'){ un.open=false; un.ot=2; un.cost=3+f; }
      if (hh) hh.items.forEach(function(it){ un.items.push(it); });
      else if (f===1&&un.ot!=='deity') un.items.push(pick(['food','money','comb']));
      if (hh && un.ot!=='deity'){ var n=hh.sp.length, w0=un.rx[1]-un.rx[0];
        hh.sp.forEach(function(sp,i){ var hw0=(n>=3?(i%2?60:66):74)*0.47+4; var px=un.rx[0]+w0*(n===1?0.42:n>=3?0.18+0.64*i/(n-1):0.28+0.44*i/(n-1)); if (n<3&&Math.abs(px-un.x)<22) px+=(px<un.x?-24:24); px=Math.max(un.rx[0]+hw0,Math.min(un.rx[1]-hw0,px));
          var r={h:n>=3?(i%2?60:66):74, dy:n>=3&&i%2?-8:0, unit:un,sprite:sp,x:px,y:fy(f)-16,fear:0,brave:hh.brave||0,state:'home',vx:0,doorT:8+rnd()*10,hh:L[4],awake:hh.awake[0]===1,idleT:4+rnd()*10};
          if (hh.away){ r.state='away'; } G.res.push(r); un.rs.push(r); });
        un.res=un.rs[0];
        hh.props.forEach(function(p,i){ un.props.push({k:p,x:un.rx[0]+w0*(0.3+0.4*i)+(i?8:-8),t:0,cd:0}); }); }
      G.units.push(un); e.unit=un;
    });
    // 開門方式：故事戶多數係黑屋（隔籬戶亂咗先開）；最高兩層各有一戶要鎖匙
    G.units.forEach(function(u){ if (u.ot!==0||u.f<2) return; var nb=G.units.filter(function(v){return v.f===u.f&&v!==u&&v.rs.length&&v.ot!=='deity'&&Math.abs(v.u-u.u)===1;})[0];
      if (nb&&(u.story||rnd()<0.22)){ u.open=false; u.ot=1; u.dep=nb; } });
    var keyNames=['key','key2'], tops=G.units.filter(function(u){return u.ot===0&&u.f>=FL-3&&u.rs.length;}).sort(function(a,b){return b.f-a.f;});
    var keyUnits=[]; keyNames.forEach(function(kn,i){ var t=tops[i*2]; if (t){ t.open=false; t.ot=11; t.keyNeed=kn; keyUnits.push(t); } });
    var cand=G.units.filter(function(u){return u.ot!=='deity'&&keyUnits.indexOf(u)<0;});
    keyNames.forEach(function(kn,i){ if (!keyUnits[i]) return; var c=shuffle(cand.filter(function(u){return u.f<keyUnits[i].f-1;}))[0]; if (c) c.items.push(kn); });
    var dolls=0; shuffle(cand).forEach(function(u){ if (dolls<12){ u.items.push('doll'); dolls++; } });
    // 門：幾戶夜晚閂門，住客出入先開
    shuffle(G.units.filter(function(u){return u.rs.length&&u.ot===0&&u.f>=2;})).slice(0,6).forEach(function(u){ u.door=true; });
    // 黑屋伏擊：兩戶冇人嘅屋有隻醒住嘅看門狗
    shuffle(G.units.filter(function(u){return !u.rs.length&&u.ot!=='deity'&&u.f>=1;})).slice(0,3).forEach(function(u){ u.ambush='dog'; });
    G.units.forEach(function(u){ u.seen=(u.ot===0||u.ot==='deity')&&!u.ambush&&u.f<=1; if (u.ot===0&&!u.ambush&&u.f>1&&rnd()<0.5) u.seen=true; });
    // 走廊機關：每層一條可以敲嘅水管、一盞會閃嘅燈
    G.cprops=[];
    for (var f=1;f<FL;f++){ var ds=shuffle(G.units.filter(function(u){return u.f===f;})); if (ds[0]) G.cprops.push({k:'pipeK',node:ds[0].did,f:f,t:0,cd:0}); if (ds[1]) G.cprops.push({k:'light',node:ds[1].did,f:f,t:0,cd:0}); }
    // 支線
    G.quests=[];
    var olds=G.units.filter(function(u){return (u.hh==='elder'||u.hh==='granny')&&u.f>=2&&u.open;}); if (!olds.length) olds=G.units.filter(function(u){return (u.hh==='elder'||u.hh==='granny');});
    if (olds.length){ var ow=pick(olds), thing=pick(['老花鏡','假牙','結婚戒指','錢罌']), hid=shuffle(cand.filter(function(u){return u!==ow&&Math.abs(u.f-ow.f)>=2;}))[0];
      if (hid){ hid.items.unshift('lost'); G.quests.push({id:'lost',t:'搵返'+FLN[ow.f]+LV0K.who(ow)+'嘅'+thing,thing:thing,owner:ow,hid:hid,state:0}); ow.questMark=1; } }
    var dbt=G.units.find(function(u){return u.hh==='debt';}); if (dbt) G.quests.push({id:'debt',t:'嚇走'+FLN[dbt.f]+'拍門嘅收數佬',unit:dbt,state:0,at:30+rnd()*25});
    var mj=G.units.find(function(u){return u.hh==='mahjong';}); if (mj) G.quests.push({id:'mj',t:'散咗'+FLN[mj.f]+'嘅麻雀局（四個都嚇走）',unit:mj,state:0});
    G.relief=[]; G.alertAcc=0;
  }
  var LV0K={who:function(u){ return u.hh==='elder'?'伯伯':'婆婆'; }};

  // ---------- 背景：逐格剪貼原圖重砌 ----------
  function bake2(){
    var SC=Math.min(1.4,Math.sqrt(6.5e6/(WW*WH))), B=LV.B; staticCv=document.createElement('canvas'); staticCv.width=Math.round(WW*SC); staticCv.height=Math.round(WH*SC); var c=staticCv.getContext('2d'); c.scale(SC,SC);
    var img=IMG[B.skin], k=img&&img.width?img.width/600:1;
    var sky=c.createLinearGradient(0,0,0,WH); sky.addColorStop(0,'#0b0d16'); sky.addColorStop(0.5,'#141622'); sky.addColorStop(1,'#0c0c10'); c.fillStyle=sky; c.fillRect(0,0,WW,WH);
    for (var i=0;i<60;i++){ c.fillStyle='rgba(230,230,255,'+(0.2+((i*37)%10)/20)+')'; c.fillRect((i*197)%WW,(i*61)%Math.max(40,fy(FL)-60),1.5,1.5); }
    function put(r,dx,dy,dw,dh,flip,dark){ if (!img||!img.width) { c.fillStyle='#222'; c.fillRect(dx,dy,dw,dh); return; } c.save(); if (flip||r[4]){ c.translate(dx+dw,dy); c.scale(-1,1); dx=0; dy=0; } c.drawImage(img,r[0]*k,r[2]*k,(r[1]-r[0])*k,(r[3]-r[2])*k,dx,dy,dw,dh); c.restore();
      if (dark){ c.fillStyle=dark; c.fillRect(flip||r[4]?dx:dx,dy,dw,dh); } }
    // ===== v8：新剖面格（twt_*）。回傳 false＝冇圖，行返舊砌法 =====
    function bakeTiles(){
      function TI(k){ var im=IMG['twt_'+k]||(typeof SPR!=='undefined'?SPR['twt_'+k]:null); return im&&(im.naturalWidth||im.width)?im:null; }
      var T={}, ok=true; ['corr1','corr2','stairR','stairL','lift','roof','lobby','carpark'].forEach(function(k){ T[k]=TI(k); if (!T[k]) ok=false; }); if (!ok) return false;
      var N=416, FLY={corr1:400,corr2:400,stairR:398,stairL:398,lift:403,roof:402,lobby:405,carpark:405};   // 每格地台前緣喺原圖第幾行（對準 fy(f)+3）
      var KK=LV.key==='shop'?2:1, SHOP=LV.key==='shop', BT='rgba(10,20,40,0.34)';
      function hs(a,b,d){ var h=Math.imul(a+1,73856093)^Math.imul(b+7,19349663)^Math.imul(d+3,83492791); h=Math.imul(h^(h>>>13),1274126177); return (h^(h>>>16))>>>0; }   // 固定 seed：每次開局都一樣
      // 將格圖 [sx0,sx1]×[sy0,底] 貼去 [x0,x0+w]；sy0 行對 top、FLY 行對 floor
      function tile(k,sx0,sx1,sy0,x0,w,top,floor,flip,tint){ var im=T[k], q=(im.naturalWidth||im.width)/N, s=(floor-top)/(FLY[k]-sy0), h=(N-sy0)*s;
        c.save(); if (flip){ c.translate(x0+w,0); c.scale(-1,1); c.drawImage(im,sx0*q,sy0*q,(sx1-sx0)*q,(N-sy0)*q,0,top,w,h); } else c.drawImage(im,sx0*q,sy0*q,(sx1-sx0)*q,(N-sy0)*q,x0,top,w,h); c.restore();
        if (tint){ c.fillStyle=tint; c.fillRect(x0,top,w,h); } }
      var RM={mahjong:'room_mahjong',gamer:'room_gamer',nurse:'room_nurse',helper:'room_helper',gym:'room_gym',shopper:'room_shopper'};
      var resPool=B.src.res, gPool=B.src.ground, ui=0;
      for (var f=0;f<FL;f++){ var top=fy(f+1), floor=fy(f)+3, bot=fy(f)+12, hgt=bot-top, c2prev=false;
        LV.xs.forEach(function(col,ci){ var x0=col[0], w=col[1]-col[0], kd=col[2], h0=hs(KK,f,ci), tn=f===0?BT:null;
          // 樓梯：兩邊樓梯都係向大樓內側行上（上到上一層就係走廊）；老店屋中間樓梯逐層調頭（之字形）
          if (kd==='stair'||kd==='back'||(kd==='lift'&&!LV.lift)){
            if (kd==='back'&&f===0&&!G.nodes['f0_b']){ tile('carpark',296,N,0,x0,w,top,floor,false,'rgba(10,20,40,0.16)'); return; }   // 組屋後樓梯唔落地庫：補停車場柱位
            var up=kd==='stair'?'R':kd==='back'?'L':(f%2?'L':'R');
            if (up==='R') tile('stairR',62,N,0,x0,w,top,floor,false,tn); else tile('stairL',0,354,0,x0,w,top,floor,false,tn); return; }
          if (kd==='lift'){ tile('lift',58,360,f===FL-1?0:46,x0,w,top,floor,false,tn); return; }   // 頂層先見到滑輪；𨋢門／轎廂由 core/lift.js 疊喺上面
          var un=G.units.find(function(q){return q.f===f&&q.rx[0]===x0;}), deity=un&&un.ot==='deity', rk=un&&!deity&&f>=1?RM[un.hh]:null, ri=rk&&IMG[rk];
          if (f===0){ tile('carpark',0,N,0,x0,w,top,floor,(h0>>>5)&1,'rgba(10,20,40,0.16)'); c2prev=false; return; }
          if (ri&&ri.width){ c.save(); if ((ci+f)%2===1){ c.translate(x0+w,top); c.scale(-1,1); c.drawImage(ri,0,0,w,hgt); } else c.drawImage(ri,x0,top,w,hgt); c.restore(); c.strokeStyle='rgba(0,0,0,0.6)'; c.lineWidth=3; c.strokeRect(x0+1,top+1,w-2,hgt-2); c2prev=false; return; }
          if (SHOP){ var r=deity?B.src.deity[0]:f===1?gPool[(ci+f)%gPool.length]:resPool[(ui++*5+f)%resPool.length]; put(r,x0,top,w,hgt,(ci+f)%2===1,null); return; }   // 老店屋：保留舊店屋圖
          if (f===1){ tile('lobby',0,N,0,x0,w,top,floor,ci%2===1,null); return; }   // 組屋地下：一格格 void deck
          // 組屋住宅層：走廊格（corr1 有門有閘、corr2 晾衫位），corr2 唔會連續兩格；corr1 鐵閘對準門口
          var two=!deity&&!c2prev&&(h0%100)<40; c2prev=two;
          if (two) tile('corr2',0,N,0,x0,w,top,floor,(h0>>>7)&1,null);
          else { tile('corr1',0,N,0,x0,w,top,floor,un?un.u%2===0:((h0>>>7)&1),null);
            if (deity){ c.fillStyle='rgba(110,8,8,0.20)'; c.fillRect(x0,top,w,floor-top); var dx=un.x;   // 神明戶：鐵閘貼滿紅紙
              for (var p=0;p<7;p++){ var px=dx-15+((h0>>>(p*3))&7)*4.3, py=fy(f)-92+((h0>>>(p*2+5))&7)*9+p*3; c.save(); c.translate(px,py); c.rotate((((h0>>>(p+9))&7)-3.5)*0.05); c.fillStyle=p%3?'#9e1e1a':'#c0281f'; c.fillRect(-4.5,-10,9,20); c.fillStyle='rgba(30,0,0,0.35)'; c.fillRect(2.5,-10,2,20); c.fillStyle='rgba(240,200,90,0.6)'; c.fillRect(-2,-6,4,1.4); c.fillRect(-2,-1,4,1.4); c.fillRect(-2,4,4,1.4); c.restore(); } } }
        }); }
      // 天台：天台格同佢左邊（天線＋機房）輪流排，每段左邊漸變疊上一段，冇硬接縫
      var rs=(fy(FL)+3+8)/FLY.roof, rh=N*rs, rtop=fy(FL)+3-FLY.roof*rs, x=0, i=0, F=30, im=T.roof, q=(im.naturalWidth||im.width)/N;
      while (x<WW){ var A=i%2===1, sx1=A?196:N, w=sx1*rs, flip=A?((hs(KK,99,i)>>>3)&1):((i>>1)%2===1);
        var oc=document.createElement('canvas'); oc.width=Math.max(1,Math.ceil(w*SC)); oc.height=Math.max(1,Math.ceil(rh*SC)); var ox=oc.getContext('2d');
        if (flip){ ox.translate(oc.width,0); ox.scale(-1,1); } ox.drawImage(im,0,0,sx1*q,N*q,0,0,oc.width,oc.height); ox.setTransform(1,0,0,1,0,0);
        if (i>0){ ox.globalCompositeOperation='destination-in'; var gr=ox.createLinearGradient(0,0,F*SC,0); gr.addColorStop(0,'rgba(0,0,0,0)'); gr.addColorStop(1,'rgba(0,0,0,1)'); ox.fillStyle=gr; ox.fillRect(0,0,oc.width,oc.height); }
        c.drawImage(oc,x,rtop,w,rh); x+=w-F; i++; }
      // 遮縫：每格之間一條柱影、每塊樓板底一層天花陰影、兩邊外牆暗角
      for (var f=0;f<FL;f++){ var top=fy(f+1), floor=fy(f)+10;
        LV.xs.forEach(function(col,ci){ if (!ci) return; var xb=col[0], g=c.createLinearGradient(xb-8,0,xb+8,0); g.addColorStop(0,'rgba(0,0,0,0)'); g.addColorStop(0.5,'rgba(0,0,0,0.58)'); g.addColorStop(1,'rgba(0,0,0,0)'); c.fillStyle=g; c.fillRect(xb-8,top,16,floor-top); }); }
      for (var f=0;f<=FL;f++){ var yb=fy(f)+3, g=c.createLinearGradient(0,yb,0,yb+26); g.addColorStop(0,'rgba(0,0,0,0)'); g.addColorStop(0.28,'rgba(0,0,0,0.5)'); g.addColorStop(1,'rgba(0,0,0,0)'); if (f>0){ c.fillStyle=g; c.fillRect(0,yb,WW,26); } }
      [[0,1],[WW,-1]].forEach(function(e){ var g=c.createLinearGradient(e[0],0,e[0]+e[1]*28,0); g.addColorStop(0,'rgba(0,0,0,0.55)'); g.addColorStop(1,'rgba(0,0,0,0)'); c.fillStyle=g; c.fillRect(e[1]>0?0:WW-28,0,28,WH); });
      return true; }
    window.TW8={bakeURL:function(){ return staticCv?staticCv.toDataURL('image/png'):null; }, camTo:function(x,y){ cam.free=x==null?null:{x:x,y:y}; }};   // 測試用
    if (!bakeTiles()){
    var resPool=B.src.res, gPool=B.src.ground, ui=0;
    for (var f=0;f<FL;f++){ var top=fy(f+1), bot=fy(f)+12, hgt=bot-top, dark=f===0?'rgba(10,20,40,0.45)':null;
      LV.xs.forEach(function(col,ci){ var x0=col[0], w=col[1]-col[0];
        if (col[2]==='stair') put(f<=1?B.src.gstair:B.src.stair,x0,top,w,hgt,false,dark);
        else if (col[2]==='lift') put(f<=1?B.src.glift:B.src.lift,x0,top,w,hgt,false,dark);
        else if (col[2]==='back') put(B.src.back,x0,top,w,hgt,!B.src.back[4]&&LV.key==='flat',dark);
        else { var un=G.units.find(function(q){return q.f===f&&q.rx[0]===x0;}), r;
          var RM={mahjong:'room_mahjong',gamer:'room_gamer',nurse:'room_nurse',helper:'room_helper',gym:'room_gym',shopper:'room_shopper'};
          var rk=un&&un.ot!=='deity'?(f===0?'room_carpark':(f===1&&un.u===0)?'room_lobby':RM[un.hh]):null, ri=rk&&IMG[rk];
          if (ri&&ri.width){ c.save(); if ((ci+f)%2===1){ c.translate(x0+w,top); c.scale(-1,1); c.drawImage(ri,0,0,w,hgt); } else c.drawImage(ri,x0,top,w,hgt); c.restore(); if (dark){ c.fillStyle='rgba(10,20,40,0.25)'; c.fillRect(x0,top,w,hgt); } c.strokeStyle='rgba(0,0,0,0.6)'; c.lineWidth=3; c.strokeRect(x0+1,top+1,w-2,hgt-2); }
          else { if (un&&un.ot==='deity') r=B.src.deity[0]; else if (f<=1) r=gPool[(ci+f)%gPool.length]; else r=resPool[(ui++*5+f)%resPool.length];
            put(r,x0,top,w,hgt,(ci+f)%2===1,dark); } }
      });
      c.fillStyle='rgba(0,0,0,0.55)'; c.fillRect(0,bot-4,WW,6); }
    // 天台：重複原圖天台
    var rt=B.src.roof, rh=(rt[3]-rt[2]), rw=(rt[1]-rt[0]); for (var x=0;x<WW;x+=rw){ put(rt,x,fy(FL)-rh,rw,rh+8,(x/rw)%2===1); }
    // 地庫：水喉、停車格
    c.strokeStyle='rgba(120,140,150,0.5)'; c.lineWidth=4; c.beginPath(); c.moveTo(0,fy(1)+30); c.lineTo(WW,fy(1)+30); c.stroke();
    c.fillStyle='rgba(220,220,160,0.25)'; for (var x=120;x<WW-100;x+=110) c.fillRect(x,fy(0)-4,60,3);
    }
    // 外牆雨水喉（鬼先爬得）
    LV.pipes.forEach(function(P){ var px=LV.ucols[P[2]][1]-6; c.strokeStyle='#5a6a68'; c.lineWidth=5; c.beginPath(); c.moveTo(px,fy(P[1])-110); c.lineTo(px,fy(P[0])); c.stroke(); c.strokeStyle='#8a9a96'; c.lineWidth=1.5; c.stroke();
      for (var y=fy(P[1])-100;y<fy(P[0]);y+=40){ c.fillStyle='#3a4442'; c.fillRect(px-5,y,10,4); } });
    // 樓層名
    c.font='bold 13px '+FONT; c.textAlign='left'; for (var f=0;f<=FL;f++){ c.lineWidth=3; c.strokeStyle='#000'; c.strokeText(FLN[f],6,fy(f)-LV.B.FH+44+(f===FL?60:0)); c.fillStyle='#e8d8b0'; c.fillText(FLN[f],6,fy(f)-LV.B.FH+44+(f===FL?60:0)); }
  }

  // ---------- 住戶作息、連鎖反應 ----------
  function resUpdate2(dt){
    var ph=Math.min(2,G.phase), tt=G.t/PHT;
    G.res.forEach(function(r){ var hh=HH[r.hh]; if (!hh) return;
      if (r.state==='home'){ var want=hh.awake[ph]===1; if (want&&!r.awake){ r.awake=true; say(r,pick(['又醒咗……','咩鐘數呀而家？'])); } if (!want&&r.awake&&!r.woke&&r.fear<20&&rnd()<dt*0.05){ r.awake=false; }
        r.idleT-=dt; if (r.idleT<=0){ r.idleT=10+rnd()*14; if (r.awake&&!r.say) say(r,pick(hh.idle)); }
        if (hh.leave && !r.left && tt>=hh.leave){ r.left=true; r.state='leave'; r.awake=true; say(r,r.hh==='nurse'?'返工喇，出門口先':'去晨運先'); r.unit.doorOpen=4; r.vx=-70; } }
      if (r.state==='away' && hh.away && tt>=hh.away){ r.state='back'; r.x=SX; r.y=fy(r.unit.f)-16; r.vx=70; r.awake=true; say(r,'收工返屋企喇……'); }
      if (r.state==='leave'){ r.x+=r.vx*dt; if (r.x<=SX){ r.state='gone'; } }
      if (r.state==='back'){ var tx=r.unit.rx[0]+30; r.x+=Math.sign(tx-r.x)*70*dt; if (Math.abs(tx-r.x)<4){ r.state='home'; r.unit.doorOpen=3; } }
    });
    G.units.forEach(function(u){ if (!u.rs) return; u.res=u.rs.find(function(r){return r.state==='home';})||u.rs[0]||null; u.props.forEach(function(p){ p.t=Math.max(0,p.t-dt); p.cd=Math.max(0,p.cd-dt); }); });
    (G.cprops||[]).forEach(function(p){ p.t=Math.max(0,p.t-dt); p.cd=Math.max(0,p.cd-dt); });
    G.edges.forEach(function(e){ if (e.fire){ e.fire.shut=Math.max(0,e.fire.shut-dt); e.fire.cd=Math.max(0,e.fire.cd-dt); } });
    G.lureCd=Math.max(0,(G.lureCd||0)-dt);
    questUpdate(dt); reliefUpdate(dt);
  }
  function chain(un,amt,depth){
    if ((depth||0)>1) return; var hit=0;
    G.units.forEach(function(v){ if (v===un||!v.rs.length||v.ot==='deity') return; var adj=(v.f===un.f&&Math.abs(v.u-un.u)===1)||(Math.abs(v.f-un.f)===1&&v.rx[0]<un.rx[1]&&v.rx[1]>un.rx[0]); if (!adj) return;
      v.rs.forEach(function(r){ if (r.state!=='home') return; r.awake=true; r.woke=true; r.fear+=amt; r.jumpT=0.4; hit++; if (rnd()<0.5) say(r,pick(['隔籬做咩嗌成咁？','樓上咩聲呀？！','咩事咩事？！'])); if (r.fear>=100&&!(r.fleeAfter>0)){ r.fleeAfter=1.2; r.chainD=(depth||0)+1; } }); });
    if (hit){ float(un.x,un.y-120,'連鎖！隔籬 '+hit+' 個醒晒','#ffb7a0'); addFear(Math.min(12,hit*2),un.x,un.y-140); }
  }
  // ---------- 引開保安（響聲）----------
  function noise(nodeId,lvl,why){
    var n=G.nodes[nodeId]; if (!n) return; G.noiseFx=G.noiseFx||[]; G.noiseFx.push({x:n.x,y:n.y-40,t:1.2,lvl:lvl});
    G.guards.forEach(function(h){ if (h.kind!=='guard'||h.state==='chase'||h.state==='scared'||h.state==='shift'||h.state==='flee'||h.state==='gone') return;
      var p=dijkstra(h,h.node,nodeId); if (!p) return; var d=0, a=G.nodes[h.node]; p.forEach(function(id){ var b=G.nodes[id]; d+=Math.abs(a.x-b.x)+Math.abs(a.y-b.y); a=b; });
      if (d>700*lvl||!inZone(h,n.f,1)) return;
      if (h.state==='puzzle' && h.invNode===nodeId){ spook(h,'同一個位又有怪聲！'); return; }
      h.state='inv'; h.invNode=nodeId; h.path=p; h.to=null; h.wait=0; h.alertT=0.8; h.say=pick(['咩聲嚟㗎？過去睇睇','邊度傳嚟嘅？','又係'+FLN[n.f]+'？']); h.sayT=2.2; });
  }
  function spook(h,txt0){
    if (h.state==='shift'||h.state==='gone') return;
    h.nerve=(h.nerve==null?3:h.nerve)-1; h.state='scared'; h.scT=2.6; h.to=null; h.path=null; var gS=null, dS=1e9; G.gh.forEach(function(g){ if (g.home||g.out) return; var d=Math.abs(g.x-h.x)+Math.abs(g.y-h.y)*3; if (d<dS){ dS=d; gS=g; } }); h.scAway=gS&&dS<400?(h.x>=gS.x?1:-1):(rnd()<0.5?-1:1); h.vx=h.scAway*55; h.dir=-h.scAway; h.shockT=0.9; h.say=uniq([txt0])||uniq(SPOOKL); h.sayT=2; h.alertT=0.6;
    addFear(6,h.x,h.y-90); float(h.x,h.y-110,'保安嚇親！','#ffd54a');
    if (rnd()<0.3){ G.alert+=1; checkAlert(); float(h.x,h.y-130,'對講機：「管理處！'+FLN[G.nodes[h.node].f]+'有怪事！」警覺 +1','#ffb0b0'); }
    if (h.nerve<=0){ h.state='shift'; h.say='唔做喇！交更！'; h.sayT=2.5; float(h.x,h.y-130,'保安頂唔順，落樓交更','#9fd6bf'); G.relief.push({t:26,zone:h.zone}); h.path=dijkstra(h,h.node,'f1_s'); }
  }
  function reliefUpdate(dt){ (G.relief||[]).forEach(function(r){ r.t-=dt; if (r.t<=0&&!r.done){ r.done=true; var zn=r.zone||[1,3]; var h=mkHuman('guard','f'+zn[0]+'_s'); h.zone=zn; h.nerve=3; G.guards.push(h); float(h.x,h.y-80,'新一更保安上班','#ffb0b0'); } }); G.relief=(G.relief||[]).filter(function(r){return !r.done;}); }
  function lureCost(){ G.alertAcc=(G.alertAcc||0)+0.34; if (G.alertAcc>=1){ G.alertAcc-=1; G.alert+=1; checkAlert(); } }
  // 而家企喺度可以做咩（顯示喺「互動」掣）
  function ctxAction(g){
    if (!g||g.to||g.home||g.out) return null; var n=G.nodes[g.node];
    if (n.kind==='in'){ var un=unitOf(n.id);
      var q=(G.quests||[]).find(function(q){return q.id==='lost'&&q.state===1&&q.owner===un;}); if (q) return {k:'deliver',t:'交還'+q.thing,q:q};
      var p=un.props.find(function(p){return PROP[p.k].v&&p.cd<=0;}); if (p) return {k:'prop',t:PROP[p.k].v,p:p,un:un};
      var anc=un.props.find(function(p){return p.k==='ancestor';}); if (anc) return {k:'respect',t:'（祖先牌位：唔好郁）'};
      return null; }
    var cp=(G.cprops||[]).find(function(p){return p.node===n.id&&p.cd<=0;}); if (cp) return {k:'cprop',t:cp.k==='pipeK'?'敲水管':'整閃走廊燈',p:cp};
    if (UNIT){ var ua=UNIT.action(g,n); if (ua) return ua; }   // UNIT HOOK 4：門口「入屋」
    if (LIFT){ var la=LIFT.action(g,n); if (la) return la; }   // LIFT HOOK 2：𨋢口出「入𨋢」
    if (n.kind==='lift'&&LV.lift&&(G.liftCd||0)<=0) return {k:'lift',t:'叫𨋢自己上落'};
    if (n.kind==='pipe') return {k:'pipeN',t:'敲雨水喉（另一層都聽到）'};
    if (n.id.slice(-2)==='_s'||n.id.slice(-2)==='_b'){ var fe=n.links.map(function(l){return l.e;}).find(function(e){return e.fire;}); if (fe&&fe.fire.cd<=0&&fe.fire.shut<=0) return {k:'fire',t:'閂防煙門（保安要兜路）',e:fe}; }
    return null;
  }
  function actPress(){
    var g=G.gh[G.active], a=ctxAction(g); if (!a) return;
    standStill(g); if (g.to){ float(g.x,g.y-80,'行到位先做得','#ffd54a'); return; } calm(g);
    if (a.k==='liftIn'){ LIFT.enter(g); return; }
    if (UNIT&&UNIT.act(g,a)) return;   // UNIT HOOK 5   // LIFT HOOK 3：入𨋢／叫𨋢
    if (a.k==='respect'){ float(g.x,g.y-90,'祖先牌位要尊重，我哋唔郁','#e8d8b0'); return; }
    if (a.k==='deliver'){ var q=a.q; q.state=2; G.carry=null; var ow=q.owner.res; if (ow){ say(ow,'咦？我副'+q.thing+'點解會喺張枱度嘅？多謝晒……'); ow.fear=0; }
      addFear(25,g.x,g.y-90); G.gh.forEach(function(x){ x.energy=Math.min(100,x.energy+30); }); float(g.x,g.y-120,'支線完成：'+q.t,'#8affc8'); giveStory(); toast('支線完成！'+q.t+'——怕意 +25、三隻鬼能量 +30。'); return; }
    if (a.k==='prop'){ var p=a.p, un=a.un, P=PROP[p.k]; if (G.lureCd>0) return; p.t=3; p.cd=18; G.lureCd=1.5; g.actT=0.9; g.dir=p.x>g.x?1:-1;
      un.rs.forEach(function(r){ if (r.state!=='home') return; if (!r.awake){ r.awake=true; r.woke=true; r.fear+=P.f*0.6*G.mods.pow*(1-r.brave); r.jumpT=0.5; say(r,pick(['咩聲呀……邊個？','發開夢？'])); }
        else { scareRes(r,P.f,g); if (rnd()<0.6) say(r,pick(PROPLINE[p.k])); } });
      if (p.k==='mahjong'){ for (var q2=0;q2<10;q2++) part(p.x,un.y-40,(rnd()-0.5)*90,-60-rnd()*40,0.8,'paper'); }
      float(p.x,un.y-96,P.v+'！','#ffb7a0'); noise(un.did,P.lv,P.n); lureCost(); g.energy=Math.min(100,g.energy+8); return; }
    if (a.k==='cprop'){ var cp=a.p; cp.t=3; cp.cd=20; lureCost(); var nn=G.nodes[cp.node];
      if (cp.k==='pipeK'){ float(nn.x,nn.y-90,'噹！噹！噹！','#ffd54a'); noise(cp.node,2); }
      else { float(nn.x,nn.y-90,'走廊燈閃閃吓……','#ffd54a'); G.guards.forEach(function(h){ if (h.kind==='guard'&&G.nodes[h.node].f===nn.f&&Math.abs(h.x-nn.x)<260&&h.state!=='chase') spook(h,'盞燈……盞燈做咩閃成咁？！'); }); noise(cp.node,1); }
      return; }
    if (a.k==='lift'){ G.liftCd=16; lureCost(); var fs=[]; for (var f=0;f<FL;f++) if (Math.abs(f-G.nodes[g.node].f)>=2) fs.push(f); var tf=pick(fs.length?fs:[0]); var ln='f'+tf+'_l';
      G.liftFx={f:tf,t:2.5}; float(g.x,g.y-90,'部𨋢自己落咗去'+FLN[tf]+'……','#ffd54a'); noise(ln,3); return; }
    if (a.k==='pipeN'){ if (G.lureCd>0) return; G.lureCd=6; lureCost(); var e=G.nodes[g.node].links.map(function(l){return l.e;}).find(function(e){return e.pipe;}); var other=e.a===g.node?e.b:e.a;
      float(g.x,g.y-90,'噹……（'+FLN[G.nodes[other].f]+'都聽到）','#ffd54a'); noise(other,2); return; }
    if (a.k==='fire'){ var fe=a.e; fe.fire.shut=14; fe.fire.cd=26; float(g.x,g.y-90,'防煙門閂咗！保安要兜路','#9fd6bf'); G.guards.forEach(function(h){ h.path=null; h.repath=0; }); return; }
  }
  function giveStory(){ for (var i=0;i<STORY.length;i++) if (G.story.indexOf(i)<0){ G.story.push(i); G.story.sort(); toast('收集到故事碎片——'+STORY[i]); return; } }
  // ---------- 支線 ----------
  function questUpdate(dt){
    (G.quests||[]).forEach(function(q){
      if (q.id==='debt'){ if (q.state===0 && G.t>=q.at){ q.state=1; var h=mkHuman('collector',q.unit.did,{courage:3,real:true}); h.wait=1e9; G.guards.push(h); q.h=h; toast(FLN[q.unit.f]+'有個收數佬拍門大嗌，屋企人嚇到唔敢出聲……嚇走佢！'); }
        if (q.state===1){ var h=q.h; h.bangT=(h.bangT||0)-dt; if (h.bangT<=0&&h.state!=='flee'){ h.bangT=3.2; h.say=pick(['開門呀！還錢呀！','我知你喺入面！','唔還錢就淋紅油！']); h.sayT=2.4; G.shake=Math.max(G.shake,0.12); q.unit.rs.forEach(function(r){ if (r.state==='home'){ r.fear=Math.min(90,r.fear+4); } }); }
          if (h.state==='flee'||h.state==='gone'){ q.state=2; q.unit.items.push('money','money'); q.unit.rs.forEach(function(r){ if (r.state==='home'){ r.fear=0; say(r,'佢……佢走咗？好似有人幫緊我哋……'); } }); addFear(30,q.unit.x,q.unit.y-100); float(q.unit.x,q.unit.y-130,'支線完成：'+q.t,'#8affc8'); giveStory(); toast('收數佬嚇到碌落樓梯！佢跌低咗個銀包喺門口。'); } } }
      if (q.id==='mj' && q.state===0 && q.unit.rs.every(function(r){return r.state!=='home';})){ q.state=2; addFear(20,q.unit.x,q.unit.y-100); q.unit.items.push('money'); float(q.unit.x,q.unit.y-130,'支線完成：'+q.t,'#8affc8'); giveStory(); }
      if (q.id==='lost' && q.state===0 && G.carry==='lost') q.state=1;
    });
  }

  // ---------- 畫：單位物件、走廊機關、防煙門、細地圖 ----------
  function drawProps2(){
    G.units.forEach(function(u){ if (!u.seen&&!u.entered) return; u.props.forEach(function(p){ var x=p.x, y=u.y-4, a=p.t>0, T=G.t;
      if (p.k==='tv'){ ctx.fillStyle='#1a1a1e'; ctx.fillRect(x-14,y-40,28,20); ctx.fillStyle=a?'rgba(220,230,240,'+(0.5+0.5*Math.random())+')':'#2a3440'; ctx.fillRect(x-12,y-38,24,16); if (a){ ctx.fillStyle='rgba(20,20,20,0.7)'; ctx.beginPath(); ctx.arc(x,y-30,5,0,7); ctx.fill(); } ctx.fillStyle='#4a3424'; ctx.fillRect(x-10,y-20,20,16); }
      else if (p.k==='fan'){ ctx.strokeStyle='#bbb'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(x,y); ctx.lineTo(x,y-30); ctx.stroke(); ctx.save(); ctx.translate(x,y-34); ctx.rotate(T*(a?40:6)); for (var i=0;i<3;i++){ ctx.rotate(2.094); ctx.fillStyle='rgba(200,210,220,0.8)'; ctx.fillRect(0,-2,9,4); } ctx.restore(); ctx.strokeStyle='#888'; ctx.beginPath(); ctx.arc(x,y-34,10,0,7); ctx.stroke(); }
      else if (p.k==='fridge'){ ctx.fillStyle='#7d8786'; ctx.fillRect(x-9,y-40,18,38); ctx.fillStyle='rgba(255,255,255,0.12)'; ctx.fillRect(x-9,y-40,5,38); ctx.strokeStyle='#2a2e2e'; ctx.lineWidth=1.5; ctx.strokeRect(x-9,y-40,18,38); ctx.beginPath(); ctx.moveTo(x-9,y-26); ctx.lineTo(x+9,y-26); ctx.stroke(); ctx.fillStyle='#c8c8c0'; ctx.fillRect(x+5,y-36,2,7); if (a){ var o=Math.abs(Math.sin(T*9))*16; ctx.fillStyle='#b8c0c0'; ctx.fillRect(x+10,y-46,o,30); ctx.fillStyle='rgba(200,240,255,0.5)'; ctx.fillRect(x-8,y-44,16,26); } }
      else if (p.k==='pc'){ ctx.fillStyle='#202428'; ctx.fillRect(x-13,y-38,26,18); ctx.fillStyle=a?(Math.floor(T*8)%2?'#e8e8e8':'#d02020'):'#3a6ad0'; ctx.fillRect(x-11,y-36,22,14); if (a){ ctx.fillStyle='#000'; ctx.fillRect(x-5,y-32,3,3); ctx.fillRect(x+2,y-32,3,3); ctx.fillRect(x-4,y-26,8,2); } ctx.fillStyle='#4a3424'; ctx.fillRect(x-16,y-20,32,4); }
      else if (p.k==='radio'){ ctx.fillStyle='#8a5a3a'; ctx.fillRect(x-10,y-26,20,12); ctx.fillStyle='#ffd54a'; ctx.fillRect(x+3,y-23,4,4); if (a){ ctx.fillStyle='#ffe9a0'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.fillText('♪',x-8+Math.sin(T*5)*6,y-34-((T*30)%14)); ctx.fillText('♫',x+8,y-30-((T*30+7)%14)); } }
      else if (p.k==='phone'){ ctx.fillStyle='#202428'; ctx.fillRect(x-4,y-22,8,12); if (a){ ctx.strokeStyle='rgba(159,224,255,0.8)'; ctx.lineWidth=1.5; for (var i=0;i<2;i++){ ctx.beginPath(); ctx.arc(x,y-16,7+i*5+((T*20)%5),-0.8,0.8); ctx.stroke(); } } }
      else if (p.k==='mahjong'){ ctx.fillStyle='#2a6a3a'; ctx.fillRect(x-22,y-24,44,6); ctx.fillStyle='#4a3424'; ctx.fillRect(x-20,y-18,4,14); ctx.fillRect(x+16,y-18,4,14); for (var i=0;i<8;i++){ ctx.fillStyle='#f0ead8'; ctx.fillRect(x-18+i*4.6,y-28-(a?Math.abs(Math.sin(T*14+i))*6:0),3.6,4); } }
      else if (p.k==='doorbell'){ ctx.fillStyle='#c8a050'; ctx.beginPath(); ctx.arc(u.x+16,y-52,3,0,7); ctx.fill(); ctx.fillStyle='#a07040'; for (var i=0;i<3;i++) ctx.fillRect(x-14+i*9,y-10-(i%2)*8,10,8); if (a){ ctx.fillStyle='#ffd54a'; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.fillText('叮噹',u.x+16,y-60); } }
      else if (p.k==='washer'){ ctx.fillStyle='#e8e8e2'; ctx.fillRect(x-12,y-30,24,28); ctx.strokeStyle='#777'; ctx.lineWidth=1; ctx.strokeRect(x-12,y-30,24,28); ctx.save(); ctx.translate(x,y-15); ctx.rotate(a?T*20:0); ctx.fillStyle='#6a8aa8'; ctx.beginPath(); ctx.arc(0,0,8,0,7); ctx.fill(); ctx.fillStyle='#e8e2d0'; ctx.fillRect(-2,-7,4,6); ctx.restore(); }
      else if (p.k==='kettle'||p.k==='rice'){ ctx.fillStyle=p.k==='kettle'?'#b8bcc0':'#e8e2d0'; ctx.beginPath(); ctx.ellipse(x,y-26,8,7,0,0,7); ctx.fill(); if (a){ for (var i=0;i<2;i++){ ctx.fillStyle='rgba(230,230,230,0.5)'; ctx.beginPath(); ctx.arc(x+(i?6:-2),y-36-((T*30+i*8)%16),3,0,7); ctx.fill(); } } }
      else if (p.k==='ancestor'){ ctx.fillStyle='#6a1a16'; ctx.fillRect(x-9,y-56,18,22); ctx.fillStyle='#ffd54a'; ctx.fillRect(x-6,y-53,12,3); ctx.globalAlpha=0.35+0.15*Math.sin(T*3); ctx.fillStyle='#ff8a5a'; ctx.beginPath(); ctx.arc(x,y-30,4,0,7); ctx.fill(); ctx.globalAlpha=1; }
      if (a&&p.k!=='ancestor'){ ctx.strokeStyle='rgba(138,255,200,'+(0.4*p.t/3)+')'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(x,y-28,22+(3-p.t)*10,0,7); ctx.stroke(); } }); });
    // 走廊機關
    (G.cprops||[]).forEach(function(p){ var n=G.nodes[p.node], x=n.x+22, y=n.y; if (p.k==='pipeK'){ ctx.strokeStyle='#7a8a86'; ctx.lineWidth=3; ctx.beginPath(); ctx.moveTo(x,y-110); ctx.lineTo(x,y-6); ctx.stroke(); if (p.t>0){ ctx.strokeStyle='rgba(255,213,74,'+(p.t/3)+')'; for (var i=0;i<3;i++){ ctx.beginPath(); ctx.arc(x,y-60,8+i*7+(3-p.t)*6,0,7); ctx.stroke(); } } }
      else { var on=p.t>0?(Math.floor(G.t*12)%2):1; ctx.fillStyle=on?'rgba(255,240,180,0.9)':'#333'; ctx.fillRect(n.x-10,y-118,20,4); if (on){ var gr=ctx.createRadialGradient(n.x,y-114,2,n.x,y-114,40); gr.addColorStop(0,'rgba(255,240,180,0.25)'); gr.addColorStop(1,'rgba(255,240,180,0)'); ctx.fillStyle=gr; ctx.fillRect(n.x-40,y-150,80,80); } } });
    // 防煙門
    G.edges.forEach(function(e){ if (!e.fire) return; var x=e.fire.x, y=fy(e.fire.f); if (e.fire.shut>0){ ctx.fillStyle='#6a1e1a'; ctx.fillRect(x-6,y-70,12,66); ctx.strokeStyle='#ffd54a'; ctx.lineWidth=1.5; ctx.strokeRect(x-6,y-70,12,66); ctx.fillStyle='#e8e2d0'; ctx.font='9px '+FONT; ctx.textAlign='center'; ctx.fillText(Math.ceil(e.fire.shut),x,y-74); } else { ctx.strokeStyle='rgba(160,60,50,0.5)'; ctx.lineWidth=1; ctx.strokeRect(x-6,y-70,12,66); } });
    // 𨋢 自己落咗去某層
    if (G.liftFx&&G.liftFx.t>0){ var ln=G.nodes['f'+G.liftFx.f+'_l']; G.liftFx.t-=0.033; ctx.fillStyle='rgba(255,230,140,'+(0.5+0.4*Math.sin(G.t*20))+')'; ctx.fillRect(ln.x-14,ln.y-80,28,74); ctx.fillStyle='#000'; ctx.font='bold 14px '+FONT; ctx.textAlign='center'; ctx.fillText('叮！',ln.x,ln.y-86); }
    (G.noiseFx||[]).forEach(function(z){ z.t-=0.033; ctx.strokeStyle='rgba(255,213,74,'+Math.max(0,z.t)+')'; ctx.lineWidth=2; for (var i=0;i<z.lvl;i++){ ctx.beginPath(); ctx.arc(z.x,z.y,(1.2-z.t)*90+i*16,0,7); ctx.stroke(); } }); G.noiseFx=(G.noiseFx||[]).filter(function(z){return z.t>0;});
    // 支線標記
    (G.quests||[]).forEach(function(q){ if (q.id==='lost'&&q.state<2){ var u=q.owner; if (u.seen||u.entered){ txt(q.state===1?'交還'+q.thing:'？',(u.rx[0]+u.rx[1])/2,u.y-112,'#8affc8',13); } if (q.state===0&&(q.hid.seen||q.hid.entered)) txt('✦'+q.thing,(q.hid.rx[0]+q.hid.rx[1])/2,q.hid.y-100,'#8affc8',11); } });
  }
  function miniJump(){ var b=buttons.find(function(q){return q.id==='mini';}); if (!b||!LASTP) return; var wx=(LASTP.x-b.x)/b.w*WW, wy=(LASTP.y-b.y)/b.h*WH; cam.free={x:clamp(wx,0,WW),y:clamp(wy,0,WH)}; }
  function drawMini(){
    var mw=74, mh=Math.min(110,Math.round(74*WH/WW)), mx=10, my=TOP+60, sx=mw/WW, sy=mh/WH; buttons.push({id:'mini',x:mx,y:my,w:mw,h:mh});
    crPanel(ctx,mx-5,my-5,mw+10,mh+10,'ink');
    G.units.forEach(function(u){ var top=fy(u.f+1)+16; ctx.fillStyle=u.ot==='deity'?'#5a2420':!u.open?'#2a2430':(u.seen||u.entered)?'#3a4632':'#1c1820'; ctx.fillRect(mx+u.rx[0]*sx+0.5,my+top*sy,(u.rx[1]-u.rx[0])*sx-1,(u.y-top)*sy); });
    ctx.fillStyle='#8aac6c'; ['f0_e','f'+FL+'_p'].forEach(function(id){ var n=G.nodes[id]; ctx.fillRect(mx+n.x*sx-2,my+n.y*sy-3,4,3); });
    G.guards.forEach(function(h){ if (h.state==='gone') return; ctx.fillStyle=h.kind==='collector'?'#d87e3c':h.state==='chase'?'#e0483a':'#b8786a'; ctx.fillRect(mx+h.x*sx-1.5,my+h.y*sy-3,3,3); });
    G.gh.forEach(function(g,i){ if (g.home||g.out) return; ctx.fillStyle=i===G.active?'#efe5cf':'#9c88cc'; ctx.beginPath(); ctx.arc(mx+g.x*sx,my+g.y*sy-2,i===G.active?3:2,0,7); ctx.fill(); });
    var S=cam.s*cam.z; ctx.strokeStyle='rgba(216,204,176,0.6)'; ctx.lineWidth=1.2; ctx.strokeRect(mx+cam.x*sx,my+cam.y*sy,(VW/S)*sx,((VH-TOP-BOT)/S)*sy);
  }

  // ---------- 畫面 ----------
  var cam={x:0,y:0,s:1,z:1,free:null}, staticCv=null, LASTP=null;
  function resize(){ VW=Math.min(window.innerWidth,520); VH=window.innerHeight; cv.style.width=VW+'px'; cv.style.height=VH+'px'; cv.width=Math.round(VW*DPR); cv.height=Math.round(VH*DPR); cam.s=VW/((LV&&LV.camW)||600); BOTX=VW/WW; }
  function crayon(c2,x,y,w,h,col,dens){ c2.fillStyle=col; c2.fillRect(x,y,w,h); c2.save(); c2.beginPath(); c2.rect(x,y,w,h); c2.clip(); c2.globalAlpha=0.16; c2.strokeStyle='#000'; c2.lineWidth=1;
    var n=Math.floor(w*h/(dens||140)); for (var i=0;i<n;i++){ var px=x+Math.random()*w, py=y+Math.random()*h, L=4+Math.random()*9; c2.beginPath(); c2.moveTo(px,py); c2.lineTo(px+L,py-L*0.35); c2.stroke(); }
    c2.globalAlpha=0.10; c2.strokeStyle='#fff'; for (var i=0;i<n/2;i++){ var px=x+Math.random()*w, py=y+Math.random()*h; c2.beginPath(); c2.moveTo(px,py); c2.lineTo(px+5,py-2); c2.stroke(); } c2.restore(); }
  function bake(){ if (LV.B){ bake2(); return; }
    staticCv=document.createElement('canvas'); staticCv.width=WW*2; staticCv.height=WH*2; var c=staticCv.getContext('2d');
    var bgi=IMG[LV.bg]; if (bgi&&bgi.width) c.drawImage(bgi,0,0,WW*2,WH*2); else { c.fillStyle='#1a1a1e'; c.fillRect(0,0,WW*2,WH*2); }
  }
  function W2S(x,y){ var S=cam.s*cam.z; return {x:(x-cam.x)*S, y:(y-cam.y)*S+TOP}; }
  function spr(k,x,y,h,o){ var im=IMG[k]; if(!im||!im.width) return; var w=h*im.width/im.height; o=o||{}; ctx.save(); ctx.globalAlpha=o.alpha==null?1:o.alpha; ctx.translate(x+(o.ox||0),y+(o.oy||0)); if (o.rot) ctx.rotate(o.rot); ctx.scale((o.flip?-1:1)*(o.sx||1),o.sy||1); ctx.drawImage(im,-w/2,-h,w,h); ctx.restore(); }
  function sprite(k,x,y,h,flip,alpha){ var im=IMG[k]; if(!im||!im.width) return; var w=h*im.width/im.height; ctx.globalAlpha=alpha==null?1:alpha;
    if (flip){ ctx.save(); ctx.translate(x,0); ctx.scale(-1,1); ctx.drawImage(im,-w/2,y-h,w,h); ctx.restore(); } else ctx.drawImage(im,x-w/2,y-h,w,h); ctx.globalAlpha=1; }
  function drawWard(e){ var n=G.nodes[e.a].kind==='door'?G.nodes[e.a]:G.nodes[e.b], x=n.x, y=n.y, w=e.ward; if (!w) return;
    if (w==='fu'){ ctx.fillStyle='#d42a2a'; ctx.fillRect(x-6,y-92,12,16); ctx.strokeStyle='#ffd54a'; ctx.lineWidth=1.5; ctx.strokeRect(x-6,y-92,12,16); }
    if (w==='menshen'){ ctx.fillStyle='#b7302a'; ctx.fillRect(x-14,y-70,13,46); ctx.fillRect(x+1,y-70,13,46); ctx.strokeStyle='#ffd54a'; ctx.lineWidth=2; ctx.strokeRect(x-14,y-70,13,46); ctx.strokeRect(x+1,y-70,13,46); ctx.fillStyle='#ffd54a'; ctx.beginPath(); ctx.arc(x-7.5,y-56,4,0,7); ctx.arc(x+7.5,y-56,4,0,7); ctx.fill(); }
    if (w==='zha'){ ctx.fillStyle='#c8ccd8'; ctx.fillRect(x+8,y-44,8,6); ctx.strokeStyle='#2a2030'; ctx.lineWidth=1; ctx.strokeRect(x+8,y-44,8,6); ctx.beginPath(); ctx.arc(x+12,y-46,3,Math.PI,0); ctx.stroke(); }
    if (w==='nuomi'){ ctx.fillStyle='#fffbe8'; for (var k=0;k<20;k++){ ctx.fillRect(x-24+k*2.5,y-6+(k%3)*1.5,2,2); } }
    if (w==='datuk'){ ctx.globalAlpha=0.3+0.15*Math.sin(G.t*3); ctx.fillStyle='#ffcc66'; ctx.beginPath(); ctx.arc(x+22,y-14,14,0,7); ctx.fill(); ctx.globalAlpha=1; ctx.fillStyle='#c4202a'; ctx.fillRect(x+13,y-24,18,20); ctx.strokeStyle='#ffd54a'; ctx.lineWidth=1.5; ctx.strokeRect(x+13,y-24,18,20); ctx.fillStyle='#ffd54a'; ctx.fillRect(x+16,y-20,12,3); }
  }
  function bubble(x,y,t,col){ crBubble(x,y,t,col); }
  function rr(x,y,w,h,r){ ctx.beginPath(); ctx.moveTo(x+r,y); ctx.arcTo(x+w,y,x+w,y+h,r); ctx.arcTo(x+w,y+h,x,y+h,r); ctx.arcTo(x,y+h,x,y,r); ctx.arcTo(x,y,x+w,y,r); ctx.closePath(); }
  var buttons=[];

  // ===================== v7 蠟筆 UI（黑暗系蠟筆）=====================
  // 色盤：暗紅 red、骨白 bone、鏽橙 rust、冷紫 violet、苔綠 moss；ink＝炭黑、paper＝深紫褐紙
  var CR={cache:{}, n:0, M:8, tones:{
    red:   {b:'#2b1012',m:'#7a2522',e:'#c4493c',t:'#f2e3cc',h:'#e07a62'},
    bone:  {b:'#1e1a16',m:'#5c5246',e:'#d8ccb0',t:'#efe5cf',h:'#f4ead2'},
    rust:  {b:'#2a190d',m:'#8c4b1d',e:'#d87e3c',t:'#f6dcb6',h:'#eea060'},
    violet:{b:'#19132a',m:'#4b3b6e',e:'#9c88cc',t:'#e8e0fa',h:'#bfaee8'},
    moss:  {b:'#121a11',m:'#3b5431',e:'#8aac6c',t:'#e4ecd2',h:'#b4d090'},
    ink:   {b:'#18141b',m:'#3c3544',e:'#958a9c',t:'#ebe3d6',h:'#b8aec0'},
    paper: {b:'#141016',m:'#2e2430',e:'#6a5a68',t:'#e9e1d4',h:'#8a7a8c'},
    sheet: {b:'#1a1418',m:'#3a2a34',e:'#cdbf9f',t:'#efe5cf',h:'#e8dcc0'},
    note:  {b:'#d6c9ab',m:'#b3a283',e:'#3a2c28',t:'#2a1e1c',h:'#efe4c8'},
    dawn:  {b:'#1a1418',m:'#3a5230',e:'#d87e3c',t:'#efe5cf',h:'#eea060'}}};
  // 舊亮色 → 主題色（文字用）
  var CRC={'#ffffff':'#efe5cf','#fff3c8':'#efdcb4','#ffd54a':'#e6a85a','#ffcc55':'#e6a85a','#ffe9a0':'#e8d2a0','#ffe9c0':'#efdcb8','#8affc8':'#b2d394','#9fd6bf':'#a9c79a','#9fe0ff':'#a9a0d8',
    '#ff9a9a':'#e48a78','#ffb0b0':'#e48a78','#ffb7a0':'#e8a088','#ff8a5a':'#e0844a','#dddddd':'#ddd2bd','#d8d8d0':'#ddd2bd','#c8ccc4':'#cfc4b0','#ecece6':'#efe5cf','#d6dad2':'#ddd2bd',
    '#e2e6e0':'#efe5cf','#7a7f78':'#9a8e92','#55585a':'#8a7e84','#5a5e58':'#7a6e74','#e8e2d0':'#e6dcc6','#ffd8c8':'#e8c4b0','#ff3a2a':'#d2463a','#d24a3a':'#c4493c'};
  function crCol(c){ if (typeof c!=='string') return c; var k=c.toLowerCase(); if (k==='#fff') k='#ffffff'; return CRC[k]||c; }
  function crRnd(seed){ var s=seed%2147483646+1; return function(){ s=(s*16807)%2147483647; return (s-1)/2147483646; }; }
  function crHash(str){ var h=2166136261; for (var i=0;i<str.length;i++){ h^=str.charCodeAt(i); h=Math.imul(h,16777619); } return (h>>>0)%2147483646+1; }
  // 紙紋噪點（一次生成，repeat）
  function crGrain(){ if (CR.grain) return CR.grain; var c=document.createElement('canvas'); c.width=c.height=128; var x=c.getContext('2d'), r=crRnd(99);
    for (var i=0;i<2600;i++){ var v=r(); x.fillStyle=v<0.55?'rgba(0,0,0,'+(0.10+r()*0.25)+')':'rgba(255,240,220,'+(0.03+r()*0.07)+')'; x.fillRect(r()*128,r()*128,1+r()*1.6,1+r()*1.2); }
    x.strokeStyle='rgba(0,0,0,0.2)'; x.lineWidth=0.7; for (var j=0;j<70;j++){ var px=r()*128, py=r()*128; x.beginPath(); x.moveTo(px,py); x.lineTo(px+4+r()*10,py+(r()-0.5)*3); x.stroke(); } CR.grain=c; return c; }
  function crShape(r,w,h,j,ring){ var P=[];
    if (ring){ var R=w/2, n=Math.max(18,Math.round(R*0.6)); for (var i=0;i<n;i++){ var a=i/n*Math.PI*2; P.push([R+Math.cos(a)*(R+(r()-0.5)*j),R+Math.sin(a)*(R+(r()-0.5)*j)]); } return P; }
    function seg(x0,y0,x1,y1){ var L=Math.hypot(x1-x0,y1-y0), n=Math.max(2,Math.round(L/16)); for (var i=0;i<n;i++){ var t=i/n; P.push([x0+(x1-x0)*t+(r()-0.5)*j, y0+(y1-y0)*t+(r()-0.5)*j]); } }
    seg(0,0,w,0); seg(w,0,w,h); seg(w,h,0,h); seg(0,h,0,0); return P; }
  function crTrace(c,P){ c.beginPath(); c.moveTo(P[0][0],P[0][1]); for (var i=1;i<P.length;i++) c.lineTo(P[i][0],P[i][1]); c.closePath(); }
  // 砌一塊蠟筆底（mode：n 平常、p 按下、off 停用、panel 大紙、bar 槽、fill 進度色、ring 圓）
  function crBuild(w,h,tone,mode){
    var T=CR.tones[tone]||CR.tones.ink, M=CR.M, D=DPR, o=document.createElement('canvas'); o.width=Math.ceil((w+M*2)*D); o.height=Math.ceil((h+M*2)*D);
    var c=o.getContext('2d'); c.scale(D,D); c.translate(M,M);
    var r=crRnd(crHash(w+'x'+h+tone+mode)), pr=mode==='p', off=mode==='off', pan=mode==='panel', bar=mode==='bar'||mode==='fill', ring=mode.indexOf('ring')===0, J=pan?2.4:bar?1:1.7;
    var P=crShape(r,w,h,J,ring);
    if (!pr&&!pan&&!bar){ c.save(); c.translate(2,3); crTrace(c,P); c.fillStyle='rgba(0,0,0,0.55)'; c.fill(); c.restore(); }
    crTrace(c,P);
    if (mode==='fill'&&tone==='dawn'){ var gd=c.createLinearGradient(0,0,w,0); gd.addColorStop(0,'#24361f'); gd.addColorStop(0.62,'#6a2220'); gd.addColorStop(1,'#b8642c'); c.fillStyle=gd; }
    else c.fillStyle=mode==='fill'?T.m:T.b;
    c.fill();
    c.save(); crTrace(c,P); c.clip();
    var g=c.createLinearGradient(0,0,0,h); g.addColorStop(0,'rgba(255,240,220,0.06)'); g.addColorStop(1,'rgba(0,0,0,0.34)'); c.fillStyle=g; c.fillRect(0,0,w,h);
    // 斜線排線
    c.strokeStyle=mode==='fill'?T.h:T.m; c.lineCap='round'; var step=pan?7:bar?3.5:5;
    for (var k=-h-4;k<w+h;k+=step+r()*2){ c.globalAlpha=(pan?0.22:mode==='fill'?0.28:0.36)+r()*0.25; c.lineWidth=0.8+r()*1.4; c.beginPath(); var a0=k+(r()-0.5)*3; c.moveTo(a0,h+2); c.lineTo(a0+h*0.9+(r()-0.5)*4,-2); c.stroke(); }
    // 零碎交叉筆觸
    c.strokeStyle=T.e; var nq=pan?Math.min(260,w*h/900):w/6; for (var q=0;q<nq;q++){ c.globalAlpha=0.05+r()*0.08; c.lineWidth=0.6+r(); var qx=r()*w, qy=r()*h; c.beginPath(); c.moveTo(qx,qy); c.lineTo(qx+6+r()*14,qy-3-r()*5); c.stroke(); }
    c.globalAlpha=1; c.fillStyle=c.createPattern(crGrain(),'repeat'); c.fillRect(-2,-2,w+4,h+4);
    if (!pan&&!bar&&!ring){ c.strokeStyle=T.h; for (var s2=0;s2<3;s2++){ c.globalAlpha=0.08+r()*0.12; c.lineWidth=2+r()*2; c.beginPath(); var yy=3+s2*2.2+r(); c.moveTo(6+r()*6,yy); c.lineTo(w-6-r()*10,yy+(r()-0.5)*2); c.stroke(); } }
    c.restore();
    // 抖動多重描邊
    var passes=pr?4:bar?2:3, jj=pan?2.6:bar?1:2;
    if (mode!=='fill') for (var p=0;p<passes;p++){ var Q=P.map(function(v){ return [v[0]+(r()-0.5)*jj,v[1]+(r()-0.5)*jj]; }); c.globalAlpha=p===0?0.95:0.42+r()*0.3; c.strokeStyle=(p===passes-1&&!bar)?'rgba(0,0,0,0.55)':T.e; c.lineWidth=(pr?3.4:pan?2.1:bar?1.3:2.2)-p*0.35+r()*0.5; c.lineJoin='round'; crTrace(c,Q); c.stroke(); }
    if (!bar&&!ring){ c.fillStyle=T.e; [[0,0],[w,0],[w,h],[0,h]].forEach(function(o2){ c.globalAlpha=0.6; c.beginPath(); c.arc(o2[0]+(r()-0.5)*2,o2[1]+(r()-0.5)*2,1.3+r()*1.2,0,7); c.fill(); }); }
    c.globalAlpha=1;
    if (off){ c.globalCompositeOperation='source-atop'; c.fillStyle='rgba(16,13,18,0.58)'; c.fillRect(-M,-M,w+2*M,h+2*M); c.globalCompositeOperation='source-over'; }
    return o; }
  function crGet(w,h,tone,mode){ w=Math.max(4,Math.round(w)); h=Math.max(4,Math.round(h)); var k=w+'|'+h+'|'+tone+'|'+mode+'|'+DPR, v=CR.cache[k];
    if (!v){ if (CR.n>220){ CR.cache={}; CR.n=0; } v=CR.cache[k]=crBuild(w,h,tone,mode); CR.n++; } return v; }
  function crBlit(c,im,x,y){ var M=CR.M; c.drawImage(im,x-M,y-M,im.width/DPR,im.height/DPR); }
  function crPanel(c,x,y,w,h,tone){ crBlit(c,crGet(w,h,tone||'paper','panel'),x,y); }
  // 字：手寫感陰影（偏移暗影＋暗描邊＋蠟筆重描）
  function crText(c,s,x,y,sz,col,al,mw,mid,wt){ s=String(s); c.save(); c.font=(wt||'bold')+' '+sz+'px '+FONT; c.textAlign=al||'left'; c.textBaseline=mid?'middle':'alphabetic'; c.lineJoin='round';
    var F=function(dx,dy){ if (mw) c.fillText(s,x+dx,y+dy,mw); else c.fillText(s,x+dx,y+dy); };
    c.fillStyle='rgba(6,3,8,0.88)'; F(1.4,2); c.lineWidth=Math.max(2.4,sz*0.2); c.strokeStyle='rgba(8,5,10,0.82)'; if (mw) c.strokeText(s,x,y,mw); else c.strokeText(s,x,y);
    c.fillStyle=crCol(col||'#efe5cf'); F(0,0); c.globalAlpha*=0.35; F(0.6,-0.4); c.restore(); }
  // 用而家 ctx 狀態（font/align/fillStyle）寫字，自動套手寫陰影＋主題色
  function crFill(s,x,y,mw){ var m=/(\d+(?:\.\d+)?)px/.exec(ctx.font), sz=m?+m[1]:13, bold=/bold/.test(ctx.font); crText(ctx,s,x,y,sz,ctx.fillStyle,ctx.textAlign,mw,false,bold?'bold':'normal'); }
  function crBar(c,x,y,w,h,f,tone){ crBlit(c,crGet(w,h,'ink','bar'),x,y); f=Math.max(0,Math.min(1,f||0)); if (f<=0) return; c.save(); c.beginPath(); c.rect(x-2,y-3,w*f+2,h+6); c.clip(); crBlit(c,crGet(w,h,tone||'red','fill'),x,y); c.restore();
    if (f<1){ c.strokeStyle=(CR.tones[tone]||CR.tones.red).e; c.globalAlpha=0.8; c.lineWidth=2; c.beginPath(); c.moveTo(x+w*f,y-1); c.lineTo(x+w*f+1,y+h+1); c.stroke(); c.globalAlpha=1; } }
  function crTone(col){ var k=String(col||'').toLowerCase();
    return ({'#6e1c1c':'red','#5a1c1c':'red','#2a4a7a':'violet','#2f5a4a':'moss','#3a5a2a':'moss','#2e3a34':'moss','#8a5a14':'rust','#3a3a40':'ink','#2c2c33':'ink','#24242a':'ink','#26262c':'ink'})[k]||'ink'; }
  function crBtn(c,x,y,w,h,label,tone,pressed,off){ var dy=pressed?2:0; crBlit(c,crGet(w,h,tone,pressed?'p':off?'off':'n'),x,y+dy);
    if (label) crText(c,label,x+w/2,y+h/2+dy+1,h>=50?17:16,off?'#8a7e84':(CR.tones[tone]||CR.tones.ink).t,'center',w-10,true); }
  function crBubble(x,y,t,col){ ctx.font='bold 12px '+FONT; var w=Math.ceil((Math.min(190,ctx.measureText(t).width+16))/8)*8; crBlit(ctx,crGet(w,22,'note','bar'),x-w/2,y-24);
    ctx.save(); ctx.fillStyle=col||'#2a1e1c'; ctx.textAlign='center'; ctx.fillText(t,x,y-9,w-8); ctx.restore(); }
  function crBg(){ crPanel(ctx,-8,-8,VW+16,VH+16,'paper'); }
  function crPressed(id){ return (ptr&&ptr.btn===id)||(PRESS&&PRESS.id===id&&performance.now()-PRESS.t<200); }
  function btn(id,x,y,w,h,label,col,on){ buttons.push({id:id,x:x,y:y,w:w,h:h}); crBtn(ctx,x,y,w,h,label,crTone(col),crPressed(id),on===false); }
  function draw(){
    ctx.setTransform(DPR,0,0,DPR,0,0); ctx.fillStyle='#0b0b0d'; ctx.fillRect(0,0,VW,VH); buttons=[];
    if (scene==='title'){ drawTitle(); return; }
    var g=G.gh[G.active], S=cam.s*cam.z, viewH=(VH-TOP-BOT)/S, viewW=VW/S, fxc=cam.free?cam.free.x:g.x, fyc=cam.free?cam.free.y:g.y, LB=(!cam.free&&LIFT&&LIFT.band)?LIFT.band():null, ty=LB?fyc-(LB.y1-14-TOP)/S:clamp(fyc-viewH*0.55,0,Math.max(0,WH-viewH+70)), tx=clamp(fxc-viewW/2,0,Math.max(0,WW-viewW)); cam.y+=(ty-cam.y)*0.15; cam.x+=(tx-cam.x)*0.15;
    var shk=G.shake>0?(Math.random()-0.5)*G.shake*16:0; ctx.save(); ctx.translate(shk,TOP); ctx.beginPath(); ctx.rect(0,0,VW,VH-TOP-BOT); ctx.clip(); ctx.scale(S,S); ctx.translate(-cam.x,-cam.y);
    ctx.drawImage(staticCv,0,0,WW,WH);
    G.units.forEach(function(un){ var top=fy(un.f+1)+16; if (un.lit){ ctx.fillStyle='rgba(255,230,140,0.38)'; ctx.fillRect(un.rx[0],top,un.rx[1]-un.rx[0],un.y-top-4); }
      if (un.task&&!un.taskDone){ var col={food:'#ffd54a',money:'#ffe27a',comb:'#e8b0a0'}[un.task]; ctx.strokeStyle=col; ctx.lineWidth=3; ctx.globalAlpha=0.6+0.3*Math.sin(G.t*4); ctx.beginPath(); ctx.ellipse(un.x,un.y-34,16,5,0,0,7); ctx.stroke(); ctx.globalAlpha=1;
        ctx.font='bold 11px '+FONT; ctx.lineWidth=3; ctx.strokeStyle='#0c0c0e'; ctx.textAlign='center'; var lb={food:'宵夜',money:'銀包',comb:'梳頭'}[un.task]; ctx.strokeText(lb,un.x,un.y-44); ctx.fillStyle=col; ctx.fillText(lb,un.x,un.y-44); }
      if (un.story){ var tx=(un.rx[0]+un.rx[1])/2, tt=G.story.indexOf(un.si)>=0?'✦已收集':'✦故事'; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#0c0c0e'; ctx.strokeText(tt,tx,top+14); ctx.fillStyle='#cfe8dc'; ctx.fillText(tt,tx,top+14); } });
    G.edges.forEach(drawWard);
    drawProps2();
    // 回陰間點
    ['f0_e','f'+FL+'_p'].forEach(function(id){ if (G.gate&&G.gate.node!==id) return; var n=G.nodes[id]; ctx.globalAlpha=0.5+0.3*Math.sin(G.t*2.5); ctx.fillStyle='#3fbf8f'; ctx.beginPath(); ctx.ellipse(n.x,n.y-4,26,9,0,0,7); ctx.fill(); ctx.globalAlpha=1; ctx.fillStyle='#e2e6e0'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#0c0c0e'; ctx.strokeText('回陰間',n.x,n.y-14); ctx.fillText('回陰間',n.x,n.y-14); });
    // 燈泡閃 + 冷霧
    for (var f=0;f<FL;f++){ if (fy(f)<cam.y-20||fy(f+1)>cam.y+viewH+40) continue; var ly=fy(f+1)+18, fl=0.55+0.45*Math.sin(G.t*13+f*2.1)*Math.sin(G.t*3.7+f); if ((Math.floor(G.t*7+f*5)%23)===0) fl=0.1; if (G.dark[f]) fl=0;
      G.units.filter(function(u){return u.f===f;}).map(function(u){return (u.rx[0]+u.rx[1])/2;}).forEach(function(lx){ var gr=ctx.createRadialGradient(lx,ly,2,lx,ly,46); gr.addColorStop(0,'rgba(255,214,140,'+(0.32*fl)+')'); gr.addColorStop(1,'rgba(255,214,140,0)'); ctx.fillStyle=gr; ctx.fillRect(lx-46,ly-46,92,92); });
      for (var k=0;k<3;k++){ var fx=((G.t*(10+k*4)+k*200+f*90)%(WW+100))-50; ctx.fillStyle='rgba(180,220,210,0.07)'; ctx.beginPath(); ctx.ellipse(fx,fy(f)-6,70,9,0,0,7); ctx.fill(); }
      if (G.dark[f]){ ctx.fillStyle='rgba(0,0,0,'+Math.min(0.78,G.dark[f]*0.6)+')'; ctx.fillRect(0,fy(f+1)+8,WW,fy(f)-fy(f+1)-6); } }
    G.wardFx.forEach(function(w){ var a=w.t/0.9, gr=ctx.createRadialGradient(w.x,w.y-30,4,w.x,w.y-30,60); gr.addColorStop(0,'rgba(255,220,140,'+(0.7*a)+')'); gr.addColorStop(1,'rgba(255,220,140,0)'); ctx.fillStyle=gr; ctx.fillRect(w.x-60,w.y-90,120,120); ctx.strokeStyle='rgba(255,230,160,'+a+')'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(w.x,w.y-30,30+(1-a)*30,0,7); ctx.stroke(); });
    drawTraces(); drawSafe(); drawDrops();   // PEOPLE HOOK
    G.res.forEach(function(r){ pplDrawRes(r,viewW,viewH); });   // PEOPLE HOOK：住客統一畫法
    if (G.tao){ var T=G.tao, ty=fy(T.f); T.waves.forEach(function(w){ ctx.strokeStyle='rgba(255,215,90,'+(w.t*0.85)+')'; ctx.lineWidth=4; ctx.beginPath(); ctx.ellipse(T.x,ty-30,w.r,w.r*0.45,0,0,7); ctx.stroke(); });
      ctx.fillStyle='rgba(0,0,0,0.45)'; ctx.beginPath(); ctx.ellipse(T.x,ty-1,16,4,0,0,7); ctx.fill();
      ctx.shadowColor='rgba(255,215,90,0.9)'; ctx.shadowBlur=9; spr('npc_boss',T.x,ty,62,{flip:T.dir<0,oy:-Math.abs(Math.sin(G.t*6))*2}); ctx.shadowBlur=0;
      var bx=T.x+T.dir*16, byy=ty-40+Math.sin(G.t*14)*2; ctx.fillStyle='#e8b830'; ctx.beginPath(); ctx.moveTo(bx-6,byy+8); ctx.quadraticCurveTo(bx,byy-10,bx+6,byy+8); ctx.closePath(); ctx.fill(); ctx.strokeStyle='#5a3a10'; ctx.lineWidth=1; ctx.stroke();
      ctx.fillStyle='#ffe9a0'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; ctx.strokeText('天師',T.x,ty-70); ctx.fillText('天師',T.x,ty-70); if (T.sayT>0) bubble(T.x,ty-78,T.say); }
    G.gh.forEach(function(o){ if (o.sealT>0&&!o.home){ ctx.strokeStyle='rgba(255,215,90,0.7)'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(o.x,o.y-o.d.h*0.5,o.d.h*0.55,0,7); ctx.stroke(); } });
    G.guards.forEach(function(s){ var H=HUM[s.kind], HHt=H.spr?PPLFX.hgt(H.spr,H.spr,H.h):H.h; s.alertT=Math.max(0,(s.alertT||0)-0.0);
      if (s.kind==='guard'||s.kind==='compass'){ var sw=s.state==='scared'?Math.sin(G.t*23+s.x)*46+Math.sin(G.t*37)*18:Math.sin(G.t*2.4+s.x*0.01)*14; var bg=ctx.createLinearGradient(s.x,0,s.x+s.dir*150,0); bg.addColorStop(0,'rgba(255,245,180,'+((s.state==='chase'||s.kind==='compass'?0.45:0.3)*(s.state==='scared'?0.4+0.6*Math.abs(Math.sin(G.t*29)):1))+')'); bg.addColorStop(1,'rgba(255,245,180,0)'); ctx.fillStyle=bg; ctx.beginPath(); ctx.moveTo(s.x+s.dir*8,s.y-30); ctx.lineTo(s.x+s.dir*150,s.y-56+sw); ctx.lineTo(s.x+s.dir*150,s.y-4+sw*0.4); ctx.closePath(); ctx.fill(); }
      ctx.fillStyle='rgba(0,0,0,0.45)'; ctx.beginPath(); ctx.ellipse(s.x,s.y-1,16,4,0,0,7); ctx.fill();
      var bob=s.kind==='dog'?-Math.abs(Math.sin(G.t*18+s.x))*5:pplStep(s), fl=s.state==='flee'?s.vx<0:s.dir<0;
      if (s.kind==='dog'){ ctx.save(); ctx.translate(s.x,s.y+bob); ctx.scale(fl?-1:1,1); ctx.fillStyle='#3a2e24'; ctx.strokeStyle='#e8d8b0'; ctx.lineWidth=1.5; ctx.beginPath(); ctx.ellipse(0,-14,20,9,0,0,7); ctx.fill(); ctx.stroke(); ctx.beginPath(); ctx.ellipse(18,-22,9,7,0,0,7); ctx.fill(); ctx.stroke(); ctx.fillStyle='#ff4a3a'; ctx.fillRect(21,-25,3,3); ctx.strokeStyle='#3a2e24'; ctx.lineWidth=3; [-12,-4,6,12].forEach(function(lx,k){ ctx.beginPath(); ctx.moveTo(lx,-8); ctx.lineTo(lx+Math.sin(G.t*20+k)*4,0); ctx.stroke(); }); ctx.beginPath(); ctx.moveTo(-19,-16); ctx.lineTo(-28,-24+Math.sin(G.t*25)*3); ctx.stroke(); ctx.restore(); }
      else { ctx.shadowColor=s.kind==='mirror'||s.kind==='decoy'?'rgba(255,215,90,0.8)':'rgba(255,236,200,0.75)'; ctx.shadowBlur=6; pplGuard(s,H,bob,fl); ctx.shadowBlur=0; }
      if (s.kind==='mirror'){ var mx=s.x+s.dir*14, my=s.y-40; ctx.fillStyle='#d8c070'; ctx.beginPath(); ctx.arc(mx,my,8,0,7); ctx.fill(); ctx.fillStyle='rgba(220,245,255,'+(0.6+0.3*Math.sin(G.t*6))+')'; ctx.beginPath(); ctx.arc(mx,my,5.5,0,7); ctx.fill(); var mg=ctx.createLinearGradient(mx,0,mx+s.dir*220,0); mg.addColorStop(0,'rgba(220,245,255,0.25)'); mg.addColorStop(1,'rgba(220,245,255,0)'); ctx.fillStyle=mg; ctx.beginPath(); ctx.moveTo(mx,my); ctx.lineTo(mx+s.dir*220,my-26); ctx.lineTo(mx+s.dir*220,my+26); ctx.closePath(); ctx.fill(); }
      if (s.kind==='compass'){ ctx.fillStyle='#c8a050'; ctx.beginPath(); ctx.arc(s.x+s.dir*12,s.y-30,6,0,7); ctx.fill(); ctx.strokeStyle='#600'; ctx.lineWidth=1.5; var na=G.t*7; ctx.beginPath(); ctx.moveTo(s.x+s.dir*12,s.y-30); ctx.lineTo(s.x+s.dir*12+Math.cos(na)*5,s.y-30+Math.sin(na)*5); ctx.stroke(); for (var q=0;q<s.courage;q++){ ctx.fillStyle='#ffd54a'; ctx.fillRect(s.x-12+q*5,s.y-HHt-10,4,4); } }
      var lab=H.n; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; ctx.strokeText(lab,s.x,s.y-HHt-14); ctx.fillStyle=s.kind==='guard'?'#e8e4dc':'#ffe9a0'; ctx.fillText(lab,s.x,s.y-HHt-14);
      if (s.alertT>0){ ctx.fillStyle='#ffe25a'; ctx.strokeStyle='#000'; ctx.lineWidth=3; ctx.font='bold 26px '+FONT; ctx.textAlign='center'; var bb=Math.sin(G.t*20)*2; ctx.strokeText('！',s.x,s.y-HHt-24+bb); ctx.fillText('！',s.x,s.y-HHt-24+bb); }
      if (s.say) bubble(s.x,s.y-HHt-30,s.say); });
    // 房間遮罩：未踩點=黑屋；鎖住=鎖頭/注入進度/鎖匙；門閂住=木門
    G.units.forEach(function(u){ var top=fy(u.f+1)+16, w=u.rx[1]-u.rx[0], hgt=u.y-top-4;
      if (!u.seen){ ctx.fillStyle='rgba(2,2,4,'+(u.open?0.82:0.9)+')'; ctx.fillRect(u.rx[0],top,w,hgt); if (u.unlockFx>0){ ctx.strokeStyle='rgba(159,214,191,'+u.unlockFx+')'; ctx.lineWidth=3; ctx.strokeRect(u.rx[0]+2,top+2,w-4,hgt-4); } }
      if (!u.open && u.ot!=='deity'){ var cx=(u.rx[0]+u.rx[1])/2, cy=top+hgt*0.5; ctx.fillStyle='rgba(0,0,0,0.6)'; ctx.beginPath(); ctx.arc(cx,cy,20,0,7); ctx.fill(); ctx.strokeStyle='#c8a050'; ctx.lineWidth=2.5; ctx.beginPath(); ctx.arc(cx,cy-5,6,Math.PI,0); ctx.stroke(); ctx.fillStyle='#c8a050'; ctx.fillRect(cx-8,cy-4,16,12);
        var tx=u.ot===2?('破鎮宅 '+u.paid+'/'+u.cost):u.ot===11?'要鎖匙':'隔籬未亂'; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; ctx.strokeText(tx,cx,cy+30); ctx.fillStyle='#ffe9a0'; ctx.fillText(tx,cx,cy+30);
        if (u.ot===2&&u.paid>0){ ctx.strokeStyle='#9fd6bf'; ctx.lineWidth=4; ctx.beginPath(); ctx.arc(cx,cy,24,-Math.PI/2,-Math.PI/2+Math.PI*2*u.paid/u.cost); ctx.stroke(); } }
      if (u.door){ var dx=u.x, a=u.doorOpen>0?0.25:1; ctx.globalAlpha=a; ctx.fillStyle='#4a3020'; ctx.fillRect(dx-12,u.y-62,24,58); ctx.strokeStyle='#c8a050'; ctx.lineWidth=2; ctx.strokeRect(dx-12,u.y-62,24,58); ctx.fillStyle='#c8a050'; ctx.fillRect(dx+6,u.y-34,3,3); ctx.globalAlpha=1; if (u.doorOpen>0){ ctx.fillStyle='#9fd6bf'; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.fillText('門開咗！',dx,u.y-68); } }
      if (u.seen && u.items.length && u.open){ var ix=(u.rx[0]+u.rx[1])/2; ctx.font='10px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; var cnt={}, ord=[]; u.items.forEach(function(k){ if (!cnt[k]){ cnt[k]=0; ord.push(k); } cnt[k]++; }); var tt=ord.map(function(k){ return ITEM[k].n+(cnt[k]>1?'×'+cnt[k]:''); }).join(' '); ctx.strokeText(tt,ix,top+28); ctx.fillStyle='#e8d8b0'; ctx.fillText(tt,ix,top+28); } });
    if (G.gate||G.gateCharge>0){ var gn=G.nodes[G.gate?G.gate.node:G.gh[G.gateG].node], rr2=G.gate?40+Math.sin(G.t*4)*6:20*G.gateCharge; var gg=ctx.createRadialGradient(gn.x,gn.y-40,4,gn.x,gn.y-40,rr2*1.8); gg.addColorStop(0,'rgba(120,255,200,0.75)'); gg.addColorStop(1,'rgba(40,120,90,0)'); ctx.fillStyle=gg; ctx.beginPath(); ctx.arc(gn.x,gn.y-40,rr2*1.8,0,7); ctx.fill(); ctx.strokeStyle='rgba(160,255,210,0.8)'; ctx.lineWidth=3; for (var q=0;q<3;q++){ ctx.beginPath(); ctx.arc(gn.x,gn.y-40,rr2*(0.5+q*0.3),G.t*(2+q),G.t*(2+q)+4); ctx.stroke(); } }
    drawMoves();
    if (UNIT) UNIT.drawWorld(ctx);   // UNIT HOOK 7
    G.gh.forEach(function(o,i){ if (o.home||o.out) return; var n=G.nodes[o.node], inside=n.kind==='in'&&!o.to, hang=o.d.key==='tianhua'&&inside;
      var a=o.inv>0?0.35:(i===G.active?1:0.75); if (o.stun>0&&!(o.countT>0)&&!(o.dropT>0)) a*=0.6+0.4*Math.sin(G.t*30);
      if (i===G.active){ ctx.fillStyle='rgba(110,255,190,0.40)'; ctx.beginPath(); ctx.ellipse(o.x,o.y-2,24,6,0,0,7); ctx.fill(); }
      var T=G.t+o.ph, k=o.d.key, ox=0, oy=0, ro=0, sx=1, sy=1, key=hang?'tianhua_hang':o.d.sprite, by=hang?o.y-50:o.y;
      if (o.countT>0){ sy=0.8; oy=3; ro=Math.sin(G.t*9)*0.1; }
      else if (o.sc){ var st=o.sc.t;
        if (st<OMEN){ var c=st/OMEN; sx=sy=1-0.08*c+0.03*Math.sin(G.t*20); ctx.fillStyle={eking:'rgba(210,90,40,',toyol:'rgba(120,220,140,',tianhua:'rgba(110,190,255,'}[k]+(0.25*c)+')'; ctx.beginPath(); ctx.arc(o.x,by-o.d.h*0.5,o.d.h*0.6*(0.6+0.4*c),0,7); ctx.fill(); }
        else if (st<OMEN+STRIKE){ if (k==='eking'){ sx=1.18+0.06*Math.sin(G.t*30); sy=0.92; ro=o.dir*0.1; } else a*=0.25; }
        else { a*=k==='eking'?1:Math.min(1,0.25+(st-OMEN-STRIKE)/AFTER); } }
      else if (o.hitT>0){ var h=o.hitT/0.8; ox=-(o.hitDir||1)*(1-h)*0+(o.hitDir||1)*h*14; ro=(o.hitDir||1)*0.25*h; a*=0.5+0.5*Math.abs(Math.sin(G.t*35)); }
      else if (o.actT>0){ var q=1-o.actT/0.9; // 蓄力→撲出→收招
        if (q<0.3){ var c=q/0.3; sx=sy=1-0.12*c; oy=2*c; ro=-o.dir*0.12*c; ctx.fillStyle='rgba(200,30,30,'+(0.35*c)+')'; ctx.beginPath(); ctx.arc(o.x,by-o.d.h*0.5,o.d.h*0.7,0,7); ctx.fill(); }
        else if (q<0.6){ var c=(q-0.3)/0.3; sx=sy=0.88+0.55*c; ox=o.dir*26*c; ro=o.dir*0.15*c; if (k==='tianhua') oy=-6*c; }
        else { var c=(q-0.6)/0.4; sx=sy=1.43-0.43*c; ox=o.dir*26*(1-c); }
        if (q>0.3&&q<0.75&&k==='tianhua'){ ctx.strokeStyle='rgba(20,20,24,0.85)'; ctx.lineWidth=2; for (var hs=0;hs<9;hs++){ var hx=o.x+o.dir*(10+hs*5); ctx.beginPath(); ctx.moveTo(hx,by-o.d.h); ctx.quadraticCurveTo(hx+Math.sin(G.t*9+hs)*6,by-o.d.h*0.4,hx+Math.sin(G.t*7+hs)*4,by+4); ctx.stroke(); } } }
      else if (o.taskP>0){ if (k==='eking'){ sy=1+0.09*Math.sin(G.t*18); sx=1-0.05*Math.sin(G.t*18); } else if (k==='toyol'){ ro=Math.sin(G.t*20)*0.14; oy=-Math.abs(Math.sin(G.t*10))*3; } else { ro=Math.sin(G.t*5)*0.08; }
        if (k==='tianhua'){ ctx.strokeStyle='rgba(30,30,34,0.8)'; ctx.lineWidth=1.5; for (var hs=0;hs<6;hs++){ var hx=o.x-8+hs*3; ctx.beginPath(); ctx.moveTo(hx,by-o.d.h*0.2); ctx.lineTo(hx+Math.sin(G.t*4+hs)*3,by+16+hs%2*6); ctx.stroke(); } } }
      else if (o.mv>0){ if (k==='eking'){ ro=Math.sin(T*8)*0.08; oy=-Math.abs(Math.sin(T*8))*2; var bp=Math.sin(T*9); sx=1+0.08*bp; sy=1-0.035*bp; }
        else if (k==='toyol'){ oy=-Math.abs(Math.sin(T*15))*7; ro=Math.sin(T*15)*0.13; if (o.flipT>0){ var fq=1-o.flipT/0.55; ro=o.dir*Math.PI*2*fq; oy=-Math.sin(fq*Math.PI)*22-o.d.h*0.3*Math.sin(fq*Math.PI); } }
        else { var na=G.nodes[o.node], nb=o.to?G.nodes[o.to]:na; if (na.f===nb.f&&na.kind!=='in'&&nb.kind!=='in'){ by=fy(na.f+1)+14; sy=-1; ro=Math.sin(T*10)*0.06; ox=Math.sin(T*10)*2; } else { ro=o.dir*0.12; oy=-4+Math.sin(T*6)*3; } } }
      else { oy=Math.sin(T*2.5)*3-(k==='eking'?0:3); sy=1+0.025*Math.sin(T*2.5); }
      if (o.bounceT>0){ ox+=-o.dir*Math.sin(o.bounceT/0.45*Math.PI)*12; }
      if (k==='tianhua'){ var na2=G.nodes[o.node], nb2=o.to?G.nodes[o.to]:na2, ceil2=fy(Math.min(FL,na2.f+1))+14, flo2=o.y;
        if (o.dropT>0){ key=o.d.sprite; var dq=o.dropT;
          if (dq>2.05){ var u2=(2.3-dq)/0.25; by=ceil2+(flo2-ceil2)*u2; sy=1; sx=1; ro=Math.PI*(1-u2); oy=0; ox=0; }
          else if (dq<0.5){ var u3=1-dq/0.5; by=flo2-(flo2-ceil2)*u3; sy=1; sx=1; ro=0; ox=Math.sin(G.t*30)*1.5; }
          else { by=flo2; sy=1; sx=1; ro=o.dir*0.24+Math.sin(G.t*3)*0.03; ox=0; oy=0; if (dq>0.8){ ctx.strokeStyle='rgba(255,230,160,0.8)'; ctx.lineWidth=2; for (var w2=0;w2<3;w2++){ ctx.beginPath(); ctx.arc(o.x-o.dir*10,flo2-o.d.h*0.42,6+w2*5+((G.t*16)%5),Math.PI*0.6,Math.PI*1.4); ctx.stroke(); } } } }
        else if (!hang){ if (na2.f!==nb2.f){ var down=(nb2.f<na2.f); by=o.y-(down?0:6); ro=down?Math.PI:0; ox=o.dir*14+Math.sin(G.t*14)*2; if (down) by=o.y-o.d.h*0.9; sx=sx*0.95; sy=Math.abs(sy); }
          else { by=ceil2; sy=-Math.abs(sy||1); oy=(oy||0)*0.4; } } }
      if (k==='eking'){ sx*=1+(o.fat||0); }
      drawTaskProps(o,by);
      if (o.countT>0){ var cy0=o.y-o.d.h-8, fa=Math.min(1,(o.cntAcc||0)/0.32); if (o.cntN>0){ ctx.globalAlpha=1-fa; txt(COUNT[(o.cntN-1)%10],o.x+10,cy0-fa*14,'#b8f0a0',13); ctx.globalAlpha=1; } ctx.globalAlpha=fa; txt(COUNT[(o.cntN||0)%10]+'……',o.x+10,cy0+6-fa*6,'#d8ffc0',16); ctx.globalAlpha=1; }
      ctx.shadowColor='rgba(140,255,200,0.85)'; ctx.shadowBlur=7; spr(key,o.x,by,o.d.h,{flip:o.dir<0,alpha:a,ox:ox,oy:oy,rot:ro,sx:sx,sy:sy}); ctx.shadowBlur=0;
      if (i===G.active&&!o.to&&o.still>=0.1&&o.mv<=0){ ctx.strokeStyle='rgba(138,255,200,0.55)'; ctx.setLineDash([4,4]); ctx.beginPath(); ctx.ellipse(o.x,o.y-2,30,8,0,0,7); ctx.stroke(); ctx.setLineDash([]); }
      if (o.taskP>0){ ctx.strokeStyle='#8affc8'; ctx.lineWidth=4; ctx.beginPath(); ctx.arc(o.x,o.y-o.d.h-14,10,-Math.PI/2,-Math.PI/2+Math.PI*2*o.taskP); ctx.stroke(); } });
    G.parts.forEach(function(p){ var a=p.life/p.max; ctx.globalAlpha=Math.min(1,a*1.4);
      if (p.type==='coin'){ ctx.fillStyle='#ffd54a'; ctx.beginPath(); ctx.ellipse(p.x,p.y,4,4*Math.abs(Math.sin(G.t*12+p.x)),0,0,7); ctx.fill(); }
      else if (p.type==='crumb'){ ctx.fillStyle='#e8c07a'; ctx.fillRect(p.x,p.y,3,3); }
      else if (p.type==='sweat'){ ctx.fillStyle='#9fe0ff'; ctx.beginPath(); ctx.arc(p.x,p.y,2.5,0,7); ctx.fill(); }
      else if (p.type==='tear'){ ctx.fillStyle='#bfeaff'; ctx.strokeStyle='#2a4a5a'; ctx.lineWidth=0.8; ctx.beginPath(); ctx.moveTo(p.x,p.y-4.5); ctx.quadraticCurveTo(p.x+3.2,p.y,p.x,p.y+2.6); ctx.quadraticCurveTo(p.x-3.2,p.y,p.x,p.y-4.5); ctx.fill(); ctx.stroke(); }
      else if (p.type==='hair'){ ctx.strokeStyle='#222'; ctx.lineWidth=1; ctx.beginPath(); ctx.moveTo(p.x,p.y); ctx.lineTo(p.x+3,p.y+9); ctx.stroke(); }
      else if (p.type==='smoke'){ ctx.fillStyle='rgba(200,210,205,0.5)'; ctx.beginPath(); ctx.arc(p.x,p.y,4+(1-a)*10,0,7); ctx.fill(); }
      else if (p.type==='dust'){ ctx.fillStyle='rgba(180,170,150,0.5)'; ctx.beginPath(); ctx.arc(p.x,p.y,3+(1-a)*5,0,7); ctx.fill(); }
      else if (p.type==='drip'){ ctx.fillStyle='#9fe0ff'; ctx.beginPath(); ctx.ellipse(p.x,p.y,1.6,3,0,0,7); ctx.fill(); }
      else if (p.type==='note'){ ctx.fillStyle='#9cc89c'; ctx.save(); ctx.translate(p.x,p.y); ctx.rotate(G.t*8+p.vx); ctx.fillRect(-5,-3,10,6); ctx.restore(); }
      else if (p.type==='suck'){ ctx.fillStyle='#d24a3a'; ctx.beginPath(); ctx.arc(p.x,p.y,3,0,7); ctx.fill(); }
      ctx.globalAlpha=1; });
    if (G.ult&&G.ult.t>=1.3){ var U=G.ult, uf=U.f, ut=U.t-1.3, top=fy(Math.min(FL,uf+1))+8, bot=fy(uf);
      if (U.g.d.key==='toyol'&&U.clones){ U.clones.forEach(function(c,j){ c.x+=c.v*0.033; if (c.x<60||c.x>WW-60) c.v*=-1; spr('toyol',c.x,bot,40,{flip:c.v<0,alpha:0.75,oy:-Math.abs(Math.sin(G.t*14+j))*8}); if (Math.random()<0.3) part(c.x,bot-20,(Math.random()-0.5)*60,-80,0.6,'coin'); }); }
      if (U.g.d.key==='tianhua'){ ctx.strokeStyle='rgba(12,12,14,0.9)'; ctx.lineWidth=2.2; var len=Math.min(1,ut*1.6)*(bot-top), spread=Math.min(300,ut*190); if (spread<300) txt('頭髮沿走廊爬去隔籬屋……',U.g.x,top+18,'#9fe0ff',13); for (var hx=Math.max(60,U.g.x-spread);hx<Math.min(WW-55,U.g.x+spread);hx+=7){ ctx.beginPath(); ctx.moveTo(hx,top); ctx.quadraticCurveTo(hx+Math.sin(G.t*3+hx)*10,top+len*0.5,hx+Math.sin(G.t*2+hx*0.3)*8,top+len); ctx.stroke(); } }
      if (U.g.d.key==='eking'){ var R0=Math.min(1,ut*1.5)*((bot-top)*0.46), cy=(top+bot)/2+6; ctx.save(); ctx.beginPath(); ctx.rect(0,top,WW,bot-top); ctx.clip(); ctx.fillStyle='rgba(0,0,0,0.55)'; ctx.fillRect(0,top,WW,bot-top); drawMouth(U.g.x,cy,R0,0.3+0.7*Math.abs(Math.sin(ut*5)),1); ctx.restore(); if (ut<1.6) txt('開飯喇……',U.g.x,top+16,'#ffb7a0',13); } }
    G.floats.forEach(function(f){ ctx.globalAlpha=Math.min(1,f.life); crText(ctx,f.t,f.x,f.y,14,f.c,'center'); ctx.globalAlpha=1; });
    ctx.restore();
    if (G.ult&&G.ult.t<1.3){ var t=G.ult.t, gk=G.ult.g.d, ea=Math.min(1,t*4)*(t>1.1?(1.3-t)/0.2:1);
      ctx.fillStyle='rgba(0,0,0,'+(0.7*ea)+')'; ctx.fillRect(0,0,VW,VH);
      var bx=t<0.25?VW*(1-t/0.25):0, by=VH*0.36; ctx.save(); ctx.translate(bx,0); ctx.fillStyle='rgba(110,20,20,0.92)'; ctx.beginPath(); ctx.moveTo(0,by); ctx.lineTo(VW,by-30); ctx.lineTo(VW,by+120); ctx.lineTo(0,by+150); ctx.closePath(); ctx.fill();
      ctx.strokeStyle='#e8d0a0'; ctx.lineWidth=3; ctx.stroke();
      for (var q=0;q<14;q++){ ctx.strokeStyle='rgba(255,220,180,0.25)'; ctx.beginPath(); var yy=by+((q*37+t*900)%150); ctx.moveTo(0,yy); ctx.lineTo(VW,yy-30); ctx.stroke(); }
      spr(gk.sprite,VW*0.27+Math.sin(t*20)*2,by+148,190,{sx:1+0.04*Math.sin(t*12)});
      ctx.fillStyle='#ffe9c0'; ctx.strokeStyle='#000'; ctx.lineWidth=5; ctx.font='bold 40px '+FONT; ctx.textAlign='left'; ctx.strokeText(ULT[gk.key].n,VW*0.5,by+58); ctx.fillText(ULT[gk.key].n,VW*0.5,by+58);
      ctx.font='bold 14px '+FONT; ctx.lineWidth=3; ctx.strokeText(ULT[gk.key].d,VW*0.5-20,by+92,VW*0.52); ctx.fillText(ULT[gk.key].d,VW*0.5-20,by+92,VW*0.52); ctx.restore(); }
    drawHUD();
  }
  function drawHUD(){
    // 頂：時辰 + 天光進度 + 警覺 + 怕意
    crPanel(ctx,-8,-8,VW+16,TOP+8,'paper');
    var fr=Math.min(1,G.t/(PHT*3));
    crBar(ctx,12,8,VW-24,15,fr,'dawn');
    crText(ctx,(G.gate?'陰門死守 '+Math.ceil(30-G.gate.t)+' 秒　':'')+(G.phase<3?PH[G.phase]+'　天光 '+Math.floor(fr*100)+'%':'天光後・追兵第 '+G.wave+' 輪')+'　警覺 '+G.alert,14,44,15,G.alert>=3?'#e8b4a0':'#efe5cf','left',VW-110);
    crText(ctx,'怕意 '+G.fear,VW-14,44,15,'#b2d394','right');
    crText(ctx,'收穫 '+G.bag.length+'/'+BAGMAX+'　紙人 '+G.dolls+'/6　匙 紅'+(G.keys.key||0)+' 黃'+(G.keys.key2||0)+(G.carry?'　帶住失物':''),14,68,13,'#cfc4b0','left',VW-118);
    btn('story',VW-100,48,90,44,'故事 '+G.story.length+'/'+STORY.length,'#2e3a34'); drawMini(); if (cam.free) btn('follow',VW/2-66,TOP+8,132,46,'◎ 跟返隻鬼','#2f5a4a');
    btn('quit',10,TOP+8,62,46,'離開','#2c2c33'); btn('zin',VW-56,TOP+8,46,46,'＋','#24242a'); btn('zout',VW-56,TOP+60,46,46,'－','#24242a');
    // 底：鬼頭像 + 按鈕
    var y0=VH-BOT; crPanel(ctx,-8,y0,VW+16,BOT+8,'paper');
    if (G.toastT>0&&G.toast){ crPanel(ctx,10,y0-58,VW-20,52,'sheet'); ctx.fillStyle='#efdcb4'; ctx.font='bold 13px '+FONT; ctx.textAlign='left'; wrap(G.toast,20,y0-37,VW-40,17); }
    G.gh.forEach(function(o,i){ var x=10+i*72, y=y0+12, full=o.energy>=100&&!o.home, act=i===G.active; buttons.push({id:'gh'+i,x:x,y:y,w:64,h:74}); var pz=crPressed('gh'+i), dy=pz?2:0;
      if (full){ ctx.save(); ctx.globalAlpha=0.45+0.35*Math.sin(G.t*8); crBlit(ctx,crGet(72,82,'rust','panel'),x-4,y-4+dy); ctx.restore(); }
      crBlit(ctx,crGet(64,74,full?'rust':act?'moss':'ink',pz?'p':'n'),x,y+dy);
      sprite(o.d.sprite,x+32,y+58+dy,46,false,o.home||o.out?0.3:1);
      crBar(ctx,x+6,y+5+dy,52,6,o.energy/100,full?'rust':'red');
      if (full) crText(ctx,'點我放大招',x+32,y+24+dy,11,'#f6dcb6','center',60);
      crText(ctx,o.out?'被收服':o.home?'已返':o.d.name+(o.caught?' '+o.caught+'/3':''),x+32,y+69+dy,12,act?'#e4ecd2':'#ebe3d6','center',60); });
    var g=G.gh[G.active], n=G.nodes[g.node], atP=!g.to&&n.kind==='portal'&&!g.home;
    btn('scare',VW-170,y0+12,74,52,'嚇！','#6e1c1c');
    btn('inv',VW-88,y0+12,76,52,g.invCd>0?'隱身 '+Math.ceil(g.invCd):'隱身','#2a4a7a',g.invCd<=0);
    var A=ctxAction(g), U=g.energy>=100&&!g.home&&!g.out&&!G.ult, aw=U?(VW-30)/2:VW-20; if (A) btn('act',10,y0+92,aw,46,A.t,A.k==='respect'?'#3a3a40':'#3a5a2a',A.k!=='respect'); else if (!U){ crText(ctx,'撳住戶＝行過去嚇；企喺電器、水管、𨋢口、樓梯口出「互動」',VW/2,y0+120,12,'#9a8e92','center',VW-20,false,'normal'); }
    if (U) btn('ult',A?20+aw:10,y0+92,A?aw:VW-20,46,'放大招：'+ULT[g.d.key].n,'#8a5a14');
    var hw=(VW-30)/2; btn('gate',10,y0+146,hw,44,G.gate?'陰門 '+Math.ceil(30-G.gate.t)+'s':atP?'開陰門（企定）':'陰門：天台/地庫','#2f5a4a',atP&&!G.gate); btn('doll',20+hw,y0+146,hw,44,'替身遁走 '+G.dolls+'/6','#5a1c1c',G.dolls>=6&&!G.gate);
    crText(ctx,'拖動＝移動；鬆手企定先嚇人、搜嘢、附身、破鎮宅',VW/2,VH-12,12,'#9a8e92','center',VW-16,false,'normal');
    if (G.choice) drawChoice(); if (G.showStory) drawStory(); if (G.over) drawOver();
  }
  function wrap(t,x,y,w,lh){ var line='',yy=y; for (var i=0;i<t.length;i++){ var tt=line+t[i]; if (ctx.measureText(tt).width>w){ crFill(line,x,yy); line=t[i]; yy+=lh; } else line=tt; } crFill(line,x,yy); return yy; }
  function panel(h){ ctx.fillStyle='rgba(6,3,8,0.78)'; ctx.fillRect(0,0,VW,VH); var y=(VH-h)/2; crPanel(ctx,16,y,VW-32,h,'sheet'); buttons=[]; return y; }
  function drawChoice(){ var h=330, y=VH-h-8; ctx.fillStyle='rgba(6,3,8,0.45)'; ctx.fillRect(0,0,VW,VH); crPanel(ctx,10,y,VW-20,h,'sheet'); buttons=[]; ctx.fillStyle='#fff'; ctx.font='bold 19px '+FONT; ctx.textAlign='center'; crFill('怕意滿咗！揀一樣強化',VW/2,y+36);
    G.choice.forEach(function(c,i){ var by=y+52+i*88; btn('card'+i,26,by,VW-52,78,'', '#26262c'); ctx.fillStyle='#ffd54a'; ctx.font='bold 18px '+FONT; crFill(c.t,VW/2,by+32,VW-70); ctx.fillStyle='#d6dad2'; ctx.font='bold 14px '+FONT; crFill(c.d,VW/2,by+58,VW-70); }); }
  function drawStory(){ var H0=Math.min(VH-40,620), y=panel(H0); ctx.fillStyle='#fff'; ctx.font='bold 18px '+FONT; ctx.textAlign='center'; crFill(LV.name+'嘅故事（'+G.story.length+'/'+STORY.length+'）',VW/2,y+34); ctx.textAlign='left'; ctx.font='13px '+FONT; var yy=y+60;
    for (var f=0;f<STORY.length;f++){ ctx.fillStyle=G.story.indexOf(f)>=0?'#ecece6':'#5a5e58'; yy=wrap(G.story.indexOf(f)>=0?STORY[f]:LV.hint[f]+'：？？？（嚇走「✦故事」戶或者完成支線）',28,yy,VW-56,16)+22; }
    if (G.story.length===STORY.length){ ctx.fillStyle='#ffd54a'; yy=wrap(TRUTH,28,yy,VW-56,16)+24; }
    ctx.fillStyle='#9fd6bf'; ctx.font='bold 13px '+FONT; crFill('支線',28,yy); yy+=20; ctx.font='12px '+FONT;
    (G.quests||[]).forEach(function(q){ ctx.fillStyle=q.state===2?'#8affc8':'#d8d8d0'; yy=wrap((q.state===2?'✓ ':'・')+q.t+(q.id==='debt'&&q.state===0?'（遲啲先出現）':''),28,yy,VW-56,16)+20; });
    btn('closeStory',VW/2-60,y+H0-56,120,46,'返去','#5a1c1c'); }
  function drawOver(){ var o=G.over, y=panel(420); ctx.textAlign='center'; ctx.fillStyle=o.ok?'#8affc8':'#ff9a9a'; ctx.font='bold 26px '+FONT;
    crFill(o.why==='gate'?'陰門撤離成功！':o.why==='doll'?'替身遁走！':'被圍收服……',VW/2,y+44); ctx.fillStyle='#fff'; ctx.font='bold 15px '+FONT;
    var msg=o.why==='gate'?['返到陰間嘅鬼：'+o.home+' 隻','帶走全部收穫：'+o.kept+' 件','收服故事碎片：'+o.story+'/'+STORY.length,'今晚怕意總共：'+o.fear,'全樓警覺：'+o.alert]
      :o.why==='doll'?['用替身紙人遁走：'+o.home+' 隻鬼','帶走一半收穫：'+o.kept+' 件（留低 '+o.lost+' 件）','故事碎片冇得帶走（'+o.storyLost+' 塊留咗喺樓入面）','今晚怕意總共：'+o.fear]
      :['三隻鬼全部畀人收服','收穫全部冇晒：'+o.lost+' 件','今晚怕意總共：'+o.fear,'全樓警覺：'+o.alert];
    msg.forEach(function(m,i){ crFill(m,VW/2,y+90+i*30,VW-50); });
    if (o.story===STORY.length){ ctx.fillStyle='#ffd54a'; ctx.font='bold 13px '+FONT; ctx.textAlign='left'; wrap(TRUTH,36,y+250,VW-72,18); }
    btn('again',VW/2-130,y+420-60,120,44,'再嚟一晚','#5a1c1c'); btn('toMap',VW/2+10,y+420-60,120,44,'返地圖','#2c2c33'); if (o.reward!=null){ crText(ctx,'收到冥幣 +'+o.reward,VW/2,y+420-76,17,'#e6a85a','center'); } }
  function crTitleDeco(){ var r=crRnd(5), y=VH*0.24+52; ctx.save(); ctx.strokeStyle='#7a2522'; ctx.lineCap='round';
    for (var p=0;p<3;p++){ ctx.globalAlpha=0.5+r()*0.4; ctx.lineWidth=2.4-p*0.5; ctx.beginPath(); ctx.moveTo(VW*0.2+r()*6,y+r()*3); for (var k=1;k<=8;k++) ctx.lineTo(VW*0.2+VW*0.6*k/8,y+(r()-0.5)*4); ctx.stroke(); }
    ctx.restore(); crPanel(ctx,14,VH*0.62-24,VW-28,5*24+14,'ink'); }
  function drawTitle(){ crBg(); crTitleDeco(); btn('exit',12,14,104,46,'◀ 返地圖','#2c2c33'); ctx.textAlign='center'; ctx.fillStyle='#c4493c'; ctx.font='bold 40px '+FONT; crFill('樓裡有鬼',VW/2,VH*0.24); ctx.font='bold 16px '+FONT; ctx.fillStyle='#d8ccb0'; crFill('揀一棟樓・天光前返陰間',VW/2,VH*0.24+36);
    GH.forEach(function(d,i){ sprite(d.sprite,VW/2+(i-1)*100,VH*0.52,d.h*1.5); });
    ctx.fillStyle='#c8ccc4'; ctx.font='bold 14px '+FONT; ['三隻鬼一齊出動：餓鬼搵宵夜、Toyol 偷錢、天花姐梳頭。','成棟樓幾十戶人：打機、返夜更、打麻雀、網購……','保安唔係捉鬼師傅：附身電器、敲水管、叫𨋢引開佢。','有紅紙符、門神、拿督公、祖先牌位要尊重，繞路行。','子時→丑時→寅時，天光前由地庫或天台陰門返陰間。'].forEach(function(t,i){ crFill(t,VW/2,VH*0.62+i*24,VW-30); });
    var sv=TS(); var shopOpen=!!sv.cleared.flat||Q.has('unlock')||!!window.STN_TEST;
    btn('lv_flat',22,VH*0.80,(VW-56)/2,58,'組屋'+(sv.cleared.flat?' ✓':''),'#5a1c1c'); btn('lv_shop',34+(VW-56)/2,VH*0.80,(VW-56)/2,58,shopOpen?'老店屋'+(sv.cleared.shop?' ✓':''):'老店屋（未解鎖）','#2f5a4a',shopOpen);
    ctx.fillStyle='#7a7f78'; ctx.font='bold 13px '+FONT; ctx.textAlign='center'; crFill(shopOpen?'揀一棟樓開始今晚':'組屋過關（安全返陰間）就解鎖老店屋',VW/2,VH*0.80+78); }

  // ---------- 輸入 ----------
  var joy=null, ptr=null, JR=58, pts={}, pinch=null;
  cv.addEventListener('pointerdown',function(e){ if (e.isPrimary) pts={}; var p=pt(e); pts[e.pointerId]=p; var hb=hitBtn(p.x,p.y); if (hb){ PRESS={id:hb.id,t:performance.now()}; try{ navigator.vibrate&&navigator.vibrate(12); }catch(_){} ptr={sx:p.x,sy:p.y,drag:false,btn:hb.id,id:e.pointerId}; joy=null; try{cv.setPointerCapture(e.pointerId);}catch(_){} return; } var ids=Object.keys(pts); if (ids.length===2){ var a=pts[ids[0]],b=pts[ids[1]]; pinch={d:Math.hypot(a.x-b.x,a.y-b.y),z:cam.z}; joy=null; ptr=null; return; } ptr={sx:p.x,sy:p.y,drag:false,id:e.pointerId,hud:p.y>=VH-BOT||p.y<=TOP}; if (scene==='play'&&!G.over&&!G.choice&&!G.showStory&&p.y>TOP&&p.y<VH-BOT) joy={ox:p.x,oy:p.y,x:p.x,y:p.y,on:false}; try{cv.setPointerCapture(e.pointerId);}catch(_){} });
  cv.addEventListener('pointermove',function(e){ var p=pt(e); if (pts[e.pointerId]) pts[e.pointerId]=p; if (pinch){ var ids=Object.keys(pts); if (ids.length===2){ var a=pts[ids[0]],b=pts[ids[1]]; cam.z=clamp(pinch.z*Math.hypot(a.x-b.x,a.y-b.y)/pinch.d,0.5,1.5); var S9=cam.s*cam.z, mxp=(a.x+b.x)/2, myp=(a.y+b.y)/2; if (pinch.mx!=null){ var c0=cam.free||{x:cam.x+VW/S9/2,y:cam.y+(VH-TOP-BOT)/S9*0.55}; cam.free={x:c0.x-(mxp-pinch.mx)/S9,y:c0.y-(myp-pinch.my)/S9}; } pinch.mx=mxp; pinch.my=myp; } return; } if(!ptr||ptr.id!==e.pointerId) return; if (!ptr.btn&&Math.hypot(p.x-ptr.sx,p.y-ptr.sy)>12) ptr.drag=true; if (joy){ joy.x=p.x; joy.y=p.y; if (ptr.drag) joy.on=true; } });
  cv.addEventListener('pointerup',function(e){ delete pts[e.pointerId]; if (pinch){ if (!Object.keys(pts).length) pinch=null; return; } if (ptr&&ptr.id!=null&&ptr.id!==e.pointerId) return; var p=pt(e), was=ptr; ptr=null; var j=joy&&joy.on; joy=null; if (j&&scene==='play'&&G&&!G.over) settleNear(G.gh[G.active],44); if (was&&was.btn){ LASTP=p; var hb=hitBtn(p.x,p.y); if (hb&&hb.id===was.btn) press(hb.id); else if (Math.hypot(p.x-was.sx,p.y-was.sy)<24) press(was.btn); return; } if (was&&!was.drag&&!j) tap(p.x,p.y); });
  cv.addEventListener('pointercancel',function(e){ delete pts[e.pointerId]; pinch=null; ptr=null; joy=null; });
  // 搖桿鬆手時離最近嗰點好近：自動行埋去，唔好卡喺兩點中間
  function settleNear(g,R0){ if (!g||!g.to||g.home||g.out) return; var a=G.nodes[g.node], b=G.nodes[g.to], E=Math.hypot(b.x-a.x,b.y-a.y); if (E*(1-g.p)<=R0) g.auto=[g.to]; else if (E*g.p<=R0){ var t=g.node; g.node=g.to; g.to=t; g.p=1-g.p; g.auto=[t]; } }
  function pt(e){ var r=cv.getBoundingClientRect(); return {x:e.clientX-r.left,y:e.clientY-r.top}; }
  function joyVec(){ if (!joy||!joy.on) return null; var dx=joy.x-joy.ox, dy=joy.y-joy.oy, L=Math.hypot(dx,dy); if (L>JR){ dx*=JR/L; dy*=JR/L; } return {x:dx/JR,y:dy/JR}; }
  function drawJoy(){ if (!joy||!joy.on) return; var v=joyVec(); ctx.setTransform(DPR,0,0,DPR,0,0); ctx.save(); ctx.globalAlpha=0.7; crBlit(ctx,crGet(JR*2,JR*2,'paper','ring'),joy.ox-JR,joy.oy-JR); ctx.globalAlpha=0.92; crBlit(ctx,crGet(48,48,'bone','ring2'),joy.ox+v.x*JR-24,joy.oy+v.y*JR-24); ctx.restore(); }
  var PRESS=null, PAD=10;
  function hitBtn(x,y){ var best=null, bd=1e9; for (var i=buttons.length-1;i>=0;i--){ var b=buttons[i]; if (x>=b.x-PAD&&x<=b.x+b.w+PAD&&y>=b.y-PAD&&y<=b.y+b.h+PAD){ var d=(x>=b.x&&x<=b.x+b.w&&y>=b.y&&y<=b.y+b.h)?-1:Math.hypot(x-(b.x+b.w/2),y-(b.y+b.h/2)); if (d<bd){ bd=d; best=b; } } } return best; }
  function tap(x,y){ LASTP={x:x,y:y}; var b=hitBtn(x,y); if (b){ press(b.id); return; } if (scene==='play'&&G&&!G.over&&!G.choice&&!G.showStory&&y>TOP&&y<VH-BOT) worldTap(x,y); }
  function worldTap(x,y){ var S=cam.s*cam.z, wx=x/S+cam.x, wy=(y-TOP)/S+cam.y, best=null, bd=40;
    if (UNIT&&UNIT.worldTap(wx,wy)) return;   // UNIT HOOK 6：撳門／「入屋」掣
    var gb=null, gbd=26; G.gh.forEach(function(g,i){ if (g.home||g.out||i===G.active) return; var d=Math.hypot(g.x-wx,(g.y-g.d.h*0.5)-wy); if (d<gbd){ gbd=d; gb={g:i}; } });
    G.res.forEach(function(r){ if (r.state!=='home') return; var d=Math.hypot(r.x-wx,(r.y-26)-wy); if (d<bd){ bd=d; best={r:r}; } });
    G.guards.forEach(function(h){ if (h.state==='gone'||h.state==='flee') return; var d=Math.hypot(h.x-wx,(h.y-30)-wy); if (d<bd){ bd=d; best={h:h}; } });
    if (!best&&gb) best=gb; var g=G.gh[G.active]; if (!best){ var nn=null, nd=1e9; for (var k in G.nodes){ var n=G.nodes[k]; var d=Math.abs(n.x-wx)+Math.abs((n.y-30)-wy)*1.6; if (d<nd){ nd=d; nn=k; } } if (nn&&nd<120){ if (gotoNode(g,nn)){ g.autoS=null; float(G.nodes[nn].x,G.nodes[nn].y-70,'去呢度','#9fd6bf'); } else float(wx,wy,'去唔到','#ffb0b0'); } return; }
    if (best.g!=null){ G.active=best.g; cam.free=null; return; }
    if (best.r){ var un=best.r.unit; if (!un.open&&un.ot!==1){ float(best.r.x,best.r.y-80,'呢戶未入得','#ffd54a'); return; } if (g.node===un.id&&!g.to){ g.still=Math.max(g.still,0.11); scarePress(); return; } if (gotoNode(g,un.id)){ g.autoS={r:best.r}; float(best.r.x,best.r.y-86,'目標：'+(HH[best.r.hh]?HH[best.r.hh].n:'住戶'),'#ffb7a0'); } else float(best.r.x,best.r.y-80,'去唔到（要先開門／破鎮宅）','#ffb0b0'); return; }
    if (best.h){ var hn=best.h.to&&Math.abs(G.nodes[best.h.to].x-best.h.x)<Math.abs(G.nodes[best.h.node].x-best.h.x)?best.h.to:best.h.node; if (gotoNode(g,hn)){ g.autoS={h:best.h}; float(best.h.x,best.h.y-90,'目標：'+HUM[best.h.kind].n,'#ffb7a0'); } return; } }
  function press(id){
    if (id==='lv_flat'||id==='start'){ newGame(null,'flat'); bake(); return; }
    if (id==='exit'){ close(); return; }
    if (id==='quit'){ scene='title'; return; }
    if (id==='lv_shop'){ var sv=TS(); if (sv.cleared.flat||Q.has('unlock')||window.STN_TEST){ newGame(null,'shop'); bake(); } return; }
    if (id==='again'){ newGame(); bake(); return; } if (id==='title'){ scene='title'; return; } if (id==='toMap'){ close(); return; }
    if (scene!=='play') return;
    if (id.indexOf('card')===0){ chooseCard(+id.slice(4)); return; }
    if (id==='zin'){ cam.z=Math.min(1.5,cam.z*1.25); return; } if (id==='zout'){ cam.z=Math.max(0.5,cam.z/1.25); return; } if (id==='mini'){ miniJump(); return; } if (id==='follow'){ cam.free=null; return; } if (id==='act'){ actPress(); return; } if (id==='ult'){ ultPress(G.active); return; }
    if (id==='story'){ G.showStory=true; return; } if (id==='closeStory'){ G.showStory=false; return; }
    if (G.over||G.choice||G.showStory) return;
    if (id.indexOf('gh')===0){ cam.free=null; var i=+id.slice(2); if (G.gh[i].home) return; if (i===G.active&&G.gh[i].energy>=100){ ultPress(i); return; } G.active=i; toast(GH[i].tip+(G.gh[i].energy>=100?'（能量滿！再點頭像放大招）':'')); return; }
    if (id==='scare') scarePress(); if (id==='inv') invPress(); if (id==='gate') gatePress(); if (id==='doll') dollEscape();
  }
  var last=0;
  function frame(ts){ if (!OPEN){ RAF=0; return; } RAF=requestAnimationFrame(frame); if (!last) last=ts; var dt=(ts-last)/1000; if (dt<1/31) return; last=ts; dt=Math.min(dt,0.1);
    if (scene==='play'&&!G.showStory){ var v=joyVec(); if (v&&!G.choice&&!G.over){ G.gh[G.active].auto=null; G.gh[G.active].autoS=null; cam.free=null; joyMove(G.gh[G.active],v.x,v.y,dt); } update(dt); }
    if (!(UNIT&&UNIT.covering())){ draw(); drawJoy(); } }   // UNIT HOOK 9
  // 測試介面
  // LIFT HOOK 1：電梯系統（core/lift.js）接駁——只係將閉包變數交俾模組，模組自己行 rAF
  var LIFT=window.LiftSys?window.LiftSys({get G(){return G;}, get LV(){return LV;}, get FL(){return FL;}, get FLN(){return FLN;}, get IMG(){return IMG;}, get scene(){return OPEN?scene:'closed';}, get paused(){return paused;},
    get VW(){return VW;}, get VH(){return VH;}, get TOP(){return TOP;}, get BOT(){return BOT;}, get BTNS(){return buttons;}, FONT:FONT, HUM:HUM, HH:HH, cv:cv, fy:fy, rnd:rnd, float:float, toast:toast, say:say, addFear:addFear, noise:noise, spook:spook, W2S:W2S}):null;
  window.LIFT=LIFT;
  // UNIT HOOK 1：入屋模式（core/unit.js）——只係將閉包變數交俾模組，模組自己行 rAF、自己開疊層 canvas
  var UNIT=window.UnitSys?window.UnitSys({get G(){ return G; }, get LV(){ return LV; }, get FL(){ return FL; }, get FLN(){ return FLN; }, get IMG(){ return IMG; }, get scene(){ return OPEN?scene:'closed'; }, get paused(){ return paused; },
    get VW(){ return VW; }, get VH(){ return VH; }, get TOP(){ return TOP; }, get BOT(){ return BOT; }, FONT:FONT, HH:HH, ITEM:ITEM, BAGMAX:BAGMAX, MV:MV, BLOCKMSG:BLOCKMSG, PH:PH, PHT:PHT, cv:cv,
    fy:fy, rnd:rnd, float:float, toast:toast, say:say, addFear:addFear, scareRes:scareRes, takeItem:takeItem, onArrive:onArrive, unitOf:unitOf, doorBlock:doorBlock, ctxAction:ctxAction, actPress:actPress, gotoNode:gotoNode, noise:noise, checkAlert:checkAlert,
    crPanel:crPanel, crText:crText, crBtn:crBtn, crBar:crBar, crGet:crGet, crBlit:crBlit}):null;
  window.UNIT=UNIT;
  window.TW={safe:function(){ return SAFE?{x:SAFE.x,y:SAFE.y,r:SAFE.r,f:SAFE.f,nodes:Object.keys(SAFE.nodes),on:safeOn()}:null; }, inSafe:function(i){ return inSafe(G.gh[i]); }, inSafeXY:function(x,y){ return inSafeXY(x,y); }, uq:function(){ return Object.keys(G._uq||{}); }, cam:function(){ return {z:cam.z,free:!!cam.free,x:cam.x,y:cam.y}; }, btns:function(){ return buttons.map(function(b){return {id:b.id,x:b.x,y:b.y,w:b.w,h:b.h};}); }, act:function(){ actPress(); }, ctx:function(){ return ctxAction(G.gh[G.active]); }, noise:function(id,l){ noise(id,l); }, zoom:function(z){cam.z=z;}, pause:function(v){paused=v;}, step:function(dt,n){ var pp=paused; paused=false; for (var i=0;i<(n||1);i++) update(dt); paused=pp; draw(); }, gate:gatePress, doll:dollEscape, catchG:function(i){ catchGhost(G.gh[i],G.guards[0]||{dir:1}); }, ult:ultPress, press:press, tap:tap, goto:function(i,id){ return gotoNode(G.gh[i],id); }, choose:chooseCard, skip:function(s){ G.t+=s; }, get G(){return G;}, set G(v){}, w2s:function(x,y){return W2S(x,y);}};
  window.addEventListener('resize',function(){ if (OPEN) resize(); });
  function loadImgs(){ var M={flatbg:'bg_tw_flat',shopbg:'bg_tw_shop'}; ['res_gamer_scared','res_uncle_scared','res_granny_scared','res_helper_scared','res_mjaunty_scared','res_shopper_scared','res_collector_scared','res_guard_scared','res_ot_scared','res_gym_scared','eguiking','toyol','tianhua','tianhua_hang','npc_ken','npc_auntie','npc_guard','npc_it','npc_mis','npc_boss','npc_it_sit','npc_ken_sit','res_gamer','res_uncle','res_granny','res_helper','res_mjaunty','res_shopper','res_collector','res_guard','res_ot','res_gym','room_mahjong','room_gamer','room_nurse','room_helper','room_gym','room_shopper','room_carpark','room_lobby','flatbg','shopbg','gb_unit_ppr','gb_unit_gamer','gb_unit_shop'].forEach(function(k){ IMG[k]=SPR[M[k]||k]; }); }
  function open(){ loadImgs(); TS(); ROOT.classList.add('on'); OPEN=true; scene='title'; resize(); last=0; if (!RAF) RAF=requestAnimationFrame(frame); try{ Sound.setMode&&Sound.setMode('story'); }catch(e){} try{ window.Policy&&Policy.firstEnter&&Policy.firstEnter('tower'); }catch(e){} }
  function close(){ OPEN=false; ROOT.classList.remove('on'); joy=null; ptr=null; try{ save(); Sound.setMode&&Sound.setMode('village'); }catch(e){} if (typeof World!=='undefined') World.open(); }
  return { open:open, close:close, get on(){ return OPEN; } };
})();
