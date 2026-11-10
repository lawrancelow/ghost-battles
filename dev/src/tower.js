// ===================== 樓裡有鬼（由 /home/claude/lyg 獨立版移植；用 tools/port_tower.py 重新生成，唔好直接改）=====================
// 樓裡有鬼 — 組屋關（rumah pangsa）：橫切五層樓 + 天台，路徑點網絡，我哋係鬼
const Tower=(function(){
  var OPEN=false, RAF=0, ROOT=document.createElement('section'); ROOT.id='tw-root'; ROOT.className='tw-root';
  var _cv=document.createElement('canvas'); _cv.className='tw-cv'; ROOT.appendChild(_cv); document.body.appendChild(ROOT);
  function TS(){ if (!S.tower) S.tower={unlocked:true,cleared:{},best:0,nights:0}; S.tower.cleared=S.tower.cleared||{}; return S.tower; }
  if (typeof World!=='undefined') World.ICON.tower='樓';
  var FONT='"PingFang HK","PingFang TC","Noto Sans CJK TC","Noto Sans TC","Microsoft JhengHei",sans-serif';
  var cv=_cv, ctx=cv.getContext('2d');
  var DPR=Math.min(2,window.devicePixelRatio||1), VW=390, VH=844, TOP=78, BOT=236;
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
  var HUM={collector:{n:'收數佬',sp:0,spr:'res_collector',h:62}, guard:{n:'保安',sp:58,spr:'res_guard',h:64}, compass:{n:'羅盤保安',sp:62,spr:'npc_guard',h:64}, mirror:{n:'鏡子道士',sp:52,spr:'npc_boss',h:62}, decoy:{n:'道士',sp:50,spr:'npc_boss',h:62}, dog:{n:'看門狗',sp:190,spr:null,h:30}};
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
    G.parts=[]; G.ult=null; G.wardFx=[]; G.dark={};
    G.guards.push(mkHuman('guard','f1_s')); G.guards.push(mkHuman('guard','f'+(FL-2)+'_b'));
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
  function humanPassTo(h,a,b){ var l=a.links.find(function(l){return l.to===b.id;}); return !l||humanPass(h,l.e); }
  function nearNode(o){ var best=null,bd=1e9; for (var k in G.nodes){ var n=G.nodes[k]; if (n.kind==='in') continue; var d=Math.abs(n.x-o.x)+Math.abs(n.y-o.y)*3; if (d<bd){bd=d;best=k;} } return best; }
  function mirrorOn(g){ var m=null; G.guards.forEach(function(h){ if (h.kind!=='mirror'||h.state==='gone') return; if (Math.abs(h.y-g.y)>40) return; var dx=g.x-h.x; if (Math.abs(dx)>220) return; if (Math.sign(dx)===h.dir && g.dir===-h.dir) m=h; }); return m; }

  // ---------- 主更新 ----------
  function update(dt){
    if (G.over||G.choice||paused) return;
    if (G.ult){ G.ult.t+=dt; if (G.ult.t<1.3){ stepFx(dt); return; } if (!G.ult.done){ G.ult.done=true; applyUlt(G.ult); } if (G.ult.t>4){ G.ult=null; G.ultCool=1.5; } }
    G.t+=dt; var np=Math.min(3,Math.floor(G.t/PHT));
    if (np!==G.phase){ G.phase=np; toast(np<3?PH[np]+'到喇——巡邏加派，越近天光人越精。':'天光喇！樓下開始有人起身，追兵越嚟越快，快啲走！'); }
    G.toastT-=dt; if (!G.traces) G.traces=[]; setupBeans();
    // 波次：每個時辰入面定時加派巡邏，天光後指數加強
    G.waveT-=dt; if (G.waveT<=0 && !G.gate){ G.wave++; G.waveT=G.phase>=3?18:30; var f=1+Math.floor(rnd()*(FL-1)); var h=mkHuman('guard','f'+f+'_'+(rnd()<0.5?'s':'l')); h.boost=G.phase>=3?Math.pow(1.15,G.wave):1; G.guards.push(h); float(h.x,h.y-80,'加派保安','#ffb0b0'); }
    G.gh.forEach(function(g){ if (g.home||g.out) return;
      g.blockT=(g.blockT||0)-dt; g.inv=Math.max(0,g.inv-dt); g.invCd=Math.max(0,g.invCd-dt); g.stun=Math.max(0,g.stun-dt); g.scareCd=Math.max(0,g.scareCd-dt);
      g.actT=Math.max(0,g.actT-dt); g.hitT=Math.max(0,g.hitT-dt); g.bounceT=Math.max(0,g.bounceT-dt); g.sealT=Math.max(0,(g.sealT||0)-dt);
      moveUpdate(g,dt); beansCheck(g,dt);
      if (g.d.key==='toyol'){ g.flipT=Math.max(0,(g.flipT||0)-dt); if (g.mv>0){ g.flipCd=(g.flipCd==null?1.2:g.flipCd)-dt; if (g.flipCd<=0){ g.flipT=0.55; g.flipCd=2.2+rnd()*1.5; } } }
      if (g.auto&&g.auto.length){ var nx=g.auto[0];
        if (!g.to){ if (g.node===nx) g.auto.shift(); else { var ln=G.nodes[g.node].links.find(function(l){return l.to===nx;}); if (ln&&canPass(g,ln.e)===true){ g.to=nx; g.p=0; } else g.auto=null; } }
        if (g.to){ var a=G.nodes[g.node], b=G.nodes[g.to], D=Math.hypot(b.x-a.x,b.y-a.y); g.p+=g.d.sp*G.mods.spd*dt/D; g.still=0; g.taskP=0; if (b.x!==a.x) g.dir=b.x>a.x?1:-1; if (g.p>=1){ g.node=g.to; g.to=null; g.p=0; if (g.auto&&g.auto[0]===g.node) g.auto.shift(); onArrive(g); } } }
      var p=posOf(g); g.mv=Math.max(0,g.mv-dt); if (Math.abs(p.x-g.x)+Math.abs(p.y-g.y)>0.2){ g.mv=0.18; g.still=0; } else g.still+=dt; g.x=p.x; g.y=p.y;
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
      r.jumpT=Math.max(0,(r.jumpT||0)-dt); r.tangle=Math.max(0,(r.tangle||0)-dt);
      if (r.state==='flee'){ if (r.tripT>0){ r.tripT-=dt; r.x+=r.vx*0.18*dt; } else r.x+=r.vx*dt; if (r.x<SX||r.x>LX) r.state='gone'; if (rnd()<dt*8) part(r.x-Math.sign(r.vx)*10,r.y-4,-r.vx*0.1,-10,0.5,'dust'); }
      if (r.state==='home' && r.unit.door){ r.doorT-=dt; if (r.doorT<=0){ r.unit.doorOpen=2.6; r.doorT=12+rnd()*8; say(r,pick(['出去倒杯水先','邊個喺門口？','開門透下氣'])); } }
      if (r.unit.doorOpen>0) r.unit.doorOpen-=dt;
    });
    if (G.phase>=2) G.units.forEach(function(un){ un.litT-=dt; if (un.res&&un.res.state==='home'&&!un.lit&&rnd()<dt*0.04){ un.lit=true; un.litT=7; say(un.res,line('wake')); } if (un.lit&&un.litT<=0) un.lit=false; });
    traceUpdate(dt); G.phoneCd=Math.max(0,(G.phoneCd||0)-dt);
    resUpdate2(dt);
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
  // ---------- 人類 ----------
  function nearestGhost(h){ var best=null, bd=1e9; G.gh.forEach(function(g){ if (g.home||g.out||g.inv>0) return; var d=Math.abs(g.x-h.x)+Math.abs(g.y-h.y)*1.5; if (d<bd){ bd=d; best=g; } }); return best; }
  function humanUpdate(h,dt){
    var H=HUM[h.kind]; h.alertT=Math.max(0,h.alertT-dt); h.talkT-=dt; if (h.sayT>0) h.sayT-=dt; else h.say=null;
    if (h.state==='flee'){ h.x+=h.vx*dt; if (h.x<SX-20||h.x>LX+20) h.state='gone'; return; }
    if (h.state==='scared'){ h.scT-=dt; var nx=h.x+h.vx*dt; if (nx<SX||nx>LX) h.vx*=-1; else h.x=nx; if (h.scT<=0){ h.state='patrol'; var nn=nearNode(h); h.node=nn; h.to=null; h.p=0; var q0=G.nodes[nn]; h.x=q0.x; h.y=q0.y; } return; }
    if (h.state==='shift'||h.state==='inv'){ if (!h.to){ if (!h.path||!h.path.length){ if (h.state==='shift'){ h.state='gone'; return; } h.state='puzzle'; h.puzzleT=3.5; h.say=pick(['咩都冇喎……','係咪我聽錯？','奇怪……啱啱明明有聲']); h.sayT=2.4; return; } h.to=h.path.shift(); h.p=0; }
      var a0=G.nodes[h.node], b0=G.nodes[h.to]; if (!humanPassTo(h,a0,b0)){ h.to=null; h.path=dijkstra(h,h.node,h.state==='shift'?'f1_s':h.invNode); if (!h.path){ h.state='patrol'; } return; }
      var D0=Math.max(1,Math.hypot(b0.x-a0.x,b0.y-a0.y)); h.p+=H.sp*1.15*dt/D0; if (b0.x!==a0.x) h.dir=b0.x>a0.x?1:-1; if (h.p>=1){ h.node=h.to; h.to=null; h.p=0; } var p0=posOf(h); h.x=p0.x; h.y=p0.y;
      if (h.state==='inv'){ var tg0=nearestGhost(h); if (tg0 && Math.abs(tg0.y-h.y)<40 && (tg0.x-h.x)*h.dir>0 && Math.abs(tg0.x-h.x)<150){ h.state='chase'; h.alertT=1.2; h.say=line('guardHit'); h.sayT=2; } }
      return; }
    if (h.state==='puzzle'){ h.puzzleT-=dt; h.dir=Math.floor(h.puzzleT*1.2)%2?1:-1; var tg1=nearestGhost(h); if (tg1 && Math.abs(tg1.y-h.y)<40 && (tg1.x-h.x)*h.dir>0 && Math.abs(tg1.x-h.x)<130){ h.state='chase'; h.alertT=1.2; h.say=line('guardHit'); h.sayT=2; } else if (h.puzzleT<=0){ h.state='patrol'; h.wait=0.5; } return; }
    if (h.kind==='collector'){ return; }
    if (h.state==='chase'){ var tg2=nearestGhost(h); var far=!tg2||Math.abs(G.nodes[tg2.node].f-G.nodes[h.node].f)>=2||Math.abs(tg2.x-h.x)>460; h.lostT=far?(h.lostT||0)+dt:0; if (h.lostT>5){ h.state='patrol'; h.lostT=0; h.path=null; h.say=pick(['走甩咗……','跑得咁快？算數','嗰樣嘢去咗邊？']); h.sayT=2.2; } }
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
  function spawnTao(f,x){ G.tao={x:x, f:f, dir:x<WW/2?1:-1, ringT:2.2, life:26, waves:[], say:pick(TAOL), sayT:2.6}; float(x,fy(f)-90,'天師嚟咗！','#ffd54a'); }
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
    try{ var sv=TS(), first=why==='gate'&&!sv['gate_'+curLv]; if (first) sv['gate_'+curLv]=1; sv.nights=(sv.nights||0)+1; var rw=why==='gate'?40+15*kept+25*story:why==='doll'?20+8*kept:0; if (first) rw+=100; if (why!=='fail'){ sv.best=Math.max(sv.best||0,kept); sv.cleared[curLv]=1; } G.over.reward=rw; S.res.coins+=rw; save(); }catch(e){ console.error(e); }
  }
  // ---------- 嚇人（要企定）----------
  function say(r,t){ r.say=t; r.sayT=2.6; }
  function scareRes(r,amt,g){ if (r.state!=='home') return; if (!r.awake){ r.awake=true; r.woke=true; amt*=0.6; } r.fear+=amt*G.mods.pow*(1-r.brave); if (r.unit&&r.unit.rs) r.unit.rs.forEach(function(o){ if (o!==r&&o.state==='home'){ o.awake=true; o.woke=true; o.fear+=amt*0.35*(1-o.brave); o.jumpT=0.4; if (o.fear>=100&&!(o.fleeAfter>0)){ o.fleeAfter=1; o.fleeG=g; } } }); r.jumpT=0.5; if (g) g.energy=Math.min(100,g.energy+(r.brave?8:18)); for (var k=0;k<5;k++) part(r.x,r.y-48,(rnd()-0.5)*90,-60-rnd()*40,0.6,'sweat'); doReact(r,g); if (r.fear>=100 && !(r.fleeAfter>0)){ r.fleeAfter=0.9; r.fleeG=g; } }
  function flee(r,g){
    r.state='flee'; r.y=fy(r.unit.f); r.vx=(r.x<WW/2?-1:1)*150; chain(r.unit,16,r.chainD||0); r.tripT=rnd()<0.35?0.9:0; say(r,line('flee')); if (g) g.energy=Math.min(100,g.energy+20);
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
    if (un&&un.res&&un.res.state==='home'){ if (g.sc) return; startMove(g,un.res,un); return; }
    var h=null, bd=90; G.guards.forEach(function(o){ if (o.state==='flee') return; if (Math.abs(o.y-g.y)>30) return; var d=Math.abs(o.x-g.x); if (d<bd){ bd=d; h=o; } });
    if (!h){ float(g.x,g.y-80,'附近冇人可以嚇','#ddd'); return; }
    g.scareCd=1.2; g.actT=0.9; g.dir=h.x>g.x?1:-1; G.shake=0.25;
    if (h.kind==='mirror' && Math.sign(g.x-h.x)===h.dir){ float(h.x,h.y-90,'正面對住面鏡，嚇唔到！兜去背後','#ffe9a0'); return; }
    if (h.kind==='decoy' && !h.real){ h.state='gone'; for (var k=0;k<12;k++) part(h.x,h.y-30,(rnd()-0.5)*120,-60-rnd()*60,0.9,'paper'); float(h.x,h.y-80,'紙人替身！','#e8d8b0'); return; }
    if (h.kind==='guard'){ spook(h,pick(['嘩！有嘢喺我後面！','乜……乜嘢嚟㗎？！'])); g.energy=Math.min(100,g.energy+15); return; }
    h.courage--; h.alertT=0.8; float(h.x,h.y-90,h.kind==='compass'?'羅盤保安膽量 -1（剩 '+Math.max(0,h.courage)+'）':'嚇！','#ff7a5a');
    if (h.courage<=0){ h.state='flee'; h.vx=(h.x<WW/2?-1:1)*170; h.say=line('flee'); h.sayT=2; addFear(h.kind==='dog'?6:12,h.x,h.y-80); g.energy=Math.min(100,g.energy+20); }
  }
  function part(x,y,vx,vy,life,type){ if (G.parts.length<260) G.parts.push({x:x,y:y,vx:vx,vy:vy,life:life,max:life,type:type}); }
  function stepFx(dt){ G.parts.forEach(function(p){ p.life-=dt; p.x+=p.vx*dt; p.y+=p.vy*dt; if (p.type==='coin'||p.type==='crumb'||p.type==='sweat'||p.type==='paper'||p.type==='drip') p.vy+=220*dt; if (p.type==='smoke') { p.vx*=0.96; p.vy*=0.96; } if (p.tx!=null){ p.x+=(p.tx-p.x)*dt*3; p.y+=(p.ty-p.y)*dt*3; } }); G.parts=G.parts.filter(function(p){return p.life>0;});
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
    if (!S.tr && S.t>=OMEN+STRIKE){ S.tr=true; addTrace(MV[k].tr,S,g); }
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
  function txt(s,x,y,c,sz){ ctx.font='bold '+(sz||12)+'px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; ctx.strokeText(s,x,y); ctx.fillStyle=c; ctx.fillText(s,x,y); }
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
    flat:{name:'組屋', skin:'flatbg', FH:150, ROOF:130,
      levels:['地庫','地下','一樓','二樓','三樓','四樓','五樓','六樓','天台'],
      cols:[['stair',78],['u',146],['u',146],['u',146],['lift',84],['u',146],['u',146],['u',146],['u',146],['back',78]],
      src:{ stair:[0,78,261,405], lift:[516,600,261,405], back:[0,78,261,405,1], gstair:[0,78,711,873], glift:[520,600,711,873], roof:[0,600,0,117],
        res:[[78,240,117,261],[240,378,117,261],[378,516,117,261],[78,240,261,405],[240,378,261,405],[378,516,261,405],[78,240,405,549],[240,378,405,549],[378,516,405,549],[78,240,549,711],[240,378,549,711],[378,516,549,711]],
        deity:[[78,240,117,261]], ground:[[78,240,711,873],[240,405,711,873],[405,520,711,873]] },
      ground:['信箱大堂','士多','管理處','茶餐廳','單車房','垃圾房','藥房'], base:['停車場','機房','水錶房','貨倉','雜物房','停車場','冷氣機房'],
      pipes:[[2,4,3],[4,7,6],[1,3,0],[5,7,2]],                  // [由層,到層,喺第幾格單位右邊]：外牆雨水喉（得鬼爬得）
      lift:true },
    shop:{name:'老店屋', skin:'shopbg', FH:160, ROOF:120,
      levels:['地庫','地下','一樓','二樓','三樓','四樓','五樓','天台'],
      cols:[['stair',100],['u',215],['u',215],['u',215],['lift',90],['u',215],['u',215],['back',70]],
      src:{ stair:[0,100,262,420], lift:[0,100,420,585,1], back:[530,600,262,420], gstair:[0,100,585,812], glift:[0,100,585,812,1], roof:[0,600,0,74],
        res:[[100,320,262,420],[320,530,262,420],[100,320,420,585],[320,530,420,585],[100,320,74,262]],
        deity:[[320,530,74,262]], ground:[[100,320,585,812],[320,530,585,812]] },
      ground:['茶餐室','中藥舖','車衣舖','五金舖','涼茶舖'], base:['貨倉','雜物房','米倉','舊工場','冷房'],
      pipes:[[1,3,2],[3,6,4],[2,5,0]],
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
    var LVg={name:B.name, key:k, bg:null, B:B, FL:FLn, FYS:ys, WW:W, WH:H, SX:colX('stair'), LX:colX('back'), GLX:colX('lift'), MX:colX('lift'), PX0:ucols[0][0]+30, fln:B.levels, xs:xs, ucols:ucols, units:[], pipes:B.pipes, lift:B.lift};
    // 單位表：[層,戶,鎮宅,任務,住戶種類,故事序號,名,門x,範圍]
    var storyF=[], si=0;
    for (var f=0;f<FLn;f++){
      var wardsF={}, nU=ucols.length;
      if (f>=2){ var idx=shuffle(ucols.map(function(_,i){return i;})); wardsF[idx[0]]=pick(['fu','menshen','datuk']); wardsF[idx[1]]='zha'; wardsF[idx[2]]='nuomi'; if (f%2===0) wardsF[idx[3]]=pick(['zha','nuomi']); }
      if (f===1){ wardsF[2]='datuk'; wardsF[5]='zha'; }
      if (f===0){ wardsF[1]='zha'; }
      ucols.forEach(function(c,u){
        var w=wardsF[u]||null, deity=w==='fu'||w==='menshen'||w==='datuk', nm, hh=null, task=null;
        if (f===0){ nm=B.base[u%B.base.length]; hh=null; }
        else if (f===1){ nm=B.ground[u%B.ground.length]; hh=(u===0||deity)?null:(R()<0.5?pick(['insomnia','cook','gamer']):null); }
        else { hh=deity?null:(R()<0.86?wpick(HHW):null); nm=hh?HH[hh].n:'空置單位'; }
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
        hh.sp.forEach(function(sp,i){ var px=un.rx[0]+w0*(n===1?0.42:n>=3?0.13+0.74*i/(n-1):0.2+0.6*i/(n-1)); if (n<3&&Math.abs(px-un.x)<22) px+=(px<un.x?-24:24);
          var r={h:n>=3?(i%2?42:47):58, dy:n>=3&&i%2?-7:0, unit:un,sprite:sp,x:px,y:fy(f)-16,fear:0,brave:hh.brave||0,state:'home',vx:0,doorT:8+rnd()*10,hh:L[4],awake:hh.awake[0]===1,idleT:4+rnd()*10};
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
    var dolls=0; shuffle(cand).forEach(function(u){ if (dolls<9){ u.items.push('doll'); dolls++; } });
    // 門：幾戶夜晚閂門，住客出入先開
    shuffle(G.units.filter(function(u){return u.rs.length&&u.ot===0&&u.f>=2;})).slice(0,4).forEach(function(u){ u.door=true; });
    // 黑屋伏擊：兩戶冇人嘅屋有隻醒住嘅看門狗
    shuffle(G.units.filter(function(u){return !u.rs.length&&u.ot!=='deity'&&u.f>=1;})).slice(0,2).forEach(function(u){ u.ambush='dog'; });
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
    var SC=1.4, B=LV.B; staticCv=document.createElement('canvas'); staticCv.width=Math.round(WW*SC); staticCv.height=Math.round(WH*SC); var c=staticCv.getContext('2d'); c.scale(SC,SC);
    var img=IMG[B.skin], k=img&&img.width?img.width/600:1;
    var sky=c.createLinearGradient(0,0,0,WH); sky.addColorStop(0,'#0b0d16'); sky.addColorStop(0.5,'#141622'); sky.addColorStop(1,'#0c0c10'); c.fillStyle=sky; c.fillRect(0,0,WW,WH);
    for (var i=0;i<60;i++){ c.fillStyle='rgba(230,230,255,'+(0.2+((i*37)%10)/20)+')'; c.fillRect((i*197)%WW,(i*61)%Math.max(40,fy(FL)-60),1.5,1.5); }
    function put(r,dx,dy,dw,dh,flip,dark){ if (!img||!img.width) { c.fillStyle='#222'; c.fillRect(dx,dy,dw,dh); return; } c.save(); if (flip||r[4]){ c.translate(dx+dw,dy); c.scale(-1,1); dx=0; dy=0; } c.drawImage(img,r[0]*k,r[2]*k,(r[1]-r[0])*k,(r[3]-r[2])*k,dx,dy,dw,dh); c.restore();
      if (dark){ c.fillStyle=dark; c.fillRect(flip||r[4]?dx:dx,dy,dw,dh); } }
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
    // 外牆雨水喉（鬼先爬得）
    LV.pipes.forEach(function(P){ var px=LV.ucols[P[2]][1]-6; c.strokeStyle='#5a6a68'; c.lineWidth=5; c.beginPath(); c.moveTo(px,fy(P[1])-110); c.lineTo(px,fy(P[0])); c.stroke(); c.strokeStyle='#8a9a96'; c.lineWidth=1.5; c.stroke();
      for (var y=fy(P[1])-100;y<fy(P[0]);y+=40){ c.fillStyle='#3a4442'; c.fillRect(px-5,y,10,4); } });
    // 樓層名
    c.font='bold 13px '+FONT; c.textAlign='left'; for (var f=0;f<=FL;f++){ c.lineWidth=3; c.strokeStyle='#000'; c.strokeText(FLN[f],6,fy(f)-112+(f===FL?60:0)); c.fillStyle='#e8d8b0'; c.fillText(FLN[f],6,fy(f)-112+(f===FL?60:0)); }
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
      if (d>700*lvl) return;
      if (h.state==='puzzle' && h.invNode===nodeId){ spook(h,'同一個位又有怪聲！'); return; }
      h.state='inv'; h.invNode=nodeId; h.path=p; h.to=null; h.wait=0; h.alertT=0.8; h.say=pick(['咩聲嚟㗎？過去睇睇','邊度傳嚟嘅？','又係'+FLN[n.f]+'？']); h.sayT=2.2; });
  }
  function spook(h,txt0){
    if (h.state==='shift'||h.state==='gone') return;
    h.nerve=(h.nerve==null?3:h.nerve)-1; h.state='scared'; h.scT=2.6; h.to=null; h.path=null; h.vx=(rnd()<0.5?-1:1)*120; h.say=txt0||pick(['嘩！！','乜嘢嚟㗎？！','我唔做喇……']); h.sayT=2; h.alertT=0.6;
    addFear(6,h.x,h.y-90); float(h.x,h.y-110,'保安嚇親！','#ffd54a');
    if (rnd()<0.3){ G.alert+=1; checkAlert(); float(h.x,h.y-130,'對講機：「管理處！'+FLN[G.nodes[h.node].f]+'有怪事！」警覺 +1','#ffb0b0'); }
    if (h.nerve<=0){ h.state='shift'; h.say='唔做喇！交更！'; h.sayT=2.5; float(h.x,h.y-130,'保安頂唔順，落樓交更','#9fd6bf'); G.relief.push({t:26}); h.path=dijkstra(h,h.node,'f1_s'); }
  }
  function reliefUpdate(dt){ (G.relief||[]).forEach(function(r){ r.t-=dt; if (r.t<=0&&!r.done){ r.done=true; var h=mkHuman('guard','f1_s'); h.nerve=3; G.guards.push(h); float(h.x,h.y-80,'新一更保安上班','#ffb0b0'); } }); G.relief=(G.relief||[]).filter(function(r){return !r.done;}); }
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
    if (n.kind==='lift'&&LV.lift&&(G.liftCd||0)<=0) return {k:'lift',t:'叫𨋢自己上落'};
    if (n.kind==='pipe') return {k:'pipeN',t:'敲雨水喉（另一層都聽到）'};
    if (n.id.slice(-2)==='_s'||n.id.slice(-2)==='_b'){ var fe=n.links.map(function(l){return l.e;}).find(function(e){return e.fire;}); if (fe&&fe.fire.cd<=0&&fe.fire.shut<=0) return {k:'fire',t:'閂防煙門（保安要兜路）',e:fe}; }
    return null;
  }
  function actPress(){
    var g=G.gh[G.active], a=ctxAction(g); if (!a) return;
    if (g.still<0.1){ float(g.x,g.y-80,'鬆手企定先做得','#ffd54a'); return; }
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
      else if (p.k==='fridge'){ ctx.fillStyle='#d8dcd8'; ctx.fillRect(x-10,y-46,20,44); ctx.strokeStyle='#666'; ctx.lineWidth=1; ctx.strokeRect(x-10,y-46,20,44); if (a){ var o=Math.abs(Math.sin(T*9))*16; ctx.fillStyle='#b8c0c0'; ctx.fillRect(x+10,y-46,o,30); ctx.fillStyle='rgba(200,240,255,0.5)'; ctx.fillRect(x-8,y-44,16,26); } }
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
  function drawMini(){
    var mw=96, mh=Math.round(96*WH/WW), mx=10, my=TOP+44, sx=mw/WW, sy=mh/WH; buttons.push({id:'mini',x:mx,y:my,w:mw,h:mh});
    ctx.fillStyle='rgba(8,8,12,0.78)'; ctx.fillRect(mx-2,my-2,mw+4,mh+4); ctx.strokeStyle='#4a4a50'; ctx.lineWidth=1; ctx.strokeRect(mx-2,my-2,mw+4,mh+4);
    G.units.forEach(function(u){ var top=fy(u.f+1)+16; ctx.fillStyle=u.ot==='deity'?'#5a2a20':!u.open?'#2a2a30':(u.seen||u.entered)?'#3a4a44':'#1a1a1e'; ctx.fillRect(mx+u.rx[0]*sx+0.5,my+top*sy,(u.rx[1]-u.rx[0])*sx-1,(u.y-top)*sy); });
    ctx.fillStyle='#3fbf8f'; ['f0_e','f'+FL+'_p'].forEach(function(id){ var n=G.nodes[id]; ctx.fillRect(mx+n.x*sx-2,my+n.y*sy-3,4,3); });
    G.guards.forEach(function(h){ if (h.state==='gone') return; ctx.fillStyle=h.kind==='collector'?'#ffd54a':h.state==='chase'?'#ff3a2a':'#d08070'; ctx.fillRect(mx+h.x*sx-1.5,my+h.y*sy-3,3,3); });
    G.gh.forEach(function(g,i){ if (g.home||g.out) return; ctx.fillStyle=i===G.active?'#8affc8':'#3a9a78'; ctx.beginPath(); ctx.arc(mx+g.x*sx,my+g.y*sy-2,i===G.active?3:2,0,7); ctx.fill(); });
    var S=cam.s*cam.z; ctx.strokeStyle='rgba(255,255,255,0.5)'; ctx.strokeRect(mx+cam.x*sx,my+cam.y*sy,(VW/S)*sx,((VH-TOP-BOT)/S)*sy);
  }

  // ---------- 畫面 ----------
  var cam={x:0,y:0,s:1,z:1.7}, staticCv=null;
  function resize(){ VW=Math.min(window.innerWidth,520); VH=window.innerHeight; cv.style.width=VW+'px'; cv.style.height=VH+'px'; cv.width=Math.round(VW*DPR); cv.height=Math.round(VH*DPR); cam.s=VW/600; BOTX=VW/WW; }
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
    drawProps2();
    // 回陰間點
    ['f0_e','f'+FL+'_p'].forEach(function(id){ if (G.gate&&G.gate.node!==id) return; var n=G.nodes[id]; ctx.globalAlpha=0.5+0.3*Math.sin(G.t*2.5); ctx.fillStyle='#3fbf8f'; ctx.beginPath(); ctx.ellipse(n.x,n.y-4,26,9,0,0,7); ctx.fill(); ctx.globalAlpha=1; ctx.fillStyle='#e2e6e0'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#0c0c0e'; ctx.strokeText('回陰間',n.x,n.y-14); ctx.fillText('回陰間',n.x,n.y-14); });
    // 燈泡閃 + 冷霧
    for (var f=0;f<FL;f++){ if (fy(f)<cam.y-20||fy(f+1)>cam.y+viewH+40) continue; var ly=fy(f+1)+18, fl=0.55+0.45*Math.sin(G.t*13+f*2.1)*Math.sin(G.t*3.7+f); if ((Math.floor(G.t*7+f*5)%23)===0) fl=0.1; if (G.dark[f]) fl=0;
      G.units.filter(function(u){return u.f===f;}).map(function(u){return (u.rx[0]+u.rx[1])/2;}).forEach(function(lx){ var gr=ctx.createRadialGradient(lx,ly,2,lx,ly,46); gr.addColorStop(0,'rgba(255,214,140,'+(0.32*fl)+')'); gr.addColorStop(1,'rgba(255,214,140,0)'); ctx.fillStyle=gr; ctx.fillRect(lx-46,ly-46,92,92); });
      for (var k=0;k<3;k++){ var fx=((G.t*(10+k*4)+k*200+f*90)%(WW+100))-50; ctx.fillStyle='rgba(180,220,210,0.07)'; ctx.beginPath(); ctx.ellipse(fx,fy(f)-6,70,9,0,0,7); ctx.fill(); }
      if (G.dark[f]){ ctx.fillStyle='rgba(0,0,0,'+Math.min(0.78,G.dark[f]*0.6)+')'; ctx.fillRect(0,fy(f+1)+8,WW,fy(f)-fy(f+1)-6); } }
    G.wardFx.forEach(function(w){ var a=w.t/0.9, gr=ctx.createRadialGradient(w.x,w.y-30,4,w.x,w.y-30,60); gr.addColorStop(0,'rgba(255,220,140,'+(0.7*a)+')'); gr.addColorStop(1,'rgba(255,220,140,0)'); ctx.fillStyle=gr; ctx.fillRect(w.x-60,w.y-90,120,120); ctx.strokeStyle='rgba(255,230,160,'+a+')'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(w.x,w.y-30,30+(1-a)*30,0,7); ctx.stroke(); });
    drawTraces();
    G.res.forEach(function(r){ if (r.state==='gone'||r.state==='away') return; if (r.x<cam.x-60||r.x>cam.x+viewW+60||r.y<cam.y-20||r.y>cam.y+viewH+120) return; if (r.state==='leave'||r.state==='back') r.vx=r.vx||1; ctx.fillStyle='rgba(0,0,0,0.45)'; ctx.beginPath(); ctx.ellipse(r.x,r.y-1,16,4,0,0,7); ctx.fill(); ctx.shadowColor='rgba(255,236,200,0.75)'; ctx.shadowBlur=5; var jy=r.jumpT>0?-Math.sin((0.5-r.jumpT)/0.5*Math.PI)*16:0, sh=(r.state==='home'&&r.fear>60)?Math.sin(G.t*40)*1.6:0, ro=0, sy=1;
      if (r.state==='flee'){ if (r.tripT>0){ ro=(r.vx>0?1:-1)*1.25; jy=-6; } else { jy=-Math.abs(Math.sin(G.t*16))*7; ro=(r.vx>0?1:-1)*0.18; } }
      if (r.tangle>0){ sh=Math.sin(G.t*30)*2; sy=0.96; }
      if (r.state==='leave'||r.state==='back'){ jy=-Math.abs(Math.sin(G.t*10))*3; }
      if (r.state==='home'&&!r.awake&&!r.react){ ro=-1.45; jy=-8; ctx.fillStyle='rgba(200,220,255,0.8)'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.fillText('Z',r.x+18,r.y-30-((G.t*12)%10)); ctx.font='bold 9px '+FONT; ctx.fillText('z',r.x+26,r.y-40-((G.t*12+5)%10)); }
      var P={sh:0,jy:0,ro:0,sy:1}; reactPose(r,P); sh+=P.sh; jy+=P.jy; ro+=P.ro; sy*=P.sy;
      spr(r.sprite,r.x+sh,r.y+jy+(r.dy||0),r.h||58,{flip:r.vx<0,rot:ro,sy:sy}); ctx.shadowBlur=0; reactProps(r,P); if (r.state==='flee'&&!r.tripT){ ctx.fillStyle='#fff'; ctx.font='bold 13px '+FONT; ctx.textAlign='center'; ctx.fillText('！！',r.x,r.y-66+jy); } if (r.state==='home'&&r.fear>0){ ctx.fillStyle='#1a1a1e'; ctx.fillRect(r.x-18,r.y-64,36,6); ctx.fillStyle='#d24a3a'; ctx.fillRect(r.x-18,r.y-64,36*r.fear/100,6); } if (r.say) bubble(r.x,r.y-68,r.say); });
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
      if (u.seen && u.items.length && u.open){ var ix=(u.rx[0]+u.rx[1])/2; ctx.font='10px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; var cnt={}, ord=[]; u.items.forEach(function(k){ if (!cnt[k]){ cnt[k]=0; ord.push(k); } cnt[k]++; }); var tt=ord.map(function(k){ return ITEM[k].n+(cnt[k]>1?'×'+cnt[k]:''); }).join(' '); ctx.strokeText(tt,ix,top+28); ctx.fillStyle='#e8d8b0'; ctx.fillText(tt,ix,top+28); } });
    if (G.gate||G.gateCharge>0){ var gn=G.nodes[G.gate?G.gate.node:G.gh[G.gateG].node], rr2=G.gate?40+Math.sin(G.t*4)*6:20*G.gateCharge; var gg=ctx.createRadialGradient(gn.x,gn.y-40,4,gn.x,gn.y-40,rr2*1.8); gg.addColorStop(0,'rgba(120,255,200,0.75)'); gg.addColorStop(1,'rgba(40,120,90,0)'); ctx.fillStyle=gg; ctx.beginPath(); ctx.arc(gn.x,gn.y-40,rr2*1.8,0,7); ctx.fill(); ctx.strokeStyle='rgba(160,255,210,0.8)'; ctx.lineWidth=3; for (var q=0;q<3;q++){ ctx.beginPath(); ctx.arc(gn.x,gn.y-40,rr2*(0.5+q*0.3),G.t*(2+q),G.t*(2+q)+4); ctx.stroke(); } }
    drawMoves();
    G.gh.forEach(function(o,i){ if (o.home||o.out) return; var n=G.nodes[o.node], inside=n.kind==='in'&&!o.to, hang=o.d.key==='tianhua'&&inside;
      var a=o.inv>0?0.35:(i===G.active?1:0.75); if (o.stun>0&&!(o.countT>0)) a*=0.6+0.4*Math.sin(G.t*30);
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
    ctx.font='13px '+FONT; ctx.fillStyle='#c8ccc4'; ctx.textAlign='left'; ctx.fillText('收穫 '+G.bag.length+'/'+BAGMAX+'　紙人 '+G.dolls+'/6　匙 紅'+(G.keys.key||0)+' 黃'+(G.keys.key2||0)+(G.carry?'　帶住失物':''),14,68);
    btn('story',VW-86,52,74,22,'故事 '+G.story.length+'/'+STORY.length,'#2e3a34'); drawMini();
    btn('quit',10,TOP+8,52,30,'離開','#2c2c33'); btn('zin',VW-50,TOP+8,40,36,'＋','#24242a'); btn('zout',VW-50,TOP+50,40,36,'－','#24242a');
    // 底：鬼頭像 + 按鈕
    var y0=VH-BOT; ctx.fillStyle='#111114'; ctx.fillRect(0,y0,VW,BOT);
    if (G.toastT>0&&G.toast){ ctx.fillStyle='rgba(18,18,22,0.95)'; rr(10,y0-56,VW-20,50,10); ctx.fill(); ctx.fillStyle='#fff3c8'; ctx.font='13px '+FONT; ctx.textAlign='left'; wrap(G.toast,20,y0-36,VW-40,17); }
    G.gh.forEach(function(o,i){ var x=10+i*72, y=y0+12; buttons.push({id:'gh'+i,x:x,y:y,w:64,h:74}); ctx.fillStyle=i===G.active?'#2f5a4a':'#24242a'; ctx.strokeStyle=i===G.active?'#8affc8':'#4a4a50'; ctx.lineWidth=2; rr(x,y,64,74,10); ctx.fill(); ctx.stroke();
      if (o.energy>=100&&!o.home){ ctx.fillStyle='rgba(255,200,90,'+(0.35+0.25*Math.sin(G.t*8))+')'; rr(x-2,y-2,68,78,12); ctx.fill(); } sprite(o.d.sprite,x+32,y+58,46,false,o.home||o.out?0.3:1); ctx.fillStyle='#000'; ctx.fillRect(x+6,y+4,52,5); ctx.fillStyle=o.energy>=100?'#ffcc55':'#d24a3a'; ctx.fillRect(x+6,y+4,52*o.energy/100,5); if (o.energy>=100&&!o.home){ ctx.fillStyle='#ffe9a0'; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.fillText('點我放大招',x+32,y+20); } ctx.fillStyle='#fff'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.fillText(o.out?'被收服':o.home?'已返':o.d.name+(o.caught?' '+o.caught+'/3':''),x+32,y+70); });
    var g=G.gh[G.active], n=G.nodes[g.node], atP=!g.to&&n.kind==='portal'&&!g.home;
    btn('scare',VW-170,y0+12,74,52,'嚇！','#6e1c1c');
    btn('inv',VW-88,y0+12,76,52,g.invCd>0?'隱身 '+Math.ceil(g.invCd):'隱身','#2a4a7a',g.invCd<=0);
    var A=ctxAction(g); if (A) btn('act',10,y0+92,VW-20,40,A.t,A.k==='respect'?'#3a3a40':'#3a5a2a',A.k!=='respect'); else { ctx.fillStyle='#55585a'; ctx.font='12px '+FONT; ctx.textAlign='center'; ctx.fillText('（企喺電器、水管、𨋢口、樓梯口會出「互動」）',VW/2,y0+116); }
    var hw=(VW-30)/2; btn('gate',10,y0+140,hw,44,G.gate?'陰門 '+Math.ceil(30-G.gate.t)+'s':atP?'開陰門（企定）':'陰門：天台/地庫','#2f5a4a',atP&&!G.gate); btn('doll',20+hw,y0+140,hw,44,'替身遁走 '+G.dolls+'/6','#5a1c1c',G.dolls>=6&&!G.gate);
    ctx.fillStyle='#7a7f78'; ctx.font='12px '+FONT; ctx.textAlign='center'; ctx.fillText('拖動＝移動；鬆手企定先嚇人、搜嘢、附身、破鎮宅',VW/2,VH-12);
    if (G.choice) drawChoice(); if (G.showStory) drawStory(); if (G.over) drawOver();
  }
  function wrap(t,x,y,w,lh){ var line='',yy=y; for (var i=0;i<t.length;i++){ var tt=line+t[i]; if (ctx.measureText(tt).width>w){ ctx.fillText(line,x,yy); line=t[i]; yy+=lh; } else line=tt; } ctx.fillText(line,x,yy); return yy; }
  function panel(h){ ctx.fillStyle='rgba(4,4,6,0.75)'; ctx.fillRect(0,0,VW,VH); var y=(VH-h)/2; ctx.fillStyle='#17171b'; ctx.strokeStyle='#9fd6bf'; ctx.lineWidth=2; rr(16,y,VW-32,h,16); ctx.fill(); ctx.stroke(); buttons=[]; return y; }
  function drawChoice(){ var h=330, y=VH-h-8; ctx.fillStyle='rgba(4,4,6,0.35)'; ctx.fillRect(0,0,VW,VH); ctx.fillStyle='#17171b'; ctx.strokeStyle='#9fd6bf'; ctx.lineWidth=2; rr(10,y,VW-20,h,16); ctx.fill(); ctx.stroke(); buttons=[]; ctx.fillStyle='#fff'; ctx.font='bold 19px '+FONT; ctx.textAlign='center'; ctx.fillText('怕意滿咗！揀一樣強化',VW/2,y+36);
    G.choice.forEach(function(c,i){ var by=y+52+i*88; btn('card'+i,26,by,VW-52,78,'', '#26262c'); ctx.fillStyle='#ffd54a'; ctx.font='bold 18px '+FONT; ctx.fillText(c.t,VW/2,by+32); ctx.fillStyle='#d6dad2'; ctx.font='14px '+FONT; ctx.fillText(c.d,VW/2,by+58); }); }
  function drawStory(){ var H0=Math.min(VH-40,620), y=panel(H0); ctx.fillStyle='#fff'; ctx.font='bold 18px '+FONT; ctx.textAlign='center'; ctx.fillText(LV.name+'嘅故事（'+G.story.length+'/'+STORY.length+'）',VW/2,y+34); ctx.textAlign='left'; ctx.font='12px '+FONT; var yy=y+60;
    for (var f=0;f<STORY.length;f++){ ctx.fillStyle=G.story.indexOf(f)>=0?'#ecece6':'#5a5e58'; yy=wrap(G.story.indexOf(f)>=0?STORY[f]:LV.hint[f]+'：？？？（嚇走「✦故事」戶或者完成支線）',28,yy,VW-56,16)+22; }
    if (G.story.length===STORY.length){ ctx.fillStyle='#ffd54a'; yy=wrap(TRUTH,28,yy,VW-56,16)+24; }
    ctx.fillStyle='#9fd6bf'; ctx.font='bold 13px '+FONT; ctx.fillText('支線',28,yy); yy+=20; ctx.font='12px '+FONT;
    (G.quests||[]).forEach(function(q){ ctx.fillStyle=q.state===2?'#8affc8':'#d8d8d0'; yy=wrap((q.state===2?'✓ ':'・')+q.t+(q.id==='debt'&&q.state===0?'（遲啲先出現）':''),28,yy,VW-56,16)+20; });
    btn('closeStory',VW/2-60,y+H0-54,120,40,'返去','#5a1c1c'); }
  function drawOver(){ var o=G.over, y=panel(420); ctx.textAlign='center'; ctx.fillStyle=o.ok?'#8affc8':'#ff9a9a'; ctx.font='bold 24px '+FONT;
    ctx.fillText(o.why==='gate'?'陰門撤離成功！':o.why==='doll'?'替身遁走！':'被圍收服……',VW/2,y+44); ctx.fillStyle='#fff'; ctx.font='15px '+FONT;
    var msg=o.why==='gate'?['返到陰間嘅鬼：'+o.home+' 隻','帶走全部收穫：'+o.kept+' 件','收服故事碎片：'+o.story+'/'+STORY.length,'今晚怕意總共：'+o.fear,'全樓警覺：'+o.alert]
      :o.why==='doll'?['用替身紙人遁走：'+o.home+' 隻鬼','帶走一半收穫：'+o.kept+' 件（留低 '+o.lost+' 件）','故事碎片冇得帶走（'+o.storyLost+' 塊留咗喺樓入面）','今晚怕意總共：'+o.fear]
      :['三隻鬼全部畀人收服','收穫全部冇晒：'+o.lost+' 件','今晚怕意總共：'+o.fear,'全樓警覺：'+o.alert];
    msg.forEach(function(m,i){ ctx.fillText(m,VW/2,y+90+i*30,VW-50); });
    if (o.story===STORY.length){ ctx.fillStyle='#ffd54a'; ctx.font='13px '+FONT; ctx.textAlign='left'; wrap(TRUTH,36,y+250,VW-72,18); }
    btn('again',VW/2-130,y+420-60,120,44,'再嚟一晚','#5a1c1c'); btn('toMap',VW/2+10,y+420-60,120,44,'返地圖','#2c2c33'); if (o.reward!=null){ ctx.fillStyle='#ffd54a'; ctx.font='bold 16px '+FONT; ctx.textAlign='center'; ctx.fillText('收到冥幣 +'+o.reward,VW/2,y+420-76); } }
  function drawTitle(){ ctx.fillStyle='#0e0e11'; ctx.fillRect(0,0,VW,VH); btn('exit',12,14,92,36,'◀ 返地圖','#2c2c33'); ctx.textAlign='center'; ctx.fillStyle='#e2e6e0'; ctx.font='bold 34px '+FONT; ctx.fillText('樓裡有鬼',VW/2,VH*0.24); ctx.font='16px '+FONT; ctx.fillStyle='#9fd6bf'; ctx.fillText('揀一棟樓・天光前返陰間',VW/2,VH*0.24+34);
    GH.forEach(function(d,i){ sprite(d.sprite,VW/2+(i-1)*100,VH*0.52,d.h*1.5); });
    ctx.fillStyle='#c8ccc4'; ctx.font='14px '+FONT; ['三隻鬼一齊出動：餓鬼搵宵夜、Toyol 偷錢、天花姐梳頭。','成棟樓幾十戶人：打機、返夜更、打麻雀、網購……','保安唔係捉鬼師傅：附身電器、敲水管、叫𨋢引開佢。','有紅紙符、門神、拿督公、祖先牌位要尊重，繞路行。','子時→丑時→寅時，天光前由地庫或天台陰門返陰間。'].forEach(function(t,i){ ctx.fillText(t,VW/2,VH*0.62+i*24,VW-30); });
    var sv=TS(); var shopOpen=!!sv.cleared.flat||Q.has('unlock')||!!window.STN_TEST;
    btn('lv_flat',22,VH*0.80,(VW-56)/2,58,'組屋'+(sv.cleared.flat?' ✓':''),'#5a1c1c'); btn('lv_shop',34+(VW-56)/2,VH*0.80,(VW-56)/2,58,shopOpen?'老店屋'+(sv.cleared.shop?' ✓':''):'老店屋（未解鎖）','#2f5a4a',shopOpen);
    ctx.fillStyle='#7a7f78'; ctx.font='12px '+FONT; ctx.textAlign='center'; ctx.fillText(shopOpen?'揀一棟樓開始今晚':'組屋過關（安全返陰間）就解鎖老店屋',VW/2,VH*0.80+78); }

  // ---------- 輸入 ----------
  var joy=null, ptr=null, JR=58, pts={}, pinch=null;
  cv.addEventListener('pointerdown',function(e){ var p=pt(e); pts[e.pointerId]=p; var ids=Object.keys(pts); if (ids.length===2){ var a=pts[ids[0]],b=pts[ids[1]]; pinch={d:Math.hypot(a.x-b.x,a.y-b.y),z:cam.z}; joy=null; ptr=null; return; } ptr={sx:p.x,sy:p.y,drag:false}; if (scene==='play'&&!G.over&&!G.choice&&!G.showStory&&p.y>TOP&&p.y<VH-BOT) joy={ox:p.x,oy:p.y,x:p.x,y:p.y,on:false}; try{cv.setPointerCapture(e.pointerId);}catch(_){} });
  cv.addEventListener('pointermove',function(e){ var p=pt(e); if (pts[e.pointerId]) pts[e.pointerId]=p; if (pinch){ var ids=Object.keys(pts); if (ids.length===2){ var a=pts[ids[0]],b=pts[ids[1]]; cam.z=clamp(pinch.z*Math.hypot(a.x-b.x,a.y-b.y)/pinch.d,0.5,2.6); } return; } if(!ptr) return; if (Math.hypot(p.x-ptr.sx,p.y-ptr.sy)>10) ptr.drag=true; if (joy){ joy.x=p.x; joy.y=p.y; if (ptr.drag) joy.on=true; } });
  cv.addEventListener('pointerup',function(e){ delete pts[e.pointerId]; if (pinch){ if (!Object.keys(pts).length) pinch=null; return; } var p=pt(e), was=ptr; ptr=null; var j=joy&&joy.on; joy=null; if (was&&!was.drag&&!j) tap(p.x,p.y); });
  cv.addEventListener('pointercancel',function(e){ delete pts[e.pointerId]; pinch=null; ptr=null; joy=null; });
  function pt(e){ var r=cv.getBoundingClientRect(); return {x:e.clientX-r.left,y:e.clientY-r.top}; }
  function joyVec(){ if (!joy||!joy.on) return null; var dx=joy.x-joy.ox, dy=joy.y-joy.oy, L=Math.hypot(dx,dy); if (L>JR){ dx*=JR/L; dy*=JR/L; } return {x:dx/JR,y:dy/JR}; }
  function drawJoy(){ if (!joy||!joy.on) return; var v=joyVec(); ctx.setTransform(DPR,0,0,DPR,0,0); ctx.fillStyle='rgba(10,10,12,0.5)'; ctx.strokeStyle='rgba(170,200,185,0.55)'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(joy.ox,joy.oy,JR,0,7); ctx.fill(); ctx.stroke(); ctx.fillStyle='rgba(138,255,200,0.85)'; ctx.beginPath(); ctx.arc(joy.ox+v.x*JR,joy.oy+v.y*JR,24,0,7); ctx.fill(); }
  function tap(x,y){ for (var i=buttons.length-1;i>=0;i--){ var b=buttons[i]; if (x>=b.x&&x<=b.x+b.w&&y>=b.y&&y<=b.y+b.h){ press(b.id); return; } } }
  function press(id){
    if (id==='lv_flat'||id==='start'){ newGame(null,'flat'); bake(); return; }
    if (id==='exit'){ close(); return; }
    if (id==='quit'){ scene='title'; return; }
    if (id==='lv_shop'){ var sv=TS(); if (sv.cleared.flat||Q.has('unlock')||window.STN_TEST){ newGame(null,'shop'); bake(); } return; }
    if (id==='again'){ newGame(); bake(); return; } if (id==='title'){ scene='title'; return; } if (id==='toMap'){ close(); return; }
    if (scene!=='play') return;
    if (id.indexOf('card')===0){ chooseCard(+id.slice(4)); return; }
    if (id==='zin'){ cam.z=Math.min(2.6,cam.z*1.25); return; } if (id==='zout'){ cam.z=Math.max(0.5,cam.z/1.25); return; } if (id==='mini'){ cam.z=cam.z>0.8?0.55:1.7; return; } if (id==='act'){ actPress(); return; }
    if (id==='story'){ G.showStory=true; return; } if (id==='closeStory'){ G.showStory=false; return; }
    if (G.over||G.choice||G.showStory) return;
    if (id.indexOf('gh')===0){ var i=+id.slice(2); if (G.gh[i].home) return; if (i===G.active&&G.gh[i].energy>=100){ ultPress(i); return; } G.active=i; toast(GH[i].tip+(G.gh[i].energy>=100?'（能量滿！再點頭像放大招）':'')); return; }
    if (id==='scare') scarePress(); if (id==='inv') invPress(); if (id==='gate') gatePress(); if (id==='doll') dollEscape();
  }
  var last=0;
  function frame(ts){ if (!OPEN){ RAF=0; return; } RAF=requestAnimationFrame(frame); if (!last) last=ts; var dt=(ts-last)/1000; if (dt<1/31) return; last=ts; dt=Math.min(dt,0.1);
    if (scene==='play'&&!G.showStory){ var v=joyVec(); if (v&&!G.choice&&!G.over){ G.gh[G.active].auto=null; joyMove(G.gh[G.active],v.x,v.y,dt); } update(dt); }
    draw(); drawJoy(); }
  // 測試介面
  window.TW={act:function(){ actPress(); }, ctx:function(){ return ctxAction(G.gh[G.active]); }, noise:function(id,l){ noise(id,l); }, zoom:function(z){cam.z=z;}, pause:function(v){paused=v;}, step:function(dt,n){ var pp=paused; paused=false; for (var i=0;i<(n||1);i++) update(dt); paused=pp; draw(); }, gate:gatePress, doll:dollEscape, catchG:function(i){ catchGhost(G.gh[i],G.guards[0]||{dir:1}); }, ult:ultPress, press:press, tap:tap, goto:function(i,id){ return gotoNode(G.gh[i],id); }, choose:chooseCard, skip:function(s){ G.t+=s; }, get G(){return G;}, set G(v){}, w2s:function(x,y){return W2S(x,y);}};
  window.addEventListener('resize',function(){ if (OPEN) resize(); });
  function loadImgs(){ var M={flatbg:'bg_tw_flat',shopbg:'bg_tw_shop'}; ['eguiking','toyol','tianhua','tianhua_hang','npc_ken','npc_auntie','npc_guard','npc_it','npc_mis','npc_boss','npc_it_sit','npc_ken_sit','res_gamer','res_uncle','res_granny','res_helper','res_mjaunty','res_shopper','res_collector','res_guard','res_ot','res_gym','room_mahjong','room_gamer','room_nurse','room_helper','room_gym','room_shopper','room_carpark','room_lobby','flatbg','shopbg'].forEach(function(k){ IMG[k]=SPR[M[k]||k]; }); }
  function open(){ loadImgs(); TS(); ROOT.classList.add('on'); OPEN=true; scene='title'; resize(); last=0; if (!RAF) RAF=requestAnimationFrame(frame); try{ Sound.setMode&&Sound.setMode('story'); }catch(e){} try{ window.Policy&&Policy.firstEnter&&Policy.firstEnter('tower'); }catch(e){} }
  function close(){ OPEN=false; ROOT.classList.remove('on'); joy=null; ptr=null; try{ save(); Sound.setMode&&Sound.setMode('village'); }catch(e){} if (typeof World!=='undefined') World.open(); }
  return { open:open, close:close, get on(){ return OPEN; } };
})();
