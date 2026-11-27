import sys,json,os,numpy as np
sys.path.insert(0,'/home/claude/sfxwork/v2')
from build2 import *
from ana import metrics,metal_score
OUT='/home/claude/sfxwork/v2/out'; os.makedirs(OUT,exist_ok=True)
def thud(name): x=wood(name,0.4); x=hp(x,140,3); x=dip(x,2000,6000,8); x=lp(x,3400); return tame(x,0.05,0.03)
def crack(name,dur=0.12): x=seg(P(MW+name),dur,th=0.2); x=lp(hp(x,2500),7500); x=dip(x,2000,6000,4); return tame(x,0.012,0.012)
def rust(name,dur=0.25,off=0.0): x=seg(P('20-rustles-dry-leaves/x/rustle/'+name),dur,off,th=0.25); x=lp(hp(x,200),7000); return tame(x,0.08,0.05)
def swish(n): x=seg(P('swishes-sound-pack/x/swishes/swish-%d.wav'%n),0.3,th=0.2); return hp(x,80)
def eerie(x,semi=-3,lpf=2600,wet=0.2): return diffuse(lp(pitch(x,semi),lpf),wet=wet)
SRC={'mw':('rubberduck','https://opengameart.org/content/100-cc0-metal-and-wood-sfx'),
 'rustle':('qubodup','https://opengameart.org/content/20-rustles-dry-leaves'),
 'swish':('artisticdude','https://opengameart.org/content/swishes-sound-pack'),
 'sfxpack':('OwlishMedia','https://opengameart.org/content/sound-effects-pack'),
 'cc0sfx':('rubberduck','https://opengameart.org/content/100-cc0-sfx'),
 'synth':('音效組程式合成（本專案原創）','—')}
R={}
R['wk_chop_hit']={
 'D':('厚實「篤」＋細木纖維裂聲',lambda: mix((thud('wood_hit_04.ogg'),0,0),(crack('wood_cracking_01.ogg'),-7,0.004)),[('mw','wood_hit_04.ogg'),('mw','wood_cracking_01.ogg')],False),
 'E':('低沉「咚」，斧頭深砍入樹幹',lambda: mix((thud('wood_slam_04.ogg'),0,0),(crack('wood_cracking_04.ogg'),-6,0.003)),[('mw','wood_slam_04.ogg'),('mw','wood_cracking_04.ogg')],False),
 'F':('悶實短促，帶乾木碎裂',lambda: mix((hp(thud('wood_hit_08.ogg'),230,3),0,0),(crack('wood_cracking_02.ogg'),-7,0.005)),[('mw','wood_hit_08.ogg'),('mw','wood_cracking_02.ogg')],False),
 'G':('中低頻「篤」，像砍進濕木',lambda: mix((tame(hp(thud('wood_close_02.ogg'),210,3),0.03,0.018),0,0),(crack('wood_cracking_01.ogg'),-8,0.006)),[('mw','wood_close_02.ogg'),('mw','wood_cracking_01.ogg')],False),
 'H':('較清脆的乾柴一劈',lambda: mix((tame(thud('wood_slam_01.ogg'),0.03,0.02),0,0),(crack('wood_cracking_02.ogg'),-8,0.004)),[('mw','wood_slam_01.ogg'),('mw','wood_cracking_02.ogg')],False),
 'I':('程式合成：純木質撞擊＋纖維爆裂，完全無金屬',lambda: hp(synth_chop(1),170,3),[('synth','')],False),
 'J':('陰間化：E 壓低音調＋空洞迴響（非金屬）',lambda: eerie(mix((tame(thud('wood_slam_04.ogg'),0.03,0.02),0,0),(crack('wood_cracking_04.ogg'),-6,0.003)),-3,2800,0.12),[('mw','wood_slam_04.ogg'),('mw','wood_cracking_04.ogg')],True),
 'K':('陰間化：合成木擊壓低，悶沉陰森（無金屬）',lambda: hp(eerie(synth_chop(5),-2,2800,0.12),170,3),[('synth','')],True),
}
R['wk_reap_cut']={
 'D':('「唰」一下乾稻葉沙沙＋稈子斷聲',lambda: mix((rust('rustle04.flac',0.22),0,0.006),(crack('wood_cracking_02.ogg',0.05),-10,0.0)),[('rustle','rustle04.flac'),('mw','wood_cracking_02.ogg')],False),
 'E':('短促「嚓」，稻稈齊口割斷',lambda: hp(mix((swish(4),-18,0),(rust('rustle12.flac',0.18),0,0.01)),250,3),[('swish','swish-4.wav'),('rustle','rustle12.flac')],False),
 'F':('稻稈「啪」斷一下＋葉子沙聲',lambda: mix((crack('wood_cracking_04.ogg',0.06),-6,0.0),(rust('rustle18.flac',0.22),0,0.01)),[('mw','wood_cracking_04.ogg'),('rustle','rustle18.flac')],False),
 'G':('一束稻葉沙沙＋稈子輕輕「卡」斷',lambda: mix((rust('rustle16.flac',0.2),0,0.008),(crack('wood_cracking_01.ogg',0.05),-9,0.0),(swish(10),-10,0)),[('rustle','rustle16.flac'),('mw','wood_cracking_01.ogg'),('swish','swish-10.wav')],False),
 'H':('紙質感「嚓」，偏乾脆',lambda: mix((tame(lp(hp(seg(P('100-cc0-sfx/x/paper_02.ogg'),0.2),300),5500),0.04,0.025),0,0),(swish(12),-9,0)),[('cc0sfx','paper_02.ogg'),('swish','swish-12.wav')],False),
 'I':('程式合成：氣聲「唰」＋細碎纖維斷裂',lambda: synth_reap(2),[('synth','')],False),
 'J':('陰間化：D 壓低音調＋空洞迴響',lambda: eerie(tame(mix((rust('rustle04.flac',0.15),0,0.006),(crack('wood_cracking_02.ogg',0.05),-10,0.0)),0.05,0.04),-2,4500,0.05),[('rustle','rustle04.flac'),('mw','wood_cracking_02.ogg')],True),
 'K':('陰間化：合成割稻壓低，像陰風掃過稻田',lambda: eerie(synth_reap(7),-3,4200,0.1),[('synth','')],True),
}
SX='sound-effects-pack/x/'
KS='/home/claude/sfxsrc/kenney-audio-assets/Audio (295 files)/RPG sounds (50 sounds)/'
def soft(x,lo=180,hi=2500,t0=0.06,tau=0.04): return tame(lp(hp(x,lo,3),hi),t0,tau)
def flour(dl=0.05,g=-20): return (tame(lp(hp(seg(P('20-rustles-dry-leaves/x/rustle/rustle04.flac'),0.15,th=0.2),3500),7000),0.03,0.04),g,dl)
SRC['kenney']=('Kenney (kenney.nl)','https://kenney.nl/assets/rpg-audio')
R['wk_knead_roll']={
 'D':('軟悶「噗」，手掌壓進麵團',lambda: soft(seg(KS+'cloth2.ogg',0.3),220,2400,0.04,0.03),[('kenney','cloth2.ogg')],False),
 'E':('手抓起麵團再按下，帶皮肉摩擦感',lambda: soft(seg(P(SX+'Impacts/shouldergrab.wav'),0.3),150,3000,0.08,0.05),[('sfxpack','Impacts/shouldergrab.wav')],False),
 'F':('悶「啪」一拍麵團（掌心拍，非硬物）',lambda: mix((lp(hp(seg(P(SX+'Human/solo-clap.wav'),0.2),200,3),1300),0,0),(soft(seg(P(SX+'Impacts/fruit3.wav'),0.3),180,2000),-4,0.0)),[('sfxpack','Human/solo-clap.wav'),('sfxpack','Impacts/fruit3.wav')],False),
 'G':('搓揉拉扯麵團的軟韌聲',lambda: soft(seg(KS+'handleSmallLeather.ogg',0.3),200,2600),[('kenney','handleSmallLeather.ogg')],False),
 'H':('麵團「噗」落案板＋少許麵粉沙沙',lambda: mix((soft(seg(P(SX+'Impacts/fruit2.wav'),0.3),180,2200),0,0),flour(0.03,-28)),[('sfxpack','Impacts/fruit2.wav'),('rustle','rustle04.flac')],False),
 'I':('程式合成：掌心軟拍＋擠出空氣「噗」＋麵粉細沙',lambda: synth_knead(4),[('synth','')],False),
 'J':('陰間化：F 壓低音調＋空洞感',lambda: eerie(mix((lp(hp(seg(P(SX+'Human/solo-clap.wav'),0.2),200,3),1300),0,0),(soft(seg(P(SX+'Impacts/fruit3.wav'),0.3),180,2000,0.03,0.02),-4,0.0)),-3,1800,0.05),[('sfxpack','Human/solo-clap.wav'),('sfxpack','Impacts/fruit3.wav')],True),
 'K':('陰間化：合成揉麵壓低，黏糊陰沉',lambda: hp(eerie(synth_knead(9),-3,2000,0.08),170,3),[('synth','')],True),
}
MAXD={'wk_chop_hit':0.5,'wk_reap_cut':0.5,'wk_knead_roll':0.4}
rep=[]
for ev,cs in R.items():
    for lab,(desc,fn,srcs,ee) in cs.items():
        x=finish(np.asarray(fn(),dtype=np.float64),MAXD[ev]); enc(x,f'{OUT}/{ev}_{lab}')
        m=metrics(x.astype(np.float32)); m={k:float(v) for k,v in m.items()}; ms=metal_score(m)
        rep.append(dict(event=ev,cand=lab,desc=desc,eerie=ee,dur=round(len(x)/SR,3),metal=ms,**m,
          sources=[dict(file=f,author=SRC[k][0],url=SRC[k][1],license='CC0 1.0' if k!='synth' else '原創（程式合成，無外部素材）') for k,f in srcs]))
        print(ev,lab,ms,{k:m[k] for k in ('dec','cent','ton','tflat','lo','lm','mid','hi','air')})
json.dump(rep,open(OUT+'/report.json','w'),ensure_ascii=False,indent=1)
