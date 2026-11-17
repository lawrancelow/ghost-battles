const fs=require('fs'); let src=fs.readFileSync('/tmp/jsgd_src/patrol.js','utf8');
global.window={}; global.document={createElement:()=>({getContext:()=>({})})};
src=src.replace("const Gear = (() => {","const Gear = (() => { global.__GEAR={NAMES:null};").replace("  return { open, unitMul, gpMul, crewBuff, held, nameOf, pct, SLOTS, weaponOf, armorOf, badgeOf, STY, WIMG };","  Object.assign(global.__GEAR,{NAMES,FK,WSTY,SLOTS,STY,WIMG}); return {};");
const f=new Function('global',src+';return Patrol;'); const P=f(global);
const N=P._nat, out={};
for (const k of Object.keys(N)) if (typeof N[k]!=='function') out[k]=N[k];
out.GEAR=global.__GEAR;
// FACI0 不在 _nat? 
fs.writeFileSync('/home/claude/ghost-battles/godot/data/nat/patrol.json', JSON.stringify(out));
console.log(Object.keys(out).join(','));
