# 軍團 36 隻空手圖提示詞（ChatGPT 圖片編輯；B＝共用前綴，W＝每隻要拎走嘅兵器）
import json,sys
B=("EDIT Image 1 - do NOT redraw from scratch. This is our game's character art. Remove ONLY the hand-held weapon described below and change nothing else: "
"keep the exact same character, face, expression, body, pose, clothes, colors, ghost tail, proportions, size, position and framing, the same soft grainy crayon / colored-pencil texture and thin dark-brown outline. "
"The hands stay in exactly the same place and the same pose, now EMPTY (a clenched fist or a gripping hand holding nothing). "
"Where the weapon covered the body or clothes, continue the body/clothes naturally; where it covered empty space, leave plain flat pure WHITE background. "
"Do not add anything new: no new object, no effects, no glow, no aura, no smoke, no motion lines, no text, no watermark. "
"Output one square 1024x1024 image with exactly the same framing as Image 1, plain flat pure white background. REMOVE: ")
W={
"dpl_bing":"the long bamboo pole held above his head with both hands (the whole pole, both ends). Keep the cigarette in his mouth.",
"dpl_boss":"the long rusty metal pipe (with elbow joints at both ends) held in both hands across his belly.",
"dpl_boss2":"the metal pipe raised in his right hand above his head. Keep the walkie-talkie on his belt.",
"dpl_elite":"the wooden abacus held out in his right hand, and the flying abacus beads around it. Keep the book tucked under his left arm and his wristwatch.",
"dpl_king":"the golf club held over his shoulder with both hands (the whole club: grip, shaft and head). Keep the gold chain, the ring and the sunglasses.",
"dpl_shoot":"the green glass bottle raised in his hand and the small sweat drops next to it. Keep the bottle on his belt.",
"egs_bing":"the broken bowl raised above her head in both hands and the flying bowl shards.",
"egs_boss":"the long iron ladle held in both hands. Keep the colander helmet on his head.",
"egs_boss2":"the wooden paddle raised in her right hand (also the small sweat drops). Keep the round pot-lid shield on her left arm.",
"egs_king":"the long iron ladle held up in the raised hand (the whole ladle). Keep the cracked bowl in his other hand and the small green ghost-fire wisps.",
"egs_shoot":"the small broken wooden spoon held in his hand. Keep the breath blast coming out of his mouth.",
"klj_bing":"the long halberd (pole with axe blade and spike) held upright in his right hand - the whole pole from top to bottom.",
"klj_boss":"the long halberd held in both hands, pointing left (the whole pole, blade and red tassels).",
"klj_elite":"the long straight sword / blade held diagonally in both hands (the whole weapon and its tassel).",
"klj_king":"the long halberd held across his body in both hands (the whole pole, blade and its tassel). Keep the red war banner on his back.",
"klj_shoot":"the crossbow and its arrow held in both hands. Keep the quiver of arrows on his hip.",
"klj_tank":"the curved saber raised in his right hand (blade, hilt and red tassel). Keep the big round woven shield.",
"sgj_boss":"the rusty anchor and the rope held in his raised hand and swinging around (the whole rope and the anchor). Keep the fishing net with shells on his body.",
"sgj_boss2":"the iron chain swung in her raised hand AND the wooden door/board hanging from that chain (the whole chain and the board).",
"sgj_king":"the long harpoon / fishing spear held in both hands (the whole shaft and the barbed tip).",
"ssg_boss2":"the big bone club raised in his left hand. Keep the paper lantern with green fire in his other hand.",
"ssg_elite":"the hoe raised above his head in both hands and the flying dirt clods.",
"ssg_king":"the big bone club raised in his right hand.",
"wkj_bing":"the curved katana sword raised in his right hand (blade and hilt).",
"wkj_boss":"the long curved sword held in both hands (the whole blade and hilt).",
"wkj_boss2":"the long wooden oar held in both hands (the whole oar).",
"wkj_elite":"the burning torch held in his right hand (torch and its flame). Keep the flying round clay bomb pot on the right.",
"wkj_king":"the naginata / long polearm with curved blade held in both hands (the whole pole and blade).",
"wkj_shoot":"the long matchlock musket held in both hands (the whole gun and the small smoke at its fuse). Keep the gourd bottle on his hip.",
"wkj_tank":"the iron anchor and the thick rope swung in his raised hand (the whole anchor and all of the rope, including the rope coiled around him).",
"zzj_bing":"the curved broad saber held out in his right hand (blade and hilt).",
"zzj_boss":"the long guandao polearm with crescent blade held in both hands (the whole pole and blade).",
"zzj_boss2":"the long red-and-gold staff held in both hands (the whole staff). Keep the red lantern hanging at his hip.",
"zzj_elite":"the long spear held in his raised hand (the whole shaft, spearhead and tassel). Keep the paper horse he is riding.",
"zzj_king":"the big long-handled battle axe held in both hands above his head (the whole axe and its tassels).",
"zzj_shoot":"the bow and the arrow held in his hands (the whole bow, string and arrow). Keep the quiver of arrows on his back.",
}

KEYS=list(W.keys())
def ov(k):
    i=KEYS.index(k)
    bits=[(i>>b)&1 for b in range(6)]
    return ("window.__ov&&window.__ov.remove();const g=[...document.querySelectorAll('main img')].filter(i=>i.alt.startsWith('產生的圖片')).pop();"
     "const d=document.createElement('div');d.style.cssText='position:fixed;inset:0;background:#fff;z-index:2147483647';"
     "const im=document.createElement('img');im.src=g.src;im.style.cssText='position:absolute;left:0;top:0;width:820px;height:820px;display:block';d.appendChild(im);"
     "const B="+json.dumps(bits)+";const mk=(x,c)=>{const s=document.createElement('div');s.style.cssText=`position:absolute;left:${x}px;top:830px;width:30px;height:30px;background:${c}`;d.appendChild(s)};"
     "mk(0,'#ff0000');B.forEach((b,j)=>mk(40+j*40,b?'#000':'#fff'));mk(300,'#00ff00');"
     "document.body.appendChild(d);window.__ov=d;[g.naturalWidth,g.naturalHeight,innerHeight]")

def send(k):
    P=B+W[k]
    return ("const P="+json.dumps(P)+";const e=document.querySelector('.ProseMirror');if(e.innerText.trim()!==''&&!window.__mine){'DRAFT:'+e.innerText.slice(0,80)}else{e.focus();document.execCommand('selectAll');document.execCommand('insertText',false,P);"
        "await new Promise(r=>setTimeout(r,4000));const t=e.innerText.trim();const same=t===P.trim();"
        "const b=document.querySelector('#composer-submit-button')||document.querySelector('form button[aria-label=\"傳送\"]');"
        "const n=document.querySelectorAll('form img').length;let sent=false;if(same&&b&&!b.disabled&&n>0){b.click();sent=true}"
        "await new Promise(r=>setTimeout(r,5000));JSON.stringify({same,n,sent,url:location.href})}")
if __name__=="__main__":
    k=sys.argv[1]; m=sys.argv[2] if len(sys.argv)>2 else 'send'
    print(send(k) if m=='send' else ov(k))
