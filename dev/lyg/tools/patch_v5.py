p='/home/claude/lyg/src/pangsa.js'; s=open('/home/claude/lyg/src/pangsa_v4_backup.js',encoding='utf-8').read()
def R(a,b,cnt=1):
    global s
    assert s.count(a)==cnt,(a[:90],s.count(a)); s=s.replace(a,b)
W2=open('/home/claude/lyg/core/world2.js',encoding='utf-8').read()
# 故事加到 8 段
R("""      story:['地下：管理處話，五樓嗰個貼滿紅紙嘅單位封咗好多年，但係夜晚成日有收音機聲。',""","""      story:['地庫：管理員話，停車場盡頭成日有部單車自己響鈴，佢話係陳伯以前架單車。',
        '地下：管理處話，頂樓嗰個貼滿紅紙嘅單位封咗好多年，但係夜晚成日有收音機聲。',""")
R("""        '五樓：陳伯隻雀仔而家我養住，佢一聽到收音機聲就唱歌，好似等緊有人敲門。'],""","""        '五樓：陳伯隻雀仔而家我養住，佢一聽到收音機聲就唱歌，好似等緊有人敲門。',
        '六樓：天台門口有張舊相，係陳伯同成座樓街坊嘅中秋合照，個個都笑到見牙唔見眼。',
        '天台：陳伯以前晚晚上嚟淋花，佢話「花要有人睇住，人都係」。'],""")
R("""      story:['地下：茶餐室阿叔話，以前四樓住咗個車衫嘅芳姐，成條街啲工人都搵佢補衫。',""","""      story:['地庫：貨倉入面有部舊衣車，車針仲插住半件未補好嘅工衣。',
        '地下：茶餐室阿叔話，以前四樓住咗個車衫嘅芳姐，成條街啲工人都搵佢補衫。',""")
R("""        '四樓：我執雜物嗰陣搵到佢本記帳簿，最後一頁寫住「仲有十件衫未補完」。'],""","""        '四樓：我執雜物嗰陣搵到佢本記帳簿，最後一頁寫住「仲有十件衫未補完」。',
        '五樓：涼茶舖老闆娘話，芳姐每年冬至都會煲一大煲湯，逐層逐戶咁送。',
        '天台：芳姐以前喺天台曬衫，曬好就摺得四四正正，放喺各家門口。'],""")
R("var FYS, SX, LX, GLX, PX0, LV, STORY, TRUTH, FLN;","var FYS, SX, LX, GLX, PX0, LV, STORY, TRUTH, FLN, LV0;")
R("function useLevel(k){ LV=LEVELS[k]; LV.key=k; FL=LV.FL; FYS=LV.FYS; SX=LV.SX; LX=LV.LX; GLX=LV.GLX; PX0=LV.PX0; STORY=LV.story; TRUTH=LV.truth; FLN=LV.fln; }",
  "LV0=LEVELS;\n  function useLevel(k){ var T=LEVELS[k]; LV=genLevel(k); LV.story=T.story; LV.truth=T.truth; LV.hint=T.story.map(function(_,i){return '第 '+(i+1)+' 段';}); FL=LV.FL; FYS=LV.FYS; SX=LV.SX; LX=LV.LX; GLX=LV.GLX; PX0=LV.PX0; STORY=LV.story; TRUTH=LV.truth; FLN=LV.fln; WW=LV.WW; WH=LV.WH; }")
R("    if (lv) curLv=lv; useLevel(curLv);\n    seed=s||((Date.now()%100000)+7); used={};","    if (lv) curLv=lv; seed=s||((Date.now()%100000)+7); used={}; useLevel(curLv);")
R("    buildMap(); placeUnits();","    buildMap2(); placeUnits2();")
R("G.guards.push(mkHuman('guard',LV.guard0));","G.guards.push(mkHuman('guard','f1_s')); G.guards.push(mkHuman('guard','f'+(FL-2)+'_b'));")
R("toast(LV.name+'：拖動摇桿郁鬼，鬆手企定先嚇得人、搜得嘢。開新一戶全樓會更警覺；集齊6個替身紙人可以隨時遁走，或者去陰門企穩30秒帶晒收穫返去。');",
  "toast(LV.name+'（'+(FL-1)+' 層＋地庫＋天台）：鬆手企定先嚇得人、搜得嘢。保安唔係捉鬼師傅——附身電器、敲水管、叫𨋢可以引開佢哋。左上細地圖撳一下睇全棟。');")
R("var HUM={guard:{n:'保安',sp:58,spr:'npc_guard',h:62},","var HUM={collector:{n:'收數佬',sp:0,spr:'npc_it',h:60}, guard:{n:'保安',sp:58,spr:'npc_guard',h:62},")
R("var ITEM={food:{n:'宵夜',t:0.8,who:'eking'}, money:{n:'銀包',t:1.3,who:'toyol'}, comb:{n:'木梳',t:1.6,who:'tianhua'}, doll:{n:'替身紙人',t:2.0}, key:{n:'鎖匙',t:2.6}};",
  "var ITEM={food:{n:'宵夜',t:0.8,who:'eking'}, money:{n:'銀包',t:1.3,who:'toyol'}, comb:{n:'木梳',t:1.6,who:'tianhua'}, doll:{n:'替身紙人',t:2.0}, key:{n:'紅鎖匙',t:2.6}, key2:{n:'黃鎖匙',t:2.6}, lost:{n:'失物',t:1.5}};")
R("var WW=600, WH=900; ","var WW=600, WH=900, BOTX=0; ")
R("VW=390, VH=844, TOP=78, BOT=190;","VW=390, VH=844, TOP=78, BOT=236;")
# 插入新模組
R("  // ---------- 畫面 ----------","\n"+W2+"\n  // ---------- 畫面 ----------")
# 鎖匙
R("if (du && !du.open && du.ot===11 && st && G.keys.key){ G.keys.key--; unlockUnit(du,'用鎖匙開咗門'); } }",
  "if (du && !du.open && du.ot===11 && st && G.keys[du.keyNeed]){ G.keys[du.keyNeed]--; unlockUnit(du,'用'+ITEM[du.keyNeed].n+'開咗門'); } }")
R("    if (it==='key'){ G.keys.key=(G.keys.key||0)+1; float(g.x,g.y-90,'偷到鎖匙！','#ffd54a'); return; }",
  "    if (it==='key'||it==='key2'){ G.keys[it]=(G.keys[it]||0)+1; float(g.x,g.y-90,'偷到'+ITEM[it].n+'！','#ffd54a'); return; }\n    if (it==='lost'){ G.carry='lost'; var q=(G.quests||[]).find(function(q){return q.id==='lost';}); float(g.x,g.y-90,'搵到'+(q?q.thing:'失物')+'！帶返去俾'+(q?FLN[q.owner.f]:'')+'嘅主人','#8affc8'); return; }")
R("if (it!=='doll'&&it!=='key'&&G.bag.length>=BAGMAX)","if (it!=='doll'&&it!=='key'&&it!=='key2'&&it!=='lost'&&G.bag.length>=BAGMAX)")
# 主更新：住戶作息
R("    G.guards.forEach(function(h){ humanUpdate(h,dt); });","    resUpdate2(dt);\n    G.guards.forEach(function(h){ humanUpdate(h,dt); });")
# 嚇人：熟睡、同屋人、連鎖
R("function scareRes(r,amt,g){ if (r.state!=='home') return; r.fear+=amt*G.mods.pow*(1-r.brave);",
  "function scareRes(r,amt,g){ if (r.state!=='home') return; if (!r.awake){ r.awake=true; r.woke=true; amt*=0.6; } r.fear+=amt*G.mods.pow*(1-r.brave); if (r.unit&&r.unit.rs) r.unit.rs.forEach(function(o){ if (o!==r&&o.state==='home'){ o.awake=true; o.woke=true; o.fear+=amt*0.35*(1-o.brave); o.jumpT=0.4; if (o.fear>=100&&!(o.fleeAfter>0)){ o.fleeAfter=1; o.fleeG=g; } } });")
R("    r.state='flee'; r.y=fy(r.unit.f); r.vx=(r.x<300?-1:1)*150;","    r.state='flee'; r.y=fy(r.unit.f); r.vx=(r.x<WW/2?-1:1)*150; chain(r.unit,16,r.chainD||0);")
# 嚇保安 → 驚親／交更
R("    h.courage--; h.alertT=0.8; float(h.x,h.y-90,h.kind==='compass'?",
  "    if (h.kind==='guard'){ spook(h,pick(['嘩！有嘢喺我後面！','乜……乜嘢嚟㗎？！'])); g.energy=Math.min(100,g.energy+15); return; }\n    h.courage--; h.alertT=0.8; float(h.x,h.y-90,h.kind==='compass'?")
R("if (h.courage<=0){ h.state='flee'; h.vx=(h.x<300?-1:1)*170;","if (h.courage<=0){ h.state='flee'; h.vx=(h.x<WW/2?-1:1)*170;")
# 人類：調查、驚親、交更、追丟
R("    if (h.state==='flee'){ h.x+=h.vx*dt; if (h.x<SX-20||h.x>LX+20) h.state='gone'; return; }\n    if (h.talkT<=0 && h.kind!=='dog'){",
"""    if (h.state==='flee'){ h.x+=h.vx*dt; if (h.x<SX-20||h.x>LX+20) h.state='gone'; return; }
    if (h.state==='scared'){ h.scT-=dt; var nx=h.x+h.vx*dt; if (nx<SX||nx>LX) h.vx*=-1; else h.x=nx; if (h.scT<=0){ h.state='patrol'; var nn=nearNode(h); h.node=nn; h.to=null; h.p=0; var q0=G.nodes[nn]; h.x=q0.x; h.y=q0.y; } return; }
    if (h.state==='shift'||h.state==='inv'){ if (!h.to){ if (!h.path||!h.path.length){ if (h.state==='shift'){ h.state='gone'; return; } h.state='puzzle'; h.puzzleT=3.5; h.say=pick(['咩都冇喎……','係咪我聽錯？','奇怪……啱啱明明有聲']); h.sayT=2.4; return; } h.to=h.path.shift(); h.p=0; }
      var a0=G.nodes[h.node], b0=G.nodes[h.to]; if (!humanPassTo(h,a0,b0)){ h.to=null; h.path=dijkstra(h,h.node,h.state==='shift'?'f1_s':h.invNode); if (!h.path){ h.state='patrol'; } return; }
      var D0=Math.max(1,Math.hypot(b0.x-a0.x,b0.y-a0.y)); h.p+=H.sp*1.15*dt/D0; if (b0.x!==a0.x) h.dir=b0.x>a0.x?1:-1; if (h.p>=1){ h.node=h.to; h.to=null; h.p=0; } var p0=posOf(h); h.x=p0.x; h.y=p0.y;
      if (h.state==='inv'){ var tg0=nearestGhost(h); if (tg0 && Math.abs(tg0.y-h.y)<40 && (tg0.x-h.x)*h.dir>0 && Math.abs(tg0.x-h.x)<150){ h.state='chase'; h.alertT=1.2; h.say=line('guardHit'); h.sayT=2; } }
      return; }
    if (h.state==='puzzle'){ h.puzzleT-=dt; h.dir=Math.floor(h.puzzleT*1.2)%2?1:-1; var tg1=nearestGhost(h); if (tg1 && Math.abs(tg1.y-h.y)<40 && (tg1.x-h.x)*h.dir>0 && Math.abs(tg1.x-h.x)<130){ h.state='chase'; h.alertT=1.2; h.say=line('guardHit'); h.sayT=2; } else if (h.puzzleT<=0){ h.state='patrol'; h.wait=0.5; } return; }
    if (h.kind==='collector'){ return; }
    if (h.state==='chase'){ var tg2=nearestGhost(h); var far=!tg2||Math.abs(G.nodes[tg2.node].f-G.nodes[h.node].f)>=2||Math.abs(tg2.x-h.x)>460; h.lostT=far?(h.lostT||0)+dt:0; if (h.lostT>5){ h.state='patrol'; h.lostT=0; h.path=null; h.say=pick(['走甩咗……','跑得咁快？算數','嗰樣嘢去咗邊？']); h.sayT=2.2; } }
    if (h.talkT<=0 && h.kind!=='dog'){""")
R("function humanPass(h,e){ if (h.kind==='dog' && e.door && e.unit.door && e.unit.doorOpen<=0) return false;",
  "function humanPass(h,e){ if (e.pipe) return false; if (e.fire && e.fire.shut>0) return false; if (h.kind==='dog' && e.door && e.unit.door && e.unit.doorOpen<=0) return false;")
R("  function mirrorOn(g){","  function humanPassTo(h,a,b){ var l=a.links.find(function(l){return l.to===b.id;}); return !l||humanPass(h,l.e); }\n  function nearNode(o){ var best=null,bd=1e9; for (var k in G.nodes){ var n=G.nodes[k]; if (n.kind==='in') continue; var d=Math.abs(n.x-o.x)+Math.abs(n.y-o.y)*3; if (d<bd){bd=d;best=k;} } return best; }\n  function mirrorOn(g){")
R("spawnTao(f,x){ G.tao={x:x, f:f, dir:x<300?1:-1,","spawnTao(f,x){ G.tao={x:x, f:f, dir:x<WW/2?1:-1,")
R("U.clones=[0,1,2,3,4].map(function(j){ return {x:60+j*110,","U.clones=[0,1,2,3,4].map(function(j){ return {x:Math.max(60,G.gh[0].x-260)+j*110,")
R("if (c.x<60||c.x>540) c.v*=-1;","if (c.x<60||c.x>WW-60) c.v*=-1;")
R("hx<Math.min(545,U.g.x+spread)","hx<Math.min(WW-55,U.g.x+spread)")
R("%700)-50;","%(WW+100))-50;")
R("P.ro=(r.x<300?-1:1)","P.ro=(r.x<WW/2?-1:1)")
# 鏡頭
R("cam.s=VW","cam.s=VW/600; BOTX=VW",1)

# ===== 第二部分：畫面、HUD、新住戶圖 =====
R("  function bake(){","  function bake(){ if (LV.B){ bake2(); return; }")
R("    G.edges.forEach(drawWard);","    G.edges.forEach(drawWard);\n    drawProps2();")
R("    for (var f=0;f<FL;f++){ var ly=fy(f+1)+18, fl=","    for (var f=0;f<FL;f++){ if (fy(f)<cam.y-20||fy(f+1)>cam.y+viewH+40) continue; var ly=fy(f+1)+18, fl=")
R("    G.res.forEach(function(r){ if (r.state==='gone') return; ctx.fillStyle",
  "    G.res.forEach(function(r){ if (r.state==='gone'||r.state==='away') return; if (r.x<cam.x-60||r.x>cam.x+viewW+60||r.y<cam.y-20||r.y>cam.y+viewH+120) return; if (r.state==='leave'||r.state==='back') r.vx=r.vx||1; ctx.fillStyle")
R("      if (r.tangle>0){ sh=Math.sin(G.t*30)*2; sy=0.96; }\n      var P=",
  "      if (r.tangle>0){ sh=Math.sin(G.t*30)*2; sy=0.96; }\n      if (r.state==='leave'||r.state==='back'){ jy=-Math.abs(Math.sin(G.t*10))*3; }\n      if (r.state==='home'&&!r.awake&&!r.react){ ro=-1.45; jy=-8; ctx.fillStyle='rgba(200,220,255,0.8)'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.fillText('Z',r.x+18,r.y-30-((G.t*12)%10)); ctx.font='bold 9px '+FONT; ctx.fillText('z',r.x+26,r.y-40-((G.t*12+5)%10)); }\n      var P=")
# HUD
R("ctx.fillText('收穫 '+G.bag.length+'/'+BAGMAX+'　紙人 '+G.dolls+'/6　鎖匙 '+(G.keys.key||0),14,68);",
  "ctx.fillText('收穫 '+G.bag.length+'/'+BAGMAX+'　紙人 '+G.dolls+'/6　匙 紅'+(G.keys.key||0)+' 黃'+(G.keys.key2||0)+(G.carry?'　帶住失物':''),14,68);")
R("btn('story',VW-86,52,74,22,'故事 '+G.story.length+'/5','#2e3a34');","btn('story',VW-86,52,74,22,'故事 '+G.story.length+'/'+STORY.length,'#2e3a34'); drawMini();")
R("btn('zin',VW-50,TOP+8,40,36,'＋','#24242a');","btn('zin',VW-50,TOP+8,40,36,'＋','#24242a');",1)
R("    var hw=(VW-30)/2; btn('gate',10,y0+98,","    var A=ctxAction(g); if (A) btn('act',10,y0+92,VW-20,40,A.t,A.k==='respect'?'#3a3a40':'#3a5a2a',A.k!=='respect'); else { ctx.fillStyle='#55585a'; ctx.font='12px '+FONT; ctx.textAlign='center'; ctx.fillText('（企喺電器、水管、𨋢口、樓梯口會出「互動」）',VW/2,y0+116); }\n    var hw=(VW-30)/2; btn('gate',10,y0+140,")
R("btn('doll',20+hw,y0+98,hw,44,","btn('doll',20+hw,y0+140,hw,44,")
R("ctx.fillText('拖動＝移動；鬆手企定先嚇得人、搜得嘢、破得鎮宅',VW/2,VH-14);","ctx.fillText('拖動＝移動；鬆手企定先嚇人、搜嘢、附身、破鎮宅',VW/2,VH-12);")
# 故事版
i0=s.index("  function drawStory(){"); i1=s.index("  function drawOver(){")
s=s[:i0]+"""  function drawStory(){ var H0=Math.min(VH-40,620), y=panel(H0); ctx.fillStyle='#fff'; ctx.font='bold 18px '+FONT; ctx.textAlign='center'; ctx.fillText(LV.name+'嘅故事（'+G.story.length+'/'+STORY.length+'）',VW/2,y+34); ctx.textAlign='left'; ctx.font='12px '+FONT; var yy=y+60;
    for (var f=0;f<STORY.length;f++){ ctx.fillStyle=G.story.indexOf(f)>=0?'#ecece6':'#5a5e58'; yy=wrap(G.story.indexOf(f)>=0?STORY[f]:LV.hint[f]+'：？？？（嚇走「✦故事」戶或者完成支線）',28,yy,VW-56,16)+22; }
    if (G.story.length===STORY.length){ ctx.fillStyle='#ffd54a'; yy=wrap(TRUTH,28,yy,VW-56,16)+24; }
    ctx.fillStyle='#9fd6bf'; ctx.font='bold 13px '+FONT; ctx.fillText('支線',28,yy); yy+=20; ctx.font='12px '+FONT;
    (G.quests||[]).forEach(function(q){ ctx.fillStyle=q.state===2?'#8affc8':'#d8d8d0'; yy=wrap((q.state===2?'✓ ':'・')+q.t+(q.id==='debt'&&q.state===0?'（遲啲先出現）':''),28,yy,VW-56,16)+20; });
    btn('closeStory',VW/2-60,y+H0-54,120,40,'返去','#5a1c1c'); }
"""+s[i1:]

open(p,'w',encoding='utf-8').write(s); print('ok')
s=open(p,encoding='utf-8').read()
R("'收服故事碎片：'+o.story+'/5'","'收服故事碎片：'+o.story+'/'+STORY.length")
R("if (o.story===5){","if (o.story===STORY.length){")
R("if (id==='zout'){ cam.z=Math.max(1,cam.z/1.25); return; }","if (id==='zout'){ cam.z=Math.max(0.5,cam.z/1.25); return; } if (id==='mini'){ cam.z=cam.z>0.8?0.55:1.7; return; } if (id==='act'){ actPress(); return; }")
R("clamp(pinch.z*Math.hypot(a.x-b.x,a.y-b.y)/pinch.d,1,2.6)","clamp(pinch.z*Math.hypot(a.x-b.x,a.y-b.y)/pinch.d,0.5,2.6)")
R("window.TW={","window.TW={act:function(){ actPress(); }, ctx:function(){ return ctxAction(G.gh[G.active]); }, noise:function(id,l){ noise(id,l); }, ")
R("['三隻鬼一齊出動：餓鬼搵宵夜、Toyol 偷錢、天花姐梳頭。','有紅紙符、門神、拿督公嘅單位要尊重，繞路行。','鐵閘得 Toyol 鑽得入，糯米得天花姐過得去。','子時→丑時→寅時，天光前一定要返陰間。']",
  "['三隻鬼一齊出動：餓鬼搵宵夜、Toyol 偷錢、天花姐梳頭。','成棟樓幾十戶人：打機、返夜更、打麻雀、網購……','保安唔係捉鬼師傅：附身電器、敲水管、叫𨋢引開佢。','有紅紙符、門神、拿督公、祖先牌位要尊重，繞路行。','子時→丑時→寅時，天光前由地庫或天台陰門返陰間。']")
# 新住戶圖＋新種類
R("gamer:{n:'打機青年', sp:['npc_it_sit'],","gamer:{n:'打機青年', sp:['res_gamer'],")
R("elder:{n:'獨居伯伯', sp:['npc_boss'],","elder:{n:'獨居伯伯', sp:['res_uncle'],")
R("granny:{n:'婆婆', sp:['npc_auntie'],","granny:{n:'婆婆', sp:['res_granny'],")
R("mahjong:{n:'麻雀腳', sp:['npc_boss','npc_ken','npc_auntie','npc_mis'],","mahjong:{n:'麻雀腳', sp:['res_mjaunty','npc_boss','npc_ken','npc_mis'],")
R("shopper:{n:'網購狂', sp:['npc_mis'],","shopper:{n:'網購狂', sp:['res_shopper'],")
R("    debt:{n:'欠債人家',","""    helper:{n:'家務姐姐', sp:['res_helper'], awake:[1,1,0], props:['washer','fridge'], items:['food','comb'], idle:['仲有一籃衫未熨……','聽朝一早要陪婆婆睇醫生','洗埋呢籃先瞓']},
    ot:{n:'加班族', sp:['res_ot'], awake:[1,1,0], away:0.75, props:['pc','tv'], items:['food','food'], idle:['又OT到咁夜……','食完個外賣就瞓','老細仲WhatsApp我？']},
    gym:{n:'健身仔', sp:['res_gym'], awake:[1,1,1], brave:0.5, props:['radio','fan'], items:['food'], idle:['再做多十下！','練完先食宵夜','今晚練胸']},
    debt:{n:'欠債人家',""")
R("['taxi',1],['cook',2],['insomnia',1]];","['taxi',1],['cook',2],['insomnia',1],['helper',1],['ot',2],['gym',1]];")
R("    kettle:{n:'水煲',v:'自己煲水',lv:1,f:16},","    kettle:{n:'水煲',v:'自己煲水',lv:1,f:16}, washer:{n:'洗衣機',v:'洗衣機自己轉',lv:2,f:20},")
R("    kettle:['水煲自己嗚嗚叫……','我冇煲水㗎喎'],","    kettle:['水煲自己嗚嗚叫……','我冇煲水㗎喎'], washer:['洗衣機自己開咗？！','入面啲衫……好似有隻手'],")
R("      else if (p.k==='kettle'||p.k==='rice'){","      else if (p.k==='washer'){ ctx.fillStyle='#e8e8e2'; ctx.fillRect(x-12,y-30,24,28); ctx.strokeStyle='#777'; ctx.lineWidth=1; ctx.strokeRect(x-12,y-30,24,28); ctx.save(); ctx.translate(x,y-15); ctx.rotate(a?T*20:0); ctx.fillStyle='#6a8aa8'; ctx.beginPath(); ctx.arc(0,0,8,0,7); ctx.fill(); ctx.fillStyle='#e8e2d0'; ctx.fillRect(-2,-7,4,6); ctx.restore(); }\n      else if (p.k==='kettle'||p.k==='rice'){")
R("var HUM={collector:{n:'收數佬',sp:0,spr:'npc_it',h:60}, guard:{n:'保安',sp:58,spr:'npc_guard',h:62},","var HUM={collector:{n:'收數佬',sp:0,spr:'res_collector',h:62}, guard:{n:'保安',sp:58,spr:'res_guard',h:64},")
open(p,'w',encoding='utf-8').write(s); print('ok2')
s=open(p,encoding='utf-8').read()
R("'陰門：天台/地下'","'陰門：天台/地庫'")
R("float(g.x,g.y-80,'怕意唔夠，去嚇多啲人','#ffd54a'); g.blockT=1.5;","float(g.x,g.y-80,'怕意唔夠，去嚇多啲人','#ffd54a'); g.blockT=6;")
open(p,'w',encoding='utf-8').write(s); print('ok3')

s=open(p,encoding='utf-8').read()
R("spr(r.sprite,r.x+sh,r.y+jy,58,{flip:r.vx<0,rot:ro,sy:sy});","spr(r.sprite,r.x+sh,r.y+jy+(r.dy||0),r.h||58,{flip:r.vx<0,rot:ro,sy:sy});")
R("var tt=u.items.map(function(k){return ITEM[k].n;}).join('·');","var cnt={}, ord=[]; u.items.forEach(function(k){ if (!cnt[k]){ cnt[k]=0; ord.push(k); } cnt[k]++; }); var tt=ord.map(function(k){ return ITEM[k].n+(cnt[k]>1?'×'+cnt[k]:''); }).join(' ');")
open(p,'w',encoding='utf-8').write(s); print('ok4')
# ===== v5.1：保安慢行、天花姐全程天花、觸控 =====
s=open(p,encoding='utf-8').read()
R("var sp=H.sp*(h.boost||1)*(G.gate?(G.gate.t>20?2:1.5):1)*(1+0.12*G.phase); if (tg&&chaser) sp*=Math.pow(1.4,Math.abs(G.nodes[tg.node].f-a.f)); sp=Math.min(sp,320);",
  "var sp=H.sp*(h.boost||1)*(G.gate?(G.gate.t>20?1.4:1.2):1)*(1+0.08*G.phase); if (tg&&chaser){ sp*=0.75*Math.pow(1.15,Math.abs(G.nodes[tg.node].f-a.f)); sp=Math.min(sp,tg.d.sp*G.mods.spd*0.85); } else sp*=0.45; h.walkSp=sp;")
R("h.p+=H.sp*1.15*dt/","h.p+=H.sp*0.65*dt/")
R("if (h.lostT>5)","if (h.lostT>8)")
R("    if (!S.tr && S.t>=OMEN+STRIKE){ S.tr=true; addTrace(MV[k].tr,S,g); }","    if (!S.tr && S.t>=OMEN+STRIKE){ S.tr=true; addTrace(MV[k].tr,S,g); if (k==='tianhua'){ g.dropT=2.3; g.stun=Math.max(g.stun,2.3); g.to=null; g.auto=null; float(g.x,g.y-70,'哎吔……腰骨痛','#e8d8b0'); } }")
R("g.sealT=Math.max(0,(g.sealT||0)-dt);","g.sealT=Math.max(0,(g.sealT||0)-dt); g.dropT=Math.max(0,(g.dropT||0)-dt);")
R("if (o.stun>0&&!(o.countT>0)) a*=","if (o.stun>0&&!(o.countT>0)&&!(o.dropT>0)) a*=")
R("      if (k==='eking'){ sx*=1+(o.fat||0); }","""      if (k==='tianhua'){ var na2=G.nodes[o.node], nb2=o.to?G.nodes[o.to]:na2, ceil2=fy(Math.min(FL,na2.f+1))+14, flo2=o.y;
        if (o.dropT>0){ key=o.d.sprite; var dq=o.dropT;
          if (dq>2.05){ var u2=(2.3-dq)/0.25; by=ceil2+(flo2-ceil2)*u2; sy=1; sx=1; ro=Math.PI*(1-u2); oy=0; ox=0; }
          else if (dq<0.5){ var u3=1-dq/0.5; by=flo2-(flo2-ceil2)*u3; sy=1; sx=1; ro=0; ox=Math.sin(G.t*30)*1.5; }
          else { by=flo2; sy=1; sx=1; ro=o.dir*0.24+Math.sin(G.t*3)*0.03; ox=0; oy=0; if (dq>0.8){ ctx.strokeStyle='rgba(255,230,160,0.8)'; ctx.lineWidth=2; for (var w2=0;w2<3;w2++){ ctx.beginPath(); ctx.arc(o.x-o.dir*10,flo2-o.d.h*0.42,6+w2*5+((G.t*16)%5),Math.PI*0.6,Math.PI*1.4); ctx.stroke(); } } } }
        else if (!hang){ if (na2.f!==nb2.f){ var down=(nb2.f<na2.f); by=o.y-(down?0:6); ro=down?Math.PI:0; ox=o.dir*14+Math.sin(G.t*14)*2; if (down) by=o.y-o.d.h*0.9; sx=sx*0.95; sy=Math.abs(sy); }
          else { by=ceil2; sy=-Math.abs(sy||1); oy=(oy||0)*0.4; } } }
      if (k==='eking'){ sx*=1+(o.fat||0); }""")
# HUD 掣放大（最少 44px）
R("VW=390, VH=844, TOP=78, BOT=236;","VW=390, VH=844, TOP=96, BOT=240;")
R("btn('story',VW-86,52,74,22,'故事 '+G.story.length+'/'+STORY.length,'#2e3a34'); drawMini();","btn('story',VW-100,48,90,44,'故事 '+G.story.length+'/'+STORY.length,'#2e3a34'); drawMini();")
R("btn('zin',VW-50,TOP+8,40,36,'＋','#24242a'); btn('zout',VW-50,TOP+50,40,36,'－','#24242a');","btn('zin',VW-56,TOP+8,46,46,'＋','#24242a'); btn('zout',VW-56,TOP+60,46,46,'－','#24242a');")
R("var mw=96, mh=Math.round(96*WH/WW), mx=10, my=TOP+44,","var mw=74, mh=Math.min(110,Math.round(74*WH/WW)), mx=10, my=TOP+60,")
R("    var A=ctxAction(g); if (A) btn('act',10,y0+92,VW-20,40,A.t,A.k==='respect'?'#3a3a40':'#3a5a2a',A.k!=='respect'); else { ctx.fillStyle='#55585a'; ctx.font='12px '+FONT; ctx.textAlign='center'; ctx.fillText('（企喺電器、水管、𨋢口、樓梯口會出「互動」）',VW/2,y0+116); }",
  "    var A=ctxAction(g), U=g.energy>=100&&!g.home&&!g.out&&!G.ult, aw=U?(VW-30)/2:VW-20; if (A) btn('act',10,y0+92,aw,46,A.t,A.k==='respect'?'#3a3a40':'#3a5a2a',A.k!=='respect'); else if (!U){ ctx.fillStyle='#55585a'; ctx.font='12px '+FONT; ctx.textAlign='center'; ctx.fillText('（撳住戶＝行過去嚇；企喺電器、水管、𨋢口、樓梯口會出「互動」）',VW/2,y0+118,VW-20); }\n    if (U) btn('ult',A?20+aw:10,y0+92,A?aw:VW-20,46,'放大招：'+ULT[g.d.key].n,'#8a5a14');")
R("var hw=(VW-30)/2; btn('gate',10,y0+140,","var hw=(VW-30)/2; btn('gate',10,y0+146,")
R("btn('doll',20+hw,y0+140,hw,44,","btn('doll',20+hw,y0+146,hw,44,")
R("    btn('closeStory',VW/2-60,y+H0-54,120,40,'返去','#5a1c1c'); }","    btn('closeStory',VW/2-60,y+H0-56,120,46,'返去','#5a1c1c'); }")
# 觸控：按落即時反饋＋命中範圍放大＋拖動唔取消掣＋撳人＝目標
R("function btn(id,x,y,w,h,label,col,on){ buttons.push({id:id,x:x,y:y,w:w,h:h});","function btn(id,x,y,w,h,label,col,on){ buttons.push({id:id,x:x,y:y,w:w,h:h}); var pz=PRESS&&PRESS.id===id&&performance.now()-PRESS.t<260; if (pz){ ctx.save(); ctx.shadowColor='#ffe9a0'; ctx.shadowBlur=18; ctx.fillStyle='rgba(255,233,160,0.35)'; rr(x-3,y-3,w+6,h+6,14); ctx.fill(); ctx.restore(); }")
R("  function tap(x,y){ for (var i=buttons.length-1;i>=0;i--){ var b=buttons[i]; if (x>=b.x&&x<=b.x+b.w&&y>=b.y&&y<=b.y+b.h){ press(b.id); return; } } }",
"""  var PRESS=null, PAD=10;
  function hitBtn(x,y){ var best=null, bd=1e9; for (var i=buttons.length-1;i>=0;i--){ var b=buttons[i]; if (x>=b.x-PAD&&x<=b.x+b.w+PAD&&y>=b.y-PAD&&y<=b.y+b.h+PAD){ var d=(x>=b.x&&x<=b.x+b.w&&y>=b.y&&y<=b.y+b.h)?-1:Math.hypot(x-(b.x+b.w/2),y-(b.y+b.h/2)); if (d<bd){ bd=d; best=b; } } } return best; }
  function tap(x,y){ var b=hitBtn(x,y); if (b){ press(b.id); return; } if (scene==='play'&&G&&!G.over&&!G.choice&&!G.showStory) worldTap(x,y); }
  function worldTap(x,y){ var S=cam.s*cam.z, wx=x/S+cam.x, wy=(y-TOP)/S+cam.y, best=null, bd=40;
    var gb=null, gbd=26; G.gh.forEach(function(g,i){ if (g.home||g.out||i===G.active) return; var d=Math.hypot(g.x-wx,(g.y-g.d.h*0.5)-wy); if (d<gbd){ gbd=d; gb={g:i}; } });
    G.res.forEach(function(r){ if (r.state!=='home') return; var d=Math.hypot(r.x-wx,(r.y-26)-wy); if (d<bd){ bd=d; best={r:r}; } });
    G.guards.forEach(function(h){ if (h.state==='gone'||h.state==='flee') return; var d=Math.hypot(h.x-wx,(h.y-30)-wy); if (d<bd){ bd=d; best={h:h}; } });
    if (!best&&gb) best=gb; var g=G.gh[G.active]; if (!best){ var nn=null, nd=1e9; for (var k in G.nodes){ var n=G.nodes[k]; var d=Math.abs(n.x-wx)+Math.abs((n.y-30)-wy)*1.6; if (d<nd){ nd=d; nn=k; } } if (nn&&nd<120){ if (gotoNode(g,nn)){ g.autoS=null; float(G.nodes[nn].x,G.nodes[nn].y-70,'去呢度','#9fd6bf'); } else float(wx,wy,'去唔到','#ffb0b0'); } return; }
    if (best.g!=null){ G.active=best.g; return; }
    if (best.r){ var un=best.r.unit; if (!un.open&&un.ot!==1){ float(best.r.x,best.r.y-80,'呢戶未入得','#ffd54a'); return; } if (g.node===un.id&&!g.to){ g.still=Math.max(g.still,0.11); scarePress(); return; } if (gotoNode(g,un.id)){ g.autoS={r:best.r}; float(best.r.x,best.r.y-86,'目標：'+(HH[best.r.hh]?HH[best.r.hh].n:'住戶'),'#ffb7a0'); } else float(best.r.x,best.r.y-80,'去唔到（要先開門／破鎮宅）','#ffb0b0'); return; }
    if (best.h){ var hn=best.h.to&&Math.abs(G.nodes[best.h.to].x-best.h.x)<Math.abs(G.nodes[best.h.node].x-best.h.x)?best.h.to:best.h.node; if (gotoNode(g,hn)){ g.autoS={h:best.h}; float(best.h.x,best.h.y-90,'目標：'+HUM[best.h.kind].n,'#ffb7a0'); } return; } }""")
R("cv.addEventListener('pointerdown',function(e){ var p=pt(e); pts[e.pointerId]=p;","cv.addEventListener('pointerdown',function(e){ if (e.isPrimary) pts={}; var p=pt(e); pts[e.pointerId]=p; var hb=hitBtn(p.x,p.y); if (hb){ PRESS={id:hb.id,t:performance.now()}; try{ navigator.vibrate&&navigator.vibrate(12); }catch(_){} ptr={sx:p.x,sy:p.y,drag:false,btn:hb.id}; joy=null; try{cv.setPointerCapture(e.pointerId);}catch(_){} return; }")
R("var p=pt(e), was=ptr; ptr=null; var j=joy&&joy.on; joy=null; if (was&&!was.drag&&!j) tap(p.x,p.y); });","var p=pt(e), was=ptr; ptr=null; var j=joy&&joy.on; joy=null; if (was&&was.btn){ var hb=hitBtn(p.x,p.y); if (hb&&hb.id===was.btn) press(hb.id); else if (Math.hypot(p.x-was.sx,p.y-was.sy)<24) press(was.btn); return; } if (was&&!was.drag&&!j) tap(p.x,p.y); });")
R("if (Math.hypot(p.x-ptr.sx,p.y-ptr.sy)>10) ptr.drag=true;","if (!ptr.btn&&Math.hypot(p.x-ptr.sx,p.y-ptr.sy)>12) ptr.drag=true;")
R("if (id==='act'){ actPress(); return; }","if (id==='act'){ actPress(); return; } if (id==='ult'){ ultPress(G.active); return; }")
open(p,'w',encoding='utf-8').write(s); print('ok5')
s=open(p,encoding='utf-8').read()
R("else g.still+=dt; g.x=p.x; g.y=p.y;","else g.still+=dt; g.x=p.x; g.y=p.y;\n      if (g.autoS && !g.to && !(g.auto&&g.auto.length) && g.still>=0.12){ g.autoS=null; if (G.active===g.i && g.scareCd<=0) scarePress(); }")
R("G.gh[G.active].auto=null; joyMove","G.gh[G.active].auto=null; G.gh[G.active].autoS=null; joyMove")
open(p,'w',encoding='utf-8').write(s); print('ok6')
s=open(p,encoding='utf-8').read()
R("window.TW={act:","window.TW={btns:function(){ return buttons.map(function(b){return {id:b.id,x:b.x,y:b.y,w:b.w,h:b.h};}); }, act:")
open(p,'w',encoding='utf-8').write(s); print('ok7')
# ===== v5.2：地圖再放大、保安分區、鏡頭 =====
s=open(p,encoding='utf-8').read()
R("{key:'eking', name:'餓鬼', sprite:'eguiking', h:62, sp:80,","{key:'eking', name:'餓鬼', sprite:'eguiking', h:76, sp:104,")
R("{key:'toyol', name:'Toyol', sprite:'toyol', h:46, sp:104,","{key:'toyol', name:'Toyol', sprite:'toyol', h:70, sp:132,")
R("{key:'tianhua', name:'天花姐', sprite:'tianhua', h:60, sp:88,","{key:'tianhua', name:'天花姐', sprite:'tianhua', h:74, sp:114,")
R("var HUM={collector:{n:'收數佬',sp:0,spr:'res_collector',h:62}, guard:{n:'保安',sp:58,spr:'res_guard',h:64}, compass:{n:'羅盤保安',sp:62,spr:'npc_guard',h:64}, mirror:{n:'鏡子道士',sp:52,spr:'npc_boss',h:62}, decoy:{n:'道士',sp:50,spr:'npc_boss',h:62}, dog:{n:'看門狗',sp:190,spr:null,h:30}};",
  "var HUM={collector:{n:'收數佬',sp:0,spr:'res_collector',h:76}, guard:{n:'保安',sp:74,spr:'res_guard',h:78}, compass:{n:'羅盤保安',sp:78,spr:'npc_guard',h:78}, mirror:{n:'鏡子道士',sp:66,spr:'npc_boss',h:76}, decoy:{n:'道士',sp:64,spr:'npc_boss',h:76}, dog:{n:'看門狗',sp:230,spr:null,h:38}};")
# 住戶泡泡、怕意條跟人仔高度
R("if (r.state==='home'&&r.fear>0){ ctx.fillStyle='#1a1a1e'; ctx.fillRect(r.x-18,r.y-64,36,6); ctx.fillStyle='#d24a3a'; ctx.fillRect(r.x-18,r.y-64,36*r.fear/100,6); } if (r.say) bubble(r.x,r.y-68,r.say);",
  "var RH=(r.h||58)+(r.dy||0); if (r.state==='home'&&r.fear>0){ ctx.fillStyle='#1a1a1e'; ctx.fillRect(r.x-18,r.y-RH-6,36,6); ctx.fillStyle='#d24a3a'; ctx.fillRect(r.x-18,r.y-RH-6,36*r.fear/100,6); } if (r.say) bubble(r.x,r.y-RH-10,r.say);")
# 保安分區
R("G.guards.push(mkHuman('guard','f1_s')); G.guards.push(mkHuman('guard','f'+(FL-2)+'_b'));","spawnZoneGuards();")
R("  function toast(m){","  function spawnZoneGuards(){ var nz=Math.max(2,Math.round((FL-1)/3)), span=(FL-1)/nz; for (var i=0;i<nz;i++){ var a=1+Math.round(i*span), b=Math.min(FL-1,Math.round((i+1)*span)); var h=mkHuman('guard','f'+a+'_'+(i%2?'b':'s')); h.zone=[a,b]; G.guards.push(h); } }\n  function inZone(h,f,pad){ return !h.zone||(f>=h.zone[0]-(pad||0)&&f<=h.zone[1]+(pad||0)); }\n  function toast(m){")
R("var h=mkHuman('guard','f'+f+'_'+(rnd()<0.5?'s':'l')); h.boost=","var h=mkHuman('guard','f'+f+'_'+(rnd()<0.5?'s':'l')); h.zone=[Math.max(1,f-1),Math.min(FL-1,f+1)]; h.boost=")
R("var n=G.nodes[h.node], opts=n.links.filter(function(l){ var m=G.nodes[l.to]; return m.kind!=='in' && m.kind!=='portal' && humanPass(h,l.e); });",
  "var n=G.nodes[h.node], zm=h.zone?(h.zone[0]+h.zone[1])/2:0, opts=n.links.filter(function(l){ var m=G.nodes[l.to]; return m.kind!=='in' && m.kind!=='portal' && humanPass(h,l.e) && (inZone(h,m.f)||(!inZone(h,n.f)&&Math.abs(m.f-zm)<Math.abs(n.f-zm))); });")
R("var far=!tg2||Math.abs(G.nodes[tg2.node].f-G.nodes[h.node].f)>=2||Math.abs(tg2.x-h.x)>460; h.lostT=far?(h.lostT||0)+dt:0;","var far=!tg2||Math.abs(G.nodes[tg2.node].f-G.nodes[h.node].f)>=2||Math.abs(tg2.x-h.x)>460; if (tg2&&!inZone(h,G.nodes[tg2.node].f,1)) h.lostT=(h.lostT||0)+dt*3; h.lostT=far?(h.lostT||0)+dt:0;")
open(p,'w',encoding='utf-8').write(s); print('ok8')
s=open(p,encoding='utf-8').read()
R("var cam={x:0,y:0,s:1,z:1.7}, staticCv=null;","var cam={x:0,y:0,s:1,z:1,free:null}, staticCv=null, LASTP=null;")
R("cam.s=VW/600; BOTX=VW/WW;","cam.s=VW/((LV&&LV.camW)||600); BOTX=VW/WW;")
R("    G.parts=[]; G.ult=null;","    cam.z=1; cam.free=null; cam.s=VW/((LV&&LV.camW)||600);\n    G.parts=[]; G.ult=null;")
R("ty=clamp(g.y-viewH*0.55,0,Math.max(0,WH-viewH+70)), tx=clamp(g.x-viewW/2,0,Math.max(0,WW-viewW));","fxc=cam.free?cam.free.x:g.x, fyc=cam.free?cam.free.y:g.y, ty=clamp(fyc-viewH*0.55,0,Math.max(0,WH-viewH+70)), tx=clamp(fxc-viewW/2,0,Math.max(0,WW-viewW));")
R("if (id==='zin'){ cam.z=Math.min(2.6,cam.z*1.25); return; } if (id==='zout'){ cam.z=Math.max(0.5,cam.z/1.25); return; } if (id==='mini'){ cam.z=cam.z>0.8?0.55:1.7; return; }",
  "if (id==='zin'){ cam.z=Math.min(1.5,cam.z*1.25); return; } if (id==='zout'){ cam.z=Math.max(0.5,cam.z/1.25); return; } if (id==='mini'){ miniJump(); return; } if (id==='follow'){ cam.free=null; return; }")
R("clamp(pinch.z*Math.hypot(a.x-b.x,a.y-b.y)/pinch.d,0.5,2.6)","clamp(pinch.z*Math.hypot(a.x-b.x,a.y-b.y)/pinch.d,0.5,1.5); var S9=cam.s*cam.z, mxp=(a.x+b.x)/2, myp=(a.y+b.y)/2; if (pinch.mx!=null){ var c0=cam.free||{x:cam.x+VW/S9/2,y:cam.y+(VH-TOP-BOT)/S9*0.55}; cam.free={x:c0.x-(mxp-pinch.mx)/S9,y:c0.y-(myp-pinch.my)/S9}; } pinch.mx=mxp; pinch.my=myp")
R("function tap(x,y){ var b=hitBtn(x,y);","function tap(x,y){ LASTP={x:x,y:y}; var b=hitBtn(x,y);")
R("if (was&&was.btn){ var hb=hitBtn(p.x,p.y);","if (was&&was.btn){ LASTP=p; var hb=hitBtn(p.x,p.y);")
R("  function drawMini(){","  function miniJump(){ var b=buttons.find(function(q){return q.id==='mini';}); if (!b||!LASTP) return; var wx=(LASTP.x-b.x)/b.w*WW, wy=(LASTP.y-b.y)/b.h*WH; cam.free={x:clamp(wx,0,WW),y:clamp(wy,0,WH)}; }\n  function drawMini(){")
R("G.gh[G.active].auto=null; G.gh[G.active].autoS=null; joyMove","G.gh[G.active].auto=null; G.gh[G.active].autoS=null; cam.free=null; joyMove")
R("if (best.g!=null){ G.active=best.g; return; }","if (best.g!=null){ G.active=best.g; cam.free=null; return; }")
R("if (id.indexOf('gh')===0){ var i=+id.slice(2);","if (id.indexOf('gh')===0){ cam.free=null; var i=+id.slice(2);")
R("btn('story',VW-100,48,90,44,'故事 '+G.story.length+'/'+STORY.length,'#2e3a34'); drawMini();","btn('story',VW-100,48,90,44,'故事 '+G.story.length+'/'+STORY.length,'#2e3a34'); drawMini(); if (cam.free) btn('follow',VW/2-66,TOP+8,132,46,'◎ 跟返隻鬼','#2f5a4a');")
open(p,'w',encoding='utf-8').write(s); print('ok9')
s=open(p,encoding='utf-8').read()
R("window.TW={btns:","window.TW={cam:function(){ return {z:cam.z,free:!!cam.free,x:cam.x,y:cam.y}; }, btns:")
open(p,'w',encoding='utf-8').write(s); print('ok10')
# ===== 電梯 LIFT HOOK（core/lift.js；搭𨋢期間住戶／保安暫時移出 G.res／G.guards）=====
import importlib.util as _iu
_sp=_iu.spec_from_file_location('alh','/home/claude/lyg/tools/apply_lift_hooks.py'); _m=_iu.module_from_spec(_sp); _sp.loader.exec_module(_m)
s=open(p,encoding='utf-8').read(); s=_m.patch(s); open(p,'w',encoding='utf-8').write(s); print('ok-lift')
# ===== v6：真機觸控（嚇人掣、浮字唔疊、HUD 唔觸發移動）— tools/patch_v6_touch.py =====
_sp6=_iu.spec_from_file_location('p6','/home/claude/lyg/tools/patch_v6_touch.py'); _m6=_iu.module_from_spec(_sp6); _sp6.loader.exec_module(_m6)
s=open(p,encoding='utf-8').read(); s=_m6.patch(s); open(p,'w',encoding='utf-8').write(s); print('ok-v6')
# ===== v7：黑暗系蠟筆 UI — tools/patch_v7_ui.py =====
_sp7=_iu.spec_from_file_location('p7','/home/claude/lyg/tools/patch_v7_ui.py'); _m7=_iu.module_from_spec(_sp7); _sp7.loader.exec_module(_m7)
s=open(p,encoding='utf-8').read(); s=_m7.patch(s); open(p,'w',encoding='utf-8').write(s); print('ok-v7')
# ===== v8：樓裡有鬼新剖面格（gb_tower_tiles2）— tools/patch_v8_tiles.py =====
_sp8=_iu.spec_from_file_location('p8','/home/claude/lyg/tools/patch_v8_tiles.py'); _m8=_iu.module_from_spec(_sp8); _sp8.loader.exec_module(_m8)
s=open(p,encoding='utf-8').read(); s=_m8.patch(s); open(p,'w',encoding='utf-8').write(s); print('ok-v8')
# ===== v9：入屋模式（點門入住戶室內介面）— tools/patch_v9_unit.py =====
_sp9=_iu.spec_from_file_location('p9','/home/claude/lyg/tools/patch_v9_unit.py'); _m9=_iu.module_from_spec(_sp9); _sp9.loader.exec_module(_m9)
s=open(p,encoding='utf-8').read(); s=_m9.patch(s); open(p,'w',encoding='utf-8').write(s); print('ok-v9')
# ===== v10：人物（Q 版統一畫法、嚇親反應、鬼初始點安全區、保安行慢）— tools/patch_v10_people.py =====
_sp10=_iu.spec_from_file_location('p10','/home/claude/lyg/tools/patch_v10_people.py'); _m10=_iu.module_from_spec(_sp10); _sp10.loader.exec_module(_m10)
s=open(p,encoding='utf-8').read(); s=_m10.patch(s); open(p,'w',encoding='utf-8').write(s); print('ok-v10')
# ===== v11：鬼力關聯（村入面升級 → 樓裡有鬼能力；建議鬼力；失敗返村升級）— tools/patch_v11_gp.py =====
_sp11=_iu.spec_from_file_location('p11','/home/claude/lyg/tools/patch_v11_gp.py'); _m11=_iu.module_from_spec(_sp11); _sp11.loader.exec_module(_m11)
s=open(p,encoding='utf-8').read(); s=_m11.patch(s); open(p,'w',encoding='utf-8').write(s); print('ok-v11')
