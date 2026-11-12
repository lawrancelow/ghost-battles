const fs=require('fs'),vm=require('vm');const [REF,OUT]=process.argv.slice(2);
const ctx={Math,Object,JSON,console,document:undefined,location:undefined};vm.createContext(ctx);
vm.runInContext(fs.readFileSync(REF+'/meshanim.js','utf8')+'\n;'+fs.readFileSync(REF+'/limbdata.js','utf8')+'\n;globalThis.__R=MeshAnim.RIG;globalThis.__N=MeshAnim.NATIVE_R;globalThis.__L=typeof LIMBS_DATA!=="undefined"?LIMBS_DATA:null;',ctx);
const rig={};for(const k in ctx.__R){const r=ctx.__R[k];rig[k]={bones:r.bones,legs:!!r.legs,hop:!!r.hop,hold:r.hold||null};}
fs.writeFileSync(OUT+'/rigs.json',JSON.stringify({RIG:rig,NATIVE_R:ctx.__N,LIMBS:ctx.__L}));
console.log(Object.keys(rig).length,'rigs; limbs chars',ctx.__L&&Object.keys(ctx.__L.chars));
