# -*- coding: utf-8 -*-
"""產生 godot/data/nat/zones.json（分區地圖：第 1 關 v3 定稿布局，座標以 /home/claude/ctx/layout3.py 為準）。
用法：python3 tools/zone_build.py [out]
格式（每張圖 maps["<ci>"]；冇定義嘅圖照用舊豎條布局）：
  w,h：世界大細；ground：預烘地面圖鍵（assets/img/<key>_a.webp/_b.webp，上下兩半）
  zones：[{id,type(wild|market|village|res),rect[x0,y0,x1,y1],n[粵,中],col,...}]
    res：door{rect,in,out}、power（建議戰力）、loss（自動攻佔折損陰兵比例）、fields{bid:{nodes,sign}}、shops{bid:{pos,need{bid:lv}}}、stage（親自出征戰鬥）
    wild：gate{x,w}、bosses[{id,n,stage 或 chapter[ci,si]，main}]、boss_at、decor
  roads：石板路矩形；walls 由 zones 自動計（門洞留空）
  village：POS／TREE_POS／PADDY_POS／DECOR／EXTRA／spots（打工鬼企位）／plaza（廣場鬼活動範圍）／fence（出村門柵欄）
  market：mv_data.layout 格式（counter/serve/road/j/st/q2/fence_y）＋ paths（每台搬貨路）、gates、guard_slots、vol_slots、vol_mid、porter
"""
import json, os, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "data", "nat", "zones.json")

def P(*a): return [list(x) for x in a]

M0 = {
  "w": 1340, "h": 2410, "ground": "zone1_ground",
  "cam": {"home": [670, 1420], "zoom": 1.0},
  "zones": [
    {"id": "w_graves", "type": "wild", "rect": [230, 0, 660, 420], "n": ["野外區　亂葬崗", "野外區　亂葬崗"], "col": "#8a1c24",
     "gate": {"x": 445, "w": 60}, "boss_at": [445, 270],
     "bosses": [
       {"id": "zb_paper", "n": ["紙人偶頭目", "紙人偶頭目"], "art": "zhiren", "stage": {"en": ["zhiren", "zhiren", "zhiren"], "boss": "zhiren", "p": 2}},
       # 守墓鬼：用老闆現有鬼怪 n30_jerangkung（馬來墳地骷髏鬼，喀喀響嘅骨頭；冇宗教元素），戰鬥顯示名改「亂葬崗守墓鬼」
       {"id": "zb_keeper", "n": ["亂葬崗守墓鬼", "亂葬崗守墓鬼"], "art": "n30_jerangkung", "rename": True, "stage": {"en": ["youhun", "n30_jerangkung", "youhun"], "boss": "n30_jerangkung", "p": 3}}],
     "decor": [["tree_bare", 320, 300, 70], ["tree_bare", 430, 200, 70], ["tree_bare", 560, 320, 70], ["tree_bare", 610, 180, 70],
               ["grave", 290, 380, 0], ["grave", 360, 150, 0], ["grave", 520, 390, 0], ["grave", 600, 260, 0]]},
    {"id": "w_pit", "type": "wild", "rect": [680, 0, 1110, 420], "n": ["野外區　餓鬼坑", "野外區　餓鬼坑"], "col": "#8a1c24",
     "gate": {"x": 895, "w": 60}, "boss_at": [900, 262], "pit": [900, 250, 80, 50],
     "bosses": [
       {"id": "zb_egui", "n": ["餓鬼頭目", "餓鬼頭目"], "art": "egui", "stage": {"en": ["egui", "egui", "egui"], "boss": "egui", "p": 2}},
       {"id": "zb_eguiking", "n": ["餓鬼王", "餓鬼王"], "art": "eguiking", "main": True, "chapter": [0, 2]}],
     "decor": [["tree_bare", 740, 300, 70], ["tree_bare", 1060, 260, 70], ["tree_bare", 760, 160, 64]]},
    {"id": "market", "type": "market", "rect": [230, 440, 1110, 1080], "n": ["開放區　陰間大排檔", "開放區　陰間大排檔"], "col": "#a8602a"},
    {"id": "village", "type": "village", "rect": [230, 1160, 1110, 1984], "n": ["中央村", "中央村"], "col": "#a8602a"},
    {"id": "A", "type": "res", "rect": [0, 1160, 220, 1984], "n": ["資源區 A　後山竹林", "資源區 A　後山竹林"], "col": "#3a5a32",
     "door": {"rect": [215, 1545, 240, 1607], "in": [262, 1576], "out": [196, 1576]}, "power": 300, "loss": 0.3,
     "fields": {"b_bamboo": {"nodes": P((60, 1360), (150, 1350), (95, 1430), (175, 1440)), "sign": [110, 1500]}},
     "shops": {"b_strip": {"pos": [110, 1700], "need": {"b_bamboo": 3}}},
     "stage": {"en": ["youhun", "youhun", "youhun"], "boss": "youhun", "p": 1.5}},
    {"id": "B", "type": "res", "rect": [1120, 1160, 1340, 1984], "n": ["資源區 B　枯井巷", "資源區 B　枯井巷"], "col": "#2a4a5a",
     "door": {"rect": [1100, 1545, 1125, 1607], "in": [1078, 1576], "out": [1144, 1576]}, "power": 600, "loss": 0.3,
     "fields": {"b_well": {"nodes": P((1185, 1350), (1280, 1360), (1230, 1440)), "sign": [1230, 1500]}},
     "shops": {"b_paper": {"pos": [1230, 1700], "need": {"b_well": 3}}},
     "stage": {"en": ["egui", "youhun", "egui"], "boss": "egui", "p": 2.5}},
    {"id": "C", "type": "res", "rect": [450, 2004, 890, 2404], "n": ["資源區 C　荒田禾稈場", "資源區 C　荒田禾稈場"], "col": "#6a5a2a",
     "door": {"rect": [640, 1976, 700, 2004], "in": [670, 1962], "out": [670, 2026]}, "power": 1000, "loss": 0.3,
     "fields": {"b_straw": {"nodes": P((530, 2190), (610, 2180), (550, 2250)), "sign": [570, 2320]}},
     "shops": {"b_rope": {"pos": [790, 2240], "need": {"b_straw": 3}}},
     "stage": {"en": ["zhiren", "egui", "zhiren"], "boss": "egui", "p": 3.5}},
  ],
  # [zone v4] 區與區之間嘅地形阻隔（唔再係方框牆）：有碰撞（阿福只可以經門洞／小徑／橋，見 zone_walk.gd）
  "barriers": [
    {"k": "ridge", "rect": [652, 0, 688, 434]},                                    # 兩個野外區之間：亂石山脊
    {"k": "stakes", "y": 446, "x0": 230, "x1": 1110, "gaps": [[415, 475], [865, 925]]},   # 野外區 → 大排檔：削尖木樁防線＋兩道野外門
    {"k": "cliff", "rects": [[0, 0, 224, 1152], [1116, 0, 1340, 1152], [0, 2008, 448, 2410], [892, 2008, 1340, 2410]]},   # 四周虛空：山岩懸崖＋濃霧＋黑森林
    {"k": "forest", "x0": 204, "x1": 250, "y0": 1162, "y1": 1984, "gap": [1540, 1612]},   # 中央村｜A：樹林帶＋小徑
    {"k": "stonewall", "x0": 1100, "x1": 1130, "y0": 1162, "y1": 1984, "gap": [1545, 1607]},   # 中央村｜B：青苔舊石牆＋拱門
    {"k": "river", "y": 1996, "amp": 6, "w": 40, "x0": 0, "x1": 1340, "bridge": [644, 696]},   # 中央村｜C：暗色小河＋破木橋
  ],
  # [zone v5] 彎曲泥石路（唔再係兩條死直石板路）：main＝主路（中路由出村門落到橋、橫路連小徑同拱門），lane＝去各建築嘅小路分岔
  "paths": [
    {"k": "main", "w": 46, "pts": P((670, 1080), (670, 1162), (662, 1240), (678, 1330), (664, 1430), (674, 1520), (670, 1578), (662, 1660), (680, 1760), (666, 1860), (672, 1940), (670, 1994), (670, 2040))},
    {"k": "main", "w": 40, "pts": P((190, 1578), (300, 1584), (420, 1574), (560, 1582), (670, 1578), (780, 1572), (920, 1582), (1060, 1576), (1150, 1576))},
    {"k": "lane", "w": 22, "pts": P((662, 1300), (620, 1316), (575, 1322))},
    {"k": "lane", "w": 22, "pts": P((678, 1300), (730, 1330), (790, 1334))},
    {"k": "lane", "w": 20, "pts": P((812, 1334), (880, 1345), (935, 1338))},
    {"k": "lane", "w": 22, "pts": P((650, 1690), (560, 1720), (470, 1760), (420, 1806))},
    {"k": "lane", "w": 20, "pts": P((690, 1740), (780, 1770), (850, 1812))},
    {"k": "lane", "w": 20, "pts": P((672, 1890), (800, 1920), (940, 1962))},
    {"k": "lane", "w": 18, "pts": P((420, 1574), (400, 1470), (380, 1386))},
    {"k": "lane", "w": 20, "pts": P((190, 1578), (150, 1560), (110, 1520))},
    {"k": "lane", "w": 20, "pts": P((1150, 1576), (1190, 1560), (1230, 1520))},
    {"k": "lane", "w": 20, "pts": P((670, 2040), (630, 2120), (590, 2200))},
  ],
  "village": {
    "POS": {"gate": [670, 1152], "house": [392, 1790], "furnace": [516, 1772], "wood": [318, 1516], "rice": [800, 1520], "plank": [540, 1530],
            "bun": [1020, 1532], "store": [812, 1306], "home": [548, 1296], "camp": [990, 1946], "altar": [872, 1800]},
    "TREE_POS": P((290, 1290), (345, 1280), (400, 1295), (310, 1345), (365, 1350), (420, 1360)),
    "PADDY_POS": P((950, 1300), (1030, 1300), (950, 1360), (1030, 1360)),
    "DECOR": [["post", 628, 1230], ["post", 712, 1230], ["post", 628, 1650], ["post", 712, 1650], ["post", 628, 1900], ["post", 712, 1900],
              ["banana", 258, 1660], ["banana", 1086, 1640], ["scarecrow", 1086, 1360], ["grave", 1070, 1720], ["grave", 1092, 1745],
              ["willo", 470, 1420], ["willo", 760, 1440], ["willo", 960, 1700]],
    # 自然填充（zone_view 畫；唔擋路、唔撞建築）：[圖鍵或 proc:種類, x, y, 闊]
    "props": [
      ["zb_bush", 262, 1215, 70], ["zb_rock2", 470, 1220, 64], ["tree", 905, 1222, 58], ["zb_bush", 1080, 1240, 64], ["proc:grass", 600, 1230, 0],
      ["proc:barrel", 878, 1262, 0], ["store__crate", 896, 1300, 30], ["proc:grass", 720, 1410, 0], ["zb_rock2", 470, 1420, 54], ["proc:laundry", 600, 1430, 0],
      ["proc:grass", 870, 1440, 0], ["tree", 1080, 1460, 56], ["zb_bush", 262, 1460, 60], ["n30_taozhai__bucket", 760, 1470, 26],
      ["proc:grass", 260, 1640, 0], ["zb_rock2", 560, 1650, 50], ["proc:barrel", 760, 1660, 0], ["tree", 980, 1660, 58], ["proc:grass", 1060, 1700, 0],
      ["zb_bush", 270, 1730, 62], ["proc:laundry", 960, 1760, 0], ["proc:grass", 560, 1860, 0], ["zb_rock2", 760, 1880, 48], ["tree", 270, 1890, 54],
      ["proc:grass", 860, 1910, 0], ["zb_bush", 1080, 1880, 58], ["proc:grass", 520, 1960, 0], ["bun__basket", 1075, 1636, 26], ["pr_cart", 470, 1610, 56]],
    "EXTRA": [["vil_board", 330, 1948, 74], ["vil_rebirth", 445, 1952, 84]],
    "spots": {"wood": [[262, 1330, 1], [448, 1322, 0], [322, 1386, 1], [256, 1372, 0]],
              "rice": [[908, 1332, 0], [1072, 1332, 1], [990, 1392, 0], [912, 1392, 1]],
              "plank": [[488, 1548, 0], [592, 1550, 1], [504, 1556, 0], [578, 1558, 1]],
              "bun": [[968, 1550, 0], [1072, 1548, 1], [982, 1556, 0], [1058, 1556, 1]],
              "store": [[762, 1322, 0]], "boss": [[460, 1808, 1]],
              "camp": [[938, 1962, 0], [1042, 1962, 1], [958, 1968, 0], [1022, 1968, 1]]},
    "plaza": {"ZA": [600, 740, 1600, 1740], "ZB": [300, 1050, 1600, 1640], "eave": [362, 1553, 1469],
              "banana": [[1060, 1660, -1], [284, 1676, 1]], "bumps": [[640, 1660, -1], [700, 1660, 1], [600, 1700, -1], [740, 1700, 1]]},
    "hero": [670, 1640],
    "fence": {"y": 1146, "gate_x": 670, "gap": 24, "spans": [[230, 627], [713, 1110]]},
  },
  "market": {
    "w": 1340, "h": 1080, "fence_y": 430, "counter": [670, 1000], "serve": [670, 1042], "house": [670, 1000],
    "road": P((895, 436), (895, 540), (820, 760), (795, 960), (780, 1045), (670, 970)), "j": 5,
    "q2": P((670, 1042), (560, 1045), (545, 960), (520, 760), (445, 540), (445, 436)),
    "st": {"st_shoubao": [320, 690, 5], "st_zhishan": [560, 640, 5], "st_douhua": [780, 640, 5], "st_nuomici": [1020, 690, 5],
           "st_guancaichuang": [400, 900, 5], "st_denglong": [670, 860, 5], "st_tiaodan": [940, 900, 5]},
    "paths": {"st_shoubao": P((420, 780), (590, 780), (590, 960)), "st_zhishan": P((590, 740), (590, 960)),
              "st_douhua": P((750, 740), (750, 960)), "st_nuomici": P((920, 780), (750, 780), (750, 960)),
              "st_guancaichuang": P((480, 990), (600, 975)), "st_denglong": [], "st_tiaodan": P((860, 990), (740, 975))},
    "gates": P((445, 430), (895, 430)),
    "guard_slots": P((409, 466), (931, 466), (481, 466)),
    "vol_slots": P((385, 492), (505, 492), (835, 492), (955, 492), (415, 500), (475, 500), (865, 500), (925, 500)),
    "vol_mid": P((670, 740), (670, 500)),
    "porter": P((670, 1260), (670, 1160), (670, 1092), (790, 1062), (790, 985), (690, 970)),
    "decor": [], "spare": [], "fence_art": True, "unify": True, "zone": True,
  },
}

# ================= [zone v6] 中央村自然填充（老闆：每屏都要有內容，參考 Level1_Map_Art_v2 密度） =================
#   1) 院落：每間建築兩側貼住擺矮竹籬、晾衫竹、柴堆、水缸、雞籠（冇活物）、菜圃、石磨、木桶、木箱
#   2) 槐樹林外圍裝飾槐樹／灌木（唔可砍）；稻田外圍裝飾稻田＋田埂
#   3) 小路兩邊路燈、雜草、碎石
#   4) 填空：60×60 格掃描，周圍 70 內冇嘢就補雜草／碎石／灌木 → 冇大過約 120×120 嘅空地
#   全部避開：建築圖、可砍槐樹、可割稻田、主路／小路、公告板、打工鬼企位、門洞路點
import math, random
def _paths_samples(M, step=6.0):
    out = []
    for pa in M["paths"]:
        P = [tuple(map(float, q)) for q in pa["pts"]]; hw = pa["w"] / 2.0
        for i in range(len(P) - 1):
            p0 = P[max(0, i - 1)]; p1 = P[i]; p2 = P[i + 1]; p3 = P[min(len(P) - 1, i + 2)]
            n = max(1, int(math.dist(p1, p2) / step))
            for k in range(n):
                t = k / n; t2 = t * t; t3 = t2 * t
                q = [0.5 * ((2 * p1[j]) + (-p0[j] + p2[j]) * t + (2 * p0[j] - 5 * p1[j] + 4 * p2[j] - p3[j]) * t2 + (-p0[j] + 3 * p1[j] - 3 * p2[j] + p3[j]) * t3) for j in (0, 1)]
                out.append((q[0], q[1], hw, pa["k"]))
    return out
def _dress(M):
    rnd = random.Random(20261120)
    V = M["village"]; VR = (230 + 24, 1160 + 30, 1110 - 24, 1984 - 14)
    BW = {"house": 150, "gate": 150, "plank": 106, "bun": 106, "wood": 108, "rice": 108, "store": 112, "home": 104, "camp": 108, "altar": 104, "furnace": 62}
    blocks = []   # (x0,y0,x1,y1) 唔可以擺嘢
    for k, (x, y) in V["POS"].items():
        w = BW.get(k, 100); h = w * 0.93
        blocks.append((x - w / 2 + 4, y + 6 - h * 0.75, x + w / 2 - 4, y + 16))
    for (x, y) in V["TREE_POS"]: blocks.append((x - 28, y - 58, x + 28, y + 10))
    for (x, y) in V["PADDY_POS"]: blocks.append((x - 40, y - 34, x + 40, y + 8))
    for e in V["EXTRA"]: blocks.append((e[1] - e[3] / 2 - 6, e[2] - 70, e[1] + e[3] / 2 + 6, e[2] + 8))
    for d in V["DECOR"]: blocks.append((d[1] - 12, d[2] - 30, d[1] + 12, d[2] + 6))
    for sp in V["spots"].values():
        for q in sp: blocks.append((q[0] - 14, q[1] - 40, q[0] + 14, q[1] + 6))
    PS = _paths_samples(M)
    def free(x0, y0, x1, y1, pad=0.0, roads=True, lanes=True):
        if x0 < VR[0] or x1 > VR[2] or y0 < VR[1] or y1 > VR[3]: return False
        for b in blocks:
            if x0 < b[2] + pad and x1 > b[0] - pad and y0 < b[3] + pad and y1 > b[1] - pad: return False
        if roads:
            for (px, py, hw, k) in PS:
                if k != "main" and not lanes: continue
                m = hw + (8 if k == "main" else 5)
                if abs(px - (x0 + x1) / 2) < (x1 - x0) / 2 + m and abs(py - (y0 + y1) / 2) < (y1 - y0) / 2 + m * 0.7: return False
        return True
    props = []
    def put(k, x, y, w, foot=None, pad=2.0, roads=True, lanes=True):
        fw = foot or max(22.0, w * 0.7)
        r = (x - fw / 2, y - 16, x + fw / 2, y + 4)
        if not free(*r, pad=pad, roads=roads, lanes=lanes): return False
        props.append([k, round(x), round(y), round(w)]); blocks.append(r); return True
    # 1) 院落：每間建築旁邊 2–4 件院落擺設（zp_*，畫闊 55–85），矮竹籬圍出小院
    YARD = {"home": ["zp_laundry", "zp_jars", "zp_stove", "zp_fence"], "store": ["zp_sacks", "zp_cart", "zp_fence"],
            "wood": ["zp_woodpile", "zp_cart", "zp_fence"], "plank": ["zp_woodpile", "zp_sacks", "zp_fence"],
            "rice": ["zp_sacks", "zp_veg", "zp_fence"], "bun": ["zp_sacks", "zp_jars", "zp_stove"],
            "house": ["zp_bench", "zp_jars", "zp_fence", "zp_laundry"], "altar": ["zp_bench", "zp_deadtree"],
            "camp": ["zp_fence", "zp_sacks", "zp_bench"], "furnace": ["zp_jars"]}
    WID = {"zp_fence": 78, "zp_laundry": 74, "zp_woodpile": 70, "zp_jars": 60, "zp_veg": 76, "zp_mill": 62, "zp_cart": 72, "zp_coop": 64,
           "zp_sacks": 66, "zp_stove": 58, "zp_deadtree": 70, "zp_bench": 72}
    for k, (x, y) in V["POS"].items():
        if k not in YARD: continue
        w = BW.get(k, 100); placed = 0
        for kk in YARD[k]:
            ww = WID[kk] * rnd.uniform(0.92, 1.08)
            cand = []
            for sgn in (-1, 1):
                for dy in (-6, 18, 40, -34):
                    cand.append((x + sgn * (w / 2 + ww / 2 - 4), y + dy))
                    cand.append((x + sgn * (w / 2 + ww / 2 + 22), y + dy))
            cand += [(x - ww * 0.6, y + 44), (x + ww * 0.6, y + 44)]
            rnd.shuffle(cand)
            for (cx, cy) in cand:
                if put(kk, cx, cy, ww, foot=ww * 0.72, pad=0, lanes=False): placed += 1; break
    for (kk, cx, cy) in [("zp_veg", 880, 1230), ("zp_sacks", 1075, 1410), ("zp_mill", 470, 1440), ("zp_coop", 760, 1440), ("zp_mill", 760, 1660)]:
        put(kk, cx, cy, WID[kk], foot=WID[kk] * 0.8, pad=0)
    # 2) 槐樹林外圍：裝飾槐樹／灌木
    gx0, gy0, gx1, gy1 = 270, 1240, 440, 1365
    for i in range(16):
        a = i / 16 * math.tau; x = (gx0 + gx1) / 2 + math.cos(a) * 118; y = (gy0 + gy1) / 2 + 30 + math.sin(a) * 82
        put("deco:tree" if i % 3 else "zb_bush", x, y, 58 if i % 3 else 60, foot=30)
    # 稻田外圍：裝飾稻田（同一片田）＋田埂（地面畫）
    for (x, y) in [(870, 1300), (870, 1360), (1110 - 40, 1300 - 60), (950, 1240), (1030, 1240), (870, 1240)]:
        put("deco:paddy", x, y, 78, foot=70, pad=-6)
    put("deco:scarecrow", 1090, 1420, 40, foot=24)
    # 3) 小路兩邊：路燈、雜草、碎石
    for pa in M["paths"]:
        if pa["k"] != "lane": continue
        P = pa["pts"]
        for i in range(len(P) - 1):
            (x0, y0), (x1, y1) = P[i], P[i + 1]
            mx, my = (x0 + x1) / 2, (y0 + y1) / 2; L = math.dist(P[i], P[i + 1]) or 1
            nx, ny = -(y1 - y0) / L, (x1 - x0) / L
            side = 1 if i % 2 == 0 else -1
            off = pa["w"] / 2 + 16
            if not put("deco:post", mx + nx * off * side, my + ny * off * side, 30, foot=18):
                put("proc:grass", mx + nx * off * side, my + ny * off * side, 0, foot=20)
            if i % 2 == 0: put("zb_rock2", mx - nx * (off + 6) * side, my - ny * (off + 6) * side + 6, 34, foot=26)
    # 4) 填空：冇大過約 120×120 嘅空地
    fill = ["zp_deadtree", "zp_deadtree", "proc:grass", "zb_bush", "deco:tree", "proc:flowers", "proc:grass", "zb_rock2"]
    for gy in range(int(VR[1]) + 24, int(VR[3]), 46):
        for gx in range(int(VR[0]) + 24, int(VR[2]), 46):
            cx, cy = gx + rnd.uniform(-14, 14), gy + rnd.uniform(-14, 14)
            near = any(abs(cx - (b[0] + b[2]) / 2) < (b[2] - b[0]) / 2 + 22 and abs(cy - (b[1] + b[3]) / 2) < (b[3] - b[1]) / 2 + 22 for b in blocks)
            if near: continue
            k = fill[rnd.randrange(len(fill))]
            w = {"zb_rock2": rnd.uniform(40, 50), "zb_bush": rnd.uniform(56, 70), "deco:tree": rnd.uniform(54, 62), "zp_deadtree": rnd.uniform(58, 72)}.get(k, 0)
            put(k, cx, cy, w, foot=max(26, w * 0.55))
    V["props"] = props
_dress(M0)

D = {"v": 1, "maps": {"0": M0}}
json.dump(D, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("wrote", OUT)
