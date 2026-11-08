# 把切好的素材縮到合適尺寸、轉成 webp，寫進 src/assets.js（缺的會略過，之後重跑即可）
import base64, io, os, json
from PIL import Image
CHAR = ['afu','afu_body','afu_tie','xiaozhi','egui','eguiking','xiaogui','toyol','laojiang','zombie','shuigui','pontianak','pocong','penanggal','mengpo','youhun','baiwu','heiwu','niutou','mamian','huang','zhiren','tianhua','npc_ken','npc_boss','npc_guard','npc_auntie','npc_it','npc_mis']
BLD = ['house','gate','plank','bun','wood','rice','store','home','camp','altar','furnace']
RIG = ['rg_afu_head','rg_afu_head_s','rg_afu_head_h','rg_afu_head_p','rg_afu_torso','rg_afu_tie','rg_afu_uarmF','rg_afu_farmF','rg_afu_uarmB','rg_afu_farmB','tool_axe','tool_mallet','tool_sickle','fx_dough','fx_plank','fx_chips','fx_spark','fx_dust']
RIG2 = ["rg_baiwu_farmB", "rg_baiwu_farmF", "rg_baiwu_head", "rg_baiwu_head_a", "rg_baiwu_head_h", "rg_baiwu_torso", "rg_baiwu_uarmB", "rg_baiwu_uarmF", "rg_egui_farmB", "rg_egui_farmF", "rg_egui_head", "rg_egui_head_a", "rg_egui_head_h", "rg_egui_torso", "rg_egui_uarmB", "rg_egui_uarmF", "rg_eguiking_farmB", "rg_eguiking_farmF", "rg_eguiking_head", "rg_eguiking_head_a", "rg_eguiking_head_h", "rg_eguiking_torso", "rg_eguiking_uarmB", "rg_eguiking_uarmF", "rg_heiwu_farmB", "rg_heiwu_farmF", "rg_heiwu_head", "rg_heiwu_head_a", "rg_heiwu_head_h", "rg_heiwu_torso", "rg_heiwu_uarmB", "rg_heiwu_uarmF", "rg_huang_farmB", "rg_huang_farmF", "rg_huang_head", "rg_huang_head_a", "rg_huang_head_h", "rg_huang_torso", "rg_huang_uarmB", "rg_huang_uarmF", "rg_laojiang_farmB", "rg_laojiang_farmF", "rg_laojiang_head", "rg_laojiang_head_a", "rg_laojiang_head_h", "rg_laojiang_torso", "rg_laojiang_uarmB", "rg_laojiang_uarmF", "rg_mamian_farmB", "rg_mamian_farmF", "rg_mamian_head", "rg_mamian_head_a", "rg_mamian_head_h", "rg_mamian_torso", "rg_mamian_uarmB", "rg_mamian_uarmF", "rg_mengpo_farmB", "rg_mengpo_farmF", "rg_mengpo_head", "rg_mengpo_head_a", "rg_mengpo_head_h", "rg_mengpo_torso", "rg_mengpo_uarmB", "rg_mengpo_uarmF", "rg_niutou_farmB", "rg_niutou_farmF", "rg_niutou_head", "rg_niutou_head_a", "rg_niutou_head_h", "rg_niutou_torso", "rg_niutou_uarmB", "rg_niutou_uarmF", "rg_npc_auntie_farmB", "rg_npc_auntie_farmF", "rg_npc_auntie_head", "rg_npc_auntie_head_b", "rg_npc_auntie_head_c", "rg_npc_auntie_head_f", "rg_npc_auntie_head_q", "rg_npc_auntie_head_s", "rg_npc_auntie_head_t", "rg_npc_auntie_head_x", "rg_npc_auntie_legB", "rg_npc_auntie_legF", "rg_npc_auntie_torso", "rg_npc_auntie_uarmB", "rg_npc_auntie_uarmF", "rg_npc_boss_farmB", "rg_npc_boss_farmF", "rg_npc_boss_head", "rg_npc_boss_head_b", "rg_npc_boss_head_c", "rg_npc_boss_head_f", "rg_npc_boss_head_q", "rg_npc_boss_head_s", "rg_npc_boss_head_t", "rg_npc_boss_head_x", "rg_npc_boss_legB", "rg_npc_boss_legF", "rg_npc_boss_torso", "rg_npc_boss_uarmB", "rg_npc_boss_uarmF", "rg_npc_guard_farmB", "rg_npc_guard_farmF", "rg_npc_guard_head", "rg_npc_guard_head_b", "rg_npc_guard_head_c", "rg_npc_guard_head_f", "rg_npc_guard_head_q", "rg_npc_guard_head_s", "rg_npc_guard_head_t", "rg_npc_guard_head_x", "rg_npc_guard_legB", "rg_npc_guard_legF", "rg_npc_guard_torso", "rg_npc_guard_uarmB", "rg_npc_guard_uarmF", "rg_npc_ken_farmB", "rg_npc_ken_farmF", "rg_npc_ken_head", "rg_npc_ken_head_b", "rg_npc_ken_head_c", "rg_npc_ken_head_f", "rg_npc_ken_head_q", "rg_npc_ken_head_s", "rg_npc_ken_head_t", "rg_npc_ken_head_x", "rg_npc_ken_legB", "rg_npc_ken_legF", "rg_npc_ken_torso", "rg_npc_ken_uarmB", "rg_npc_ken_uarmF", "rg_pontianak_farmB", "rg_pontianak_farmF", "rg_pontianak_head", "rg_pontianak_head_a", "rg_pontianak_head_h", "rg_pontianak_torso", "rg_pontianak_uarmB", "rg_pontianak_uarmF", "rg_shuigui_farmB", "rg_shuigui_farmF", "rg_shuigui_head", "rg_shuigui_head_a", "rg_shuigui_head_h", "rg_shuigui_torso", "rg_shuigui_uarmB", "rg_shuigui_uarmF", "rg_tianhua_farmB", "rg_tianhua_farmF", "rg_tianhua_head", "rg_tianhua_head_a", "rg_tianhua_head_h", "rg_tianhua_torso", "rg_tianhua_uarmB", "rg_tianhua_uarmF", "rg_xiaogui_farmB", "rg_xiaogui_farmF", "rg_xiaogui_head", "rg_xiaogui_head_a", "rg_xiaogui_head_h", "rg_xiaogui_torso", "rg_xiaogui_uarmB", "rg_xiaogui_uarmF", "rg_xiaozhi_farmB", "rg_xiaozhi_farmF", "rg_xiaozhi_head", "rg_xiaozhi_head_a", "rg_xiaozhi_head_h", "rg_xiaozhi_torso", "rg_xiaozhi_uarmB", "rg_xiaozhi_uarmF", "rg_youhun_farmB", "rg_youhun_farmF", "rg_youhun_head", "rg_youhun_head_a", "rg_youhun_head_h", "rg_youhun_torso", "rg_youhun_uarmB", "rg_youhun_uarmF", "rg_zhiren_farmB", "rg_zhiren_farmF", "rg_zhiren_head", "rg_zhiren_head_a", "rg_zhiren_head_h", "rg_zhiren_torso", "rg_zhiren_uarmB", "rg_zhiren_uarmF", "rg_zombie_farmB", "rg_zombie_farmF", "rg_zombie_head", "rg_zombie_head_a", "rg_zombie_head_h", "rg_zombie_torso", "rg_zombie_uarmB", "rg_zombie_uarmF", "tool_baiwu", "tool_mamian", "tool_niutou", "tool_npc_auntie", "tool_npc_boss", "tool_npc_guard", "tool_npc_ken"]
import glob as _g
LIMB = sorted(os.path.basename(f)[:-4] for f in _g.glob('cut/*__*.png'))
EXTRA = ['cover','btn_new','btn_cont']
# 新鬼 56 隻（n30_rigs.js；40 隻傳統鬼怪 + 16 隻各種死法；還沒進名冊）：刪一隻 = 刪這裡一個名字 + n30_rigs.js 一行
N30 = ['n30_' + k for k in 'diaosi wutou yecha hanba changgui guixinniang shanxiao baigujing qionggui dugui jiugui yangui guhangui taozhai danxiao maoshi hanturaya polong pelesit jenglot hantugalah jerangkung genderuwo bunian maenak phiam churel vetala kappa rokurokubi kuchisake yukionna kasaobake nopperabo chochin gashadokuro banshee hannya aswang tikbalang chehuo diansi dongsi yezi liulian yesi xiaosi xiasi leipi zipai zhongshu chengsi shedu shidu daji xiangcai'.split()]
OFFICE = ['of_desk_back_empty','op_mon_back','op_mug_back','of_desk_side','of_desk_side_empty','op_mon_side_on','op_mon_side_off','of_desk_clean','of_chair_back','of_chair_front','of_copier','of_water','of_lamp','of_plant','of_cabinet','of_fan','op_paper','op_paper_fly','op_stack','op_mug','op_mon_on','op_mon_static','op_mon_off','op_keyboard','op_clockface','op_bin','op_whiteboard','op_phone','op_cactus','op_sticky','op_box','op_binder']
DAO = ['npc_daoshi','npc_daoshi_walk','npc_daoshi_ritual','npc_daoshi_jump']  # 道士（回陽間・scare.js）：四張原畫同一個縮放比例（頭一樣大）
MIS = ['npc_mis_walk','npc_mis_selfie','npc_mis_jump']  # 美美的其他姿勢：跟站著那張同一個縮放比例（舊的 npc_sec* 不打包）
SIT = ['npc_ken_sit','npc_ken_sit_stretch','npc_ken_sit_coffee','npc_ken_sit_jump','npc_it_sit','npc_it_sit_tea','npc_it_sit_jump']  # 坐著的阿Ken：四張同一個縮放比例（頭才一樣大）
PROP = OFFICE + ['street_strainer','street_lanternW','street_lanternR','tomb1','tomb2','tomb3','tomb4','willo','tree','tree_bare','stump','crowfly','crowsit','scarecrow','paddy','paddy_cut','grave','lamppost','banana','tianhua_hang']
def enc(im, scale, q):
    im = im.convert('RGBA')
    if scale < 1: im = im.resize((max(1, round(im.width * scale)), max(1, round(im.height * scale))), Image.LANCZOS)
    b = io.BytesIO(); im.save(b, 'WEBP', quality=q, method=4); return im.size, base64.b64encode(b.getvalue()).decode()
out, meta = {}, {}
afu_h = Image.open('cut/afu_body.png').height
# 三個反派 NPC（npc_antag.js）：每人四張原畫，同一個縮放規則（籃球是 cut/npc_rival*__ball，跟 LIMB 規則自動打包）
ANTAG = [b + p for b in ('npc_rival', 'npc_hr', 'npc_kpiboss') for p in ('', '_walk', '_gossip', '_jump', '_stamp', '_yell') if os.path.exists(f'cut/{b}{p}.png')]
for n in CHAR + N30 + ANTAG + MIS + DAO + SIT + BLD + PROP + EXTRA + RIG + RIG2 + LIMB:
    p = f'cut/{n}.png'
    if not os.path.exists(p): continue
    im = Image.open(p)
    if n in ('afu_body', 'afu_tie'): sc = 420 / afu_h          # 兩層同比例，才能對齊
    elif n in LIMB: sc = 420 / Image.open(f'cut/{n.split("__")[0]}.png').height if not n.endswith('__wpn') else 420 / Image.open(f'cut/{n.split("__")[0]}.png').height
    elif n in RIG or n in RIG2: sc = 0.55                                  # 分件同一比例，關節才對得上
    elif n in CHAR or n in N30 or n in ANTAG: sc = min(1, 420 / im.height)
    elif n in SIT: sc = 420 / 627
    elif n in MIS: sc = 420 / Image.open('cut/npc_mis.png').height
    elif n in DAO: sc = 420 / Image.open('cut/npc_daoshi.png').height
    elif n == 'cover': sc = min(1, 1152 / im.height)
    elif n in ('btn_new', 'btn_cont'): sc = min(1, 700 / im.width)
    elif n in BLD: sc = min(1, 520 / max(im.size))
    else: sc = min(1, 440 / max(im.size))
    size, b = enc(im.convert('RGB') if n == 'cover' else im, sc, 86 if n in CHAR or n in N30 or n in ANTAG or n in MIS or n in DAO or n in SIT or n == 'cover' else 84)
    out[n] = 'data:image/webp;base64,' + b; meta[n] = size
bgs = {}
for f in sorted(os.listdir('bg')):
    if f[:-4] in ('office_empty',): continue  # 回陽間：舊的一點透視辦公室，已經換成橫向全景 office_pano
    im = Image.open(f'bg/{f}').convert('RGB')
    b = io.BytesIO(); im.save(b, 'WEBP', quality=82 if f[:-4] == 'office_pano' else 80, method=4)  # 全景用原圖解像度（5964×1024），手機上放大都清
    bgs[f[:-4]] = 'data:image/webp;base64,' + base64.b64encode(b.getvalue()).decode()
open('../src/assets.js', 'w').write('// 自動產生：ChatGPT 生成的蠟筆畫素材\nconst SPR_SRC = ' + json.dumps(out) + ';\nconst SPR_SIZE = ' + json.dumps(meta) + ';\nconst BG_SRC = ' + json.dumps(bgs) + ';\n')
print('sprites', len(out), 'bgs', sorted(bgs), 'KB', os.path.getsize('../src/assets.js') // 1024, 'missing', [n for n in CHAR + BLD + PROP if n not in out])
print(json.dumps(meta))
