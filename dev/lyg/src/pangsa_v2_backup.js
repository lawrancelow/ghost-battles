// 樓裡有鬼 — 組屋關（rumah pangsa）：橫切五層樓 + 天台，路徑點網絡，我哋係鬼
(function(){
  var FONT='"PingFang HK","PingFang TC","Noto Sans CJK TC","Noto Sans TC","Microsoft JhengHei",sans-serif';
  var cv=document.getElementById('c'), ctx=cv.getContext('2d');
  var DPR=Math.min(2,window.devicePixelRatio||1), VW=390, VH=844, TOP=78, BOT=190;
  var IMG={}, Q=new URLSearchParams(location.search);
  var WW=600, WH=900;                               // 世界 = 背景圖 (1024x1536 縮放)
  var FL=5;
  var FYS, SX, LX, GLX, PX0, LV, STORY, TRUTH, FLN;
  // 兩棟樓：路徑對準背景圖每層地板；units = [層,戶,鎮宅,任務,住戶圖,故事序號(-1無),名,門x,房範圍]
  var LEVELS={
    flat:{name:'組屋', bg:'flatbg', FL:5, FYS:[873,711,549,405,261,117], SX:45, LX:555, GLX:555, PX0:105, guard0:'f0_d2',
      fln:['地下','二樓','三樓','四樓','五樓','天台'],
      units:[[0,1,'zha','money','npc_ken',0,'雜貨舖',330,[255,405]],[0,2,'datuk',null,null,-1,'保安亭',470,[405,520]],
        [1,0,null,'food','npc_it',-1,'學生房',226,[78,240]],[1,1,'nuomi','comb','npc_auntie',1,'老夫妻',366,[240,378]],[1,2,null,null,null,-1,'空置單位',496,[378,516]],
        [2,0,null,'food','npc_ken',2,'大家庭',226,[78,240]],[2,1,'nuomi','comb','npc_mis',-1,'家庭理髮',366,[240,378]],[2,2,'zha','money','npc_boss',-1,'麻雀館',496,[378,516]],
        [3,0,'menshen',null,null,-1,'夜班護士',226,[78,240]],[3,1,'zha','money','npc_ken',-1,'囤積屋',366,[240,378]],[3,2,null,'food','npc_mis',3,'卡拉OK',496,[378,516]],
        [4,0,'fu',null,null,-1,'封咗嘅單位',226,[78,240]],[4,1,null,null,'npc_boss',4,'養雀伯伯',366,[240,378]],[4,2,'nuomi','comb','npc_auntie',-1,'新婚夫婦',496,[378,516]]],
      story:['地下：管理處話，五樓嗰個貼滿紅紙嘅單位封咗好多年，但係夜晚成日有收音機聲。',
        '二樓：以前陳伯朝朝喺走廊淋花，見到人就問「食咗飯未呀？」',
        '三樓：有年七月，陳伯敲過我哋門借鹽，我扮唔喺屋企，冇開門……',
        '四樓：之後成座樓都聞到陣怪味，大家都以為係垃圾槽。',
        '五樓：陳伯隻雀仔而家我養住，佢一聽到收音機聲就唱歌，好似等緊有人敲門。'],
      hint:['地下','二樓','三樓','四樓','五樓'],
      truth:'呢座樓唔係真係鬧鬼——係有個伯伯等咗好耐，想有人記得佢。今晚之後，總算有人知道陳伯嘅名。'},
    shop:{name:'老店屋', bg:'shopbg', FL:4, FYS:[812,585,420,262,74], SX:62, LX:552, GLX:520, PX0:122, guard0:'f0_d1',
      fln:['地下','二樓','三樓','四樓','天台'],
      units:[[0,0,null,'food','npc_ken',0,'茶餐室',232,[100,370]],[0,1,'datuk',null,null,-1,'後廚',430,[380,560]],
        [1,0,'zha','money','npc_boss',-1,'中藥舖',205,[100,310]],[1,1,'nuomi','comb','npc_auntie',1,'老租客房',420,[320,530]],
        [2,0,null,'food','npc_it',2,'工人房',210,[100,320]],[2,1,'zha','money','npc_mis',3,'麻雀房',430,[330,530]],
        [3,0,null,null,'npc_ken',4,'雜物房',232,[100,370]],[3,1,'fu',null,null,-1,'封咗嘅房',445,[380,530]]],
      story:['地下：茶餐室阿叔話，以前四樓住咗個車衫嘅芳姐，成條街啲工人都搵佢補衫。',
        '二樓：芳姐同我做咗三十年鄰居，佢話呢間屋就係佢一世，點都唔肯搬。',
        '三樓：收樓嗰年芳姐病咗入院，之後佢間房就封咗，門口貼滿紅紙。',
        '三樓：之後打麻雀打到三更，成日聽到樓上有車衣車聲，嗒嗒嗒咁響。',
        '四樓：我執雜物嗰陣搵到佢本記帳簿，最後一頁寫住「仲有十件衫未補完」。'],
      hint:['地下茶餐室','二樓老租客','三樓工人房','三樓麻雀房','四樓雜物房'],
      truth:'芳姐唔係嚟嚇人——佢只係想做完手上最後嗰幾件衫。今晚之後，會有人幫佢將衫交返俾街坊。'}
  };
  function useLevel(k){ LV=LEVELS[k]; LV.key=k; FL=LV.FL; FYS=LV.FYS; SX=LV.SX; LX=LV.LX; GLX=LV.GLX; PX0=LV.PX0; STORY=LV.story; TRUTH=LV.truth; FLN=LV.fln; }
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
    {key:'eking', name:'餓鬼', sprite:'eguiking', h:62, sp:80, task:'food', cross:{}, tip:'餓鬼：入屋搵宵夜，站喺金圈讀條。'},
    {key:'toyol', name:'Toyol', sprite:'toyol', h:46, sp:104, task:'money', cross:{zha:1}, tip:'Toyol：細隻，鐵閘罅都鑽得過，專偷銀包。'},
    {key:'tianhua', name:'天花姐', sprite:'tianhua', h:60, sp:88, task:'comb', cross:{nuomi:1}, tip:'天花姐：喺天花爬，地下撒嘅糯米攔佢唔住。'}
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
  var curLv='flat';
  function newGame(s,lv){
    if (lv) curLv=lv; useLevel(curLv);
    seed=s||((Date.now()%100000)+7); used={};
    G={t:0, phase:0, nodes:{}, edges:[], units:[], res:[], guards:[], floats:[], fear:0, fearNext:30, fearTotal:0,
       mods:{spd:1,pow:1,inv:3,task:1,arm:1,fear:1}, story:[], active:0, over:null, choice:null, toast:null, toastT:0, alarm:[]};
    buildMap(); placeUnits();
    G.gh=GH.map(function(d,i){ return {d:d, i:i, node:'f0_e', at:'f0_e', to:null, p:0, x:0, y:0, dir:1, loot:0, task:null, taskP:0, inv:0, invCd:0, stun:0, scareCd:0, home:false, energy:0, actT:0, hitT:0, bounceT:0, mv:0, lx:0, ly:0, ph:Math.random()*6}; });
    G.parts=[]; G.ult=null; G.wardFx=[]; G.dark={};
    G.gh.forEach(function(g){ var n=G.nodes[g.node]; g.x=n.x; g.y=n.y; });
    spawnGuards(); scene='play'; paused=false;
    toast(LV.name+'：今晚要喺天光前返陰間。拖住畫面郁鬼：門口向上推入屋，樓梯上落換層。'+GH[0].tip);
    window.TW.G=G;
  }
  function node(id,x,y,f,kind){ G.nodes[id]={id:id,x:x,y:y,f:f,kind:kind,links:[]}; }
  function link(a,b,ward){ var e={a:a,b:b,ward:ward||null}; G.edges.push(e); G.nodes[a].links.push({to:b,e:e}); G.nodes[b].links.push({to:a,e:e}); return e; }
  function buildMap(){
    for (var f=0;f<=FL;f++){
      var y=fy(f); node('f'+f+'_s',SX,y,f,'stair'); node('f'+f+'_l',f===0?GLX:LX,y,f,'lift');
      if (f<FL){ var stops=LV.units.filter(function(L){return L[0]===f;}).map(function(L){ return {x:L[7],u:L[1]}; });
        if (f===0) stops.push({x:PX0,p:1}); stops.sort(function(a,b){return a.x-b.x;});
        var prev='f'+f+'_s';
        stops.forEach(function(st){ var id; if (st.p){ id='f0_e'; node(id,st.x,y,0,'portal'); } else { id='f'+f+'_d'+st.u; node(id,st.x,y,f,'door'); node('f'+f+'_i'+st.u,st.x-14,y-34,f,'in'); link(id,'f'+f+'_i'+st.u); }
          link(prev,id); prev=id; });
        link(prev,'f'+f+'_l');
      } else { node('f'+FL+'_p',300,y,f,'portal'); link('f'+FL+'_s','f'+FL+'_p'); link('f'+FL+'_p','f'+FL+'_l'); }
      if (f>0){ link('f'+(f-1)+'_s','f'+f+'_s'); link('f'+(f-1)+'_l','f'+f+'_l'); }
    }
  }
  function placeUnits(){
    LV.units.forEach(function(L){ var f=L[0],u=L[1],w=L[2];
      var id='f'+f+'_i'+u, did='f'+f+'_d'+u;
      var e=G.nodes[did].links.find(function(l){return l.to===id;}).e; e.ward=w;
      var rx=L[8];
      var un={f:f,u:u,id:id,ward:w,task:L[3],taskDone:false,lit:false,litT:0,story:L[5]>=0,si:L[5],name:L[6],x:G.nodes[did].x,y:fy(f),rx:rx};
      G.units.push(un);
      if (L[4]){ var cx=(rx[0]+rx[1])/2, rxp=Math.abs(cx-un.x)<30?cx-34:cx;
        var r={unit:un,sprite:L[4],x:rxp,y:fy(f)-16,fear:0,brave:(L[5]===4&&LV.key==='flat')?0.3:(rnd()<0.2?0.5:0),state:'home',vx:0};
        G.res.push(r); un.res=r; }
    });
  }
  var TAOL=['鈴……鈴……各位街坊安心瞓','天師巡樓，邪氣退散','聽住鈴聲，唔好亂走','鈴聲到處，夜路平安'];
  function taoUpdate(dt){
    if (G.phase>=1 && !G.tao){ G.taoCd=(G.taoCd==null?6:G.taoCd)-dt; if (G.taoCd<=0){ var f=1+Math.floor(rnd()*(FL-1)); var fromL=rnd()<0.5; G.tao={x:fromL?SX:LX, f:f, dir:fromL?1:-1, ringT:2.5, life:24, waves:[], say:pick(TAOL), sayT:2.6}; float(G.tao.x,fy(f)-90,'天師嚟咗！','#ffd54a'); toast('天師上咗'+FLN[f]+'巡樓，聽到鈴聲就走遠啲。'); } }
    var T=G.tao; if (!T) return;
    T.life-=dt; T.x+=T.dir*36*dt; if (T.x>LX-10||T.x<SX+10) T.dir*=-1; T.sayT-=dt;
    T.ringT-=dt; if (T.ringT<=0){ T.ringT=4; T.waves.push({r:10,t:1}); T.say=pick(TAOL); T.sayT=2.4;
      G.gh.forEach(function(g){ if (g.home) return; if (Math.abs(g.y-fy(T.f))>40&&Math.abs(G.nodes[g.node].f-T.f)>0) return; if (Math.abs(g.x-T.x)>140) return;
        g.sealT=3; g.hitT=0.8; g.hitDir=g.x>T.x?1:-1; g.to=null; g.auto=null; g.taskP=0;
        var n=G.nodes[g.node], away=n.links.map(function(l){return G.nodes[l.to];}).filter(function(m){return m.kind!=='in'&&(m.x-T.x)*(g.x-T.x)>=0&&Math.abs(m.x-T.x)>Math.abs(n.x-T.x);})[0];
        if (n.kind==='in') g.node=n.id.replace('_i','_d'); else if (away) g.node=away.id;
        float(g.x,g.y-90,'鈴聲逼退，暫時嚇唔到人','#ffe9a0'); for (var k=0;k<8;k++) part(g.x,g.y-30,(rnd()-0.5)*60,-30-rnd()*40,0.9,'smoke'); }); }
    T.waves.forEach(function(w){ w.t-=dt; w.r+=180*dt; }); T.waves=T.waves.filter(function(w){return w.t>0;});
    if (T.life<=0){ G.tao=null; G.taoCd=18+rnd()*10; }
  }
  function spawnGuards(){
    var want=[1,2,3][G.phase];
    while (G.guards.length<want){
      var f=G.guards.length===0?0:1+Math.floor(rnd()*(FL-1));
      G.guards.push({node:G.guards.length===0?LV.guard0:'f'+f+'_s', to:null, p:0, x:SX, y:fy(f), dir:1, wait:1, talkT:3+rnd()*5, chase:null});
    }
  }
  function toast(m){ G.toast=m; G.toastT=5.5; }
  function float(x,y,t,c){ G.floats.push({x:x,y:y,t:t,c:c||'#fff',life:1.6}); }

  // ---------- 移動（路徑點網絡）----------
  function canPass(g,e){ if (!e.ward) return true; return !!g.d.cross[e.ward]; }
  function joyMove(g,jx,jy,dt){
    if (g.stun>0||g.home) return;
    var L=Math.hypot(jx,jy); if (L<0.25){ return; }
    jx/=L; jy/=L;
    var sp=g.d.sp*G.mods.spd*(G.phase===2?1:1);
    if (!g.to){ // 喺節點：揀最順方向嘅連線
      var n=G.nodes[g.node], best=null, bd=0.55;
      n.links.forEach(function(l){ var m=G.nodes[l.to], dx=m.x-n.x, dy=m.y-n.y, D=Math.hypot(dx,dy), dot=(dx*jx+dy*jy)/D; if (dot>bd){ bd=dot; best=l; } });
      if (!best) return;
      if (!canPass(g,best.e)){ if (!g.blockT||g.blockT<=0){ float(n.x,n.y-80,WARD[best.e.ward].m,'#ffd54a'); g.blockT=1.4; g.bounceT=0.45; G.wardFx.push({x:n.x,y:n.y,t:0.9,w:best.e.ward}); } return; }
      g.to=best.to; g.p=0;
    }
    var a=G.nodes[g.node], b=G.nodes[g.to], dx=b.x-a.x, dy=b.y-a.y, D=Math.hypot(dx,dy), dot=(dx*jx+dy*jy)/D;
    if (dot<-0.3){ var t=g.node; g.node=g.to; g.to=t; g.p=1-g.p; return; }
    g.p+=sp*dt/D; if (dx) g.dir=dx>0?1:-1;
    if (g.p>=1){ g.node=g.to; g.to=null; g.p=0; onArrive(g); }
  }
  function posOf(o){ var a=G.nodes[o.node]; if (!o.to) return {x:a.x,y:a.y}; var b=G.nodes[o.to]; return {x:a.x+(b.x-a.x)*o.p, y:a.y+(b.y-a.y)*o.p}; }
  function onArrive(g){
    var n=G.nodes[g.node];
    if (n.kind==='in'){ var un=unitOf(n.id); if (un&&un.task&&!un.taskDone&&un.task===g.d.task) float(n.x,n.y-70,'站喺度讀條','#8affc8'); }
    if (n.kind==='portal' && g.i===G.active) float(n.x,n.y-70,'回陰間點：撳「返陰間」','#9fd6bf');
  }
  function unitOf(id){ for (var i=0;i<G.units.length;i++) if (G.units[i].id===id) return G.units[i]; return null; }
  function gotoNode(g,target){ // 測試／自動尋路（只走合法連線）
    var prev={}, q=[g.node], seen={}; seen[g.node]=1;
    while(q.length){ var c=q.shift(); if (c===target) break; G.nodes[c].links.forEach(function(l){ if (!seen[l.to] && canPass(g,l.e)){ seen[l.to]=1; prev[l.to]=c; q.push(l.to); } }); }
    if (!seen[target]) return false; var path=[target]; while(path[0]!==g.node) path.unshift(prev[path[0]]); g.auto=path.slice(1); return true;
  }

  // ---------- 更新 ----------
  function update(dt){
    if (G.over||G.choice||paused) return;
    if (G.ult){ G.ult.t+=dt; if (G.ult.t<1.3) { stepFx(dt); return; } if (!G.ult.done){ G.ult.done=true; applyUlt(G.ult); } if (G.ult.t>4){ G.ult=null; G.ultCool=1.5; } }
    G.t+=dt; var np=Math.min(2,Math.floor(G.t/(NIGHT/3)));
    if (np!==G.phase){ G.phase=np; spawnGuards(); toast(PH[np]+'到喇——'+(np===1?'保安加咗巡邏，小心手電筒。':'就快天光，住戶開始開燈念經，盡快返陰間！')); }
    if (G.t>=NIGHT){ endNight(false,'dawn'); return; }
    G.toastT-=dt;
    G.gh.forEach(function(g){
      g.blockT=(g.blockT||0)-dt; g.inv=Math.max(0,g.inv-dt); g.invCd=Math.max(0,g.invCd-dt); g.stun=Math.max(0,g.stun-dt); g.scareCd=Math.max(0,g.scareCd-dt);
      if (g.auto&&g.auto.length&&!g.home){ var nx=g.auto[0];
        if (!g.to){ if (g.node===nx){ g.auto.shift(); } else { var ln=G.nodes[g.node].links.find(function(l){return l.to===nx;}); if (ln&&canPass(g,ln.e)){ g.to=nx; g.p=0; } else g.auto=null; } }
        if (g.to){ var a=G.nodes[g.node], b=G.nodes[g.to], D=Math.hypot(b.x-a.x,b.y-a.y); g.p+=g.d.sp*G.mods.spd*dt/D; if (b.x!==a.x) g.dir=b.x>a.x?1:-1; if (g.p>=1){ g.node=g.to; g.to=null; g.p=0; if (g.auto&&g.auto[0]===g.node) g.auto.shift(); onArrive(g); } }
      }
      var p=posOf(g); g.mv=Math.max(0,g.mv-dt); if (Math.abs(p.x-g.x)+Math.abs(p.y-g.y)>0.2) g.mv=0.18; g.x=p.x; g.y=p.y;
      g.sealT=Math.max(0,(g.sealT||0)-dt); g.actT=Math.max(0,g.actT-dt); g.hitT=Math.max(0,g.hitT-dt); g.bounceT=Math.max(0,g.bounceT-dt);
      if (g.taskP>0 && rnd()<dt*14) part(g.x+(rnd()-0.5)*20,g.y-g.d.h*0.5,(rnd()-0.5)*60,-40-rnd()*40,0.7,{eking:'crumb',toyol:'coin',tianhua:'hair'}[g.d.key]);
      // 讀條任務
      var n=G.nodes[g.node];
      if (!g.to && n.kind==='in'){ var un=unitOf(n.id);
        if (un.lit){ // 開咗燈：被逼返出走廊
          float(g.x,g.y-70,'開燈喇！被逼返出去','#ffb0b0'); g.node='f'+un.f+'_d'+un.u; g.stun=0.6; loseLoot(g,0.5);
        } else if (un.task===g.d.task && !un.taskDone){ g.taskP+=dt*G.mods.task/2.6; if (g.taskP>=1){ un.taskDone=true; g.taskP=0; g.loot+=un.task==='money'?2:1; g.energy=Math.min(100,g.energy+15); float(g.x,g.y-80,{food:'食到宵夜 +1',money:'偷到銀包 +2',comb:'梳完頭（嚇到成屋）+1'}[un.task],'#ffd54a'); if (un.res) scareRes(un.res,35,g); } }
        else g.taskP=0;
        if (un.res && un.res.state==='home') { un.res.fear+=dt*4*G.mods.pow*(1-un.res.brave); if (un.res.fear>=100) flee(un.res,g); }
      } else g.taskP=0;
    });
    // 住戶
    G.res.forEach(function(r){
      r.jumpT=Math.max(0,(r.jumpT||0)-dt); r.tangle=Math.max(0,(r.tangle||0)-dt);
      if (r.state==='flee'){ if (r.tripT>0){ r.tripT-=dt; r.x+=r.vx*0.18*dt; } else r.x+=r.vx*dt; if (r.x<SX||r.x>LX) r.state='gone'; if (rnd()<dt*8) part(r.x-Math.sign(r.vx)*10,r.y-4,-r.vx*0.1,-10,0.5,'dust'); }
      if (r.talkT>0) r.talkT-=dt;
    });
    // 寅時：住戶開燈
    if (G.phase===2) G.units.forEach(function(un){ un.litT-=dt; if (un.res&&un.res.state==='home'&&un.res.brave===0&&!un.lit&&rnd()<dt*0.05){ un.lit=true; un.litT=8; say(un.res,line('wake')); } if (un.lit&&un.litT<=0) un.lit=false; });
    // 保安
    G.guards.forEach(function(s){ guardUpdate(s,dt); });
    G.ultCool=Math.max(0,(G.ultCool||0)-dt);
    if (G.choiceQ>0 && !G.ult && G.ultCool<=0){ G.choiceQ--; G.choice=shuffle(CARDS).slice(0,3); }
    taoUpdate(dt);
    stepFx(dt);
    G.floats.forEach(function(f){ f.life-=dt; f.y-=dt*22; }); G.floats=G.floats.filter(function(f){return f.life>0;});
    G.res.forEach(function(r){ if (r.say){ r.sayT-=dt; if (r.sayT<=0) r.say=null; } });
  }
  function say(r,t){ r.say=t; r.sayT=2.6; }
  function scareRes(r,amt,g){ if (r.state!=='home') return; r.fear+=amt*G.mods.pow*(1-r.brave); r.jumpT=0.5; if (g) g.energy=Math.min(100,g.energy+(r.brave?8:18)); for (var k=0;k<5;k++) part(r.x,r.y-48,(rnd()-0.5)*90,-60-rnd()*40,0.6,'sweat'); if (r.fear>=100) flee(r,g); else say(r,r.brave?line('brave'):line('afraid')); }
  function flee(r,g){
    r.state='flee'; r.y=fy(r.unit.f); r.vx=(r.x<300?-1:1)*150; r.tripT=rnd()<0.35?0.9:0; say(r,line('flee')); if (g) g.energy=Math.min(100,g.energy+20);
    var amt=Math.round(15*G.mods.fear); addFear(amt,r.x,r.y-80);
    G.alarm.push(r.unit.f);
    if (r.unit.story && G.story.indexOf(r.unit.si)<0){ G.story.push(r.unit.si); G.story.sort(); toast('收集到故事碎片——'+STORY[r.unit.si]); }
  }
  function addFear(a,x,y){ G.fear+=a; G.fearTotal+=a; float(x,y,'怕意 +'+a,'#9fd6bf'); if (G.fear>=G.fearNext){ G.fear-=G.fearNext; G.fearNext+=20; G.choiceQ=(G.choiceQ||0)+1; } }
  function loseLoot(g,frac){ var l=Math.ceil(g.loot*frac*(G.mods.arm<1?0.5:1)); if (g.loot>0&&l>0){ g.loot-=l; float(g.x,g.y-95,'跌咗收穫 -'+l,'#ff9a9a'); } }
  function guardUpdate(s,dt){
    s.talkT-=dt; if (s.talkT<=0){ s.say=line('guard'); s.sayT=2.4; s.talkT=8+rnd()*8; } if (s.sayT>0) s.sayT-=dt; else s.say=null;
    if (!s.to){ s.wait-=dt; if (s.wait>0) return;
      var n=G.nodes[s.node], opts=n.links.filter(function(l){ var m=G.nodes[l.to]; return m.kind!=='in' && m.kind!=='portal'; });
      if (G.alarm.length){ var tf=G.alarm[0]; var up=opts.find(function(l){ var m=G.nodes[l.to]; return (m.f>n.f&&tf>n.f)||(m.f<n.f&&tf<n.f); }); if (up) { s.to=up.to; s.p=0; } else if (n.f===tf) G.alarm.shift(); }
      if (!s.to){ var l=pick(opts); s.to=l.to; s.p=0; }
    }
    var a=G.nodes[s.node], b=G.nodes[s.to], D=Math.hypot(b.x-a.x,b.y-a.y), sp=44+G.phase*12;
    s.p+=sp*dt/D; if (b.x!==a.x) s.dir=b.x>a.x?1:-1;
    if (s.p>=1){ s.node=s.to; s.to=null; s.p=0; s.wait=0.2+rnd()*0.8; }
    var p=posOf(s); s.x=p.x; s.y=p.y;
    G.gh.forEach(function(g){
      if (g.home||g.inv>0||g.stun>0) return; var gn=G.nodes[g.node]; if (gn.kind==='in'&&!g.to) return;
      if (Math.abs(g.y-s.y)>8) return; var dx=g.x-s.x; if (dx*s.dir<0||Math.abs(dx)>150) return;
      float(g.x,g.y-80,'被手電筒照到！','#ffb0b0'); s.say=line('guardHit'); s.sayT=2; s.alertT=1.3; g.hitT=0.8; g.hitDir=s.dir; for (var k=0;k<10;k++) part(g.x,g.y-g.d.h*0.5,(rnd()-0.5)*50+s.dir*40,-30-rnd()*40,0.9,'smoke');
      loseLoot(g,0.34); g.stun=1.0; G.fear=Math.max(0,G.fear-Math.round(6*G.mods.arm));
      // 逼返後一格（遠離保安）
      var back=G.nodes[g.node].links.map(function(l){return G.nodes[l.to];}).filter(function(m){return m.kind!=='in'&&(m.x-s.x)*s.dir>0;})[0];
      if (back&&!g.to){ g.node=back.id; } g.to=null; g.auto=null;
    });
  }
  function part(x,y,vx,vy,life,type){ if (G.parts.length<260) G.parts.push({x:x,y:y,vx:vx,vy:vy,life:life,max:life,type:type}); }
  function stepFx(dt){ G.parts.forEach(function(p){ p.life-=dt; p.x+=p.vx*dt; p.y+=p.vy*dt; if (p.type==='coin'||p.type==='crumb'||p.type==='sweat') p.vy+=220*dt; if (p.type==='smoke') { p.vx*=0.96; p.vy*=0.96; } if (p.type==='suck'&&p.tx!=null){ p.x+=(p.tx-p.x)*dt*3; p.y+=(p.ty-p.y)*dt*3; } }); G.parts=G.parts.filter(function(p){return p.life>0;});
    G.wardFx.forEach(function(w){ w.t-=dt; }); G.wardFx=G.wardFx.filter(function(w){return w.t>0;}); G.shake=Math.max(0,(G.shake||0)-dt);
    for (var k in G.dark){ G.dark[k]-=dt; if (G.dark[k]<=0) delete G.dark[k]; } }
  var ULT={eking:{n:'大胃王',d:'整層燈滅，一啖吞晒啲驚！'},toyol:{n:'一掃光',d:'分身滿層亂竄，偷到一個唔留！'},tianhua:{n:'千絲垂髮',d:'頭髮由天花鋪落嚟，纏實成層人！'}};
  function ultPress(i){ var g=G.gh[i]; if (g.energy<100||g.home||G.ult) return false; g.energy=0; G.ult={g:g,t:0,f:G.nodes[g.node].f,done:false}; return true; }
  function applyUlt(U){ var g=U.g, f=U.f, k=g.d.key, rs=G.res.filter(function(r){return r.unit.f===f&&r.state==='home';});
    if (k==='eking'){ G.dark[f]=3.2; rs.forEach(function(r){ scareRes(r,130,g); for (var q=0;q<6;q++){ var p={x:r.x,y:r.y-30,vx:0,vy:0,life:1.4,max:1.4,type:'suck'}; p.tx=g.x; p.ty=g.y-30; G.parts.push(p); } }); }
    if (k==='toyol'){ U.clones=[0,1,2,3,4].map(function(j){ return {x:60+j*110,v:(j%2?1:-1)*(220+j*30)}; }); var got=Math.max(2,rs.length); g.loot+=got; float(g.x,g.y-100,'一掃光！收穫 +'+got,'#ffd54a'); G.units.forEach(function(u){ if (u.f===f&&u.task==='money') u.taskDone=true; }); rs.forEach(function(r){ scareRes(r,85,g); }); }
    if (k==='tianhua'){ rs.forEach(function(r){ r.tangle=3.2; scareRes(r,105,g); }); }
    G.shake=0.5;
  }
  function endNight(early,why){
    var home=G.gh.filter(function(g){return g.home;}), kept=0;
    G.gh.forEach(function(g){ if (g.home) kept+=g.loot; });
    var ok=why!=='dawn' && home.length>0;
    G.over={ok:ok, why:why, kept:kept, lost:G.gh.reduce(function(s,g){return s+(g.home?0:g.loot);},0), home:home.length, fear:G.fearTotal, story:G.story.length};
    try{ var sv=JSON.parse(localStorage.getItem('lyg_pangsa')||'{}'); sv.nights=(sv.nights||0)+1; if (ok){ sv.best=Math.max(sv.best||0,kept); sv['clear_'+curLv]=1; } sv.story=Math.max(sv.story||0,G.story.length); localStorage.setItem('lyg_pangsa',JSON.stringify(sv)); }catch(e){}
  }
  function goHome(){
    var g=G.gh[G.active], n=G.nodes[g.node]; if (g.to||n.kind!=='portal') return;
    G.gh.forEach(function(o){ var m=G.nodes[o.node]; if (!o.to&&m.kind==='portal') o.home=true; });
    endNight(G.t<NIGHT,'home');
  }
  function scarePress(){
    var g=G.gh[G.active]; if (g.scareCd>0||g.home) return; var n=G.nodes[g.node]; if (g.sealT>0){ float(g.x,g.y-80,'鈴聲未散，暫時嚇唔到人','#ffe9a0'); return; }
    var un=(!g.to&&n.kind==='in')?unitOf(n.id):null;
    if (!un||!un.res||un.res.state!=='home'){ float(g.x,g.y-80,'呢度冇人可以嚇','#ddd'); return; }
    g.scareCd=1.2; g.actT=0.9; g.dir=un.res.x>g.x?1:-1; scareRes(un.res,34,g); float(g.x,g.y-90,'嚇！','#ff7a5a'); G.shake=0.25;
  }
  function invPress(){ var g=G.gh[G.active]; if (g.invCd>0) return; g.inv=G.mods.inv; g.invCd=G.mods.inv+9; float(g.x,g.y-90,'隱身','#9fe0ff'); }
  function chooseCard(i){
    var c=G.choice[i]; if (!c) return; var m=G.mods;
    if (c.id==='spd') m.spd*=1.2; if (c.id==='pow') m.pow*=1.4; if (c.id==='inv') m.inv+=2; if (c.id==='task') m.task*=1.35; if (c.id==='arm') m.arm=0.5; if (c.id==='fear') m.fear*=1.3;
    G.choice=null; toast('揀咗「'+c.t+'」：'+c.d);
  }

  // ---------- 畫面 ----------
  var cam={x:0,y:0,s:1,z:1.7}, staticCv=null;
  function resize(){ VW=Math.min(window.innerWidth,520); VH=window.innerHeight; cv.style.width=VW+'px'; cv.style.height=VH+'px'; cv.width=Math.round(VW*DPR); cv.height=Math.round(VH*DPR); cam.s=VW/WW; }
  function crayon(c2,x,y,w,h,col,dens){ c2.fillStyle=col; c2.fillRect(x,y,w,h); c2.save(); c2.beginPath(); c2.rect(x,y,w,h); c2.clip(); c2.globalAlpha=0.16; c2.strokeStyle='#000'; c2.lineWidth=1;
    var n=Math.floor(w*h/(dens||140)); for (var i=0;i<n;i++){ var px=x+Math.random()*w, py=y+Math.random()*h, L=4+Math.random()*9; c2.beginPath(); c2.moveTo(px,py); c2.lineTo(px+L,py-L*0.35); c2.stroke(); }
    c2.globalAlpha=0.10; c2.strokeStyle='#fff'; for (var i=0;i<n/2;i++){ var px=x+Math.random()*w, py=y+Math.random()*h; c2.beginPath(); c2.moveTo(px,py); c2.lineTo(px+5,py-2); c2.stroke(); } c2.restore(); }
  function bake(){
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
  function bubble(x,y,t,col){ ctx.font='12px '+FONT; var w=Math.min(190,ctx.measureText(t).width+14); ctx.fillStyle='rgba(255,250,240,0.95)'; ctx.strokeStyle='#1a1a1e'; ctx.lineWidth=1.5; rr(x-w/2,y-24,w,22,8); ctx.fill(); ctx.stroke(); ctx.fillStyle=col||'#1a1a1e'; ctx.textAlign='center'; ctx.fillText(t,x,y-9,w-8); }
  function rr(x,y,w,h,r){ ctx.beginPath(); ctx.moveTo(x+r,y); ctx.arcTo(x+w,y,x+w,y+h,r); ctx.arcTo(x+w,y+h,x,y+h,r); ctx.arcTo(x,y+h,x,y,r); ctx.arcTo(x,y,x+w,y,r); ctx.closePath(); }
  var buttons=[];
  function btn(id,x,y,w,h,label,col,on){ buttons.push({id:id,x:x,y:y,w:w,h:h}); ctx.globalAlpha=on===false?0.45:1; ctx.fillStyle=col||'#2c2c33'; ctx.strokeStyle='#8a8f88'; ctx.lineWidth=2; rr(x,y,w,h,12); ctx.fill(); ctx.stroke(); ctx.fillStyle='#fff'; ctx.font='bold 15px '+FONT; ctx.textAlign='center'; ctx.fillText(label,x+w/2,y+h/2+5,w-6); ctx.globalAlpha=1; }
  function draw(){
    ctx.setTransform(DPR,0,0,DPR,0,0); ctx.fillStyle='#0b0b0d'; ctx.fillRect(0,0,VW,VH); buttons=[];
    if (scene==='title'){ drawTitle(); return; }
    var g=G.gh[G.active], S=cam.s*cam.z, viewH=(VH-TOP-BOT)/S, viewW=VW/S, ty=clamp(g.y-viewH*0.55,0,Math.max(0,WH-viewH+70)), tx=clamp(g.x-viewW/2,0,Math.max(0,WW-viewW)); cam.y+=(ty-cam.y)*0.15; cam.x+=(tx-cam.x)*0.15;
    var shk=G.shake>0?(Math.random()-0.5)*G.shake*16:0; ctx.save(); ctx.translate(shk,TOP); ctx.beginPath(); ctx.rect(0,0,VW,VH-TOP-BOT); ctx.clip(); ctx.scale(S,S); ctx.translate(-cam.x,-cam.y);
    ctx.drawImage(staticCv,0,0,WW,WH);
    G.units.forEach(function(un){ var top=fy(un.f+1)+16; if (un.lit){ ctx.fillStyle='rgba(255,230,140,0.38)'; ctx.fillRect(un.rx[0],top,un.rx[1]-un.rx[0],un.y-top-4); }
      if (un.task&&!un.taskDone){ var col={food:'#ffd54a',money:'#ffe27a',comb:'#e8b0a0'}[un.task]; ctx.strokeStyle=col; ctx.lineWidth=3; ctx.globalAlpha=0.6+0.3*Math.sin(G.t*4); ctx.beginPath(); ctx.ellipse(un.x,un.y-34,16,5,0,0,7); ctx.stroke(); ctx.globalAlpha=1;
        ctx.font='bold 11px '+FONT; ctx.lineWidth=3; ctx.strokeStyle='#0c0c0e'; ctx.textAlign='center'; var lb={food:'宵夜',money:'銀包',comb:'梳頭'}[un.task]; ctx.strokeText(lb,un.x,un.y-44); ctx.fillStyle=col; ctx.fillText(lb,un.x,un.y-44); }
      if (un.story){ var tx=(un.rx[0]+un.rx[1])/2, tt=G.story.indexOf(un.si)>=0?'✦已收集':'✦故事'; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#0c0c0e'; ctx.strokeText(tt,tx,top+14); ctx.fillStyle='#cfe8dc'; ctx.fillText(tt,tx,top+14); } });
    G.edges.forEach(drawWard);
    // 回陰間點
    ['f0_e','f'+FL+'_p'].forEach(function(id){ var n=G.nodes[id]; ctx.globalAlpha=0.5+0.3*Math.sin(G.t*2.5); ctx.fillStyle='#3fbf8f'; ctx.beginPath(); ctx.ellipse(n.x,n.y-4,26,9,0,0,7); ctx.fill(); ctx.globalAlpha=1; ctx.fillStyle='#e2e6e0'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#0c0c0e'; ctx.strokeText('回陰間',n.x,n.y-14); ctx.fillText('回陰間',n.x,n.y-14); });
    // 燈泡閃 + 冷霧
    for (var f=0;f<FL;f++){ var ly=fy(f+1)+18, fl=0.55+0.45*Math.sin(G.t*13+f*2.1)*Math.sin(G.t*3.7+f); if ((Math.floor(G.t*7+f*5)%23)===0) fl=0.1; if (G.dark[f]) fl=0;
      G.units.filter(function(u){return u.f===f;}).map(function(u){return (u.rx[0]+u.rx[1])/2;}).forEach(function(lx){ var gr=ctx.createRadialGradient(lx,ly,2,lx,ly,46); gr.addColorStop(0,'rgba(255,214,140,'+(0.32*fl)+')'); gr.addColorStop(1,'rgba(255,214,140,0)'); ctx.fillStyle=gr; ctx.fillRect(lx-46,ly-46,92,92); });
      for (var k=0;k<3;k++){ var fx=((G.t*(10+k*4)+k*200+f*90)%700)-50; ctx.fillStyle='rgba(180,220,210,0.07)'; ctx.beginPath(); ctx.ellipse(fx,fy(f)-6,70,9,0,0,7); ctx.fill(); }
      if (G.dark[f]){ ctx.fillStyle='rgba(0,0,0,'+Math.min(0.78,G.dark[f]*0.6)+')'; ctx.fillRect(0,fy(f+1)+8,WW,fy(f)-fy(f+1)-6); } }
    G.wardFx.forEach(function(w){ var a=w.t/0.9, gr=ctx.createRadialGradient(w.x,w.y-30,4,w.x,w.y-30,60); gr.addColorStop(0,'rgba(255,220,140,'+(0.7*a)+')'); gr.addColorStop(1,'rgba(255,220,140,0)'); ctx.fillStyle=gr; ctx.fillRect(w.x-60,w.y-90,120,120); ctx.strokeStyle='rgba(255,230,160,'+a+')'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(w.x,w.y-30,30+(1-a)*30,0,7); ctx.stroke(); });
    G.res.forEach(function(r){ if (r.state==='gone') return; ctx.fillStyle='rgba(0,0,0,0.45)'; ctx.beginPath(); ctx.ellipse(r.x,r.y-1,16,4,0,0,7); ctx.fill(); ctx.shadowColor='rgba(255,236,200,0.75)'; ctx.shadowBlur=5; var jy=r.jumpT>0?-Math.sin((0.5-r.jumpT)/0.5*Math.PI)*16:0, sh=(r.state==='home'&&r.fear>60)?Math.sin(G.t*40)*1.6:0, ro=0, sy=1;
      if (r.state==='flee'){ if (r.tripT>0){ ro=(r.vx>0?1:-1)*1.25; jy=-6; } else { jy=-Math.abs(Math.sin(G.t*16))*7; ro=(r.vx>0?1:-1)*0.18; } }
      if (r.tangle>0){ sh=Math.sin(G.t*30)*2; sy=0.96; }
      spr(r.sprite,r.x+sh,r.y+jy,58,{flip:r.vx<0,rot:ro,sy:sy}); ctx.shadowBlur=0; if (r.state==='flee'&&!r.tripT){ ctx.fillStyle='#fff'; ctx.font='bold 13px '+FONT; ctx.textAlign='center'; ctx.fillText('！！',r.x,r.y-66+jy); } if (r.state==='home'&&r.fear>0){ ctx.fillStyle='#1a1a1e'; ctx.fillRect(r.x-18,r.y-64,36,6); ctx.fillStyle='#d24a3a'; ctx.fillRect(r.x-18,r.y-64,36*r.fear/100,6); } if (r.say) bubble(r.x,r.y-68,r.say); });
    if (G.tao){ var T=G.tao, ty=fy(T.f); T.waves.forEach(function(w){ ctx.strokeStyle='rgba(255,215,90,'+(w.t*0.85)+')'; ctx.lineWidth=4; ctx.beginPath(); ctx.ellipse(T.x,ty-30,w.r,w.r*0.45,0,0,7); ctx.stroke(); });
      ctx.fillStyle='rgba(0,0,0,0.45)'; ctx.beginPath(); ctx.ellipse(T.x,ty-1,16,4,0,0,7); ctx.fill();
      ctx.shadowColor='rgba(255,215,90,0.9)'; ctx.shadowBlur=9; spr('npc_boss',T.x,ty,62,{flip:T.dir<0,oy:-Math.abs(Math.sin(G.t*6))*2}); ctx.shadowBlur=0;
      var bx=T.x+T.dir*16, byy=ty-40+Math.sin(G.t*14)*2; ctx.fillStyle='#e8b830'; ctx.beginPath(); ctx.moveTo(bx-6,byy+8); ctx.quadraticCurveTo(bx,byy-10,bx+6,byy+8); ctx.closePath(); ctx.fill(); ctx.strokeStyle='#5a3a10'; ctx.lineWidth=1; ctx.stroke();
      ctx.fillStyle='#ffe9a0'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; ctx.strokeText('天師',T.x,ty-70); ctx.fillText('天師',T.x,ty-70); if (T.sayT>0) bubble(T.x,ty-78,T.say); }
    G.gh.forEach(function(o){ if (o.sealT>0&&!o.home){ ctx.strokeStyle='rgba(255,215,90,0.7)'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(o.x,o.y-o.d.h*0.5,o.d.h*0.55,0,7); ctx.stroke(); } });
    G.guards.forEach(function(s){ var sw=Math.sin(G.t*2.4+s.x*0.01)*14; var bg=ctx.createLinearGradient(s.x,0,s.x+s.dir*150,0); bg.addColorStop(0,'rgba(255,245,180,0.38)'); bg.addColorStop(1,'rgba(255,245,180,0)'); ctx.fillStyle=bg; ctx.beginPath(); ctx.moveTo(s.x+s.dir*8,s.y-30); ctx.lineTo(s.x+s.dir*150,s.y-56+sw); ctx.lineTo(s.x+s.dir*150,s.y-4+sw*0.4); ctx.closePath(); ctx.fill(); s.alertT=Math.max(0,(s.alertT||0)-0.033);
      if (s.alertT>0){ ctx.fillStyle='#ffe25a'; ctx.strokeStyle='#000'; ctx.lineWidth=3; ctx.font='bold 26px '+FONT; ctx.textAlign='center'; var bob=Math.sin(G.t*20)*2; ctx.strokeText('！',s.x,s.y-74+bob); ctx.fillText('！',s.x,s.y-74+bob); } ctx.shadowColor='rgba(255,236,200,0.75)'; ctx.shadowBlur=5; sprite('npc_guard',s.x,s.y,62,s.dir<0); ctx.shadowBlur=0; if (s.say) bubble(s.x,s.y-68,s.say); });
    G.gh.forEach(function(o,i){ if (o.home) return; var n=G.nodes[o.node], inside=n.kind==='in'&&!o.to, hang=o.d.key==='tianhua'&&inside;
      var a=o.inv>0?0.35:(i===G.active?1:0.75); if (o.stun>0) a*=0.6+0.4*Math.sin(G.t*30);
      if (i===G.active){ ctx.fillStyle='rgba(110,255,190,0.40)'; ctx.beginPath(); ctx.ellipse(o.x,o.y-2,24,6,0,0,7); ctx.fill(); }
      var T=G.t+o.ph, k=o.d.key, ox=0, oy=0, ro=0, sx=1, sy=1, key=hang?'tianhua_hang':o.d.sprite, by=hang?o.y-50:o.y;
      if (o.hitT>0){ var h=o.hitT/0.8; ox=-(o.hitDir||1)*(1-h)*0+(o.hitDir||1)*h*14; ro=(o.hitDir||1)*0.25*h; a*=0.5+0.5*Math.abs(Math.sin(G.t*35)); }
      else if (o.actT>0){ var q=1-o.actT/0.9; // 蓄力→撲出→收招
        if (q<0.3){ var c=q/0.3; sx=sy=1-0.12*c; oy=2*c; ro=-o.dir*0.12*c; ctx.fillStyle='rgba(200,30,30,'+(0.35*c)+')'; ctx.beginPath(); ctx.arc(o.x,by-o.d.h*0.5,o.d.h*0.7,0,7); ctx.fill(); }
        else if (q<0.6){ var c=(q-0.3)/0.3; sx=sy=0.88+0.55*c; ox=o.dir*26*c; ro=o.dir*0.15*c; if (k==='tianhua') oy=-6*c; }
        else { var c=(q-0.6)/0.4; sx=sy=1.43-0.43*c; ox=o.dir*26*(1-c); }
        if (q>0.3&&q<0.75&&k==='tianhua'){ ctx.strokeStyle='rgba(20,20,24,0.85)'; ctx.lineWidth=2; for (var hs=0;hs<9;hs++){ var hx=o.x+o.dir*(10+hs*5); ctx.beginPath(); ctx.moveTo(hx,by-o.d.h); ctx.quadraticCurveTo(hx+Math.sin(G.t*9+hs)*6,by-o.d.h*0.4,hx+Math.sin(G.t*7+hs)*4,by+4); ctx.stroke(); } } }
      else if (o.taskP>0){ if (k==='eking'){ sy=1+0.09*Math.sin(G.t*18); sx=1-0.05*Math.sin(G.t*18); } else if (k==='toyol'){ ro=Math.sin(G.t*20)*0.14; oy=-Math.abs(Math.sin(G.t*10))*3; } else { ro=Math.sin(G.t*5)*0.08; }
        if (k==='tianhua'){ ctx.strokeStyle='rgba(30,30,34,0.8)'; ctx.lineWidth=1.5; for (var hs=0;hs<6;hs++){ var hx=o.x-8+hs*3; ctx.beginPath(); ctx.moveTo(hx,by-o.d.h*0.2); ctx.lineTo(hx+Math.sin(G.t*4+hs)*3,by+16+hs%2*6); ctx.stroke(); } } }
      else if (o.mv>0){ if (k==='eking'){ ro=Math.sin(T*8)*0.1; oy=-Math.abs(Math.sin(T*8))*3; } else if (k==='toyol'){ oy=-Math.abs(Math.sin(T*12))*9; sy=1+0.06*Math.sin(T*24); } else { ro=o.dir*0.12; oy=-4+Math.sin(T*6)*3; } }
      else { oy=Math.sin(T*2.5)*3-(k==='eking'?0:3); sy=1+0.025*Math.sin(T*2.5); }
      if (o.bounceT>0){ ox+=-o.dir*Math.sin(o.bounceT/0.45*Math.PI)*12; }
      ctx.shadowColor='rgba(140,255,200,0.85)'; ctx.shadowBlur=7; spr(key,o.x,by,o.d.h,{flip:o.dir<0,alpha:a,ox:ox,oy:oy,rot:ro,sx:sx,sy:sy}); ctx.shadowBlur=0;
      if (o.taskP>0){ ctx.strokeStyle='#8affc8'; ctx.lineWidth=4; ctx.beginPath(); ctx.arc(o.x,o.y-o.d.h-14,10,-Math.PI/2,-Math.PI/2+Math.PI*2*o.taskP); ctx.stroke(); } });
    G.parts.forEach(function(p){ var a=p.life/p.max; ctx.globalAlpha=Math.min(1,a*1.4);
      if (p.type==='coin'){ ctx.fillStyle='#ffd54a'; ctx.beginPath(); ctx.ellipse(p.x,p.y,4,4*Math.abs(Math.sin(G.t*12+p.x)),0,0,7); ctx.fill(); }
      else if (p.type==='crumb'){ ctx.fillStyle='#e8c07a'; ctx.fillRect(p.x,p.y,3,3); }
      else if (p.type==='sweat'){ ctx.fillStyle='#9fe0ff'; ctx.beginPath(); ctx.arc(p.x,p.y,2.5,0,7); ctx.fill(); }
      else if (p.type==='hair'){ ctx.strokeStyle='#222'; ctx.lineWidth=1; ctx.beginPath(); ctx.moveTo(p.x,p.y); ctx.lineTo(p.x+3,p.y+9); ctx.stroke(); }
      else if (p.type==='smoke'){ ctx.fillStyle='rgba(200,210,205,0.5)'; ctx.beginPath(); ctx.arc(p.x,p.y,4+(1-a)*10,0,7); ctx.fill(); }
      else if (p.type==='dust'){ ctx.fillStyle='rgba(180,170,150,0.5)'; ctx.beginPath(); ctx.arc(p.x,p.y,3+(1-a)*5,0,7); ctx.fill(); }
      else if (p.type==='suck'){ ctx.fillStyle='#d24a3a'; ctx.beginPath(); ctx.arc(p.x,p.y,3,0,7); ctx.fill(); }
      ctx.globalAlpha=1; });
    if (G.ult&&G.ult.t>=1.3){ var U=G.ult, uf=U.f, ut=U.t-1.3, top=fy(Math.min(FL,uf+1))+8, bot=fy(uf);
      if (U.g.d.key==='toyol'&&U.clones){ U.clones.forEach(function(c,j){ c.x+=c.v*0.033; if (c.x<60||c.x>540) c.v*=-1; spr('toyol',c.x,bot,40,{flip:c.v<0,alpha:0.75,oy:-Math.abs(Math.sin(G.t*14+j))*8}); if (Math.random()<0.3) part(c.x,bot-20,(Math.random()-0.5)*60,-80,0.6,'coin'); }); }
      if (U.g.d.key==='tianhua'){ ctx.strokeStyle='rgba(12,12,14,0.9)'; ctx.lineWidth=2.2; var len=Math.min(1,ut*1.2)*(bot-top); for (var hx=70;hx<540;hx+=7){ ctx.beginPath(); ctx.moveTo(hx,top); ctx.quadraticCurveTo(hx+Math.sin(G.t*3+hx)*10,top+len*0.5,hx+Math.sin(G.t*2+hx*0.3)*8,top+len); ctx.stroke(); } }
      if (U.g.d.key==='eking'){ var cx=U.g.x, cy=U.g.y-30, r=40+ut*80; ctx.strokeStyle='rgba(210,74,58,'+Math.max(0,0.8-ut*0.3)+')'; ctx.lineWidth=4; ctx.beginPath(); ctx.arc(cx,cy,r,0,7); ctx.stroke(); } }
    G.floats.forEach(function(f){ ctx.globalAlpha=Math.min(1,f.life); ctx.font='bold 13px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#0a0a0c'; ctx.strokeText(f.t,f.x,f.y); ctx.fillStyle=f.c; ctx.fillText(f.t,f.x,f.y); ctx.globalAlpha=1; });
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
    // 頂：時辰 + 天光倒數 + 怕意
    ctx.fillStyle='#111114'; ctx.fillRect(0,0,VW,TOP);
    var left=Math.max(0,NIGHT-G.t), fr=G.t/NIGHT;
    ctx.fillStyle='#1e1e24'; rr(12,10,VW-24,14,7); ctx.fill(); var gr=ctx.createLinearGradient(12,0,VW-12,0); gr.addColorStop(0,'#1e3a32'); gr.addColorStop(0.66,'#5a2a22'); gr.addColorStop(1,'#d07a3a'); ctx.fillStyle=gr; rr(12,10,(VW-24)*fr+1,14,7); ctx.fill();
    ctx.font='bold 15px '+FONT; ctx.fillStyle='#fff'; ctx.textAlign='left'; ctx.fillText(PH[G.phase]+'　距離天光 '+Math.ceil(left)+' 秒',14,46);
    ctx.textAlign='right'; ctx.fillStyle='#9fd6bf'; ctx.fillText('怕意 '+G.fear+'/'+G.fearNext,VW-14,46);
    ctx.font='13px '+FONT; ctx.fillStyle='#c8ccc4'; ctx.textAlign='left'; var lt=G.gh.map(function(o){return o.d.name+(o.home?'✓':'')+' '+o.loot;}).join('　'); ctx.fillText('收穫：'+lt,14,68);
    btn('story',VW-86,52,74,22,'故事 '+G.story.length+'/5','#2e3a34');
    btn('zin',VW-50,TOP+8,40,36,'＋','#24242a'); btn('zout',VW-50,TOP+50,40,36,'－','#24242a');
    // 底：鬼頭像 + 按鈕
    var y0=VH-BOT; ctx.fillStyle='#111114'; ctx.fillRect(0,y0,VW,BOT);
    if (G.toastT>0&&G.toast){ ctx.fillStyle='rgba(18,18,22,0.95)'; rr(10,y0-56,VW-20,50,10); ctx.fill(); ctx.fillStyle='#fff3c8'; ctx.font='13px '+FONT; ctx.textAlign='left'; wrap(G.toast,20,y0-36,VW-40,17); }
    G.gh.forEach(function(o,i){ var x=10+i*72, y=y0+12; buttons.push({id:'gh'+i,x:x,y:y,w:64,h:74}); ctx.fillStyle=i===G.active?'#2f5a4a':'#24242a'; ctx.strokeStyle=i===G.active?'#8affc8':'#4a4a50'; ctx.lineWidth=2; rr(x,y,64,74,10); ctx.fill(); ctx.stroke();
      if (o.energy>=100&&!o.home){ ctx.fillStyle='rgba(255,200,90,'+(0.35+0.25*Math.sin(G.t*8))+')'; rr(x-2,y-2,68,78,12); ctx.fill(); } sprite(o.d.sprite,x+32,y+58,46,false,o.home?0.4:1); ctx.fillStyle='#000'; ctx.fillRect(x+6,y+4,52,5); ctx.fillStyle=o.energy>=100?'#ffcc55':'#d24a3a'; ctx.fillRect(x+6,y+4,52*o.energy/100,5); if (o.energy>=100&&!o.home){ ctx.fillStyle='#ffe9a0'; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.fillText('點我放大招',x+32,y+20); } ctx.fillStyle='#fff'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.fillText(o.home?'已返':o.d.name,x+32,y+70); });
    var g=G.gh[G.active], n=G.nodes[g.node], atP=!g.to&&n.kind==='portal'&&!g.home;
    btn('scare',VW-170,y0+12,74,52,'嚇！','#6e1c1c');
    btn('inv',VW-88,y0+12,76,52,g.invCd>0?'隱身 '+Math.ceil(g.invCd):'隱身','#2a4a7a',g.invCd<=0);
    btn('home',10,y0+98,VW-20,44,atP?'返陰間（喺回陰間點嘅鬼帶走收穫）':'返陰間：行去天台或地下嘅綠色回陰間點','#5a1c1c',atP);
    ctx.fillStyle='#7a7f78'; ctx.font='12px '+FONT; ctx.textAlign='center'; ctx.fillText('按住畫面拖動＝搖桿；門口向上推入屋、樓梯上落換層',VW/2,VH-14);
    if (G.choice) drawChoice(); if (G.showStory) drawStory(); if (G.over) drawOver();
  }
  function wrap(t,x,y,w,lh){ var line='',yy=y; for (var i=0;i<t.length;i++){ var tt=line+t[i]; if (ctx.measureText(tt).width>w){ ctx.fillText(line,x,yy); line=t[i]; yy+=lh; } else line=tt; } ctx.fillText(line,x,yy); return yy; }
  function panel(h){ ctx.fillStyle='rgba(4,4,6,0.75)'; ctx.fillRect(0,0,VW,VH); var y=(VH-h)/2; ctx.fillStyle='#17171b'; ctx.strokeStyle='#9fd6bf'; ctx.lineWidth=2; rr(16,y,VW-32,h,16); ctx.fill(); ctx.stroke(); buttons=[]; return y; }
  function drawChoice(){ var h=330, y=VH-h-8; ctx.fillStyle='rgba(4,4,6,0.35)'; ctx.fillRect(0,0,VW,VH); ctx.fillStyle='#17171b'; ctx.strokeStyle='#9fd6bf'; ctx.lineWidth=2; rr(10,y,VW-20,h,16); ctx.fill(); ctx.stroke(); buttons=[]; ctx.fillStyle='#fff'; ctx.font='bold 19px '+FONT; ctx.textAlign='center'; ctx.fillText('怕意滿咗！揀一樣強化',VW/2,y+36);
    G.choice.forEach(function(c,i){ var by=y+52+i*88; btn('card'+i,26,by,VW-52,78,'', '#26262c'); ctx.fillStyle='#ffd54a'; ctx.font='bold 18px '+FONT; ctx.fillText(c.t,VW/2,by+32); ctx.fillStyle='#d6dad2'; ctx.font='14px '+FONT; ctx.fillText(c.d,VW/2,by+58); }); }
  function drawStory(){ var y=panel(440); ctx.fillStyle='#fff'; ctx.font='bold 18px '+FONT; ctx.textAlign='center'; ctx.fillText(LV.name+'嘅故事（'+G.story.length+'/5）',VW/2,y+34); ctx.textAlign='left'; ctx.font='13px '+FONT; var yy=y+64;
    for (var f=0;f<5;f++){ ctx.fillStyle=G.story.indexOf(f)>=0?'#ecece6':'#5a5e58'; yy=wrap(G.story.indexOf(f)>=0?STORY[f]:LV.hint[f]+'：？？？（嚇走有「✦故事」嘅住戶）',32,yy,VW-64,18)+28; }
    if (G.story.length===5){ ctx.fillStyle='#ffd54a'; wrap(TRUTH,32,yy,VW-64,18); }
    btn('closeStory',VW/2-60,y+440-54,120,40,'返去','#5a1c1c'); }
  function drawOver(){ var o=G.over, y=panel(400); ctx.textAlign='center'; ctx.fillStyle=o.ok?'#8affc8':'#ff9a9a'; ctx.font='bold 24px '+FONT;
    ctx.fillText(o.ok?'安全返到陰間！':'天光喇……',VW/2,y+44); ctx.fillStyle='#fff'; ctx.font='15px '+FONT;
    var msg=o.ok?['返到陰間嘅鬼：'+o.home+' 隻','帶走收穫：'+o.kept, o.lost?'未返到嘅鬼跌咗收穫：'+o.lost:'全部鬼都齊齊返到','今晚怕意總共：'+o.fear,'故事碎片：'+o.story+'/5']:['鬼未返到陰間，天光一照，今晚收穫全部散晒','損失收穫：'+o.lost,'今晚怕意總共：'+o.fear,'故事碎片：'+o.story+'/5'];
    msg.forEach(function(m,i){ ctx.fillText(m,VW/2,y+90+i*30); });
    if (o.story===5){ ctx.fillStyle='#ffd54a'; ctx.font='13px '+FONT; ctx.textAlign='left'; wrap(TRUTH,36,y+250,VW-72,18); }
    btn('again',VW/2-130,y+400-60,120,44,'再嚟一晚','#5a1c1c'); btn('title',VW/2+10,y+400-60,120,44,'返主頁','#2c2c33'); }
  function drawTitle(){ ctx.fillStyle='#0e0e11'; ctx.fillRect(0,0,VW,VH); ctx.textAlign='center'; ctx.fillStyle='#e2e6e0'; ctx.font='bold 34px '+FONT; ctx.fillText('樓裡有鬼',VW/2,VH*0.24); ctx.font='16px '+FONT; ctx.fillStyle='#9fd6bf'; ctx.fillText('揀一棟樓・天光前返陰間',VW/2,VH*0.24+34);
    GH.forEach(function(d,i){ sprite(d.sprite,VW/2+(i-1)*100,VH*0.52,d.h*1.5); });
    ctx.fillStyle='#c8ccc4'; ctx.font='14px '+FONT; ['三隻鬼一齊出動：餓鬼搵宵夜、Toyol 偷錢、天花姐梳頭。','有紅紙符、門神、拿督公嘅單位要尊重，繞路行。','鐵閘得 Toyol 鑽得入，糯米得天花姐過得去。','子時→丑時→寅時，天光前一定要返陰間。'].forEach(function(t,i){ ctx.fillText(t,VW/2,VH*0.62+i*24,VW-30); });
    var sv={}; try{ sv=JSON.parse(localStorage.getItem('lyg_pangsa')||'{}'); }catch(e){} var shopOpen=!!sv.clear_flat||Q.has('unlock');
    btn('lv_flat',22,VH*0.80,(VW-56)/2,58,'組屋'+(sv.clear_flat?' ✓':''),'#5a1c1c'); btn('lv_shop',34+(VW-56)/2,VH*0.80,(VW-56)/2,58,shopOpen?'老店屋'+(sv.clear_shop?' ✓':''):'老店屋（未解鎖）','#2f5a4a',shopOpen);
    ctx.fillStyle='#7a7f78'; ctx.font='12px '+FONT; ctx.textAlign='center'; ctx.fillText(shopOpen?'揀一棟樓開始今晚':'組屋過關（安全返陰間）就解鎖老店屋',VW/2,VH*0.80+78); }

  // ---------- 輸入 ----------
  var joy=null, ptr=null, JR=58, pts={}, pinch=null;
  cv.addEventListener('pointerdown',function(e){ var p=pt(e); pts[e.pointerId]=p; var ids=Object.keys(pts); if (ids.length===2){ var a=pts[ids[0]],b=pts[ids[1]]; pinch={d:Math.hypot(a.x-b.x,a.y-b.y),z:cam.z}; joy=null; ptr=null; return; } ptr={sx:p.x,sy:p.y,drag:false}; if (scene==='play'&&!G.over&&!G.choice&&!G.showStory&&p.y>TOP&&p.y<VH-BOT) joy={ox:p.x,oy:p.y,x:p.x,y:p.y,on:false}; try{cv.setPointerCapture(e.pointerId);}catch(_){} });
  cv.addEventListener('pointermove',function(e){ var p=pt(e); if (pts[e.pointerId]) pts[e.pointerId]=p; if (pinch){ var ids=Object.keys(pts); if (ids.length===2){ var a=pts[ids[0]],b=pts[ids[1]]; cam.z=clamp(pinch.z*Math.hypot(a.x-b.x,a.y-b.y)/pinch.d,1,2.6); } return; } if(!ptr) return; if (Math.hypot(p.x-ptr.sx,p.y-ptr.sy)>10) ptr.drag=true; if (joy){ joy.x=p.x; joy.y=p.y; if (ptr.drag) joy.on=true; } });
  cv.addEventListener('pointerup',function(e){ delete pts[e.pointerId]; if (pinch){ if (!Object.keys(pts).length) pinch=null; return; } var p=pt(e), was=ptr; ptr=null; var j=joy&&joy.on; joy=null; if (was&&!was.drag&&!j) tap(p.x,p.y); });
  cv.addEventListener('pointercancel',function(e){ delete pts[e.pointerId]; pinch=null; ptr=null; joy=null; });
  function pt(e){ var r=cv.getBoundingClientRect(); return {x:e.clientX-r.left,y:e.clientY-r.top}; }
  function joyVec(){ if (!joy||!joy.on) return null; var dx=joy.x-joy.ox, dy=joy.y-joy.oy, L=Math.hypot(dx,dy); if (L>JR){ dx*=JR/L; dy*=JR/L; } return {x:dx/JR,y:dy/JR}; }
  function drawJoy(){ if (!joy||!joy.on) return; var v=joyVec(); ctx.setTransform(DPR,0,0,DPR,0,0); ctx.fillStyle='rgba(10,10,12,0.5)'; ctx.strokeStyle='rgba(170,200,185,0.55)'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(joy.ox,joy.oy,JR,0,7); ctx.fill(); ctx.stroke(); ctx.fillStyle='rgba(138,255,200,0.85)'; ctx.beginPath(); ctx.arc(joy.ox+v.x*JR,joy.oy+v.y*JR,24,0,7); ctx.fill(); }
  function tap(x,y){ for (var i=buttons.length-1;i>=0;i--){ var b=buttons[i]; if (x>=b.x&&x<=b.x+b.w&&y>=b.y&&y<=b.y+b.h){ press(b.id); return; } } }
  function press(id){
    if (id==='lv_flat'||id==='start'){ newGame(null,'flat'); bake(); return; }
    if (id==='lv_shop'){ var sv={}; try{ sv=JSON.parse(localStorage.getItem('lyg_pangsa')||'{}'); }catch(e){} if (sv.clear_flat||Q.has('unlock')){ newGame(null,'shop'); bake(); } return; }
    if (id==='again'){ newGame(); bake(); return; } if (id==='title'){ scene='title'; return; }
    if (scene!=='play') return;
    if (id.indexOf('card')===0){ chooseCard(+id.slice(4)); return; }
    if (id==='zin'){ cam.z=Math.min(2.6,cam.z*1.25); return; } if (id==='zout'){ cam.z=Math.max(1,cam.z/1.25); return; }
    if (id==='story'){ G.showStory=true; return; } if (id==='closeStory'){ G.showStory=false; return; }
    if (G.over||G.choice||G.showStory) return;
    if (id.indexOf('gh')===0){ var i=+id.slice(2); if (G.gh[i].home) return; if (i===G.active&&G.gh[i].energy>=100){ ultPress(i); return; } G.active=i; toast(GH[i].tip+(G.gh[i].energy>=100?'（能量滿！再點頭像放大招）':'')); return; }
    if (id==='scare') scarePress(); if (id==='inv') invPress(); if (id==='home') goHome();
  }
  var last=0;
  function frame(ts){ requestAnimationFrame(frame); if (!last) last=ts; var dt=(ts-last)/1000; if (dt<1/31) return; last=ts; dt=Math.min(dt,0.1);
    if (scene==='play'&&!G.showStory){ var v=joyVec(); if (v&&!G.choice&&!G.over){ G.gh[G.active].auto=null; joyMove(G.gh[G.active],v.x,v.y,dt); } update(dt); }
    draw(); drawJoy(); }
  // 測試介面
  window.TW={ult:ultPress, press:press, tap:tap, goto:function(i,id){ return gotoNode(G.gh[i],id); }, choose:chooseCard, skip:function(s){ G.t+=s; }, get G(){return G;}, set G(v){}, w2s:function(x,y){return W2S(x,y);}};
  window.addEventListener('resize',resize); resize();
  (function load(cb){ var ks=Object.keys(window.LYG_IMG||{}), n=ks.length; if(!n) return cb(); ks.forEach(function(k){ var im=new Image(); im.onload=im.onerror=function(){ if(--n===0) cb(); }; im.src=LYG_IMG[k]; IMG[k]=im; }); })(function(){ requestAnimationFrame(frame); });
})();
