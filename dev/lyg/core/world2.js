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
    gamer:{n:'打機青年', sp:['npc_it_sit'], awake:[1,1,1], brave:0.25, props:['pc','fridge'], items:['food','food'], idle:['再打多鋪先瞓','隊友又送頭……','聽日唔使返工，打通宵！']},
    nurse:{n:'夜班護士', sp:['npc_mis'], awake:[1,0,0], leave:0.55, props:['phone','kettle'], items:['money','comb'], idle:['今晚又返通宵','飲杯熱水先出門']},
    elder:{n:'獨居伯伯', sp:['npc_boss'], awake:[0,0,1], leave:2.35, props:['radio','ancestor'], items:['comb','food'], idle:['唉，又瞓唔著','聽朝早啲去飲茶']},
    granny:{n:'婆婆', sp:['npc_auntie'], awake:[0,0,1], props:['radio','fan'], items:['food','comb'], idle:['個仔又冇打電話嚟……','風扇開細啲先']},
    couple:{n:'新婚夫婦', sp:['npc_ken','npc_mis'], awake:[1,0,0], props:['tv','fridge'], items:['food','comb'], idle:['睇埋呢集先瞓','聽日去邊度食早餐？']},
    mahjong:{n:'麻雀腳', sp:['npc_boss','npc_ken','npc_auntie','npc_mis'], awake:[1,1,1], props:['mahjong','fan'], items:['money','money','food'], noisy:1, idle:['碰！','食糊！自摸！','到你出牌喇','今晚手氣真係差']},
    shopper:{n:'網購狂', sp:['npc_mis'], awake:[1,1,0], props:['doorbell','tv'], items:['money','comb'], idle:['又有速遞到？','買多件先，平呀嘛']},
    taxi:{n:'夜更的士佬', sp:['npc_ken'], awake:[1,1,1], away:1.35, props:['fridge','tv'], items:['food','money'], idle:['收工喇，攰到死','今晚載咗個好奇怪嘅客……']},
    cook:{n:'宵夜佬', sp:['npc_ken_sit'], awake:[1,1,0], props:['rice','fridge'], items:['food','food'], idle:['煮個公仔麵先','加隻蛋！']},
    insomnia:{n:'失眠阿叔', sp:['npc_boss'], awake:[1,1,1], brave:0.4, props:['radio','fan'], items:['money'], idle:['我喺呢度住咗四十年，咩未見過','收音機陪我瞓']},
    debt:{n:'欠債人家', sp:['npc_ken','npc_auntie'], awake:[1,1,0], props:['phone','tv'], items:['food'], idle:['唔好出聲，佢哋又嚟……','下個月一定還到']}
  };
  var HHW=[['gamer',3],['nurse',2],['elder',2],['granny',2],['couple',3],['mahjong',1],['shopper',2],['taxi',1],['cook',2],['insomnia',1]];
  var PROP={
    tv:{n:'電視',v:'附身電視',lv:1,f:24}, fan:{n:'風扇',v:'附身風扇',lv:1,f:18}, fridge:{n:'雪櫃',v:'附身雪櫃',lv:1,f:22}, pc:{n:'電腦',v:'附身電腦',lv:1,f:26},
    radio:{n:'收音機',v:'開收音機',lv:2,f:20}, phone:{n:'電話',v:'整響電話',lv:2,f:22}, mahjong:{n:'麻雀枱',v:'自動洗牌',lv:2,f:30}, doorbell:{n:'門鐘',v:'撳門鐘',lv:2,f:20},
    kettle:{n:'水煲',v:'自己煲水',lv:1,f:16}, rice:{n:'電飯煲',v:'電飯煲跳掣',lv:1,f:16}, ancestor:{n:'祖先牌位',v:null}
  };
  var PROPLINE={tv:['部電視做咩自己開咗？！','雪花……入面好似有個人影'], fan:['風扇自己轉到咁大力？！','窗簾吹到飛晒起……'], fridge:['雪櫃門自己開咗！','點解咁凍……'], pc:['電腦彈咗張鬼臉出嚟！','我隻角色自己行開咗？！'],
    radio:['收音機自己播粵曲……','邊個開咗收音機？'], phone:['三點幾有人打嚟……冇聲嘅','喂？喂？邊位呀？'], mahjong:['啲牌自己洗緊！','邊個郁咗我啲牌？！'], doorbell:['叮噹——門口冇人㗎喎','又係速遞？咁夜？'],
    kettle:['水煲自己嗚嗚叫……','我冇煲水㗎喎'], rice:['電飯煲自己跳掣？','啲飯冇咗一半！']};

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
    h.nerve=(h.nerve==null?3:h.nerve)-1; h.state='scared'; h.scT=2.6; h.to=null; h.path=null; h.vx=(rnd()<0.5?-1:1)*120; h.say=txt0||pick(['嘩！！','乜嘢嚟㗎？！','我唔做喇……']); h.sayT=2; h.alertT=0.6;
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
      else if (p.k==='fridge'){ ctx.fillStyle='#7d8786'; ctx.fillRect(x-9,y-40,18,38); ctx.fillStyle='rgba(255,255,255,0.12)'; ctx.fillRect(x-9,y-40,5,38); ctx.strokeStyle='#2a2e2e'; ctx.lineWidth=1.5; ctx.strokeRect(x-9,y-40,18,38); ctx.beginPath(); ctx.moveTo(x-9,y-26); ctx.lineTo(x+9,y-26); ctx.stroke(); ctx.fillStyle='#c8c8c0'; ctx.fillRect(x+5,y-36,2,7); if (a){ var o=Math.abs(Math.sin(T*9))*16; ctx.fillStyle='#b8c0c0'; ctx.fillRect(x+10,y-46,o,30); ctx.fillStyle='rgba(200,240,255,0.5)'; ctx.fillRect(x-8,y-44,16,26); } }
      else if (p.k==='pc'){ ctx.fillStyle='#202428'; ctx.fillRect(x-13,y-38,26,18); ctx.fillStyle=a?(Math.floor(T*8)%2?'#e8e8e8':'#d02020'):'#3a6ad0'; ctx.fillRect(x-11,y-36,22,14); if (a){ ctx.fillStyle='#000'; ctx.fillRect(x-5,y-32,3,3); ctx.fillRect(x+2,y-32,3,3); ctx.fillRect(x-4,y-26,8,2); } ctx.fillStyle='#4a3424'; ctx.fillRect(x-16,y-20,32,4); }
      else if (p.k==='radio'){ ctx.fillStyle='#8a5a3a'; ctx.fillRect(x-10,y-26,20,12); ctx.fillStyle='#ffd54a'; ctx.fillRect(x+3,y-23,4,4); if (a){ ctx.fillStyle='#ffe9a0'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.fillText('♪',x-8+Math.sin(T*5)*6,y-34-((T*30)%14)); ctx.fillText('♫',x+8,y-30-((T*30+7)%14)); } }
      else if (p.k==='phone'){ ctx.fillStyle='#202428'; ctx.fillRect(x-4,y-22,8,12); if (a){ ctx.strokeStyle='rgba(159,224,255,0.8)'; ctx.lineWidth=1.5; for (var i=0;i<2;i++){ ctx.beginPath(); ctx.arc(x,y-16,7+i*5+((T*20)%5),-0.8,0.8); ctx.stroke(); } } }
      else if (p.k==='mahjong'){ ctx.fillStyle='#2a6a3a'; ctx.fillRect(x-22,y-24,44,6); ctx.fillStyle='#4a3424'; ctx.fillRect(x-20,y-18,4,14); ctx.fillRect(x+16,y-18,4,14); for (var i=0;i<8;i++){ ctx.fillStyle='#f0ead8'; ctx.fillRect(x-18+i*4.6,y-28-(a?Math.abs(Math.sin(T*14+i))*6:0),3.6,4); } }
      else if (p.k==='doorbell'){ ctx.fillStyle='#c8a050'; ctx.beginPath(); ctx.arc(u.x+16,y-52,3,0,7); ctx.fill(); ctx.fillStyle='#a07040'; for (var i=0;i<3;i++) ctx.fillRect(x-14+i*9,y-10-(i%2)*8,10,8); if (a){ ctx.fillStyle='#ffd54a'; ctx.font='bold 11px '+FONT; ctx.textAlign='center'; ctx.fillText('叮噹',u.x+16,y-60); } }
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
