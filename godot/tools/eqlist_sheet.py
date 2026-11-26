#!/usr/bin/env python3
# [equip-list] 武器裝備清單排版：讀 data/nat/equip.json ＋ Godot 出嘅實際圖示（tools/tests/eqlist_test.gd → /home/claude/art/out/raw/）
# 出：/home/claude/art/out/HC_Equip_List_p<N>.jpg（每張 ≤1400×2200）、HC_Equip_List.csv（UTF-8 BOM）
# 用法：先跑 edtest.sh ... eqlist_test.gd all，再 python3 tools/eqlist_sheet.py
# 字型：Noto Sans CJK HK（SIL OFL，可商用）
import json, os, csv
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
OUT = "/home/claude/art/out/"
RAW = OUT + "raw/"
FB = "/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc"
FR = "/usr/share/fonts/opentype/noto/NotoSansCJK-Medium.ttc"
HK = 4
def F(sz, b=False): return ImageFont.truetype(FB if b else FR, sz, index=HK)

D = json.load(open(os.path.join(ROOT, "data", "nat", "equip.json"), encoding="utf-8"))
L = json.load(open(RAW + "layout.json", encoding="utf-8"))
IT = D["ITEMS"]; INFO = L["info"]; ROS = L["roster"]
GN = [g[0] for g in D["GRADE_N"]]; GC = D["GRADE_COL"]
SLOT_N = {k: v[0] for k, v in D["SLOT_N"].items()}
SETN = {k: v["n"][0] for k, v in D["SETS"].items()}
STN = {"atk": "攻擊", "hp": "血量", "taken": "受傷", "energy": "儲能", "aspd": "攻速", "spd": "移速", "heal_in": "受治療"}
SCN = {"breath": "鑊氣（同聲同氣）", "light": "照（同聲同氣）", "sound": "聲（同聲同氣）", "phone": "電話（同聲同氣）"}
ATKN = {"thrust": "突刺", "swing": "揮砍", "spin": "旋轉", "throw": "投擲"}
LOOKN = {"hand": "手持", "body": "身上", "head": "頭戴", "belt": "隨身"}
BLADE = {"cleaver", "cleaver_old", "ring_sword"}   # 有刃口、而且係揮砍：要睇刀口方向
EDGE_SEEN = {"eq_huanshou": "已查（統一畫風新圖）：刃口在右，EDGE=+1（舊圖係 −1，已改）",
             "ml_huanshou": "已查（新圖）：刃口在右，EDGE=+1（遊魂兵手持，不揮砍）",
             "eq_jue_caidao": "已查：正式圖刃口在右，EDGE=+1",
             "ml_chaidao": "已查（新圖）：崩口刃在右，EDGE=+1（遊魂兵手持，不揮砍）"}
for _k in ("parang", "podao", "hwando", "tachi", "guandao", "miaodao", "kerambit", "shuangdao", "kusarigama"):
    EDGE_SEEN["eq_w_" + _k] = "已查（新圖）：刃口在右，EDGE_W=+1"
MAT = {"m_bamboo": "竹", "m_wood": "木", "m_strip": "竹篾", "m_plank": "木板", "m_rope": "草繩", "m_paper": "紙"}

def pct(v):
    v = float(v) * 100
    s = ("%+.0f" % v) if abs(v - round(v)) < 1e-6 else ("%+.1f" % v)
    return s.replace("-", "−") + "%"
def stats(it):
    if it["kind"] == "ml":
        return "攻擊 ×%.2f　血量 ×%.2f（遊魂兵基礎倍率）" % (it["atk_k"], it["hp_k"])
    return "　".join("%s %s" % (STN.get(k, k), pct(v)) for k, v in it["st"].items())
def grade_txt(it):
    if it["kind"] == "ml": return "兵器檔★%d・%s款" % (it["tier"], it["var"])
    if it["kind"] == "ex": return "專屬（絕級）"
    return GN[it["grade"]]
def part(it):
    if it["kind"] == "ml": return {"hand": "遊魂兵・兵器", "body": "遊魂兵・護身", "head": "遊魂兵・頭戴"}[it["look"]]
    s = SLOT_N[it["slot"]]
    if it["look"] == "head": s += "（頭戴）"
    return s
def src(it):
    if it["kind"] == "ml":
        return "兵器檔製作（★%d 解鎖，%s）" % (it["tier"], "＋".join("%s×%d" % (MAT.get(k, k), v) for k, v in it["rec"].items()))
    if it["kind"] == "ex": return "打魔王掉落（收咗嘅王牌首殺必掉，之後 8%）"
    g = it["grade"]
    mk = "兵器檔製作（★%d、%d 冥幣）" % (it["star"], it["coin"])
    return {0: mk, 1: mk, 2: mk + "／回陽間燒落嚟", 3: "回陽間嚇人燒落嚟（三星 35%）", 4: "打魔王掉落（4%）"}[g]
def plus(it):
    if it["kind"] == "ml": return "不可加工"
    if it["kind"] == "ex": return "+10（王牌技每級 +5%，+5／+10 各快 2 秒）"
    return "+10（每級該件數值 +8%）"
def weapon(id):
    it = IT[id]; i = INFO[id]
    if it["look"] != "hand": return None
    sty = ATKN[i["atk"]] if it["kind"] == "eq" else "手持（遊魂兵貼手，不漂浮）"
    if id in EDGE_SEEN: e = EDGE_SEEN[id]
    elif i["atk"] == "swing" and it["kind"] == "eq": e = "無刃（不涉刀口方向）"
    else: e = "不適用（非揮砍刃器）"
    return sty, e
def owner(id):
    it = IT[id]
    if it["kind"] != "ex": return ""
    k = it["owner"]; r = ROS.get(k, {})
    return "%s（%s）" % (r.get("n", k), k)

def order():
    out = []
    for sl in ["wea", "arm", "acc", "ex"]:
        for g in range(5):
            ids = [i for i, v in IT.items() if v["kind"] in ("eq", "ex") and v["slot"] == sl and v["grade"] == g]
            if ids: out.append(("%s・%s" % (SLOT_N[sl], "王牌專屬物" if sl == "ex" else GN[g] + "品"), GC[g], ids))
    for look, nm in [("hand", "兵器"), ("body", "護身"), ("head", "頭戴")]:
        ids = sorted([i for i, v in IT.items() if v["kind"] == "ml" and v["look"] == look], key=lambda i: (IT[i]["tier"], IT[i]["var"]))
        out.append(("遊魂兵裝備・%s（兵器檔 ★0–6）" % nm, "#8a8478", ids))
    return out

# ---------- 圖 ----------
ICONS = Image.open(RAW + "icons.png").convert("RGBA")
FLOAT = Image.open(RAW + "float.png").convert("RGBA")
def icon(id, sz):
    i = L["ids"].index(id); cw = L["cw"]; c = L["cols"]
    x, y = (i % c) * cw, (i // c) * cw
    return ICONS.crop((x, y, x + cw, y + cw)).resize((sz, sz), Image.LANCZOS)
def float_frames(id):
    i = L["float"].index(id); o = []
    for j, (fx) in enumerate([0, 1, 2]):
        x0 = fx * 320; y0 = i * 320
        box = (x0 + 105, y0 + 140, x0 + 295, y0 + 300) if fx != 2 else (x0 + 25, y0 + 140, x0 + 215, y0 + 300)
        o.append(FLOAT.crop(box))
    return o

W, H = 1400, 2200
M = 28; GAP = 16
CW = (W - M * 2 - GAP) // 2
BG = (243, 236, 222); CARD = (255, 251, 242); INK = (42, 26, 16); SUB = (110, 92, 78)

def hexc(h): h = h.lstrip("#"); return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))
def wrap(d, txt, f, w):
    lines = []; cur = ""
    for ch in txt:
        if d.textlength(cur + ch, font=f) > w and cur: lines.append(cur); cur = ch
        else: cur += ch
    if cur: lines.append(cur)
    return lines

def card_lines(id):
    it = IT[id]
    rows = [("部位", part(it) + "　類別：" + (it.get("cat") or "—")),
            ("數值", stats(it))]
    extra = []
    if it.get("tag"): extra.append("附帶本領「%s」" % it["tag"])
    if it.get("sc"): extra.append(SCN.get(it["sc"], it["sc"]))
    if extra: rows.append(("本領", "　".join(extra)))
    rows.append(("套裝", SETN.get(it.get("set", ""), "—")))
    rows.append(("來源", src(it)))
    rows.append(("加工", plus(it)))
    w = weapon(id)
    if w: rows.append(("打法", w[0])); rows.append(("刃口", w[1]))
    if it["kind"] == "ex": rows.append(("專屬", owner(id)))
    rows.append(("圖形", "正式美術圖" if INFO[id]["has_img"] or INFO[id]["has_icon"] else "程序暫代圖（未有美術）"))
    return rows

FT = F(34, True); FL = F(23, True); FV = F(23); FS = F(20); FH = F(32, True); FTT = F(44, True)
ICON = 190
def card_h(d, id):
    h = 18 + 48
    for k, v in card_lines(id):
        h += 31 * len(wrap(d, v, FV, CW - ICON - 40 - 62))
    h = max(h + 12, ICON + 60)
    if id in L["float"]: h += 176 + 34
    return h

def draw_card(im, d, x, y, id, h):
    it = IT[id]; g = it.get("grade", 0) if it["kind"] != "ml" else 0
    gc = hexc(GC[4] if it["kind"] == "ex" else GC[g]) if it["kind"] != "ml" else hexc("#8a8478")
    d.rounded_rectangle((x, y, x + CW, y + h), 14, fill=CARD, outline=gc, width=4)
    ic = icon(id, ICON); im.paste(ic, (x + 14, y + 52), ic)
    # 名＋品級章
    d.text((x + 18, y + 10), it["n"][0], font=FT, fill=INK)
    gt = grade_txt(it)
    tw = d.textlength(gt, font=FL)
    d.rounded_rectangle((x + CW - tw - 34, y + 12, x + CW - 14, y + 48), 8, fill=gc)
    d.text((x + CW - tw - 24, y + 14), gt, font=FL, fill=(255, 255, 255))
    d.text((x + 18, y + 52 + ICON + 4), id, font=FS, fill=SUB)
    tx = x + ICON + 30; ty = y + 62
    for k, v in card_lines(id):
        d.text((tx, ty), k, font=FL, fill=gc if k in ("刃口", "專屬") else SUB)
        col = (176, 40, 40) if ("暫代" in v or "重查" in v) else INK
        for ln in wrap(d, v, FV, CW - ICON - 40 - 62):
            d.text((tx + 58, ty), ln, font=FV, fill=col); ty += 31
    if id in L["float"]:
        fy = y + h - 176 - 30
        d.text((x + 18, fy - 2), "遊戲內漂浮兵器（紅點＝目標）：待機・面向右揮落中・面向左揮落中", font=FS, fill=SUB)
        fw = (CW - 36 - 16) // 3
        for j, fr in enumerate(float_frames(id)):
            fr2 = fr.resize((fw, int(fr.height * fw / fr.width)), Image.LANCZOS)
            px = x + 18 + j * (fw + 8); py = fy + 28
            bgc = Image.new("RGBA", fr2.size, (44, 36, 48, 255)); bgc.alpha_composite(fr2)
            im.paste(bgc, (px, py))

def build():
    pages = []; tmp = Image.new("RGB", (10, 10)); td = ImageDraw.Draw(tmp)
    im = None; d = None; y = 0
    def newpage():
        nonlocal im, d, y
        im = Image.new("RGB", (W, H), BG); d = ImageDraw.Draw(im)
        d.text((M, 22), "過勞鬼大作戰・武器裝備清單（審批用）", font=FTT, fill=INK)
        d.text((M, 80), "圖示＝Godot 遊戲內實際渲染（eq_art.icon／eq_view2 漂浮）；數據＝data/nat/equip.json", font=FS, fill=SUB)
        pages.append(im); y = 122
    newpage()
    for title, col, ids in order():
        hs = []
        for a in range(0, len(ids), 2):
            pair = ids[a:a + 2]; hs.append((pair, max(card_h(td, i) for i in pair)))
        need = 56 + hs[0][1]
        if y + need > H - M: newpage()
        d.rectangle((M, y, W - M, y + 46), fill=hexc(col))
        d.text((M + 14, y + 3), "%s　（%d 件）" % (title, len(ids)), font=FH, fill=(255, 255, 255)); y += 56
        for pair, h in hs:
            if y + h > H - M:
                newpage()
                d.rectangle((M, y, W - M, y + 46), fill=hexc(col))
                d.text((M + 14, y + 3), "%s（續）" % title, font=FH, fill=(255, 255, 255)); y += 56
            for j, id in enumerate(pair): draw_card(im, d, M + j * (CW + GAP), y, id, h)
            y += h + GAP
        y += 8
    for n, p in enumerate(pages, 1):
        dd = ImageDraw.Draw(p); dd.text((W - M - 90, H - 34), "第 %d／%d 頁" % (n, len(pages)), font=FS, fill=SUB)
        p.save(OUT + "HC_Equip_List_p%d.jpg" % n, quality=92)
    return len(pages)

def write_csv():
    hdr = ["ID", "中文名（粵）", "中文名（普）", "部位", "外觀位置", "品級", "類別（重輕巧）", "主要數值", "附帶本領", "套裝", "來源",
           "加工上限", "攻擊方式", "刃口朝向／檢查", "專屬王牌", "圖形", "形狀代碼", "說明（粵）"]
    with open(OUT + "HC_Equip_List.csv", "w", encoding="utf-8-sig", newline="") as f:
        w = csv.writer(f); w.writerow(hdr)
        for title, col, ids in order():
            for id in ids:
                it = IT[id]; wp = weapon(id) or ("", "")
                ex = []
                if it.get("tag"): ex.append("「%s」" % it["tag"])
                if it.get("sc"): ex.append(SCN.get(it["sc"], it["sc"]))
                w.writerow([id, it["n"][0], it["n"][1], part(it), LOOKN.get(it["look"], it["look"]), grade_txt(it), it.get("cat", "") or "—",
                            stats(it), " ".join(ex), SETN.get(it.get("set", ""), ""), src(it), plus(it), wp[0], wp[1], owner(id),
                            "正式美術圖" if INFO[id]["has_img"] or INFO[id]["has_icon"] else "程序暫代圖", INFO[id]["shape"], it["d"][0]])

if __name__ == "__main__":
    n = build(); write_csv(); print("pages", n, "items", len(IT))
