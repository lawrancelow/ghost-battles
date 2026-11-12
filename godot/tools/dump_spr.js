// SPR_SRC / BG_SRC → godot/assets/spr/<key>.webp，bg 加前綴 bg_（同網頁版 SPR 鍵名一致）
const fs=require('fs'),vm=require('vm'),path=require('path');
const [SRC,OUT]=process.argv.slice(2);
const ctx={}; vm.createContext(ctx);
for(const f of ['assets.js','tower_assets.js','tower_tiles_assets.js','world_assets.js']){
  let s=fs.readFileSync(SRC+'/'+f,'utf8').replace(/^(const|let) (SPR_SRC|BG_SRC)\s*=/gm,'var $2 =');
  vm.runInContext(s,ctx,{filename:f});
}
fs.mkdirSync(OUT+'/assets/spr',{recursive:true});
const man={};
const put=(k,src)=>{const m=/^data:image\/(\w+);base64,(.*)$/.exec(src); if(!m) return; const p='assets/spr/'+k+'.'+m[1]; fs.writeFileSync(OUT+'/'+p,Buffer.from(m[2],'base64')); man[k]='res://'+p;};
for(const k in ctx.SPR_SRC) put(k,ctx.SPR_SRC[k]);
for(const k in ctx.BG_SRC) put('bg_'+k,ctx.BG_SRC[k]);
fs.writeFileSync(OUT+'/assets/spr_manifest.json',JSON.stringify(man));
console.log(Object.keys(ctx.SPR_SRC).length,'spr',Object.keys(ctx.BG_SRC).length,'bg');
