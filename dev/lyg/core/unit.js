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
  var cv=document.createElement('canvas'); cv.id='unit-cv'; cv.style.cssText='position:fixed;z-index:40;left:0;top:0;display:none;touch-action:none';
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
  function drawActor(a,V){ var r=a.r, lay=S.lay, h=lay.ph*(r.h||74)/74*V.s, q=P(a.x,lay.floor,V), rot=0, sy=1, sx=0, oy=0, al=1;
    if (q.x<-80||q.x>W+80||a.hid) return;
    var lit=S.light[roomAt(a.x)];
    if (a.pose==='sit'&&a.st==='act'){ sy=0.86; }
    if (a.act==='bed'&&a.st==='act'){ rot=-1.45; oy=-(lay.acts.bed.lift||60)*V.s; sx=h*0.45; }
    if (a.act==='shower'&&a.st==='act'){ al=0.85; }
    if (a.st==='cower'||r.react){ sx+=Math.sin(S.t*40)*2; sy*=0.94; }
    if (a.st==='run'){ oy-=Math.abs(Math.sin(S.t*16))*10; rot=-a.dir*0.18; }
    if (r.jumpT>0){ oy-=Math.sin((0.5-r.jumpT)/0.5*Math.PI)*16; }
    c.fillStyle='rgba(0,0,0,0.45)'; c.beginPath(); c.ellipse(q.x,q.y,26*V.s+6,6,0,0,7); c.fill();
    sprite(r.sprite,q.x+sx,q.y+oy,h,{flip:a.dir<0,rot:rot,sy:sy,alpha:al});
    if (a.act==='shower'&&a.st==='act'){ for (var i=0;i<3;i++){ c.fillStyle='rgba(220,230,235,0.18)'; c.beginPath(); c.arc(q.x+(i-1)*30*V.s,q.y-h*(0.4+0.2*i)-((S.t*20+i*10)%20),24*V.s+8,0,7); c.fill(); } }
    if (a.act==='bed'&&a.st==='act'&&!r.awake){ txt('Z',q.x+h*0.5,q.y+oy-h*0.25-((S.t*14)%14),15,'#c8d8ff'); txt('z',q.x+h*0.6,q.y+oy-h*0.35-((S.t*14+7)%14),11,'#c8d8ff'); }
    var top=q.y+oy-(a.act==='bed'&&a.st==='act'?h*0.35:h*sy);
    if (r.fear>0&&a.st!=='run') A.crBar(c,q.x-24,top-12,48,8,r.fear/100,'red');
    if (a.saw&&a.seeT>0.2){ txt('！',q.x,top-18,26,'#ffe25a'); }
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
