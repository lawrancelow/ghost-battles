from mk import L,A
import zheng as Z
SW=lambda n:'swish-bamboo-stick-weapon-swhoshes/x/swosh-%02d.flac'%n
MEG1='wind-hit-time-morph/x/qubodup-megaswosh1.wav'; MEG2='wind-hit-time-morph/x/qubodup-megaswosh2.wav'; SLOMO='wind-hit-time-morph/x/qubodup-slomo1.wav'
SWD=lambda n:'20-sword-sound-effects-attacks-and-clashes/x/sword - StarNinjas/sword.%d.ogg'%n
CLA=lambda n:'20-sword-sound-effects-attacks-and-clashes/x/sword_clash.%d.ogg'%n
IMP=lambda n:'10-impactshield-blocks/x/impact.%d.ogg'%n
DING=lambda n:'4-metal-dingsrings/x/ding.%d.ogg'%n
PUN=lambda n:'punch/x/qubodupPunch/qubodupPunch0%d.flac'%n
BANG=lambda s:'25-cc0-bang-firework-sfx/x/%s.ogg'%s
BFH=lambda s:'75-cc0-breaking-falling-hit-sfx/x/bfh1_%s.ogg'%s
RPG=lambda s:'rpg-sound-pack/x/RPG Sound Pack/'+s
R80=lambda s:'80-cc0-rpg-sfx/x/%s.ogg'%s
C100=lambda s:'100-cc0-sfx/x/%s.ogg'%s
C2=lambda s:'100-cc0-sfx-2/x/sfx100v2_%s.ogg'%s
K50=lambda s:'50-rpg-sound-effects/x/OGG/%s.ogg'%s
KUI=lambda s:'interface-sounds/x/Audio/%s.ogg'%s
SL=lambda s:'40-cc0-water-splash-slime-sfx/x/%s.ogg'%s
BOT=lambda s:'liquid-bottle-drink-set/x/qubodup-bottle-and-drink-sounds/%s.flac'%s
CURE=lambda n:'cure-magic/x/Cure%d.wav'%n
MAG=lambda s:'magic-spell-sfx/magical_%s.ogg'%s
DRK=lambda n:'3-dark-magic-spells/x/dark_magic/fout-0%d.flac'%n
DRAIN='energy-drain/x/qubodup-PowerDrain/flac/qubodup-PowerDrain.flac'
GB='ghost-breath/ghostbreath.flac'
MOAN=lambda n:'ghost-monster-voice-moaning-growling/x/qubodup-GhostMoans/wav/qubodup-GhostMoan0%d.wav'%n
FLAME='catching-fire/flame_0.ogg'; IGN='flare-ignition/ignition.flac'; FCR='fire-crackling/fire-1.wav'
FRZ='freeze-spell-0/freeze.wav'; ICE='ice-spells/x/ice.wav'; COLD='ice-spells/x/coldsnap.wav'
TEL='teleport-spell/teleport.wav'; CAVE='cave-in/cave_in_-_starninjas_0.ogg'
WD=lambda s:'35-wooden-crackshitsdestructions/x/wood_impact/%s.mp3.flac'%s
CH=lambda s:'chimey-ui-sounds/x/Chime_%s.mp3'%s
NTG='new-thing-get/newthingget_0.ogg'; MYS='mystery-sting/mystery_sting.ogg'
JG=lambda s:'85-short-music-jingles/x/OGG/jingles_%s/jingles_%s.ogg'%(s.rstrip('0123456789'),s)
SHADE=lambda n:RPG('NPC/shade/shade%d.wav'%n)
GOLD='sack-of-gold/gold_sack.wav'
R=lambda w=0.25,d=0.8,lp=5000:{'wet':w,'dec':d,'lp':lp}
# 每個 key：[(候選名, 說明, layers, 選項)]；選項 rv／target／maxlen
B=-18; UI=-19; ST=-21; WP=-22; ACE=-15
RC={}
def add(key,cat,where,cands): RC[key]={'cat':cat,'where':where,'c':cands}
# ---------- 副技（30 模板 → 22 種聲）----------
add('sub_slash','副技','W_CLEAVE 斬／橫掃（劈柴加班…）',[
 ('A','竹棍破風＋刀鋒切肉',[L(SW(18),g=-2),L(K50('knifeSlice2'),t=0.07,g=-4,st=-3),L(PUN(2),t=0.08,g=-6,lp=3000)],dict(target=B,maxlen=0.7)),
 ('B','重劍橫揮＋鈍擊',[L(MEG1,g=-1,st=-2),L(SWD(4),t=0.12,g=-6,lp=6000),L(IMP(8),t=0.14,g=-8,lp=2500)],dict(target=B,maxlen=0.8)),
])
add('sub_break','副技','W_BREAK 重擊破甲（為虎引路…）',[
 ('A','重擊＋木甲爆裂',[L(SW(24),g=-3,st=-2),L(PUN(4),t=0.12,g=-2),L(WD('crack05'),t=0.13,g=-5)],dict(target=B,maxlen=0.9)),
 ('B','鐵器重砸＋碎裂',[L(SW(26),g=-3),L(BFH('metal_hit_02'),t=0.10,g=-3,st=-3),L(BFH('breaking_02'),t=0.12,g=-6)],dict(target=B,maxlen=0.9)),
])
add('sub_exec','副技','A_EXEC 斬殺（夜變…）',[
 ('A','慢鏡破風＋一刀落＋低沉悶響',[L(SLOMO,g=-4,du=0.5,st=-3),L(SWD(6),t=0.30,g=-3,lp=7000),L(BANG('bang_03'),t=0.31,g=-6,lp=900)],dict(target=B,maxlen=1.2,rv=R(0.2,0.9,3000))),
 ('B','刀出鞘＋重斬',[L(RPG('battle/sword-unsheathe3.wav'),g=-4),L(SW(36),t=0.22,g=-2),L(PUN(5),t=0.30,g=-2,st=-4)],dict(target=B,maxlen=1.1)),
])
add('sub_slam','副技','T_SLAM 搥地震地／W_KNOCK 撞低（跳跳裹布、跌倒撞人…）',[
 ('A','重拳落地＋碎石',[L(PUN(2),g=0,st=-6),L(BANG('bang_03'),g=-3,lp=1200),L(BFH('rock_falling_04'),t=0.04,g=-8)],dict(target=B,maxlen=1.0,rv=R(0.15,0.6,2500))),
 ('B','木頭重撞地＋泥沙',[L(WD('impactwood10'),g=-1,st=-5),L(BFH('hit_02'),g=-3),L(BFH('rock_falling_02'),t=0.05,g=-9)],dict(target=B,maxlen=1.0)),
])
add('sub_stun','副技','T_STUN／S_STUN 定身（跳屍陣、坐心口…）',[
 ('A','悶撞＋金屬嗡鳴（震暈）',[L(PUN(3),g=-2,st=-4),L(DING(4),t=0.03,g=-6,st=-5),L(BFH('metal_hit_05'),t=0.0,g=-8)],dict(target=B,maxlen=1.0,rv=R(0.2,0.7,4000))),
 ('B','重擊＋銅鑼尾音（短）',[L(BANG('bang_07'),g=-4,lp=1500),L(C100('gong_02'),t=0.02,g=-4,st=2,du=0.9)],dict(target=B,maxlen=1.0)),
])
add('sub_guard','副技','T_GUARD／T_WALL／H_SHIELD 護盾、企硬（一毛不拔、押送歸案、骨頭碰骨頭…）',[
 ('A','盾牌擋格＋金屬餘韻',[L(IMP(3),g=-2),L(DING(2),t=0.01,g=-10,du=0.8)],dict(target=B,maxlen=0.9,rv=R(0.15,0.6))),
 ('B','骨頭碰骨頭（木＋布）',[L(WD('impactwood03'),g=-2,st=2),L(WD('impactwood07'),t=0.09,g=-4,st=4),L(RPG('inventory/cloth-heavy.wav'),t=0.0,g=-8)],dict(target=B,maxlen=0.8)),
])
add('sub_drain','副技','T_DRAIN 咬一啖吸血（餓到發狂…）',[
 ('A','咬落去＋吸氣回流',[L(RPG('NPC/beetle/bite-small.wav'),g=-2,st=-3),L(DRAIN,t=0.08,g=-5,du=0.7,fo=0.25)],dict(target=B,maxlen=1.0)),
 ('B','吸啜聲＋陰風',[L(BOT('swallow-01'),g=0),L(GB,t=0.05,g=-6,du=0.6,ss=0.3,fo=0.3,fi=0.05)],dict(target=B,maxlen=0.9)),
])
add('sub_sap','副技','S_SAP 抽走能量（借住先…）',[
 ('A','索一啖（飲管吸啜）＋下沉音',[L(BOT('swallow-04'),g=0),L(DRAIN,t=0.0,g=-8,du=0.6,st=-4,fo=0.3)],dict(target=B,maxlen=0.9)),
 ('B','陰風倒吸',[L(MEG2,g=-2,rev=True,st=-3),L(BOT('swallow-01'),t=0.2,g=-4)],dict(target=B,maxlen=0.9)),
])
add('sub_poison','副技','A_POISON 中毒（拖腸夜飛…）',[
 ('A','黏液噗一聲＋氣泡',[L(SL('slime_09'),g=0,st=-3),L(SL('bubble_01'),t=0.06,g=-6,st=-2)],dict(target=B,maxlen=0.9)),
 ('B','噴一啖毒＋嘶聲',[L(SL('slime_04'),g=-1,st=-5),L(C100('noise_02'),t=0.03,g=-10,lp=4000)],dict(target=B,maxlen=0.8)),
])
add('sub_vanish','副技','A_VANISH 消失（偷雞摸狗…）',[
 ('A','一陣陰風吹走',[L(GB,g=0,ss=0.2,du=0.8,fi=0.05,fo=0.3),L(SW(19),t=0.05,g=-6,st=-4)],dict(target=B,maxlen=1.0,rv=R(0.3,1.0,3500))),
 ('B','倒轉破風（吸入去咁消失）',[L(MEG1,g=0,rev=True,st=-2)],dict(target=B,maxlen=0.8,rv=R(0.2,0.7,4000))),
])
add('sub_dash','副技','A_BACK 閃去最後排出手（香花引路…）',[
 ('A','急閃＋落手',[L(MEG2,g=-1,st=1),L(K50('knifeSlice'),t=0.20,g=-3),L(PUN(1),t=0.21,g=-8)],dict(target=B,maxlen=0.8)),
 ('B','雙重破風＋刺',[L(SW(21),g=-2,st=2),L(SW(25),t=0.1,g=-3),L(R80('blade_02'),t=0.18,g=-5)],dict(target=B,maxlen=0.8)),
])
add('sub_shoot','副技','R_SNIPE／R_LINE／R_ANTI 遠程點殺、射穿（買大開細、伸手執檸檬…）',[
 ('A','嗖一聲＋中靶',[L(SW(4),g=-1,st=4),L(WD('impactwood13'),t=0.11,g=-4,st=3)],dict(target=B,maxlen=0.7)),
 ('B','彈射出去＋悶擊',[L(BANG('shot_03'),g=-4,lp=4000),L(SW(27),t=0.0,g=-4,st=3),L(PUN(4),t=0.12,g=-6)],dict(target=B,maxlen=0.7)),
])
add('sub_chain','副技','R_CHAIN 彈射 3 隻（出瓶亂竄…）',[
 ('A','開瓶「噗」＋三下彈撞（一下弱過一下）',[L(BOT('bottle-open-03'),g=-2,du=0.35),L(BFH('hit_10'),t=0.15,g=-3),L(BFH('hit_10'),t=0.27,g=-7,st=2),L(BFH('hit_10'),t=0.37,g=-11,st=4)],dict(target=B,maxlen=0.9)),
 ('B','三下金屬亂彈',[L(SW(2),g=-4,st=4),L(BFH('metal_hit_03'),t=0.08,g=-3),L(BFH('metal_hit_03'),t=0.2,g=-7,st=2),L(BFH('metal_hit_03'),t=0.3,g=-11,st=4)],dict(target=B,maxlen=0.9)),
])
add('sub_blast','副技','M_BLAST 範圍轟（椰子落…）',[
 ('A','跌落嚟「咚」一聲爆開（椰子落地）',[L(SW(30),g=-6,st=-3,du=0.35),L(WD('impactwood01'),t=0.26,g=-2,st=-3),L(BANG('bang_09'),t=0.27,g=-4,lp=2500)],dict(target=B,maxlen=1.3,rv=R(0.15,0.7,2500))),
 ('B','悶爆',[L(BANG('cannon_02'),g=-2,lp=3000),L(BFH('rock_falling_01'),t=0.06,g=-10)],dict(target=B,maxlen=1.2)),
])
add('sub_burn','副技','M_BURN 燒一片（赤地千里…）',[
 ('A','火舌呼一聲點著',[L(FLAME,g=0),L(IGN,t=0.0,g=-8,du=0.5,fo=0.2)],dict(target=B,maxlen=0.9)),
 ('B','點火＋劈啪',[L(IGN,g=-2,du=0.7,fo=0.3),L(FCR,t=0.1,g=-4,ss=0.5,du=0.5,fo=0.2)],dict(target=B,maxlen=0.9)),
])
add('sub_frost','副技','M_FROST 凍一片（報喪長嘯…）',[
 ('A','結冰咔嚓',[L(ICE,g=-1,du=0.8,fo=0.3),L(BFH('glass_breaking_05'),t=0.04,g=-10,st=3)],dict(target=B,maxlen=1.0)),
 ('B','寒氣＋冰裂',[L(FRZ,g=-2,du=0.9,fo=0.35),L(COLD,t=0.05,g=-6,du=0.6)],dict(target=B,maxlen=1.1)),
])
add('sub_hush','副技','M_HUSH 封口（二手煙圈…）',[
 ('A','一啖煙噴埋塊面「噗」（悶咗）',[L(C2('air_02'),g=-2,lp=3000),L(RPG('inventory/cloth-heavy.wav'),t=0.08,g=-3,lp=2000)],dict(target=B,maxlen=0.8)),
 ('B','布塞口＋悶哼',[L(RPG('inventory/cloth.wav'),g=-2),L(SHADE(2),t=0.05,g=-6,lp=1200,st=-3)],dict(target=B,maxlen=0.9)),
])
add('sub_rally','副技','S_RALLY 打氣（高帽一揚…）',[
 ('A','拍心口兩下＋古箏三音上揚（黑色幽默打氣）',[L(PUN(2),g=-4,st=3),L(PUN(2),t=0.14,g=-4,st=5),A(Z.seq([(7,0),(8,-1),(9,0)],gap=0.07,dur=0.7),t=0.22,g=-4)],dict(target=B,maxlen=1.0)),
 ('B','上揚風聲＋亮音',[L(SW(39),g=-3,rev=True),L(CH('Confirm'),t=0.18,g=-6)],dict(target=B,maxlen=1.1)),
])
add('sub_rage','副技','W_RAGE 谷氣狂暴（醉拳亂舞…）',[
 ('A','低吼一聲',[L(R80('creature_roar_02'),g=-1,st=2,du=0.8),L(PUN(3),t=0.0,g=-8)],dict(target=B,maxlen=0.9)),
 ('B','鬼嚎＋重踏',[L(MOAN(5),g=-2,st=3,du=0.7,fo=0.25),L(BFH('hit_02'),t=0.0,g=-4)],dict(target=B,maxlen=0.9)),
])
add('sub_haste','副技','S_HASTE 攻速加快（蟋蟀叫…）',[
 ('A','連續快閃破風',[L(SW(21),g=-3,st=5),L(SW(21),t=0.07,g=-4,st=7),L(SW(21),t=0.14,g=-5,st=9)],dict(target=B,maxlen=0.6)),
 ('B','加速上揚',[L(MEG2,g=-2,st=5),L(TEL,t=0.0,g=-12,du=0.5,st=5,fo=0.2)],dict(target=B,maxlen=0.7)),
])
add('sub_heal','副技','H_HOT／H_BURST 回血（紙鶴送藥、倒吊出謎題…）',[
 ('A','柔和回血光',[L(CURE(2),g=-1)],dict(target=B,maxlen=1.2)),
 ('B','清亮回血',[L(CURE(4),g=-1),L(R80('item_gem_02'),t=0.05,g=-8)],dict(target=B,maxlen=1.2)),
])
add('sub_clean','副技','H_CLEAN 淨化／S_DISPEL 驅散（湯匙敲頭、已讀不回…）',[
 ('A','湯匙敲一下＋清音散開',[L(C100('dishes_03'),g=-3),L(R80('item_gem_04'),t=0.06,g=-6),L(SW(19),t=0.08,g=-9)],dict(target=B,maxlen=1.0)),
 ('B','玻璃清音＋風散',[L(R80('item_gem_04'),g=-3),L(SW(19),t=0.04,g=-6,rev=True)],dict(target=B,maxlen=0.9)),
])
# ---------- 王牌技（ACE）：要更有份量 ----------
add('ace_strike','王牌技','ACE 攻擊／定身類（牛氣沖天、馬不停蹄、咬一口先、土地翻身、飛頭夜巡、夜梟啼、鎖魂待審、點名索命…）',[
 ('A','低頻轟＋重斬＋陰風尾',[L(MEG1,g=-3,st=-4),L(BANG('cannon_02'),t=0.18,g=-1,lp=1500),L(SWD(2),t=0.18,g=-6,lp=6000),L(GB,t=0.3,g=-10,ss=0.4,du=0.8,fo=0.4)],dict(target=ACE,maxlen=1.6,rv=R(0.3,1.2,3000))),
 ('B','山崩一擊',[L(CAVE,g=-2,du=1.2,fo=0.5),L(PUN(4),t=0.0,g=0,st=-7),L(BANG('bang_03'),t=0.0,g=-2,lp=900)],dict(target=ACE,maxlen=1.5,rv=R(0.2,1.0,2500))),
])
add('ace_curse','王牌技','ACE 控場／詛咒類（顛倒是非、夜半笑聲、犼食龍、借皮、甩鍋大師、大年夕…）',[
 ('A','鬼嚎＋低轟（壓場）',[L(MOAN(2),g=-2,du=1.2,fo=0.5),L(BANG('bang_03'),t=0.0,g=-3,lp=800),L(DRK(2),t=0.1,g=-8)],dict(target=ACE,maxlen=1.6,rv=R(0.35,1.4,3000))),
 ('B','黑魔氣湧出',[L(DRK(2),g=-1),L(BANG('cannon_04'),t=0.0,g=-5,lp=1200)],dict(target=ACE,maxlen=1.5,rv=R(0.3,1.2,3500))),
])
add('ace_bless','王牌技','ACE 增益／回血／復活類（一見發財、忘憂湯、金棒變變變、歸骨還魂、千杯不醉…）',[
 ('A','低沉起勢＋清亮光（不帶鐘聲）',[L(SW(32),g=-4,rev=True,st=-3),L(CURE(7),t=0.25,g=-2),L(BANG('bang_03'),t=0.25,g=-8,lp=700)],dict(target=ACE,maxlen=1.8,rv=R(0.3,1.3,5000))),
 ('B','升起＋光暈',[L(TEL,g=-2),L(CURE(7),t=0.15,g=-4)],dict(target=ACE,maxlen=1.8,rv=R(0.25,1.0,5000))),
])
# ---------- 狀態中招 ----------
add('st_stun','狀態','中咗定身',[
 ('A','頭頂「噹」一聲（震暈）',[L(DING(4),g=-2,st=-2,du=0.6,fo=0.3),L(PUN(3),g=-8)],dict(target=ST,maxlen=0.7)),
 ('B','悶撞',[L(BFH('metal_hit_05'),g=-2,st=-3)],dict(target=ST,maxlen=0.5)),
])
add('st_silence','狀態','中咗封口（silence）',[
 ('A','嘴被塞住「唔」',[L(SHADE(2),g=-2,lp=900,st=-2,du=0.4)],dict(target=ST,maxlen=0.5)),
 ('B','布蓋口悶響',[L(RPG('inventory/cloth-heavy.wav'),g=-2,lp=1800)],dict(target=ST,maxlen=0.5)),
])
add('st_burn','狀態','燒傷（dot 燒）',[
 ('A','嘶一聲火',[L(FLAME,g=-1,du=0.35,st=2,fo=0.15)],dict(target=ST,maxlen=0.4)),
 ('B','劈啪',[L(FCR,g=-1,ss=0.6,du=0.35,fo=0.15)],dict(target=ST,maxlen=0.4)),
])
add('st_poison','狀態','中毒（dot 毒）',[
 ('A','咕嚕氣泡',[L(SL('bubble_02'),g=-1,st=-2)],dict(target=ST,maxlen=0.5)),
 ('B','黏液',[L(SL('slime_06'),g=-1,st=-4)],dict(target=ST,maxlen=0.5)),
])
add('st_mark','狀態','易傷／破甲／重創',[
 ('A','咔一聲裂',[L(WD('crack03'),g=-1,st=2,du=0.4)],dict(target=ST,maxlen=0.45)),
 ('B','玻璃細裂',[L(BFH('glass_hit_01'),g=-2)],dict(target=ST,maxlen=0.5)),
])
add('st_flee','狀態','驚走（flee）',[
 ('A','鬼都嚇親「嘩」（高八度嘅鬼叫，黑色幽默）',[L(SHADE(14),g=-1,st=5,du=0.45,fo=0.15)],dict(target=ST,maxlen=0.5)),
 ('B','急急腳走（快破風）',[L(SW(21),g=-2,st=6),L(SW(21),t=0.08,g=-4,st=8)],dict(target=ST,maxlen=0.4)),
])
add('st_confuse','狀態','迷魂／魅惑（confuse／charm）',[
 ('A','彈簧「boing」暈陀陀（黑色幽默）',[L(C100('spring_03'),g=-2,st=-2)],dict(target=ST,maxlen=0.6)),
 ('B','細彈簧暈陀陀',[L(C100('spring_04'),g=-1)],dict(target=ST,maxlen=0.6)),
])
add('st_slow','狀態','減速（slow）',[
 ('A','慢鏡落沉',[L(SLOMO,g=-2,du=0.45,st=-3,fo=0.2)],dict(target=ST,maxlen=0.5)),
 ('B','寒氣',[L(COLD,g=-2,du=0.4,fo=0.2)],dict(target=ST,maxlen=0.45)),
])
add('st_shell','狀態','破殼／破盾（shell_break、shield_break）',[
 ('A','殼碎',[L(BFH('wood_breaking_03'),g=-1)],dict(target=ST,maxlen=0.5)),
 ('B','玻璃碎',[L(BFH('glass_breaking_02'),g=-2)],dict(target=ST,maxlen=0.5)),
])
# ---------- 名鬼養成 ----------
add('fuse','養成','融合升品成功',[
 ('A','魂魄聚合（倒吸＋亮光＋悶落）',[L(SW(33),g=-4,rev=True,st=-2),L(TEL,t=0.1,g=-3,du=1.1,fo=0.4),L(CURE(3),t=0.3,g=-6),L(PUN(2),t=0.32,g=-10,st=-5)],dict(target=-17,maxlen=1.6,rv=R(0.25,1.0,5000))),
 ('B','柔亮升起',[L(TEL,g=-3),L(CH('LevelUp'),t=0.35,g=-4)],dict(target=-17,maxlen=2.0)),
])
add('star','養成','星級突破成功（比融合更重）',[
 ('A','衝破：低轟＋火光＋上揚',[L(SW(32),g=-4,rev=True,st=-4),L(IGN,t=0.28,g=-6,du=0.7,fo=0.3),L(BANG('cannon_02'),t=0.3,g=-3,lp=1500),L(TEL,t=0.0,g=-8,du=0.6,fo=0.3)],dict(target=-15,maxlen=2.0,rv=R(0.3,1.2,4000))),
 ('B','銅鑼一響（東方）＋亮光',[L(C100('gong_01'),g=-2,du=1.4,fo=0.5),L(CURE(5),t=0.05,g=-6)],dict(target=-15,maxlen=1.9)),
])
# ---------- 裝備 ----------
add('eq_plus','裝備','裝備加工成功',[
 ('A','打鐵兩下＋叮',[L(BFH('metal_hit_04'),g=-2),L(BFH('metal_hit_04'),t=0.16,g=-1,st=1),L(R80('item_gem_01'),t=0.3,g=-6)],dict(target=UI,maxlen=0.9)),
 ('B','磨刀＋扣緊',[L(K50('knifeSlice2'),g=-4),L(K50('metalLatch'),t=0.2,g=-2)],dict(target=UI,maxlen=0.8)),
])
add('eq_wear','裝備','一鍵穿戴',[
 ('A','布＋甲片著身',[L(RPG('inventory/cloth.wav'),g=-3),L(RPG('inventory/armor-light.wav'),t=0.12,g=-2)],dict(target=UI,maxlen=0.8)),
 ('B','皮帶扣上',[L(K50('beltHandle1'),g=-3),L(K50('cloth1'),t=0.05,g=-4)],dict(target=UI,maxlen=0.8)),
])
add('eq_set','裝備','套裝湊齊（2 件／3 件）',[
 ('A','三粒叮（鏈＋清音）',[L(RPG('inventory/chainmail2.wav'),g=-6),L(R80('item_gem_02'),t=0.05,g=-3),L(R80('item_gem_02'),t=0.15,g=-3,st=3),L(R80('item_gem_02'),t=0.25,g=-3,st=7)],dict(target=UI,maxlen=1.0,rv=R(0.25,0.8,6000))),
 ('B','亮光確認',[L(CH('Confirm'),g=-2)],dict(target=UI,maxlen=1.3)),
])
add('eq_ex','裝備','專屬物掉落（稀有）',[
 ('A','神秘一響＋金光',[L(MYS,g=-2,du=2.0,fo=0.8),L(GOLD,t=0.1,g=-10,du=0.8)],dict(target=-16,maxlen=2.0)),
 ('B','寶物閃光（金屬清響＋金幣）',[L(DING(1),g=-3,du=1.6,fo=0.6),L(GOLD,t=0.05,g=-8,du=0.8,fo=0.3)],dict(target=-16,maxlen=2.0)),
])
# ---------- 魔王 ----------
add('boss_capture','魔王','魔王收服（簽約入職）',[
 ('A','鬼嚎收聲＋重印落（蓋章）',[L(MOAN(1),g=-3,du=1.0,fo=0.5),L(PUN(4),t=0.75,g=-1,st=-5),L(K50('bookClose'),t=0.76,g=-4)],dict(target=-15,maxlen=1.8,rv=R(0.25,1.0,3000))),
 ('B','黑氣收入＋銅鑼',[L(DRK(2),g=-3,rev=True),L(C100('gong_02'),t=1.0,g=-2)],dict(target=-15,maxlen=2.4)),
])
add('soul_drop','魔王','掉魂魄（魔王魂魄、精魄）',[
 ('A','一縷陰風＋清音',[L(GB,g=-3,ss=0.5,du=0.7,fi=0.1,fo=0.3),L(R80('item_gem_04'),t=0.2,g=-4)],dict(target=-18,maxlen=1.1,rv=R(0.3,0.9,5000))),
 ('B','魂魄飄落（清音＋倒吸）',[L(SW(19),g=-6,rev=True),L(R80('item_gem_04'),t=0.18,g=-2)],dict(target=-18,maxlen=1.1)),
])
# ---------- 戰報 ----------
add('mvp','戰報','戰後統計 MVP 出現',[
 ('A','銅鑼＋冥幣（東方、唔係教堂鐘）',[L(C100('gong_02'),g=-2),L(GOLD,t=0.08,g=-8,du=0.8,fo=0.3)],dict(target=-17,maxlen=1.5)),
 ('B','短喝采旋律',[L(JG('HIT03'),g=-2)],dict(target=-17,maxlen=1.8)),
])
# ---------- 陣容預設 ----------
add('preset_load','陣容','陣容預設：一鍵上陣',[
 ('A','翻名冊＋拍枱',[L(K50('bookFlip1'),g=-4),L(K50('bookPlace1'),t=0.18,g=-2)],dict(target=UI,maxlen=0.7)),
 ('B','卡牌一疊',[L(K50('bookPlace2'),g=-2),L(K50('bookPlace3'),t=0.08,g=-4)],dict(target=UI,maxlen=0.5)),
])
add('preset_save','陣容','陣容預設：存',[
 ('A','合埋名冊',[L(K50('bookClose'),g=-2)],dict(target=UI,maxlen=0.4)),
 ('B','蓋印',[L(PUN(4),g=-4,st=-2),L(K50('bookPlace1'),g=-4)],dict(target=UI,maxlen=0.5)),
])
# ---------- 漂浮兵器普攻 ----------
add('wp_thrust','兵器普攻','直刺（竹竿、叉、地拖…）',[
 ('A','短破風＋刺中',[L(SW(27),g=-2,st=3,du=0.2),L(PUN(1),t=0.08,g=-8)],dict(target=WP,maxlen=0.35)),
 ('B','尖刺',[L(R80('blade_01'),g=-2)],dict(target=WP,maxlen=0.35)),
])
add('wp_swing','兵器普攻','揮斬（菜刀、喉通、環首刀…）',[
 ('A','揮刀破風＋切',[L(SW(18),g=-2),L(K50('knifeSlice'),t=0.06,g=-8,du=0.3)],dict(target=WP,maxlen=0.45)),
 ('B','重揮',[L(SW(25),g=-1,st=-1)],dict(target=WP,maxlen=0.4)),
])
add('wp_spin','兵器普攻','轉住撞（輪、盤…）',[
 ('A','嗚嗚轉＋撞',[L(SW(21),g=-4,st=2),L(SW(21),t=0.09,g=-4,st=3),L(BFH('hit_10'),t=0.2,g=-5)],dict(target=WP,maxlen=0.45)),
 ('B','旋風',[L(SW(24),g=-2,st=3,du=0.35)],dict(target=WP,maxlen=0.4)),
])
add('wp_throw','兵器普攻','飛出去（擲出再飛返）',[
 ('A','嗖出去＋撞',[L(SW(39),g=-3,st=2),L(WD('impactwood13'),t=0.14,g=-5,st=3)],dict(target=WP,maxlen=0.45)),
 ('B','迴旋飛',[L(SW(33),g=-2,st=3,du=0.4)],dict(target=WP,maxlen=0.45)),
])
# ---------- 東方味候選：本組原創古箏撥弦（D F G A C 五聲，同背景音樂同一音階）----------
from mk import A
import zheng as Z
def C(key,cid,desc,layers,opt): RC[key]['c'].append((cid,desc,layers,opt))
C('fuse','C','古箏上行掃弦＋魂魄聚合（東方）',[L(SW(33),g=-6,rev=True,st=-2),A(Z.seq([(4,0),(5,-1),(6,-1),(7,-2),(8,-2),(9,-3)],gap=0.055,dur=1.3),t=0.22,g=-1)],dict(target=-17,maxlen=1.8,rv=R(0.25,1.2,6000)))
C('star','C','古箏刮奏＋銅鑼重落（東方，最有份量）',[L(SW(32),g=-5,rev=True,st=-4),A(Z.seq([(3,0),(4,0),(5,-1),(6,-1),(7,-2),(8,-2),(9,-2),(10,-3),(11,-3)],gap=0.04,dur=1.4),t=0.18,g=-2),L(C100('gong_02'),t=0.55,g=-2),L(PUN(2),t=0.55,g=-6,st=-6)],dict(target=-15,maxlen=2.4,rv=R(0.25,1.3,5000)))
C('mvp','C','銅鑼＋古箏三音（東方）',[L(C100('gong_02'),g=-3),A(Z.seq([(7,0),(9,-1),(11,-1)],gap=0.11,dur=1.2),t=0.12,g=-3)],dict(target=-17,maxlen=1.7,rv=R(0.2,1.0,6000)))
C('soul_drop','C','一粒古箏推弦音＋陰風',[L(GB,g=-6,ss=0.5,du=0.7,fi=0.1,fo=0.3),A(Z.pluck(Z.SC[8],dur=1.0,bend=2.0),t=0.08,g=-2)],dict(target=-18,maxlen=1.1,rv=R(0.3,1.0,6000)))
C('eq_ex','C','古箏下上掃＋金幣（稀有掉落）',[A(Z.seq([(11,0),(9,-1),(7,-1),(9,-1),(11,0),(12,-1)],gap=0.06,dur=1.3),g=-1),L(GOLD,t=0.3,g=-9,du=0.8,fo=0.3)],dict(target=-16,maxlen=2.0,rv=R(0.25,1.1,6000)))
C('sub_heal','C','古箏泛音兩粒（輕柔回血）',[A(Z.seq([(9,0),(11,-2)],gap=0.12,dur=1.0,harm=True),g=-1),L(SW(19),g=-12,rev=True)],dict(target=B,maxlen=1.1,rv=R(0.3,1.0,7000)))
C('ace_bless','C','低沉起勢＋古箏泛音和弦（東方加持）',[L(SW(32),g=-4,rev=True,st=-3),A(Z.seq([(7,0),(9,-1),(11,-1),(12,-2)],gap=0.05,dur=1.4,harm=True),t=0.25,g=-1),L(BANG('bang_03'),t=0.25,g=-7,lp=700)],dict(target=ACE,maxlen=1.9,rv=R(0.3,1.3,6000)))
C('boss_capture','C','鬼嚎收聲＋古箏低音推弦＋蓋印',[L(MOAN(1),g=-4,du=0.9,fo=0.5),A(Z.pluck(Z.SC[0],dur=1.3,bend=1.0),t=0.7,g=-1),L(PUN(4),t=0.7,g=-2,st=-5)],dict(target=-15,maxlen=2.0,rv=R(0.25,1.0,4000)))
C('eq_set','C','古箏三粒湊齊',[A(Z.seq([(7,0),(8,-1),(9,0)],gap=0.1,dur=0.9),g=-1)],dict(target=UI,maxlen=1.2,rv=R(0.2,0.8,6000)))
