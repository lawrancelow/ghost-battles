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
      if (!g.to && n.kind==='door'){ var du=unitByDoor(n.id); g.injT=st?(g.injT||0)+dt:0; if (du && !du.open && du.ot===2 && g.injT>=0.5){ g.injAcc=(g.injAcc||0)+dt; while (g.injAcc>=0.1 && G.fear>0 && du.paid<du.cost){ g.injAcc-=0.1; G.fear--; du.paid++; if (rnd()<0.6) part(g.x,g.y-40,(du.x-g.x)*2,-20,0.5,'suck'); }
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
    checkAlert(); taoUpdate(dt); gateUpdate(dt);
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
    var sp=H.sp*(h.boost||1)*(G.gate?(G.gate.t>20?2:1.5):1)*(1+0.12*G.phase); if (tg&&chaser) sp*=Math.pow(1.4,Math.abs(G.nodes[tg.node].f-a.f)); sp=Math.min(sp,320);
    h.p+=sp*dt/D; if (b.x!==a.x) h.dir=b.x>a.x?1:-1;
    if (h.p>=1){ h.node=h.to; h.to=null; h.p=0; h.wait=chaser?0:0.3+rnd()*0.8; }
    var p=posOf(h); h.x=p.x; h.y=p.y;
    // 撞到鬼
    G.gh.forEach(function(g){ if (g.home||g.out||g.inv>0||g.stun>0||(h.catchCd||0)>0) return; if (Math.abs(g.y-h.y)>30||Math.abs(g.x-h.x)>18) return;
      if (h.kind==='dog'){ g.stun=1; G.alert+=1; checkAlert(); float(g.x,g.y-80,'狗吠到成棟樓醒晒！','#ffb0b0'); h.catchCd=2; return; }
      if (h.kind==='decoy'&&!h.real) return; if (h.kind==='guard'&&h.state!=='chase') return;
      catchGhost(g,h); h.catchCd=2.2; });
    h.catchCd=Math.max(0,(h.catchCd||0)-dt);
  }
  function catchGhost(g,h){
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
    ['f0_e','f'+FL+'_p'].forEach(function(id){ if (G.gate&&G.gate.node!==id) return; var n=G.nodes[id]; ctx.globalAlpha=0.5+0.3*Math.sin(G.t*2.5); ctx.fillStyle='#3fbf8f'; ctx.beginPath(); ctx.ellipse(n.x,n.y-4,26,9,0,0,7); ctx.fill(); ctx.globalAlpha=1; ctx.fillStyle='#e2e6e0'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#0c0c0e'; ctx.strokeText('回陰間',n.x,n.y-14); ctx.fillText('回陰間',n.x,n.y-14); });
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
    G.guards.forEach(function(s){ var H=HUM[s.kind]; s.alertT=Math.max(0,(s.alertT||0)-0.0);
      if (s.kind==='guard'||s.kind==='compass'){ var sw=Math.sin(G.t*2.4+s.x*0.01)*14; var bg=ctx.createLinearGradient(s.x,0,s.x+s.dir*150,0); bg.addColorStop(0,'rgba(255,245,180,'+(s.state==='chase'||s.kind==='compass'?0.45:0.3)+')'); bg.addColorStop(1,'rgba(255,245,180,0)'); ctx.fillStyle=bg; ctx.beginPath(); ctx.moveTo(s.x+s.dir*8,s.y-30); ctx.lineTo(s.x+s.dir*150,s.y-56+sw); ctx.lineTo(s.x+s.dir*150,s.y-4+sw*0.4); ctx.closePath(); ctx.fill(); }
      ctx.fillStyle='rgba(0,0,0,0.45)'; ctx.beginPath(); ctx.ellipse(s.x,s.y-1,16,4,0,0,7); ctx.fill();
      var bob=-Math.abs(Math.sin(G.t*(s.kind==='dog'?18:8)+s.x))*(s.kind==='dog'?5:2), fl=s.state==='flee'?s.vx<0:s.dir<0;
      if (s.kind==='dog'){ ctx.save(); ctx.translate(s.x,s.y+bob); ctx.scale(fl?-1:1,1); ctx.fillStyle='#3a2e24'; ctx.strokeStyle='#e8d8b0'; ctx.lineWidth=1.5; ctx.beginPath(); ctx.ellipse(0,-14,20,9,0,0,7); ctx.fill(); ctx.stroke(); ctx.beginPath(); ctx.ellipse(18,-22,9,7,0,0,7); ctx.fill(); ctx.stroke(); ctx.fillStyle='#ff4a3a'; ctx.fillRect(21,-25,3,3); ctx.strokeStyle='#3a2e24'; ctx.lineWidth=3; [-12,-4,6,12].forEach(function(lx,k){ ctx.beginPath(); ctx.moveTo(lx,-8); ctx.lineTo(lx+Math.sin(G.t*20+k)*4,0); ctx.stroke(); }); ctx.beginPath(); ctx.moveTo(-19,-16); ctx.lineTo(-28,-24+Math.sin(G.t*25)*3); ctx.stroke(); ctx.restore(); }
      else { ctx.shadowColor=s.kind==='mirror'||s.kind==='decoy'?'rgba(255,215,90,0.8)':'rgba(255,236,200,0.75)'; ctx.shadowBlur=6; spr(H.spr,s.x,s.y+bob,H.h,{flip:fl,alpha:s.kind==='decoy'?0.88:1,rot:s.state==='flee'?(s.vx>0?0.2:-0.2):0}); ctx.shadowBlur=0; }
      if (s.kind==='mirror'){ var mx=s.x+s.dir*14, my=s.y-40; ctx.fillStyle='#d8c070'; ctx.beginPath(); ctx.arc(mx,my,8,0,7); ctx.fill(); ctx.fillStyle='rgba(220,245,255,'+(0.6+0.3*Math.sin(G.t*6))+')'; ctx.beginPath(); ctx.arc(mx,my,5.5,0,7); ctx.fill(); var mg=ctx.createLinearGradient(mx,0,mx+s.dir*220,0); mg.addColorStop(0,'rgba(220,245,255,0.25)'); mg.addColorStop(1,'rgba(220,245,255,0)'); ctx.fillStyle=mg; ctx.beginPath(); ctx.moveTo(mx,my); ctx.lineTo(mx+s.dir*220,my-26); ctx.lineTo(mx+s.dir*220,my+26); ctx.closePath(); ctx.fill(); }
      if (s.kind==='compass'){ ctx.fillStyle='#c8a050'; ctx.beginPath(); ctx.arc(s.x+s.dir*12,s.y-30,6,0,7); ctx.fill(); ctx.strokeStyle='#600'; ctx.lineWidth=1.5; var na=G.t*7; ctx.beginPath(); ctx.moveTo(s.x+s.dir*12,s.y-30); ctx.lineTo(s.x+s.dir*12+Math.cos(na)*5,s.y-30+Math.sin(na)*5); ctx.stroke(); for (var q=0;q<s.courage;q++){ ctx.fillStyle='#ffd54a'; ctx.fillRect(s.x-12+q*5,s.y-H.h-10,4,4); } }
      var lab=H.n; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; ctx.strokeText(lab,s.x,s.y-H.h-14); ctx.fillStyle=s.kind==='guard'?'#e8e4dc':'#ffe9a0'; ctx.fillText(lab,s.x,s.y-H.h-14);
      if (s.alertT>0){ ctx.fillStyle='#ffe25a'; ctx.strokeStyle='#000'; ctx.lineWidth=3; ctx.font='bold 26px '+FONT; ctx.textAlign='center'; var bb=Math.sin(G.t*20)*2; ctx.strokeText('！',s.x,s.y-H.h-24+bb); ctx.fillText('！',s.x,s.y-H.h-24+bb); }
      if (s.say) bubble(s.x,s.y-H.h-30,s.say); });
    // 房間遮罩：未踩點=黑屋；鎖住=鎖頭/注入進度/鎖匙；門閂住=木門
    G.units.forEach(function(u){ var top=fy(u.f+1)+16, w=u.rx[1]-u.rx[0], hgt=u.y-top-4;
      if (!u.seen){ ctx.fillStyle='rgba(2,2,4,'+(u.open?0.82:0.9)+')'; ctx.fillRect(u.rx[0],top,w,hgt); if (u.unlockFx>0){ ctx.strokeStyle='rgba(159,214,191,'+u.unlockFx+')'; ctx.lineWidth=3; ctx.strokeRect(u.rx[0]+2,top+2,w-4,hgt-4); } }
      if (!u.open && u.ot!=='deity'){ var cx=(u.rx[0]+u.rx[1])/2, cy=top+hgt*0.5; ctx.fillStyle='rgba(0,0,0,0.6)'; ctx.beginPath(); ctx.arc(cx,cy,20,0,7); ctx.fill(); ctx.strokeStyle='#c8a050'; ctx.lineWidth=2.5; ctx.beginPath(); ctx.arc(cx,cy-5,6,Math.PI,0); ctx.stroke(); ctx.fillStyle='#c8a050'; ctx.fillRect(cx-8,cy-4,16,12);
        var tx=u.ot===2?('破鎮宅 '+u.paid+'/'+u.cost):u.ot===11?'要鎖匙':'隔籬未亂'; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; ctx.strokeText(tx,cx,cy+30); ctx.fillStyle='#ffe9a0'; ctx.fillText(tx,cx,cy+30);
        if (u.ot===2&&u.paid>0){ ctx.strokeStyle='#9fd6bf'; ctx.lineWidth=4; ctx.beginPath(); ctx.arc(cx,cy,24,-Math.PI/2,-Math.PI/2+Math.PI*2*u.paid/u.cost); ctx.stroke(); } }
      if (u.door){ var dx=u.x, a=u.doorOpen>0?0.25:1; ctx.globalAlpha=a; ctx.fillStyle='#4a3020'; ctx.fillRect(dx-12,u.y-62,24,58); ctx.strokeStyle='#c8a050'; ctx.lineWidth=2; ctx.strokeRect(dx-12,u.y-62,24,58); ctx.fillStyle='#c8a050'; ctx.fillRect(dx+6,u.y-34,3,3); ctx.globalAlpha=1; if (u.doorOpen>0){ ctx.fillStyle='#9fd6bf'; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.fillText('門開咗！',dx,u.y-68); } }
      if (u.seen && u.items.length && u.open){ var ix=(u.rx[0]+u.rx[1])/2; ctx.font='10px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; var tt=u.items.map(function(k){return ITEM[k].n;}).join('·'); ctx.strokeText(tt,ix,top+28); ctx.fillStyle='#e8d8b0'; ctx.fillText(tt,ix,top+28); } });
    if (G.gate||G.gateCharge>0){ var gn=G.nodes[G.gate?G.gate.node:G.gh[G.gateG].node], rr2=G.gate?40+Math.sin(G.t*4)*6:20*G.gateCharge; var gg=ctx.createRadialGradient(gn.x,gn.y-40,4,gn.x,gn.y-40,rr2*1.8); gg.addColorStop(0,'rgba(120,255,200,0.75)'); gg.addColorStop(1,'rgba(40,120,90,0)'); ctx.fillStyle=gg; ctx.beginPath(); ctx.arc(gn.x,gn.y-40,rr2*1.8,0,7); ctx.fill(); ctx.strokeStyle='rgba(160,255,210,0.8)'; ctx.lineWidth=3; for (var q=0;q<3;q++){ ctx.beginPath(); ctx.arc(gn.x,gn.y-40,rr2*(0.5+q*0.3),G.t*(2+q),G.t*(2+q)+4); ctx.stroke(); } }
    G.gh.forEach(function(o,i){ if (o.home||o.out) return; var n=G.nodes[o.node], inside=n.kind==='in'&&!o.to, hang=o.d.key==='tianhua'&&inside;
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
      if (i===G.active&&!o.to&&o.still>=0.1&&o.mv<=0){ ctx.strokeStyle='rgba(138,255,200,0.55)'; ctx.setLineDash([4,4]); ctx.beginPath(); ctx.ellipse(o.x,o.y-2,30,8,0,0,7); ctx.stroke(); ctx.setLineDash([]); }
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
    var fr=Math.min(1,G.t/(PHT*3));
    ctx.fillStyle='#1e1e24'; rr(12,10,VW-24,14,7); ctx.fill(); var gr=ctx.createLinearGradient(12,0,VW-12,0); gr.addColorStop(0,'#1e3a32'); gr.addColorStop(0.66,'#5a2a22'); gr.addColorStop(1,'#d07a3a'); ctx.fillStyle=gr; rr(12,10,(VW-24)*fr+1,14,7); ctx.fill();
    ctx.font='bold 15px '+FONT; ctx.fillStyle='#fff'; ctx.textAlign='left'; ctx.fillText((G.gate?'陰門死守 '+Math.ceil(30-G.gate.t)+' 秒　':'')+(G.phase<3?PH[G.phase]+'　天光進度 '+Math.floor(fr*100)+'%':'天光後・追兵第 '+G.wave+' 輪')+'　警覺 '+G.alert,14,46); 
    ctx.textAlign='right'; ctx.fillStyle='#9fd6bf'; ctx.fillText('怕意 '+G.fear,VW-14,46);
    ctx.font='13px '+FONT; ctx.fillStyle='#c8ccc4'; ctx.textAlign='left'; ctx.fillText('收穫 '+G.bag.length+'/'+BAGMAX+'　紙人 '+G.dolls+'/6　鎖匙 '+(G.keys.key||0),14,68);
    btn('story',VW-86,52,74,22,'故事 '+G.story.length+'/5','#2e3a34');
    btn('zin',VW-50,TOP+8,40,36,'＋','#24242a'); btn('zout',VW-50,TOP+50,40,36,'－','#24242a');
    // 底：鬼頭像 + 按鈕
    var y0=VH-BOT; ctx.fillStyle='#111114'; ctx.fillRect(0,y0,VW,BOT);
    if (G.toastT>0&&G.toast){ ctx.fillStyle='rgba(18,18,22,0.95)'; rr(10,y0-56,VW-20,50,10); ctx.fill(); ctx.fillStyle='#fff3c8'; ctx.font='13px '+FONT; ctx.textAlign='left'; wrap(G.toast,20,y0-36,VW-40,17); }
    G.gh.forEach(function(o,i){ var x=10+i*72, y=y0+12; buttons.push({id:'gh'+i,x:x,y:y,w:64,h:74}); ctx.fillStyle=i===G.active?'#2f5a4a':'#24242a'; ctx.strokeStyle=i===G.active?'#8affc8':'#4a4a50'; ctx.lineWidth=2; rr(x,y,64,74,10); ctx.fill(); ctx.stroke();
      if (o.energy>=100&&!o.home){ ctx.fillStyle='rgba(255,200,90,'+(0.35+0.25*Math.sin(G.t*8))+')'; rr(x-2,y-2,68,78,12); ctx.fill(); } sprite(o.d.sprite,x+32,y+58,46,false,o.home||o.out?0.3:1); ctx.fillStyle='#000'; ctx.fillRect(x+6,y+4,52,5); ctx.fillStyle=o.energy>=100?'#ffcc55':'#d24a3a'; ctx.fillRect(x+6,y+4,52*o.energy/100,5); if (o.energy>=100&&!o.home){ ctx.fillStyle='#ffe9a0'; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.fillText('點我放大招',x+32,y+20); } ctx.fillStyle='#fff'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.fillText(o.out?'被收服':o.home?'已返':o.d.name+(o.caught?' '+o.caught+'/3':''),x+32,y+70); });
    var g=G.gh[G.active], n=G.nodes[g.node], atP=!g.to&&n.kind==='portal'&&!g.home;
    btn('scare',VW-170,y0+12,74,52,'嚇！','#6e1c1c');
    btn('inv',VW-88,y0+12,76,52,g.invCd>0?'隱身 '+Math.ceil(g.invCd):'隱身','#2a4a7a',g.invCd<=0);
    var hw=(VW-30)/2; btn('gate',10,y0+98,hw,44,G.gate?'陰門 '+Math.ceil(30-G.gate.t)+'s':atP?'開陰門（企定）':'陰門：天台/地下','#2f5a4a',atP&&!G.gate); btn('doll',20+hw,y0+98,hw,44,'替身遁走 '+G.dolls+'/6','#5a1c1c',G.dolls>=6&&!G.gate);
    ctx.fillStyle='#7a7f78'; ctx.font='12px '+FONT; ctx.textAlign='center'; ctx.fillText('拖動＝移動；鬆手企定先嚇得人、搜得嘢、破得鎮宅',VW/2,VH-14);
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
  function drawOver(){ var o=G.over, y=panel(420); ctx.textAlign='center'; ctx.fillStyle=o.ok?'#8affc8':'#ff9a9a'; ctx.font='bold 24px '+FONT;
    ctx.fillText(o.why==='gate'?'陰門撤離成功！':o.why==='doll'?'替身遁走！':'被圍收服……',VW/2,y+44); ctx.fillStyle='#fff'; ctx.font='15px '+FONT;
    var msg=o.why==='gate'?['返到陰間嘅鬼：'+o.home+' 隻','帶走全部收穫：'+o.kept+' 件','收服故事碎片：'+o.story+'/5','今晚怕意總共：'+o.fear,'全樓警覺：'+o.alert]
      :o.why==='doll'?['用替身紙人遁走：'+o.home+' 隻鬼','帶走一半收穫：'+o.kept+' 件（留低 '+o.lost+' 件）','故事碎片冇得帶走（'+o.storyLost+' 塊留咗喺樓入面）','今晚怕意總共：'+o.fear]
      :['三隻鬼全部畀人收服','收穫全部冇晒：'+o.lost+' 件','今晚怕意總共：'+o.fear,'全樓警覺：'+o.alert];
    msg.forEach(function(m,i){ ctx.fillText(m,VW/2,y+90+i*30,VW-50); });
    if (o.story===5){ ctx.fillStyle='#ffd54a'; ctx.font='13px '+FONT; ctx.textAlign='left'; wrap(TRUTH,36,y+250,VW-72,18); }
    btn('again',VW/2-130,y+420-60,120,44,'再嚟一晚','#5a1c1c'); btn('title',VW/2+10,y+420-60,120,44,'返主頁','#2c2c33'); }
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
    if (id==='scare') scarePress(); if (id==='inv') invPress(); if (id==='gate') gatePress(); if (id==='doll') dollEscape();
  }
  var last=0;
  function frame(ts){ requestAnimationFrame(frame); if (!last) last=ts; var dt=(ts-last)/1000; if (dt<1/31) return; last=ts; dt=Math.min(dt,0.1);
    if (scene==='play'&&!G.showStory){ var v=joyVec(); if (v&&!G.choice&&!G.over){ G.gh[G.active].auto=null; joyMove(G.gh[G.active],v.x,v.y,dt); } update(dt); }
    draw(); drawJoy(); }
  // 測試介面
  window.TW={gate:gatePress, doll:dollEscape, catchG:function(i){ catchGhost(G.gh[i],G.guards[0]||{dir:1}); }, ult:ultPress, press:press, tap:tap, goto:function(i,id){ return gotoNode(G.gh[i],id); }, choose:chooseCard, skip:function(s){ G.t+=s; }, get G(){return G;}, set G(v){}, w2s:function(x,y){return W2S(x,y);}};
  window.addEventListener('resize',resize); resize();
  (function load(cb){ var ks=Object.keys(window.LYG_IMG||{}), n=ks.length; if(!n) return cb(); ks.forEach(function(k){ var im=new Image(); im.onload=im.onerror=function(){ if(--n===0) cb(); }; im.src=LYG_IMG[k]; IMG[k]=im; }); })(function(){ requestAnimationFrame(frame); });
})();
