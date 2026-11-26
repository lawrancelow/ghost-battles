# P45 裝備整合審批圖：HC_P45_Equip_Integrate_p1..p3.jpg（≤1400×2200，實機截圖＋中文標註）
import json
from PIL import Image, ImageDraw, ImageFont
FB = "/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc"; FR = "/usr/share/fonts/opentype/noto/NotoSansCJK-Medium.ttc"
def F(s, b=False): return ImageFont.truetype(FB if b else FR, s, index=4)
S = '/home/claude/docs/shots/'; R = '/home/claude/art/out/raw/'; OUT = '/home/claude/art/out/HC_P45_Equip_Integrate_p%d.jpg'
EQ = json.load(open('/home/claude/wt/p44/godot/data/nat/equip.json'))['ITEMS']
BG = (28, 26, 32); GOLD = (244, 214, 138); TXT = (230, 222, 205)
def page(h): im = Image.new('RGB', (1400, h), BG); return im, ImageDraw.Draw(im)
def title(d, y, t, s=34): d.text((24, y), t, font=F(s, True), fill=GOLD); return y + s + 16
def note(d, y, t, s=22, x=24, col=TXT): d.text((x, y), t, font=F(s), fill=col); return y + s + 10
def fit(im, w): return im.resize((w, round(im.height * w / im.width)), Image.LANCZOS)

# ---------- p1：裝備欄／圖鑑新圖 ----------
im, d = page(2200); y = 18
y = title(d, y, 'P45 裝備整合 1/3：新圖入遊戲（實機截圖）')
y = note(d, y, '倭寇鬼王（軍團王）著住專屬物「破帆披風」+5、二手床板盾、紙紮手提電話；左至右：專屬物格、護身格、隨身物格、鬼怪名冊')
shots = ['away/p45_ex_wkj.png', 'away/p45_arm.png', 'away/p45_acc.png', 'away/p45_roster.png']
caps = ['專屬物格（破帆披風 +5）', '護身格（二手床板盾）', '隨身物格（紙紮手提電話等）', '名冊（主角斧頭＋軍團王）']
for i, f in enumerate(shots):
    s = fit(Image.open(S + f).convert('RGB'), 335); im.paste(s, (24 + i * 342, y)); d.text((28 + i * 342, y + s.height + 4), caps[i], font=F(19, True), fill=GOLD)
y += 727 + 40
y = title(d, y, '21 件接上新圖（遊戲實際圖示，eqi_<id>_i 斜放 256）', 28)
L = json.load(open(R + 'layout.json')); ids = L['ids']; ic = Image.open(R + 'icons.png')
want = ('eq_guanban eq_paperphone eq_fengyou eq_jinzheng eq_liangchapot eq_dianzhan eq_naozhong eq_yinji eq_hero_axe eq_hero_ruler '
        'ex_lg_dpl_king ex_lg_egs_king ex_lg_jsj_jiangchen ex_lg_klj_king ex_lg_sgj_king ex_lg_ssg_king ex_lg_wkj_king ex_lg_zzj_king '
        'ex_nw_niexiaoqian ex_bm_taotie ex_bm_hou').split()
tag = {'eq_guanban': '改名', 'eq_liangchapot': '換圖', 'eq_dianzhan': '換圖', 'eq_naozhong': '換圖', 'eq_yinji': '換圖', 'eq_hero_axe': '主角男',
       'eq_hero_ruler': '主角女', 'ex_nw_niexiaoqian': 'Fix2', 'ex_bm_taotie': 'Fix2', 'ex_bm_hou': 'Fix2 去白底'}
for n, i in enumerate(want):
    j = ids.index(i); c = ic.crop(((j % 8) * 240, (j // 8) * 240, (j % 8) * 240 + 240, (j // 8) * 240 + 240)).resize((170, 170), Image.LANCZOS)
    x = 24 + (n % 7) * 196; yy = y + (n // 7) * 262
    im.paste(c, (x + 8, yy), c)
    nm = EQ[i]['n'][0]; d.text((x, yy + 174), nm[:9], font=F(20, True), fill=TXT)
    d.text((x, yy + 202), i if len(i) < 20 else i[:19], font=F(14), fill=(160, 150, 140))
    if i in tag: d.text((x, yy + 222), tag[i], font=F(16, True), fill=(168, 255, 207))
y += 3 * 262 + 10
y = note(d, y, '軍團 8 王專屬物：加工改為升「招牌技」（每級 +5%，+5、+10 各開場能量 +20）；說明文字已修正「+5%%」顯示問題。', 21)
im = im.crop((0, 0, 1400, y + 10)); im.save(OUT % 1, quality=88); print('p1', im.size)

# ---------- p2：漂浮兵器 ----------
im, d = page(2200); y = 18
y = title(d, y, 'P45 裝備整合 2/3：漂浮兵器（實機）')
fl = L['float']; fs = Image.open(R + 'float.png')
y = note(d, y, '每行：待機｜向右揮落中｜向左揮落中｜命中（刀口／刃口一律向目標）；主角斧頭刃在右、三角尺刻度直邊在左（直刺）')
rows = ['eq_hero_axe', 'eq_hero_ruler', 'eq_w_guandao', 'eq_w_hwando', 'eq_w_kusarigama', 'eq_huanshou']
for r, i in enumerate(rows):
    j = fl.index(i); row = fs.crop((0, j * 320, 1280, j * 320 + 320)).resize((960, 240), Image.LANCZOS)
    im.paste(row, (24, y)); d.text((1000, y + 90), EQ[i]['n'][0], font=F(28, True), fill=GOLD); d.text((1000, y + 132), i, font=F(18), fill=(160, 150, 140))
    y += 250
y += 6
try:
    a = Image.open(S + 'p44/solo_m_atk.png').convert('RGB'); b = Image.open(S + 'p44/solo_f_atk.png').convert('RGB')
    w = 660; a = fit(a, w); b = fit(b, w)
    if y + 40 + a.height > 2190: a = a.resize((w, 2190 - y - 40)); b = b.resize((w, 2190 - y - 40))
    y = note(d, y, '戰場實機：阿福（斧頭）／女主（三角尺）揮擊瞬間', 22, col=GOLD)
    im.paste(a, (24, y)); im.paste(b, (24 + w + 20, y)); y += a.height + 10
except Exception as e: print('solo', e)
im = im.crop((0, 0, 1400, min(2200, y + 10))); im.save(OUT % 2, quality=88); print('p2', im.size)

# ---------- p3：做工工具 ----------
im, d = page(2200); y = 18
y = title(d, y, 'P45 裝備整合 3/3：做工工具正式圖（20 件）喺動作中')
y = note(d, y, '工具浮喺面向嗰邊；用旋轉令工作面對準目標：竹鹽筒口向落、螺絲批直立批咀落錶；柴刀、鋸、膠刀、木刨刃口向工作物；鋼杯、印仔顯示偏大', 20)
B1 = Image.open('/tmp/wk_b2/p1.png'); B2 = Image.open('/tmp/wk_b2/p2.png')
A = [Image.open(S + 'work/HC_WorkAnim_All_%d.png' % k) for k in (1, 2, 3)]
def rowcrop(img, label_y, h=232, x1=1382): return img.crop((0, label_y, min(x1, img.width), label_y + h))
picks = [(B2, 568, 222, '長臂凍檸茶：拉茶（鋼杯，顯示偏大）'), (A[2], 1176, 194, '結霜表格室：蓋印（印仔，顯示偏大）'),
         (B2, 822, 222, '碟頂鹹魚：抖鹽（竹鹽筒，筒口原圖朝右上 → 旋轉令筒口對準碟）'), (B2, 1330, 222, '停咗錶檔：扭螺絲（螺絲批直立，批咀落錶）'),
         (B2, 314, 222, '割膠拖鞋廠：切鞋底（刀刃向工作物）'), (B2, 1076, 222, '頂樓棺材板躺椅：刨板（木刨，刨底刀口向板）'),
         (B1, 60, 222, '禾稈草堆：叉禾稈（禾叉）'), (B2, 60, 222, '水底吹救生圈：打氣（打氣筒：手柄＋泵身兩張圖）')]
for img, ly, h, cap in picks:
    r = img.crop((0, ly + 28, min(1382, img.width), ly + 28 + h)); r = r.resize((1352, round(r.height * 1352 / r.width)), Image.LANCZOS)
    if y + 34 + r.height > 2195: break
    y = note(d, y, cap, 21, col=GOLD); im.paste(r, (24, y)); y += r.height + 8
im = im.crop((0, 0, 1400, min(2200, y + 10))); im.save(OUT % 3, quality=88); print('p3', im.size)
