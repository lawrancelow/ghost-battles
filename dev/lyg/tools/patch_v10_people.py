# patch_v10_people：由 patch_v5.py 引用；def patch(s) 收 pangsa.js 字串、回傳改好嘅字串
# 老闆要求：「樓裡有鬼裡面的人，請統一造型（Q版大頭）。鬼的初始點，保安不會過去。保安走路慢一些。人被嚇到要有相對應的反應和表情。」
#  1. 保安行慢啲：HUM sp ×0.58（巡邏 33→19 px/s）；查聲 0.65→0.7；追鬼 0.75→1.05（55→45 px/s）；步頻跟行咗幾遠計（唔再腳快身慢）
#  2. 鬼初始點（f0_e）安全區：半徑 150px；人類尋路／巡邏唔入、追到邊停低講句返轉頭；區內唔會被捉；淡紫陰氣
#     陰門喺初始點開咗（G.gate.node==='f0_e'）安全區就散（唔係撤離 30 秒會變送分）
#  3. 嚇親反應：瞬間跳起（squash & stretch）、震、「!!」、汗滴淚滴、臉青白（tint）、跌嘢；驚值高發抖四圍望縮起；
#     驚走狂奔雙手舉高（冇驚嚇圖嘅角色）、身後塵、浮字慘叫（同一晚唔會兩個人講同一句）；保安被嚇後退、手電筒亂晃
#  4. Q 版圖：res_xxx_scared 有就換圖（npc_* 永遠唔換臉）；Q 版高 ×1.12、驚嚇圖用 core/ppl_meta.json 比例，腳底對地
# 全部 hook 用 // PEOPLE HOOK 標明；錨點唔見／唔唯一會 assert 報錯。window.PPLFX 俾 core/unit.js、core/lift.js 共用。
import json, os
META_P='/home/claude/lyg/core/ppl_meta.json'

JS = r"""
  // ===== PEOPLE HOOK（tools/patch_v10_people.py）：鬼初始點安全區、人物統一畫法、嚇親反應 =====
  var PPL_META=__META__;
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
"""

def patch(s):
    if 'PEOPLE HOOK' in s: return s
    def R(a,b):
        nonlocal s
        assert s.count(a)==1,('v10 錨點唔見／唔唯一',a[:90],s.count(a)); s=s.replace(a,b)
    meta={}
    if os.path.exists(META_P):
        for k,v in json.load(open(META_P,encoding='utf-8')).items(): meta[k]={'n':v.get('n',{}),'s':{'k':v['s']['k'],'foot':v['s'].get('foot',0)}}
    R("  // ---------- 人類 ----------", JS.replace('__META__',json.dumps(meta,ensure_ascii=False))+"  // ---------- 人類 ----------")
    # 1. 速度：巡邏 ×0.58、查聲 0.7、追鬼 1.05
    R("var HUM={collector:{n:'收數佬',sp:0,spr:'res_collector',h:76}, guard:{n:'保安',sp:74,spr:'res_guard',h:78}, compass:{n:'羅盤保安',sp:78,spr:'npc_guard',h:78}, mirror:{n:'鏡子道士',sp:66,spr:'npc_boss',h:76}, decoy:{n:'道士',sp:64,spr:'npc_boss',h:76},",
      "var HUM={collector:{n:'收數佬',sp:0,spr:'res_collector',h:76}, guard:{n:'保安',sp:43,spr:'res_guard',h:78}, compass:{n:'羅盤保安',sp:45,spr:'npc_guard',h:78}, mirror:{n:'鏡子道士',sp:38,spr:'npc_boss',h:76}, decoy:{n:'道士',sp:37,spr:'npc_boss',h:76},   /* PEOPLE HOOK：舊 74/78/66/64 ×0.58 */")
    R("h.p+=H.sp*0.65*dt/D0;","h.p+=H.sp*0.7*dt/D0;")
    R("sp*=0.75*Math.pow(1.15,","sp*=1.05*Math.pow(1.15,")
    # 2. 安全區
    R("    spawnZoneGuards();\n","    spawnZoneGuards(); initSafe(); G.pdrops=[];   // PEOPLE HOOK\n")
    R("function nearestGhost(h){ var best=null, bd=1e9; G.gh.forEach(function(g){ if (g.home||g.out||g.inv>0) return;",
      "function nearestGhost(h){ var best=null, bd=1e9; G.gh.forEach(function(g){ if (g.home||g.out||g.inv>0||inSafe(g)) return;")
    R("G.nodes[u].links.forEach(function(l){ if (!humanPass(h,l.e)) return;",
      "G.nodes[u].links.forEach(function(l){ if (!humanPass(h,l.e)) return; if (safeNode(l.to)&&!safeNode(src)) return;")
    R("return m.kind!=='in' && m.kind!=='portal' && humanPass(h,l.e) &&","return m.kind!=='in' && m.kind!=='portal' && !safeNode(l.to) && humanPass(h,l.e) &&")
    R("if (g.home||g.out||g.inv>0||g.stun>0||(h.catchCd||0)>0) return;","if (g.home||g.out||g.inv>0||g.stun>0||(h.catchCd||0)>0||inSafe(g)) return;")
    R("  function catchGhost(g,h){\n","  function catchGhost(g,h){\n    if (inSafe(g)) return;   // PEOPLE HOOK：陰氣地入面唔會被捉\n")
    R("function mirrorOn(g){ var m=null;","function mirrorOn(g){ if (inSafe(g)) return null; var m=null;")
    R("if (g.inUnit) return; if (G.nodes[g.node].f!==T.f) return;","if (g.inUnit) return; if (inSafe(g)) return; if (G.nodes[g.node].f!==T.f) return;")
    R("if (h.state==='chase'){ var tg2=nearestGhost(h);",
      "var tgS=nearestAny(h); h.balkCd=Math.max(0,(h.balkCd||0)-dt);   // PEOPLE HOOK：追到陰氣地邊就停低、講句、返轉頭\n"
      "    if (tgS&&inSafe(tgS)&&!(h.balkCd>0)&&nearSafe(h)&&(h.state==='chase'||(h.kind!=='guard'&&h.kind!=='collector'&&!(h.kind==='decoy'&&!h.real)))){ balk(h,h.kind!=='dog'); return; }\n"
      "    if (h.state==='chase'&&tgS&&inSafe(tgS)){ balk(h,false); return; }\n"
      "    if (h.state==='chase'){ var tg2=nearestGhost(h);")
    R("if (chaser && tg){ var tn=","if (chaser && tg){ var tn=")  # 只係確認存在
    s=s.replace("if (chaser && tg){ var tn=","if (chaser && tg){ var tn=",1)
    # tn 係安全節點（鬼行緊落樓梯入陰氣地）→ 停低
    R("if (h.repath<=0||!h.path){ h.path=dijkstra(h,h.node,tn); h.repath=0.5; }",
      "if (safeNode(tn)){ balk(h,h.kind!=='dog'&&nearSafe(h)&&!(h.balkCd>0)); return; } if (h.repath<=0||!h.path){ h.path=dijkstra(h,h.node,tn); h.repath=0.5; }")
    R("if (h.state==='puzzle'){",
      "if (h.state==='balk'){ h.balkT-=dt; if (h.balkT<1.3&&!h.balkTurn){ h.balkTurn=1; h.dir=-h.dir; } if (h.balkT<=0){ h.state='patrol'; h.wait=0.2; h.repath=0; h.path=null; h.balkCd=6; } return; }\n"
      "    if (h.state==='puzzle'){")
    R("var nn=nearNode(h); h.node=nn;","var nn=nearNodeH(h); h.node=nn;")
    # 嚇親／驚走嘅位移唔會滑入陰氣地
    R("if (h.state==='flee'){ h.x+=h.vx*dt;","if (h.state==='flee'){ if (inSafeXY(h.x+h.vx*dt,h.y)) h.vx*=-1; if (Math.random()<dt*8) part(h.x-Math.sign(h.vx)*10,h.y-4,-h.vx*0.1,-10,0.5,'dust'); h.x+=h.vx*dt;")
    R("var nx=h.x+h.vx*dt; if (nx<SX||nx>LX) h.vx*=-1; else h.x=nx;",
      "var bk=h.scT>1.7; if (h.scAway){ h.vx=h.scAway*(bk?55:95); h.dir=bk?-h.scAway:h.scAway; } var nx=h.x+h.vx*dt; if (nx<SX||nx>LX||inSafeXY(nx,h.y)){ h.vx*=-1; if (h.scAway) h.scAway*=-1; } else h.x=nx;")
    # 3. 反應：住客 tick、保安 tick
    R("r.jumpT=Math.max(0,(r.jumpT||0)-dt);","pplResTick(r,dt); r.jumpT=Math.max(0,(r.jumpT||0)-dt); r._pj=r.jumpT;")
    R("    resUpdate2(dt);\n","    resUpdate2(dt); pplTick(dt);   // PEOPLE HOOK\n")
    R("var H=HUM[h.kind]; h.alertT=Math.max(0,h.alertT-dt);","var H=HUM[h.kind]; h.alertT=Math.max(0,h.alertT-dt); h.shockT=Math.max(0,(h.shockT||0)-dt); if (h.scream){ h.scream.T-=dt; if (h.scream.T<=0) h.scream=null; }")
    R("say(r,line('flee'));","pplScream(r);")
    R("h.say=line('flee'); h.sayT=2;","pplScream(h);")
    R("h.courage--; h.alertT=0.8;","h.courage--; h.alertT=0.8; h.shockT=0.9;")
    R("h.vx=(rnd()<0.5?-1:1)*120; h.say=txt0||pick(['嘩！！','乜嘢嚟㗎？！','我唔做喇……']); h.sayT=2;",
      "var gS=null, dS=1e9; G.gh.forEach(function(g){ if (g.home||g.out) return; var d=Math.abs(g.x-h.x)+Math.abs(g.y-h.y)*3; if (d<dS){ dS=d; gS=g; } }); h.scAway=gS&&dS<400?(h.x>=gS.x?1:-1):(rnd()<0.5?-1:1); h.vx=h.scAway*55; h.dir=-h.scAway; h.shockT=0.9; h.say=uniq([txt0])||uniq(SPOOKL); h.sayT=2;")
    # 粒子：淚滴
    R("p.type==='sweat'||","p.type==='sweat'||p.type==='tear'||")
    R("else if (p.type==='sweat'){ ctx.fillStyle='#9fe0ff'; ctx.beginPath(); ctx.arc(p.x,p.y,2.5,0,7); ctx.fill(); }",
      "else if (p.type==='sweat'){ ctx.fillStyle='#9fe0ff'; ctx.beginPath(); ctx.arc(p.x,p.y,2.5,0,7); ctx.fill(); }\n      else if (p.type==='tear'){ ctx.fillStyle='#bfeaff'; ctx.strokeStyle='#2a4a5a'; ctx.lineWidth=0.8; ctx.beginPath(); ctx.moveTo(p.x,p.y-4.5); ctx.quadraticCurveTo(p.x+3.2,p.y,p.x,p.y+2.6); ctx.quadraticCurveTo(p.x-3.2,p.y,p.x,p.y-4.5); ctx.fill(); ctx.stroke(); }")
    # 畫：安全區、跌落地嘅嘢、住客
    R("    drawTraces();\n","    drawTraces(); drawSafe(); drawDrops();   // PEOPLE HOOK\n")
    a0="    G.res.forEach(function(r){ if (r.state==='gone'||r.state==='away') return;"; b0="if (r.say) bubble(r.x,r.y-RH-10,r.say); });\n"
    assert s.count(a0)==1 and s.count(b0)==1, 'v10 住客畫法錨點'
    i=s.index(a0); j=s.index(b0)+len(b0); assert j>i
    s=s[:i]+"    G.res.forEach(function(r){ pplDrawRes(r,viewW,viewH); });   // PEOPLE HOOK：住客統一畫法\n"+s[j:]
    # 保安
    gi=s.index("G.guards.forEach(function(s){ var H=HUM[s.kind];"); ge=s.index("// 房間遮罩",gi); blk=s[gi:ge]
    nb=blk.replace("G.guards.forEach(function(s){ var H=HUM[s.kind];","G.guards.forEach(function(s){ var H=HUM[s.kind], HHt=H.spr?PPLFX.hgt(H.spr,H.spr,H.h):H.h;",1)
    n0=nb.count("s.y-H.h-"); assert n0>=5,('v10 保安高度',n0); nb=nb.replace("s.y-H.h-","s.y-HHt-")
    for a,b in [("var sw=Math.sin(G.t*2.4+s.x*0.01)*14;","var sw=s.state==='scared'?Math.sin(G.t*23+s.x)*46+Math.sin(G.t*37)*18:Math.sin(G.t*2.4+s.x*0.01)*14;"),
                ("(s.state==='chase'||s.kind==='compass'?0.45:0.3)","((s.state==='chase'||s.kind==='compass'?0.45:0.3)*(s.state==='scared'?0.4+0.6*Math.abs(Math.sin(G.t*29)):1))"),
                ("var bob=-Math.abs(Math.sin(G.t*(s.kind==='dog'?18:8)+s.x))*(s.kind==='dog'?5:2), fl=","var bob=s.kind==='dog'?-Math.abs(Math.sin(G.t*18+s.x))*5:pplStep(s), fl="),
                ("spr(H.spr,s.x,s.y+bob,H.h,{flip:fl,alpha:s.kind==='decoy'?0.88:1,rot:s.state==='flee'?(s.vx>0?0.2:-0.2):0});","pplGuard(s,H,bob,fl);")]:
        assert nb.count(a)==1,('v10 保安錨點',a[:60]); nb=nb.replace(a,b)
    s=s[:gi]+nb+s[ge:]
    # 測試介面
    R("window.TW={","window.TW={safe:function(){ return SAFE?{x:SAFE.x,y:SAFE.y,r:SAFE.r,f:SAFE.f,nodes:Object.keys(SAFE.nodes),on:safeOn()}:null; }, inSafe:function(i){ return inSafe(G.gh[i]); }, inSafeXY:function(x,y){ return inSafeXY(x,y); }, uq:function(){ return Object.keys(G._uq||{}); }, ")
    return s
