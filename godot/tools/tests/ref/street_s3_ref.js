// street 第三段對照參考：用網頁版 street.js（第 257–592 行）喺 node 計，輸出 tools/tests/ref/street_s3.json
const fs=require('fs'); const L=fs.readFileSync('/home/claude/gb/src/street.js','utf8').split('\n');
const body=L.slice(256,592).join('\n');
let rnd=1; const rng=()=>{ rnd=(rnd*16807)%2147483647; return (rnd-1)/2147483646; };
const GP={ grow:g=>g.q, mul:g=>g.m, pow:g=>g.p };
const fn=new Function('window','setTimeout','setInterval','S','GP','LANG', body+'\nreturn {hpMul,coinOf,hpP,coP,bossK,bossDmg,bossCD,staffOf,gridLay,floorGraph,procSpec,longLay,layOf,addHot,occOf,occPush,devRate,bsk,OG,LAYOUT};');
const S={ ghosts:[], res:{} };
const X=fn({},()=>0,()=>0,S,GP,undefined);
const out={};
out.hpMul=[]; for (let lv=1; lv<=70; lv+=0.5) out.hpMul.push([lv, X.hpMul(lv)]);
out.coinOf=[]; for (const cap of [5,14,24]) for (let lv=1; lv<=40; lv++) out.coinOf.push([lv,cap,X.coinOf(lv,cap)]);
out.hpP=[]; out.coP=[]; for (let d=0; d<=90; d++){ out.hpP.push([d,X.hpP(d)]); out.coP.push([d,X.coP(d)]); }
out.boss=[]; for (const q of [1,1.1,1.3333,1.5,2,3]) { const g={q,m:q*1.7,p:q*100}; out.boss.push([q, X.bossK(g), X.bossDmg(g), X.bossCD(g), X.staffOf(g,false), X.staffOf(g,true)]); }
out.boss.push([null, X.bossK(null), X.bossDmg(null), X.bossCD(null)]);
const clean=(o)=>JSON.parse(JSON.stringify(o,(k,v)=>(typeof v==='function'||v instanceof Set)?undefined:v));
out.grid={ g1:clean(X.gridLay('g1')), g2:clean(X.gridLay('g2')) };
out.layOf=[ [{lay:'bus'},null], [{rooms:[{lay:'cafe'},{lay:'g1'}]},1], [{rooms:[{lay:'cafe'}]},3], [{},0] ].map(([d,r])=>clean(X.layOf(d,r)));
out.long=[]; for (const sid of ['office','cafe','bus','market','flat','zzz']) for (const u of [1,2,4]) out.long.push([sid,u,clean(X.longLay(null,u,u===2?[['A','a'],['B','b']]:null,sid))]);
out.proc=[]; for (const [dL,dR] of [[0.5,0.5],[0.3,0.7],[0.62,0.4]]) { const P={proc:1,dL,dR}; const sp=X.procSpec(P); out.proc.push([dL,dR,clean(sp),clean(X.floorGraph(sp.F, sp.S.concat(sp.props.filter(o=>o.t==='s').map(o=>[o.x0,o.y0,o.x1,o.y1])), dL, dR, null))]); }
out.hot=[]; for (const cap of [3,24]) { const sd={lv:1,maxLv:1,hot:0,combo:0}; const seq=[]; rnd=cap; for (let i=0;i<400;i++){ const v = rng()<0.8?2:-18; const m=X.addHot(sd,v,{cap}); seq.push([v,m,sd.lv,sd.maxLv,sd.hot,sd.combo]); } out.hot.push([cap,seq]); }
out.occ=[]; { const sd={posts:[{role:'trap'}],maxLv:3}; rnd=5; for (let i=0;i<90;i++){ const b=rng()<0.6; X.occPush(sd, b); out.occ.push([b, X.occOf(sd), X.devRate(sd), sd.occH.length]); } out.occ.push([X.devRate({occH:sd.occH,posts:[]}), X.devRate({occH:sd.occH,posts:[null,{}]})]); }
out.bsk=['tianhua','egui','zzz'].map(k=>X.bsk(k));
fs.writeFileSync('/home/claude/ghost-battles/godot/tools/tests/ref/street_s3.json', JSON.stringify(out));
console.log(Object.keys(out).join(','), fs.statSync('/home/claude/ghost-battles/godot/tools/tests/ref/street_s3.json').size);
