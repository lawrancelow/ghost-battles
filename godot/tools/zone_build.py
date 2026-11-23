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
     "decor": [["zp_deadtree", 320, 300, 70], ["zp_deadtree", 430, 200, 70], ["zp_deadtree", 560, 320, 70], ["zp_deadtree", 610, 180, 70],
               ["grave", 290, 380, 0], ["grave", 360, 150, 0], ["grave", 520, 390, 0], ["grave", 600, 260, 0]]},
    {"id": "w_pit", "type": "wild", "rect": [680, 0, 1110, 420], "n": ["野外區　餓鬼坑", "野外區　餓鬼坑"], "col": "#8a1c24",
     "gate": {"x": 895, "w": 60}, "boss_at": [900, 262], "pit": [900, 250, 80, 50],
     "bosses": [
       {"id": "zb_egui", "n": ["餓鬼頭目", "餓鬼頭目"], "art": "egui", "stage": {"en": ["egui", "egui", "egui"], "boss": "egui", "p": 2}},
       {"id": "zb_eguiking", "n": ["餓鬼王", "餓鬼王"], "art": "eguiking", "main": True, "chapter": [0, 2]}],
     "decor": [["zp_deadtree", 740, 300, 70], ["zp_deadtree", 1060, 260, 70], ["zp_deadtree", 760, 160, 64]]},
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
    # [fogfix] 老闆：中央村嘅槐樹／稻田全部都要砍得／割得 → 恢復 8 棵＋6 格（存檔 S.trees 8、S.paddy 6），唔再用同一張圖做裝飾
    #   槐樹兩行（行距 84：撳樹範圍 y−72..y+8 唔重疊；棵距 55 ≥ 撳樹闊 48）；稻田 3 行 × 2（行距 60、列距 80）
    "TREE_POS": P((285, 1278), (340, 1274), (395, 1280), (450, 1276), (300, 1362), (355, 1366), (410, 1360), (465, 1364)),
    "PADDY_POS": P((950, 1240), (1030, 1240), (950, 1300), (1030, 1300), (950, 1360), (1030, 1360)),
    "DECOR": [["post", 628, 1230], ["post", 712, 1230], ["post", 628, 1650], ["post", 712, 1650], ["post", 628, 1900], ["post", 712, 1900],
              ["banana", 258, 1660], ["banana", 1086, 1640], ["scarecrow", 1086, 1360], ["grave", 1070, 1720], ["grave", 1092, 1745],
              ["willo", 470, 1420], ["willo", 760, 1440], ["willo", 960, 1700]],
    # 自然填充（zone_view 畫；唔擋路、唔撞建築）：[圖鍵或 proc:種類, x, y, 闊]
    "props": [
      ["zb_bush", 262, 1215, 70], ["zb_rock2", 470, 1220, 64], ["zp_deadtree", 905, 1222, 58], ["zb_bush", 1080, 1240, 64], ["proc:grass", 600, 1230, 0],
      ["proc:barrel", 878, 1262, 0], ["store__crate", 896, 1300, 30], ["proc:grass", 720, 1410, 0], ["zb_rock2", 470, 1420, 54], ["proc:laundry", 600, 1430, 0],
      ["proc:grass", 870, 1440, 0], ["zp_deadtree", 1080, 1460, 56], ["zb_bush", 262, 1460, 60], ["n30_taozhai__bucket", 760, 1470, 26],
      ["proc:grass", 260, 1640, 0], ["zb_rock2", 560, 1650, 50], ["proc:barrel", 760, 1660, 0], ["zp_deadtree", 980, 1660, 58], ["proc:grass", 1060, 1700, 0],
      ["zb_bush", 270, 1730, 62], ["proc:laundry", 960, 1760, 0], ["proc:grass", 560, 1860, 0], ["zb_rock2", 760, 1880, 48], ["zp_deadtree", 270, 1890, 54],
      ["proc:grass", 860, 1910, 0], ["zb_bush", 1080, 1880, 58], ["proc:grass", 520, 1960, 0], ["bun__basket", 1075, 1636, 26], ["pr_cart", 470, 1610, 56]],
    "EXTRA": [["vil_board", 330, 1948, 74], ["vil_rebirth", 445, 1952, 84]],
    "spots": {"wood": [[262, 1322, 1], [490, 1322, 0], [330, 1404, 1], [262, 1404, 0]],
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
#   2) 槐樹林外圍：黑灌木＋暗枯樹（zb_bush／zp_deadtree，同可砍槐樹 tree 圖明顯唔同）；稻田外圍唔再擺裝飾稻田（[fogfix]）
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
def _dress(M, look="l1", off=(0, 0), extra_blocks=()):
    ox, oy = off
    rnd = random.Random(20261120)
    V = M["village"]; VR = (230 + 24 + ox, 1160 + 30 + oy, 1110 - 24 + ox, 1984 - 14 + oy)
    LK = YARD_LOOK[look]
    BW = {"house": 150, "gate": 150, "plank": 106, "bun": 106, "wood": 108, "rice": 108, "store": 112, "home": 104, "camp": 108, "altar": 104, "furnace": 62}
    blocks = []   # (x0,y0,x1,y1) 唔可以擺嘢
    for k, (x, y) in V["POS"].items():
        w = BW.get(k, 100); h = w * 0.93
        blocks.append((x - w / 2 + 4, y + 6 - h * 0.75, x + w / 2 - 4, y + 16))
    for (x, y) in V["TREE_POS"]: blocks.append((x - 28, y - 58, x + 28, y + 10))
    for (x, y) in V["PADDY_POS"]: blocks.append((x - 40, y - 34, x + 40, y + 8))
    for b in extra_blocks: blocks.append(tuple(b))
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
    YARD0 = {"home": ["zp_laundry", "zp_jars", "zp_stove", "zp_fence"], "store": ["zp_sacks", "zp_cart", "zp_fence"],
            "wood": ["zp_woodpile", "zp_cart", "zp_fence"], "plank": ["zp_woodpile", "zp_sacks", "zp_fence"],
            "rice": ["zp_sacks", "zp_veg", "zp_fence"], "bun": ["zp_sacks", "zp_jars", "zp_stove"],
            "house": ["zp_bench", "zp_jars", "zp_fence", "zp_laundry"], "altar": ["zp_bench", "zp_deadtree"],
            "camp": ["zp_fence", "zp_sacks", "zp_bench"], "furnace": ["zp_jars"]}
    YARD = LK.get("yard", YARD0)
    WID = {"zp_fence": 78, "zp_laundry": 74, "zp_woodpile": 70, "zp_jars": 60, "zp_veg": 76, "zp_mill": 62, "zp_cart": 72, "zp_coop": 64,
           "zp_sacks": 66, "zp_stove": 58, "zp_deadtree": 70, "zp_bench": 72}
    WID.update(ZQ_W)
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
    for (kk, cx, cy) in LK.get("misc", [("zp_veg", 880, 1230), ("zp_sacks", 1075, 1410), ("zp_mill", 470, 1440), ("zp_coop", 760, 1440), ("zp_mill", 760, 1660)]):
        put(kk, cx + ox, cy + oy, WID[kk], foot=WID[kk] * 0.8, pad=0)
    # 2) 槐樹林外圍：黑灌木／暗枯樹（[fogfix] 唔用 tree 圖：玩家會以為砍得）
    gx0, gy0, gx1, gy1 = 270 + ox, 1230 + oy, 480 + ox, 1380 + oy
    for i in range(16):
        a = i / 16 * math.tau; x = (gx0 + gx1) / 2 + math.cos(a) * 138; y = (gy0 + gy1) / 2 + 26 + math.sin(a) * 92
        put(LK.get("grove", "zp_deadtree") if i % 3 == 0 else "zb_bush", x, y, 62 if i % 3 == 0 else 60, foot=30)
    # 稻田外圍：[fogfix] 唔再擺裝飾稻田（同可割稻田同一張 paddy 圖，玩家分唔到）；空位交俾第 4 步填雜草／灌木
    put(LK.get("scare", "deco:scarecrow"), 1090 + ox, 1420 + oy, 40, foot=24)
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
    fill = LK.get("fill", ["zp_deadtree", "zp_deadtree", "proc:grass", "zb_bush", "zb_bush", "proc:flowers", "proc:grass", "zb_rock2"])
    for gy in range(int(VR[1]) + 24, int(VR[3]), 46):
        for gx in range(int(VR[0]) + 24, int(VR[2]), 46):
            cx, cy = gx + rnd.uniform(-14, 14), gy + rnd.uniform(-14, 14)
            near = any(abs(cx - (b[0] + b[2]) / 2) < (b[2] - b[0]) / 2 + 22 and abs(cy - (b[1] + b[3]) / 2) < (b[3] - b[1]) / 2 + 22 for b in blocks)
            if near: continue
            k = fill[rnd.randrange(len(fill))]
            w = {"zb_rock2": rnd.uniform(40, 50), "zb_bush": rnd.uniform(56, 70), "zp_deadtree": rnd.uniform(58, 72)}.get(k, 0)
            if k in FILL_W: w = rnd.uniform(*FILL_W[k])
            put(k, cx, cy, w, foot=max(26, w * 0.55))
    V["props"] = props
# ================= [zone2] 每關獨有 look（地面調色／筆觸、天氣粒子、光、霧、村子院落） =================
# look 鍵：l1 槐林荒村（枯黃饑荒）、l2 甘榜夜路（濕熱紅土、熱帶）、l3 南下古道（冷灰青石、山霧）、l4 河口蕉園（泥灘、紅月、雨）
ZQ_W = {"zq_cocohusk": 70, "zq_latexcups": 64, "zq_sarong": 72, "zq_stiltsteps": 66, "zq_trough": 72, "zq_stonetable": 72,
        "zq_sandals": 58, "zq_lanternpost": 52, "zq_nets": 74, "zq_baskets": 64, "zq_floats": 64, "zq_saltfish": 72}
FILL_W = {"zt_banana": (54, 66), "zt_reeds": (48, 60), "zt_cliffpine": (52, 62), "zq_sandals": (44, 50), "zq_cocohusk": (50, 58), "zq_floats": (48, 56)}
YARD_LOOK = {
  "l1": {},
  "l2": {"yard": {"home": ["zq_sarong", "zp_jars", "zq_stiltsteps", "zp_fence"], "store": ["zp_sacks", "zq_cocohusk", "zp_fence"],
                  "wood": ["zp_woodpile", "zq_cocohusk", "zp_fence"], "plank": ["zp_woodpile", "zp_sacks", "zp_fence"],
                  "rice": ["zp_sacks", "zp_veg", "zp_fence"], "bun": ["zq_cocohusk", "zp_jars", "zp_stove"],
                  "house": ["zp_bench", "zq_sarong", "zp_fence", "zq_latexcups"], "altar": ["zq_latexcups", "zp_bench"],
                  "camp": ["zp_fence", "zq_stiltsteps", "zp_bench"], "furnace": ["zp_jars"]},
         "misc": [("zp_veg", 880, 1230), ("zq_cocohusk", 1075, 1410), ("zq_latexcups", 470, 1440), ("zp_coop", 760, 1440), ("zq_sarong", 760, 1660)],
         "fill": ["zt_banana", "zt_banana", "proc:grass", "zb_bush", "proc:grass", "proc:flowers", "zq_cocohusk", "zb_rock2"], "scare": "deco:banana"},
  "l3": {"yard": {"home": ["zq_lanternpost", "zp_jars", "zq_sandals", "zp_fence"], "store": ["zp_sacks", "zq_trough", "zp_cart"],
                  "wood": ["zp_woodpile", "zp_cart", "zp_fence"], "plank": ["zp_woodpile", "zq_sandals", "zp_fence"],
                  "rice": ["zp_sacks", "zq_trough", "zp_fence"], "bun": ["zq_stonetable", "zp_stove", "zp_jars"],
                  "house": ["zq_stonetable", "zq_lanternpost", "zp_fence", "zq_sandals"], "altar": ["zq_lanternpost", "zp_bench"],
                  "camp": ["zq_trough", "zq_sandals", "zp_bench"], "furnace": ["zp_jars"]},
         "misc": [("zq_trough", 880, 1230), ("zq_sandals", 1075, 1410), ("zp_mill", 470, 1440), ("zq_stonetable", 760, 1440), ("zq_lanternpost", 760, 1660)],
         "fill": ["zb_rock2", "zb_rock2", "proc:grass", "zt_cliffpine", "zb_bush", "zq_sandals", "proc:pebbles", "zp_deadtree"], "grove": "zt_cliffpine"},
  "l4": {"yard": {"home": ["zq_nets", "zq_baskets", "zp_jars", "zp_fence"], "store": ["zq_baskets", "zq_floats", "zp_sacks"],
                  "wood": ["zp_woodpile", "zq_floats", "zp_fence"], "plank": ["zp_woodpile", "zq_nets", "zp_fence"],
                  "rice": ["zp_sacks", "zq_baskets", "zp_fence"], "bun": ["zq_saltfish", "zp_stove", "zq_baskets"],
                  "house": ["zq_saltfish", "zq_floats", "zp_fence", "zq_nets"], "altar": ["zq_floats", "zq_baskets"],
                  "camp": ["zq_nets", "zq_baskets", "zp_bench"], "furnace": ["zp_jars"]},
         "misc": [("zq_baskets", 880, 1230), ("zq_floats", 1075, 1410), ("zq_saltfish", 470, 1440), ("zq_nets", 760, 1440), ("zq_baskets", 760, 1660)],
         "fill": ["zt_reeds", "zt_reeds", "proc:grass", "zb_bush", "zq_floats", "proc:grass", "zt_banana", "zb_rock2"], "scare": "deco:banana"},
}
# 地面烘圖調色（zone_ground.gd 讀）＋即時氣氛（zone_view.gd 讀）
LOOKS = {
  "l1": {"name": "槐林荒村（枯黃饑荒）",
         "g": {"base": "#5a4428", "tile": [1.0, 0.9, 0.72], "blob": [["#8a6a3a", 0.16], ["#1e140c", 0.22]],
               "patch": [["#5e5030", 0.10], ["#6a5a34", 0.10], ["#4a3e24", 0.12]], "patch_n": 0.8, "puddle_n": 0.2, "puddle": "#1c1e1e",
               "tuft": ["#6a5a32", "#7a6a3a", "#5a4a2a", "#8a7a48"], "tuft_n": 0.9,
               "road": [["#2a1a0e", 0.035], ["#7a5c3a", 0.10], ["#9a7a50", 0.11], ["#a88a5a", 0.05]], "rut": "#3a2a1c",
               "crack_n": 2.6, "drycrack": 1.0, "void": "#1c1620",
               "stroke": [["#7a5a30", 0.20], ["#5a4024", 0.26], ["#2a1a14", 0.24], ["#8a7040", 0.12], ["#1e1222", 0.18], ["#a07a48", 0.10]],
               "tint": {"wild": [0.47, 0.04, 0.08, 0.30], "A": [0.14, 0.24, 0.06, 0.18], "B": [0.08, 0.16, 0.28, 0.20], "C": [0.36, 0.26, 0.04, 0.22]}},
         "atmo": {"grade": [1.0, 0.93, 0.82], "fog": [0.42, 0.36, 0.46], "lamp": [1.0, 0.68, 0.32], "fx": "leaves", "mist": [0.78, 0.72, 0.62, 0.06]}},
  "l2": {"name": "甘榜夜路（濕熱紅土、熱帶）",
         "g": {"base": "#4a2418", "tile": [0.92, 0.66, 0.58], "blob": [["#7a3a24", 0.18], ["#0c140c", 0.24]],
               "patch": [["#1e3a1e", 0.15], ["#244a26", 0.14], ["#183018", 0.16]], "patch_n": 1.7, "puddle_n": 2.6, "puddle": "#123028",
               "tuft": ["#2a4a26", "#36602e", "#1e3a1c", "#4a6a32"], "tuft_n": 1.6,
               "road": [["#1a0c08", 0.04], ["#7a3a24", 0.12], ["#9a4a2a", 0.13], ["#b0603a", 0.06]], "rut": "#3a1a10",
               "crack_n": 0.3, "drycrack": 0.0, "void": "#08120c",
               "stroke": [["#7a3a24", 0.20], ["#4a2418", 0.26], ["#1a0e0a", 0.24], ["#2a4a24", 0.16], ["#0e1a10", 0.20], ["#9a4a2a", 0.10]],
               "tint": {"wild": [0.40, 0.04, 0.08, 0.30], "A": [0.06, 0.30, 0.10, 0.22], "B": [0.22, 0.22, 0.06, 0.20], "C": [0.08, 0.30, 0.08, 0.22]}},
         "atmo": {"grade": [0.84, 0.98, 0.90], "fog": [0.22, 0.36, 0.30], "lamp": [0.55, 1.0, 0.78], "fx": "fireflies", "mist": [0.62, 0.86, 0.76, 0.09]}},
  "l3": {"name": "南下古道（冷灰青石、山霧）",
         "g": {"base": "#383b44", "tile": [0.60, 0.66, 0.78], "blob": [["#6a7080", 0.16], ["#0c0e14", 0.24]],
               "patch": [["#2c3a34", 0.11], ["#34423a", 0.10], ["#262e2c", 0.12]], "patch_n": 0.7, "puddle_n": 0.5, "puddle": "#1a2430",
               "tuft": ["#3a4a40", "#4a5a4c", "#2c3830", "#56645a"], "tuft_n": 0.6,
               "road": [["#0e1016", 0.04], ["#5a5e68", 0.12], ["#70747e", 0.13], ["#8a8e98", 0.06]], "rut": "#22242c",
               "crack_n": 1.0, "drycrack": 0.0, "slabs": 1.0, "void": "#0e1016",
               "stroke": [["#5a5e6a", 0.20], ["#3a3c44", 0.26], ["#14161c", 0.24], ["#4a5a54", 0.12], ["#1a1c26", 0.20], ["#7a808c", 0.10]],
               "tint": {"wild": [0.30, 0.06, 0.10, 0.28], "A": [0.10, 0.28, 0.16, 0.20], "B": [0.32, 0.26, 0.08, 0.18], "C": [0.08, 0.16, 0.30, 0.20]}},
         "atmo": {"grade": [0.78, 0.86, 1.0], "fog": [0.62, 0.68, 0.80], "lamp": [0.80, 0.90, 1.0], "fx": "fog", "mist": [0.80, 0.86, 0.96, 0.13]}},
  "l4": {"name": "河口蕉園（泥灘、紅月、雨）",
         "g": {"base": "#2a2c24", "tile": [0.64, 0.70, 0.62], "blob": [["#3a4a3a", 0.16], ["#060c0c", 0.24]],
               "patch": [["#1e3424", 0.15], ["#24402a", 0.14], ["#16261c", 0.16]], "patch_n": 1.3, "puddle_n": 4.0, "puddle": "#0e2024",
               "tuft": ["#4a5a34", "#5a6a3a", "#3a4a2a", "#6a7a44"], "tuft_n": 1.3,
               "road": [["#0a0c08", 0.04], ["#4a4434", 0.12], ["#5a5440", 0.13], ["#6a6448", 0.06]], "rut": "#1a1a12",
               "crack_n": 0.2, "drycrack": 0.0, "void": "#08141a",
               "stroke": [["#4a4a3a", 0.20], ["#2a2c24", 0.26], ["#0e1210", 0.24], ["#2a4a3a", 0.14], ["#0a1418", 0.20], ["#5a5a44", 0.10]],
               "tint": {"wild": [0.36, 0.04, 0.10, 0.30], "A": [0.12, 0.30, 0.06, 0.22], "B": [0.04, 0.20, 0.30, 0.28], "C": [0.30, 0.26, 0.10, 0.18]}},
         "atmo": {"grade": [1.0, 0.84, 0.86], "fog": [0.46, 0.30, 0.34], "lamp": [1.0, 0.62, 0.58], "fx": "rain", "mist": [0.76, 0.66, 0.70, 0.08]}},
}
M0["look"] = dict(LOOKS["l1"], key="l1"); M0["gate_side"] = "N"

# ---------------- 村子：同一條村（第 1 關布局）搬去另一張圖（dx, dy 平移），出村門喺 gate_side ----------------
def _sh(p, dx, dy): return [p[0] + dx, p[1] + dy]
V0 = M0["village"]
def village_at(dx, dy, gate_pos, decor_swap):
    V = {"POS": {k: _sh(v, dx, dy) for k, v in V0["POS"].items()}}
    V["POS"]["gate"] = list(gate_pos)
    V["TREE_POS"] = [_sh(p, dx, dy) for p in V0["TREE_POS"]]
    V["PADDY_POS"] = [_sh(p, dx, dy) for p in V0["PADDY_POS"]]
    V["DECOR"] = [[decor_swap.get(d[0], d[0]), d[1] + dx, d[2] + dy] for d in V0["DECOR"]]
    V["EXTRA"] = [[e[0], e[1] + dx, e[2] + dy, e[3]] for e in V0["EXTRA"]]
    V["spots"] = {k: [[q[0] + dx, q[1] + dy, q[2]] for q in v] for k, v in V0["spots"].items()}
    pz = V0["plaza"]
    V["plaza"] = {"ZA": [pz["ZA"][0] + dx, pz["ZA"][1] + dx, pz["ZA"][2] + dy, pz["ZA"][3] + dy],
                  "ZB": [pz["ZB"][0] + dx, pz["ZB"][1] + dx, pz["ZB"][2] + dy, pz["ZB"][3] + dy],
                  "eave": [pz["eave"][0] + dx, pz["eave"][1] + dy, pz["eave"][2] + dy],
                  "banana": [[b[0] + dx, b[1] + dy, b[2]] for b in pz["banana"]], "bumps": [[b[0] + dx, b[1] + dy, b[2]] for b in pz["bumps"]]}
    V["hero"] = _sh(V0["hero"], dx, dy)
    V["fence"] = {"off": True}   # 出村門唔喺北面：舊橫柵欄（village_fence.gd）唔用，改由 zones.json barriers 畫村邊籬笆
    return V
# 村內路：主路（十字）按四邊開唔開剪短／伸出去；村內小路照搬
def village_paths(dx, dy, ext):
    """ext：{"N": [[x,y],...] 或 None, ...}：開咗嘅邊由村邊伸去邊度（None＝閂，主路喺村內收尾）"""
    VX0, VY0, VX1, VY1 = 230 + dx, 1160 + dy, 1110 + dx, 1984 + dy
    ns = [_sh(p, dx, dy) for p in M0["paths"][0]["pts"]]; ew = [_sh(p, dx, dy) for p in M0["paths"][1]["pts"]]
    ns = [p for p in ns if VY0 + 40 <= p[1] <= VY1 - 30]; ew = [p for p in ew if VX0 + 40 <= p[0] <= VX1 - 40]
    cx = 670 + dx; cy = 1578 + dy
    if ext.get("N"): ns = [list(q) for q in reversed(ext["N"])] + [[cx, VY0]] + ns
    if ext.get("S"): ns = ns + [[cx, VY1]] + [list(q) for q in ext["S"]]
    if ext.get("W"): ew = [list(q) for q in reversed(ext["W"])] + [[VX0, cy]] + ew
    if ext.get("E"): ew = ew + [[VX1, cy]] + [list(q) for q in ext["E"]]
    o = [{"k": "main", "w": 46, "pts": ns}, {"k": "main", "w": 40, "pts": ew}]
    for pa in M0["paths"][2:]:
        if all(230 <= q[0] <= 1110 and 1160 <= q[1] <= 1984 for q in pa["pts"]):
            o.append({"k": pa["k"], "w": pa["w"], "pts": [_sh(q, dx, dy) for q in pa["pts"]]})
    return o
def _boss(bid, n, art, en, p, rename=True):
    return {"id": bid, "n": [n, n], "art": art, "rename": rename, "stage": {"en": en, "boss": art, "p": p}}
def _gate_blocks(gx, gy, w=150.0):
    h = w * 0.75
    return [(gx - w / 2 + 8, gy + 6 - h * 0.6, gx + w / 2 - 8, gy + 14)]

# ================= 第 2 關（ci 1）甘榜夜路：大排檔在村東，河在村北（Level2_Plan / m2.py） =================
# 建議戰力依據：陰兵上限 = 150 + 150×民宅 + 50×訓練班，戰力 = 陰兵 × (1 + 0.08×(民宅−1))。
#   民宅＝訓練班＝L 級時滿兵戰力 ≈ (150 + 200L) × (0.92 + 0.08L)：L≈6 → 1550、L≈8 → 2600、L≈9.5 → 3450（第 2 關 1500／2500／3500）；
#   L≈11 → 4000、L≈13.5 → 6100、L≈15.5 → 8000（第 3 關）；L≈18.5 → 9100、L≈21.5 → 12000、L≈24 → 15000（第 4 關）。戰力唔夠可以親自出征強攻。
D1X, D1Y = 230, -400
M1 = {
  "w": 1800, "h": 2240, "ground": "zone2_ground", "look": dict(LOOKS["l2"], key="l2"), "gate_side": "E",
  "cam": {"home": [900, 1150], "zoom": 1.0},
  "zones": [
    {"id": "w_kgrave", "type": "wild", "rect": [1380, 0, 1800, 520], "n": ["野外區　甘榜墳場", "野外區　甘榜墳場"], "col": "#8a1c24",
     "gate": {"x": 1600, "w": 60, "y": 534, "dir": 1}, "boss_at": [1590, 330],
     "bosses": [_boss("zb_jerangkung", "Hantu Jerangkung 頭目", "n30_jerangkung", ["youhun", "n30_jerangkung", "youhun"], 5.5),
                _boss("zb_pocong", "Pocong 頭目", "pocong", ["zhiren", "pocong", "zhiren"], 6.5)],
     "decor": [["grave", 1450, 180, 0], ["grave", 1720, 150, 0], ["grave", 1470, 450, 0], ["grave", 1740, 420, 0], ["grave", 1680, 250, 0],
               ["zp_deadtree", 1440, 300, 74], ["zp_deadtree", 1760, 320, 70], ["zt_stilt", 1500, 120, 96], ["zt_banana", 1760, 500, 70], ["zt_banana", 1420, 500, 66]]},
    {"id": "w_rubber", "type": "wild", "rect": [1380, 1764, 1800, 2240], "n": ["野外區　廢膠廠", "野外區　廢膠廠"], "col": "#8a1c24",
     "gate": {"x": 1600, "w": 60, "y": 1750, "dir": -1}, "boss_at": [1590, 2070],
     "bosses": [_boss("zb_raya", "Hantu Raya", "n30_hanturaya", ["youhun", "n30_hanturaya", "egui"], 6.5, False),
                {"id": "zb_toyol", "n": ["Toyol", "Toyol"], "art": "toyol", "main": True, "chapter": [1, 2]}],
     "decor": [["zt_stilt", 1460, 1900, 110], ["zq_latexcups", 1740, 2200, 70], ["zq_latexcups", 1720, 1880, 64], ["zb_rock2", 1440, 2140, 66],
               ["zp_deadtree", 1760, 2010, 70], ["zb_rock2", 1450, 2230, 70], ["zt_stilt", 1730, 2120, 0]]},
    {"id": "market", "type": "market", "rect": [1380, 548, 1800, 1736], "n": ["開放區　陰間大排檔", "開放區　陰間大排檔"], "col": "#a8602a"},
    {"id": "village", "type": "village", "rect": [460, 760, 1340, 1584], "n": ["中央村", "中央村"], "col": "#a8602a"},
    {"id": "A", "type": "res", "rect": [460, 228, 1340, 640], "n": ["資源區 A　椰林", "資源區 A　椰林"], "col": "#3a5a32",
     "door": {"rect": [868, 630, 932, 768], "in": [900, 794], "out": [900, 612], "vis": [866, 624, 934, 652]}, "power": 1500, "loss": 0.3,
     "fields": {"b_coco": {"nodes": [[600, 430], [720, 404], [840, 436], [680, 524]], "sign": [790, 600]}},
     "shops": {"b_cocomilk": {"pos": [1150, 560], "need": {"b_coco": 3}}},
     "stage": {"en": ["zhiren", "youhun", "zhiren"], "boss": "youhun", "p": 5}},
    {"id": "B", "type": "res", "rect": [0, 760, 420, 1584], "n": ["資源區 B　膠園", "資源區 B　膠園"], "col": "#5a5a2a",
     "door": {"rect": [396, 1144, 474, 1208], "in": [492, 1176], "out": [376, 1176], "vis": [392, 1144, 420, 1208]}, "power": 2500, "loss": 0.3,
     "fields": {"b_latex": {"nodes": [[90, 990], [210, 960], [320, 1000], [150, 1090]], "sign": [270, 1110]}},
     "shops": {"b_rubbersheet": {"pos": [200, 1420], "need": {"b_latex": 3}}},
     "stage": {"en": ["zhiren", "egui", "zhiren"], "boss": "egui", "p": 6}},
    {"id": "C", "type": "res", "rect": [460, 1700, 1340, 2172], "n": ["資源區 C　甘榜竹林", "資源區 C　甘榜竹林"], "col": "#3a5a32",
     "door": {"rect": [866, 1576, 934, 1712], "in": [900, 1558], "out": [900, 1732], "vis": [864, 1620, 936, 1668]}, "power": 3500, "loss": 0.3,
     "fields": {"b_bamboo": {"nodes": [[600, 1930], [700, 1905], [800, 1945], [660, 2020]], "sign": [770, 2080]}},
     "shops": {"b_strip": {"pos": [1150, 2010], "need": {"b_bamboo": 3}}},
     "stage": {"en": ["zhiren", "pocong", "zhiren"], "boss": "pocong", "p": 7}},
  ],
  "barriers": [
    {"k": "void", "style": "jungle", "rects": [[0, 0, 452, 668], [452, 0, 1380, 214], [1344, 214, 1380, 668], [0, 1606, 452, 2240], [452, 2184, 1380, 2240], [1344, 1600, 1380, 2240]]},
    {"k": "river", "y": 700, "amp": 6, "w": 56, "x0": 0, "x1": 1372, "bridges": [[872, 928, "zt_ditchbridge"]]},   # 中央村｜A：河＋木橋
    {"k": "fence", "y": 646, "x0": 462, "x1": 1338, "gap": [868, 932], "key": "zt_pagar", "seg": 92},   # A 椰林：甘榜木籬笆＋閘口
    {"k": "ditch", "x": 440, "w": 24, "y0": 728, "y1": 1604, "gap": [1150, 1202], "key": "zb_bridge", "fence": "zt_pagar", "fx": 404},   # 中央村｜B：排水溝＋木板橋（膠園邊甘榜籬笆）
    {"k": "belt", "y": 1652, "x0": 446, "x1": 1376, "gap": [864, 936], "key": "zt_banana", "step": 64},   # 中央村｜C：香蕉樹灌木帶＋小徑
    {"k": "vfence", "x": 1358, "y0": 752, "y1": 1592, "gap": [1146, 1206], "key": "zt_pagar"},   # 村東籬笆（出村門）
    {"k": "stakes", "y": 534, "x0": 1380, "x1": 1800, "gaps": [[1570, 1630]]},
    {"k": "stakes", "y": 1750, "x0": 1380, "x1": 1800, "gaps": [[1570, 1630]], "dir": -1},
  ],
  "scenery": [["zt_stilt", 120, 210, 120], ["zt_stilt", 300, 470, 104], ["zt_stilt", 90, 1880, 112], ["zt_stilt", 320, 2140, 100],
              ["zt_stilt", 1000, 2160, 108], ["zt_stilt", 600, 120, 96], ["zt_stilt", 1220, 150, 100]],
  "paths": village_paths(D1X, D1Y, {"N": [[900, 760], [900, 700], [900, 612]], "S": [[900, 1650], [900, 1732]],
                                    "W": [[460, 1176], [430, 1176], [376, 1176]], "E": [[1360, 1176], [1400, 1180]]}) + [
    {"k": "lane", "w": 22, "pts": [[900, 612], [860, 600], [800, 590]]},
    {"k": "lane", "w": 22, "pts": [[376, 1176], [330, 1150], [280, 1120]]},
    {"k": "lane", "w": 20, "pts": [[376, 1176], [300, 1260], [220, 1360], [200, 1400]]},
    {"k": "lane", "w": 22, "pts": [[900, 1732], [840, 1820], [790, 1900], [780, 2060]]},
    {"k": "lane", "w": 18, "pts": [[900, 1732], [1000, 1840], [1100, 1940], [1150, 2010]]},
    {"k": "lane", "w": 18, "pts": [[900, 612], [1000, 600], [1100, 580], [1150, 560]]},
  ],
  "village": village_at(D1X, D1Y, [1372, 1208], {"scarecrow": "banana", "grave": "banana"}),
  "market": {
    "w": 1800, "h": 1736, "wh": 2240, "fence_y": 534, "counter": [1508, 1290], "serve": [1508, 1332], "house": [1508, 1290],
    "road": [[1600, 540], [1612, 640], [1622, 900], [1622, 1150], [1626, 1300], [1568, 1336], [1508, 1260]], "j": 6,
    "q2": [[1508, 1332], [1560, 1350], [1622, 1370], [1622, 1600], [1608, 1700], [1600, 1748]],
    "st": {"st_yeketan": [1510, 800, 5], "st_tuoxie": [1710, 800, 5], "st_zhulong": [1510, 1010, 5], "st_liulian": [1710, 1010, 5],
           "st_yejiangfan": [1510, 1460, 5], "st_shoubao": [1710, 1460, 5], "st_zhishan": [1710, 1660, 5]},
    "paths": {"st_yeketan": [[1590, 846], [1600, 1190]], "st_tuoxie": [[1640, 846], [1604, 1190]], "st_zhulong": [[1590, 1056], [1600, 1190]],
              "st_liulian": [[1640, 1056], [1604, 1190]], "st_yejiangfan": [[1638, 1500], [1638, 1196], [1570, 1196]],
              "st_shoubao": [[1640, 1500], [1640, 1196], [1570, 1196]], "st_zhishan": [[1640, 1700], [1640, 1196], [1570, 1196]]},
    "gates": [[1600, 534], [1600, 1750]], "gdir": [1, -1],
    "guard_slots": [[1564, 566], [1636, 566], [1600, 1716]],
    "vol_slots": [[1540, 590], [1660, 590], [1540, 1694], [1660, 1694], [1570, 600], [1630, 600], [1570, 1684], [1630, 1684]],
    "vol_mid": [[1622, 1150]],
    "porter": [[1180, 1180], [1300, 1180], [1394, 1184], [1440, 1218], [1490, 1254]],
    "decor": [], "spare": [], "fence_art": True, "unify": True, "zone": True,
  },
}
_dress(M1, "l2", (D1X, D1Y), _gate_blocks(1372, 1208))

# ================= 第 3 關（ci 2）南下古道：大排檔在村南（山下），資源區在山上（Level3_Plan / m3.py） =================
D2X, D2Y = 70, -260
M2 = {
  "w": 1480, "h": 2920, "ground": "zone3_ground", "look": dict(LOOKS["l3"], key="l3"), "gate_side": "S",
  "cam": {"home": [740, 1300], "zoom": 1.0},
  "zones": [
    {"id": "w_yizhuang", "type": "wild", "rect": [0, 2440, 718, 2920], "n": ["野外區　義莊外林", "野外區　義莊外林"], "col": "#8a1c24",
     "gate": {"x": 515, "w": 60, "y": 2416, "dir": -1}, "boss_at": [360, 2720],
     "bosses": [_boss("zb_changgui", "倀鬼頭目", "n30_changgui", ["zombie", "n30_changgui", "zombie"], 9.5),
                {"id": "zb_laojiang", "n": ["老殭", "老殭"], "art": "laojiang", "main": True, "chapter": [2, 2]}],
     "decor": [["zp_deadtree", 120, 2600, 74], ["zp_deadtree", 620, 2620, 70], ["zt_cliffpine", 90, 2860, 110], ["zt_pavilion", 560, 2880, 120],
               ["grave", 220, 2820, 0], ["grave", 480, 2560, 0], ["zp_deadtree", 300, 2900, 70]]},
    {"id": "w_gorge", "type": "wild", "rect": [762, 2440, 1480, 2920], "n": ["野外區　亂石峽", "野外區　亂石峽"], "col": "#8a1c24",
     "gate": {"x": 965, "w": 60, "y": 2416, "dir": -1}, "boss_at": [1120, 2720],
     "bosses": [_boss("zb_egui3", "餓鬼頭目", "egui", ["egui", "egui", "egui"], 10.0),
                _boss("zb_shanxiao", "山魈", "n30_shanxiao", ["egui", "n30_shanxiao", "zombie"], 11.0, False)],
     "decor": [["zb_rock1", 820, 2600, 120], ["zb_rock1", 1400, 2620, 130], ["zt_cliffpine", 1320, 2880, 120], ["zb_rock2", 900, 2880, 100],
               ["zb_rock2", 1220, 2560, 90], ["zt_cliffpine", 860, 2780, 100]]},
    {"id": "market", "type": "market", "rect": [300, 1760, 1180, 2400], "n": ["開放區　陰間大排檔（古道驛站市集）", "開放區　陰間大排檔（古道驛站市集）"], "col": "#a8602a"},
    {"id": "village", "type": "village", "rect": [300, 900, 1180, 1724], "n": ["中央村", "中央村"], "col": "#a8602a"},
    {"id": "A", "type": "res", "rect": [0, 220, 620, 860], "n": ["資源區 A　霧谷茶田", "資源區 A　霧谷茶田"], "col": "#3a5a32",
     "door": {"rect": [470, 836, 780, 906], "in": [740, 928], "out": [556, 830], "vis": [508, 846, 600, 878]}, "power": 4000, "loss": 0.3,
     "fields": {"b_tea": {"nodes": [[110, 470], [250, 460], [390, 476], [180, 600], [330, 610]], "sign": [260, 720]}},
     "shops": {}, "nofac": True,
     "stage": {"en": ["zombie", "youhun", "zombie"], "boss": "zombie", "p": 9}},
    {"id": "B", "type": "res", "rect": [860, 220, 1480, 860], "n": ["資源區 B　古道禾稈坡", "資源區 B　古道禾稈坡"], "col": "#6a5a2a",
     "door": {"rect": [700, 836, 1010, 906], "in": [740, 928], "out": [924, 830], "vis": [880, 846, 972, 878]}, "power": 6000, "loss": 0.3,
     "fields": {"b_straw": {"nodes": [[960, 470], [1070, 450], [1010, 560], [1130, 540]], "sign": [1060, 650]}},
     "shops": {"b_rope": {"pos": [1330, 580], "need": {"b_straw": 3}}},
     "stage": {"en": ["zombie", "zhiren", "zombie"], "boss": "zombie", "p": 10}},
    {"id": "C", "type": "res", "rect": [0, 900, 280, 1724], "n": ["資源區 C　驛站古井", "資源區 C　驛站古井"], "col": "#2a4a5a",
     "door": {"rect": [262, 1284, 320, 1348], "in": [334, 1316], "out": [236, 1316], "vis": [272, 1284, 304, 1348]}, "power": 8000, "loss": 0.3,
     "fields": {"b_well": {"nodes": [[70, 1130], [190, 1150], [120, 1240]], "sign": [150, 1400]}},
     "shops": {"b_paper": {"pos": [140, 1580], "need": {"b_well": 3}}},
     "note": ["紙寮要竹：竹由庫存供應（呢度冇竹林）", "紙寮要竹：竹由庫存供應（這裡沒有竹林）"],
     "stage": {"en": ["zombie", "laojiang", "zombie"], "boss": "zombie", "p": 11}},
  ],
  "barriers": [
    {"k": "void", "style": "cliff", "rects": [[0, 0, 1480, 214], [636, 214, 844, 836], [1184, 864, 1480, 1740], [0, 1730, 300, 2440], [1180, 1740, 1480, 2440]]},
    {"k": "ridge", "rect": [718, 2430, 762, 2920]},
    {"k": "rail", "x": 292, "y0": 900, "y1": 1728, "gap": [1284, 1348], "key": "zt_rail"},   # 中央村｜C：殘破青石護欄＋缺口
    {"k": "fence", "y": 1748, "x0": 300, "x1": 1180, "gap": [710, 770], "key": "zt_rail", "seg": 92},   # 村南護欄（出村門）
    {"k": "steps", "pts": [[556, 900, 90, False], [924, 900, 90, True]]},   # 上山石階（純畫，行路靠門洞）
    {"k": "stakes", "y": 2416, "x0": 300, "x1": 1180, "gaps": [[485, 545], [935, 995]], "dir": -1},
  ],
  "scenery": [["zt_cliffpine", 600, 260, 120], ["zt_cliffpine", 880, 250, 110], ["zt_cliffpine", 40, 250, 110], ["zt_cliffpine", 1430, 260, 110],
              ["zt_pavilion", 140, 1712, 110], ["zt_cliffpine", 1240, 1000, 110], ["zt_cliffpine", 1400, 1400, 120], ["zt_cliffpine", 60, 1900, 110],
              ["zt_cliffpine", 1420, 2000, 110], ["zt_pavilion", 1320, 1720, 120], ["zt_rail", 560, 846, 80], ["zt_rail", 920, 846, 80]],
  "gfx": [{"k": "terrace", "x0": 24, "x1": 600, "ys": [500, 630, 760]}],
  "paths": village_paths(D2X, D2Y, {"N": [[740, 880], [740, 862]], "S": [[740, 1748], [740, 1800]], "W": [[300, 1316], [236, 1316]]}) + [
    {"k": "main", "w": 32, "pts": [[740, 862], [660, 852], [556, 830]]},
    {"k": "main", "w": 32, "pts": [[740, 862], [820, 852], [924, 830]]},
    {"k": "lane", "w": 22, "pts": [[556, 830], [420, 780], [260, 720]]},
    {"k": "lane", "w": 22, "pts": [[924, 830], [1000, 740], [1060, 650]]},
    {"k": "lane", "w": 18, "pts": [[924, 830], [1150, 700], [1330, 580]]},
    {"k": "lane", "w": 22, "pts": [[236, 1316], [180, 1360], [150, 1400]]},
    {"k": "lane", "w": 18, "pts": [[236, 1316], [150, 1450], [140, 1580]]},
  ],
  "village": village_at(D2X, D2Y, [740, 1770], {"banana": "willo"}),
  "market": {
    "w": 1480, "h": 2400, "wh": 2920, "fence_y": 2416, "counter": [740, 1900], "serve": [740, 1942], "house": [740, 1900],
    "road": [[965, 2420], [990, 2380], [990, 2180], [990, 1990], [840, 1952], [780, 1944], [740, 1870]], "j": 6,
    "q2": [[740, 1942], [700, 1944], [640, 1952], [490, 1990], [490, 2180], [490, 2380], [515, 2420]],
    "st": {"st_caoxie": [400, 2060, 5], "st_wucha": [580, 2060, 5], "st_jiuban": [900, 2060, 5], "st_huajiao": [1080, 2060, 5],
           "st_xunren": [400, 2300, 5], "st_ganlu": [580, 2300, 5], "st_shoubao": [900, 2300, 5], "st_zhishan": [1080, 2300, 5]},
    "paths": {"st_caoxie": [[400, 2160], [740, 2160], [740, 1990], [866, 1960], [866, 1850], [770, 1850]],
              "st_wucha": [[580, 2160], [740, 2160], [740, 1990], [866, 1960], [866, 1850], [770, 1850]],
              "st_jiuban": [[900, 2160], [740, 2160], [740, 1990], [866, 1960], [866, 1850], [770, 1850]],
              "st_huajiao": [[1080, 2160], [740, 2160], [740, 1990], [866, 1960], [866, 1850], [770, 1850]],
              "st_xunren": [[490, 2340], [490, 2160], [740, 2160], [740, 1990], [866, 1960], [866, 1850], [770, 1850]],
              "st_ganlu": [[740, 2340], [740, 1990], [866, 1960], [866, 1850], [770, 1850]],
              "st_shoubao": [[740, 2340], [740, 1990], [866, 1960], [866, 1850], [770, 1850]],
              "st_zhishan": [[990, 2340], [990, 2160], [740, 2160], [740, 1990], [866, 1960], [866, 1850], [770, 1850]]},
    "gates": [[515, 2416], [965, 2416]], "gdir": [-1, -1],
    "guard_slots": [[478, 2386], [552, 2386], [965, 2386]],
    "vol_slots": [[470, 2370], [560, 2370], [920, 2370], [1010, 2370], [500, 2360], [530, 2360], [950, 2360], [980, 2360]],
    "vol_mid": [[740, 2160]],
    "porter": [[740, 1640], [740, 1724], [740, 1790], [724, 1862]],
    "decor": [], "spare": [], "fence_art": True, "unify": True, "zone": True,
  },
}
_dress(M2, "l3", (D2X, D2Y), _gate_blocks(740, 1770))

# ================= 第 4 關（ci 3）河口蕉園：村在河中小島，大排檔在西邊碼頭（Level4_Plan / m4.py） =================
D3X, D3Y = 330, -460
M3 = {
  "w": 1980, "h": 2240, "ground": "zone4_ground", "look": dict(LOOKS["l4"], key="l4"), "gate_side": "W",
  "cam": {"home": [1000, 1110], "zoom": 1.0},
  "zones": [
    {"id": "w_mangrove", "type": "wild", "rect": [0, 0, 480, 600], "n": ["野外區　紅樹林深處", "野外區　紅樹林深處"], "col": "#8a1c24",
     "gate": {"x": 240, "w": 56, "y": 664, "dir": 1}, "boss_at": [240, 360],
     "bosses": [_boss("zb_shuigui", "水鬼頭目", "shuigui", ["shuigui", "shuigui", "shuigui"], 13.5),
                {"id": "zb_pontianak", "n": ["Pontianak", "Pontianak"], "art": "pontianak", "main": True, "chapter": [3, 2]}],
     "decor": [["zt_mangrove", 70, 160, 120], ["zt_mangrove", 410, 140, 130], ["zt_mangrove", 90, 520, 120], ["zt_mangrove", 420, 540, 110],
               ["zt_reeds", 200, 580, 90], ["zt_reeds", 330, 260, 80], ["zp_deadtree", 140, 330, 70]]},
    {"id": "w_wreck", "type": "wild", "rect": [0, 1680, 480, 2240], "n": ["野外區　沉船灘", "野外區　沉船灘"], "col": "#8a1c24",
     "gate": {"x": 240, "w": 56, "y": 1596, "dir": -1}, "boss_at": [240, 1990],
     "bosses": [_boss("zb_aswang", "Aswang", "n30_aswang", ["shuigui", "n30_aswang", "zombie"], 14.0, False),
                _boss("zb_shuiguiking", "沉船灘水鬼王", "shuigui", ["shuigui", "shuigui", "youhun"], 14.8)],
     "decor": [["zt_boat", 90, 1820, 130], ["zt_boat", 400, 2180, 140], ["zt_reeds", 60, 2120, 100], ["zt_reeds", 420, 1800, 96],
               ["zb_rock2", 300, 2230, 90], ["zt_boat", 120, 2230, 110], ["zt_mangrove", 430, 1990, 110]]},
    {"id": "market", "type": "market", "rect": [0, 700, 480, 1590], "n": ["開放區　碼頭大排檔", "開放區　碼頭大排檔"], "col": "#a8602a"},
    {"id": "village", "type": "village", "rect": [560, 700, 1440, 1524], "n": ["中央村", "中央村"], "col": "#a8602a"},
    {"id": "A", "type": "res", "rect": [560, 160, 1440, 612], "n": ["資源區 A　蕉園", "資源區 A　蕉園"], "col": "#3a5a32",
     "door": {"rect": [968, 600, 1032, 708], "in": [1000, 732], "out": [1000, 590], "vis": [966, 596, 1034, 624]}, "power": 9000, "loss": 0.3,
     "fields": {"b_banana": {"nodes": [[660, 420], [790, 396], [920, 430], [740, 520]], "sign": [860, 580]}},
     "shops": {}, "nofac": True,
     "stage": {"en": ["shuigui", "youhun", "shuigui"], "boss": "shuigui", "p": 13}},
    {"id": "B", "type": "res", "rect": [560, 1630, 1440, 2116], "n": ["資源區 B　河口罾棚", "資源區 B　河口罾棚"], "col": "#2a4a5a",
     "door": {"rect": [968, 1512, 1032, 1646], "in": [1000, 1500], "out": [1000, 1666], "vis": [966, 1622, 1034, 1650]}, "power": 12000, "loss": 0.3,
     "fields": {"b_fish": {"nodes": [[720, 1990], [880, 2004], [1040, 1986]], "sign": [880, 2080]}},
     "shops": {}, "nofac": True, "water": True,
     "stage": {"en": ["shuigui", "zombie", "shuigui"], "boss": "shuigui", "p": 14}},
    {"id": "C", "type": "res", "rect": [1532, 700, 1980, 1524], "n": ["資源區 C　河灘椰林", "資源區 C　河灘椰林"], "col": "#5a5a2a",
     "door": {"rect": [1430, 1084, 1546, 1148], "in": [1414, 1116], "out": [1560, 1116], "vis": [1520, 1084, 1546, 1148]}, "power": 15000, "loss": 0.3,
     "fields": {"b_coco": {"nodes": [[1630, 930], [1760, 905], [1880, 940], [1700, 1030]], "sign": [1800, 1200]}},
     "shops": {"b_cocomilk": {"pos": [1755, 1420], "need": {"b_coco": 3}}},
     "stage": {"en": ["shuigui", "pontianak", "shuigui"], "boss": "shuigui", "p": 15}},
  ],
  "barriers": [
    {"k": "void", "style": "marsh", "rects": [[1500, 0, 1980, 640], [1500, 1600, 1980, 2240], [480, 0, 560, 640], [480, 1610, 560, 2240], [560, 0, 1440, 156], [560, 2122, 1440, 2240], [1440, 0, 1500, 640], [1440, 1600, 1500, 2240]]},
    {"k": "river", "y": 656, "amp": 6, "w": 64, "x0": 0, "x1": 1980, "bridges": [[212, 268, "zt_jetty"], [972, 1028, "zb_bridge_v"]]},
    {"k": "river", "y": 1590, "amp": 6, "w": 64, "x0": 0, "x1": 1980, "bridges": [[212, 268, "zt_jetty"], [972, 1028, "zb_bridge_v"]]},
    {"k": "vriver", "x": 520, "amp": 5, "w": 56, "y0": 656, "y1": 1590, "bridges": [[1088, 1144, "zb_bridge"]]},
    {"k": "vriver", "x": 1486, "amp": 5, "w": 56, "y0": 656, "y1": 1590, "bridges": [[1088, 1144, "zb_bridge"]]},
    {"k": "jetties", "pts": [[700, 1900, 120], [860, 1910, 124], [1020, 1896, 120], [1180, 1906, 116], [1320, 1900, 110]]},   # 罾棚棧橋（純畫）
  ],
  "scenery": [["zt_mangrove", 1560, 120, 130], ["zt_mangrove", 1880, 260, 140], ["zt_reeds", 1700, 520, 110], ["zt_mangrove", 1620, 1760, 130],
              ["zt_boat", 1840, 1900, 140], ["zt_reeds", 1580, 2140, 110], ["zt_mangrove", 1900, 2120, 130], ["zt_reeds", 700, 120, 100],
              ["zt_reeds", 1300, 110, 100], ["zt_reeds", 760, 2220, 100], ["zt_boat", 1220, 2220, 120], ["zt_jetty", 60, 1180, 100],
              ["zt_reeds", 1900, 1180, 90], ["zt_reeds", 1580, 1480, 80]],
  "paths": village_paths(D3X, D3Y, {"N": [[1000, 700], [1000, 590]], "S": [[1000, 1560], [1000, 1666]], "W": [[540, 1116], [470, 1116]],
                                    "E": [[1486, 1116], [1560, 1116]]}) + [
    {"k": "lane", "w": 22, "pts": [[1000, 590], [920, 570], [860, 580]]},
    {"k": "lane", "w": 22, "pts": [[1000, 1666], [920, 1760], [880, 1880]]},
    {"k": "lane", "w": 22, "pts": [[1560, 1116], [1700, 1150], [1800, 1200]]},
    {"k": "lane", "w": 18, "pts": [[1560, 1116], [1700, 1300], [1755, 1420]]},
    {"k": "lane", "w": 22, "pts": [[470, 1116], [400, 1100], [300, 1084]]},
  ],
  "village": village_at(D3X, D3Y, [520, 1146], {"scarecrow": "banana"}),
  "market": {
    "w": 1980, "h": 1590, "wh": 2240, "fence_y": 664, "counter": [240, 1110], "serve": [240, 1152], "house": [240, 1110],
    "road": [[240, 660], [240, 720], [240, 900], [250, 1010], [356, 1040], [356, 1140], [300, 1156], [240, 1080]], "j": 7,
    "q2": [[240, 1152], [240, 1250], [244, 1400], [244, 1560], [240, 1600]],
    "st": {"st_jiaoye": [110, 800, 5], "st_xianyu": [370, 800, 5], "st_ningmeng": [110, 970, 5], "st_duihuan": [370, 970, 5],
           "st_jiushengquan": [110, 1270, 5], "st_chuanpiao": [370, 1270, 5], "st_shoubao": [110, 1500, 5], "st_zhishan": [370, 1500, 5]},
    "paths": {"st_jiaoye": [[200, 846], [226, 1040]], "st_xianyu": [[280, 846], [254, 1040]], "st_ningmeng": [[200, 1016], [226, 1050]],
              "st_duihuan": [[280, 1016], [254, 1050]],
              "st_jiushengquan": [[36, 1310], [36, 1080], [200, 1076]], "st_chuanpiao": [[300, 1316], [300, 1340], [36, 1340], [36, 1080], [200, 1076]],
              "st_shoubao": [[36, 1540], [36, 1080], [200, 1076]], "st_zhishan": [[300, 1546], [36, 1546], [36, 1080], [200, 1076]]},
    "gates": [[240, 664], [240, 1596]], "gdir": [1, -1],
    "guard_slots": [[204, 706], [276, 706], [240, 1556]],
    "vol_slots": [[180, 730], [300, 730], [180, 1540], [300, 1540], [210, 740], [270, 740], [210, 1530], [270, 1530]],
    "vol_mid": [[240, 1200]],
    "porter": [[650, 1120], [570, 1118], [520, 1118], [470, 1116], [400, 1090], [262, 1078]],
    "decor": [], "spare": [], "fence_art": True, "unify": True, "zone": True,
  },
}
_dress(M3, "l4", (D3X, D3Y), _gate_blocks(520, 1146))

# ================= [zone56] 第 5、6 關 =================
import copy
ZQ_W.update({"zq_bins": 60, "zq_newsstack": 58, "zq_cones": 74, "zq_scooter": 72, "zq_planter": 70, "zq_dryrack": 74, "zq_busstop": 70, "zq_traffic": 40,
             "zq_filecab": 50, "zq_chair": 54, "zq_tonerbox": 72, "zq_cooler": 44, "zq_punch": 56, "zq_deadplant": 56, "zq_cartons": 74, "zq_firehose": 64})
FILL_W.update({"zq_bins": (52, 60), "zq_cones": (60, 70), "zq_planter": (58, 66), "zq_newsstack": (48, 56),
               "zq_cartons": (60, 70), "zq_deadplant": (48, 56), "zq_filecab": (44, 50), "zq_chair": (46, 52)})
YARD_LOOK["l5"] = {"yard": {"home": ["zq_dryrack", "zq_bins", "zq_planter", "zp_fence"], "store": ["zq_newsstack", "zp_sacks", "zq_cones"],
                  "wood": ["zp_woodpile", "zq_cones", "zp_fence"], "plank": ["zp_woodpile", "zq_newsstack", "zp_fence"],
                  "rice": ["zp_sacks", "zq_planter", "zp_fence"], "bun": ["zq_scooter", "zp_jars", "zp_stove"],
                  "house": ["zq_busstop", "zq_planter", "zp_fence", "zq_dryrack"], "altar": ["zq_planter", "zp_bench"],
                  "camp": ["zq_cones", "zq_bins", "zp_bench"], "furnace": ["zp_jars"]},
         "misc": [("zq_planter", 880, 1230), ("zq_bins", 1075, 1410), ("zq_newsstack", 470, 1440), ("zq_cones", 760, 1440), ("zq_dryrack", 760, 1660)],
         "fill": ["zb_rock2", "proc:grass", "zq_bins", "zq_cones", "proc:pebbles", "zq_planter", "proc:grass", "zq_newsstack"], "grove": "zb_bush"}
YARD_LOOK["l6"] = {"yard": {"home": ["zq_cooler", "zq_chair", "zq_deadplant", "zp_fence"], "store": ["zq_cartons", "zq_tonerbox", "zq_filecab"],
                  "wood": ["zp_woodpile", "zq_cartons", "zp_fence"], "plank": ["zp_woodpile", "zq_filecab", "zp_fence"],
                  "rice": ["zp_sacks", "zq_deadplant", "zp_fence"], "bun": ["zq_cooler", "zp_jars", "zp_stove"],
                  "house": ["zq_punch", "zq_chair", "zp_fence", "zq_firehose"], "altar": ["zq_deadplant", "zp_bench"],
                  "camp": ["zq_firehose", "zq_cartons", "zp_bench"], "furnace": ["zp_jars"]},
         "misc": [("zq_deadplant", 880, 1230), ("zq_cartons", 1075, 1410), ("zq_filecab", 470, 1440), ("zq_chair", 760, 1440), ("zq_cooler", 760, 1660)],
         "fill": ["zq_cartons", "proc:pebbles", "zq_deadplant", "zb_rock2", "zq_chair", "proc:pebbles", "zq_filecab", "proc:grass"], "grove": "zb_bush"}
LOOKS["l5"] = {"name": "橫死路口（組屋區、鈉燈、舊報紙）",
         "g": {"base": "#3a3632", "tile": [0.74, 0.70, 0.66], "blob": [["#5a524a", 0.16], ["#0e0c0c", 0.24]],
               "patch": [["#2e3428", 0.10], ["#3a3a30", 0.10], ["#28282a", 0.14]], "patch_n": 0.7, "puddle_n": 1.6, "puddle": "#16181c",
               "tuft": ["#4a4a34", "#5a5a3a", "#3a3a2a", "#6a6440"], "tuft_n": 0.6,
               "road": [["#0c0c0e", 0.04], ["#3a3a3e", 0.12], ["#4a4a50", 0.13], ["#5a5a60", 0.06]], "rut": "#1a1a1e",
               "crack_n": 2.0, "drycrack": 0.0, "slabs": 0.6, "void": "#0e0e12",
               "stroke": [["#5a5450", 0.20], ["#3a3634", 0.26], ["#141214", 0.24], ["#4a4a3a", 0.12], ["#1a1820", 0.20], ["#6a645a", 0.10]],
               "tint": {"wild": [0.40, 0.06, 0.06, 0.30], "A": [0.30, 0.24, 0.10, 0.18], "B": [0.20, 0.20, 0.22, 0.18], "C": [0.08, 0.18, 0.26, 0.20]}},
         "atmo": {"grade": [1.0, 0.90, 0.78], "fog": [0.42, 0.36, 0.30], "lamp": [1.0, 0.62, 0.28], "fx": "paper", "mist": [0.86, 0.74, 0.56, 0.07]}}
LOOKS["l6"] = {"name": "地府集團（總部大廈、光管、碳粉）",
         "g": {"base": "#2c302e", "tile": [0.62, 0.70, 0.66], "blob": [["#4a5450", 0.16], ["#080c0c", 0.26]],
               "patch": [["#243028", 0.10], ["#2c3830", 0.10], ["#1e2422", 0.14]], "patch_n": 0.5, "puddle_n": 0.8, "puddle": "#101818",
               "tuft": ["#3a4a3a", "#4a5a44", "#2c3a30", "#566050"], "tuft_n": 0.4,
               "road": [["#0a0c0c", 0.04], ["#3c4242", 0.12], ["#4c5252", 0.13], ["#5c6262", 0.06]], "rut": "#161a1a",
               "crack_n": 1.2, "drycrack": 0.0, "slabs": 1.0, "void": "#080c0e",
               "stroke": [["#4a5250", 0.20], ["#2c3230", 0.26], ["#0e1212", 0.24], ["#3a4a40", 0.12], ["#141a1c", 0.20], ["#5a6460", 0.10]],
               "tint": {"wild": [0.36, 0.04, 0.08, 0.30], "A": [0.10, 0.10, 0.14, 0.22], "B": [0.10, 0.26, 0.12, 0.20], "C": [0.30, 0.24, 0.10, 0.18]}},
         "atmo": {"grade": [0.82, 0.96, 0.90], "fog": [0.30, 0.40, 0.36], "lamp": [0.78, 1.0, 0.88], "fx": "tube", "mist": [0.70, 0.86, 0.80, 0.08]}}

# ---------------- 第 5 關（ci 4）橫死路口：甘榜推平起組屋。骨架照第 3 關（大排檔喺村南、野外區喺最南），大排檔多一行放第 9 檔 ----------------
SH5 = 200   # 大排檔以南全部向下推 200（第三行檔）
def _shy(p, y0=2390, d=SH5): return [p[0], p[1] + d] if p[1] >= y0 else list(p)
def _shr(r, y0=2390, d=SH5): return [r[0], r[1] + (d if r[1] >= y0 else 0), r[2], r[3] + (d if r[3] >= y0 else 0)]
M4 = copy.deepcopy(M2)
M4.update({"w": 1480, "h": 2920 + SH5, "ground": "zone5_ground", "look": dict(LOOKS["l5"], key="l5"), "gate_side": "S", "cam": {"home": [740, 1300], "zoom": 1.0}})
_z = {z["id"]: z for z in M4["zones"]}
for z in M4["zones"]:
    z["rect"] = _shr(z["rect"])
    if z["type"] == "wild":
        z["gate"]["y"] += SH5; z["boss_at"] = _shy(z["boss_at"]); z.pop("decor", None)
_z["w_yizhuang"].update({"id": "w_carpark", "n": ["野外區　舊墳場停車場", "野外區　舊墳場停車場"],
   "bosses": [_boss("zb_zipai", "自拍跌死鬼頭目", "n30_zipai", ["youhun", "n30_zipai", "zhiren"], 16.5),
              {"id": "zb_pocong5", "n": ["Pocong", "Pocong"], "art": "pocong", "main": True, "chapter": [4, 1]}],
   "decor": [["zt_sodium", 110, 2810, 110], ["zq_cones", 560, 2780, 74], ["zq_scooter", 220, 3040, 72], ["zt_sodium", 640, 3060, 110],
             ["zq_bins", 470, 2700, 60], ["zq_cones", 300, 2700, 70], ["grave", 160, 2960, 0], ["grave", 560, 2960, 0]]})
_z["w_gorge"].update({"id": "w_cinema", "n": ["野外區　舊戲院", "野外區　舊戲院"],
   "bosses": [_boss("zb_chengsi", "撐死鬼頭目", "n30_chengsi", ["zhiren", "n30_chengsi", "youhun"], 17.5),
              {"id": "zb_penanggal", "n": ["Penanggal", "Penanggal"], "art": "penanggal", "main": True, "chapter": [4, 2]}],
   "decor": [["zt_flats", 860, 2800, 140], ["zt_sodium", 1400, 2780, 110], ["zq_newsstack", 1240, 3060, 58], ["zq_bins", 860, 3060, 60],
             ["zq_planter", 1320, 2960, 66], ["zt_flyover", 1380, 3070, 130]]})
_z["market"]["n"] = ["開放區　陰間大排檔（巴士總站夜市）", "開放區　陰間大排檔（巴士總站夜市）"]
_z["A"].update({"n": ["資源區 A　拆樓竹棚", "資源區 A　拆樓竹棚"], "power": 18000, "loss": 0.3, "col": "#5a5a2a", "nofac": False,
   "fields": {"b_bamboo": {"nodes": [[110, 470], [250, 450], [390, 476], [200, 590]], "sign": [300, 700], "n": ["拆樓竹棚", "拆樓竹棚"]}},
   "shops": {"b_strip": {"pos": [140, 760], "need": {"b_bamboo": 3}}},
   "stage": {"en": ["zhiren", "youhun", "zhiren"], "boss": "youhun", "p": 16}})
_z["B"].update({"n": ["資源區 B　橋底回收站", "資源區 B　橋底回收站"], "power": 21000, "loss": 0.3, "col": "#4a4a4a",
   "fields": {"b_newspaper": {"nodes": [[960, 470], [1080, 450], [1010, 560], [1140, 540]], "sign": [1060, 650]}},
   "shops": {"b_pulp": {"pos": [1330, 580], "need": {"b_newspaper": 3}}},
   "stage": {"en": ["youhun", "zhiren", "youhun"], "boss": "zhiren", "p": 17}})
_z["C"].update({"n": ["資源區 C　舊村古井", "資源區 C　舊村古井"], "power": 24000, "loss": 0.3,
   "fields": {"b_well": {"nodes": [[70, 1130], [190, 1150], [120, 1240]], "sign": [150, 1400], "n": ["舊村古井", "舊村古井"]}},
   "shops": {"b_paper": {"pos": [140, 1580], "need": {"b_well": 3}}},
   "note": ["紙寮要竹：竹由拆樓竹棚供應", "紙寮要竹：竹由拆樓竹棚供應"],
   "stage": {"en": ["zhiren", "pocong", "zhiren"], "boss": "zhiren", "p": 18}})
M4["barriers"] = [
    {"k": "void", "style": "city", "rects": [[0, 0, 1480, 214], [636, 214, 844, 836], [1184, 864, 1480, 1740], [0, 1730, 300, 2440 + SH5], [1180, 1740, 1480, 2440 + SH5]]},
    {"k": "ridge", "rect": [718, 2430 + SH5, 762, 2920 + SH5]},
    {"k": "rail", "x": 292, "y0": 900, "y1": 1728, "gap": [1284, 1348], "key": "zt_rail"},
    {"k": "fence", "y": 1748, "x0": 300, "x1": 1180, "gap": [710, 770], "key": "zt_rail", "seg": 92},
    {"k": "stakes", "y": 2416 + SH5, "x0": 300, "x1": 1180, "gaps": [[485, 545], [935, 995]], "dir": -1},
]
M4["scenery"] = [["zt_flats", 120, 150, 150], ["zt_flats", 1340, 150, 150], ["zt_flyover", 740, 300, 150], ["zt_scaffold", 700, 700, 120],
                 ["zt_sodium", 760, 860, 100], ["zt_flats", 1320, 1060, 140], ["zt_scaffold", 1360, 1500, 120], ["zt_sodium", 1240, 1700, 100],
                 ["zt_flats", 120, 1880, 140], ["zt_flyover", 1340, 2000, 140], ["zt_sodium", 200, 2300, 100], ["zt_flats", 1360, 2340, 140]]
M4.pop("gfx", None)
M4["paths"] = [dict(pa, pts=[_shy(q) for q in pa["pts"]]) for pa in M2["paths"]]
M4["village"] = village_at(D2X, D2Y, [740, 1770], {"banana": "willo", "scarecrow": "scarecrow"})
_m = M4["market"]
_m.update({"h": 2400 + SH5, "wh": 2920 + SH5, "fence_y": 2416 + SH5})
for k in ("road", "q2", "porter", "guard_slots", "vol_slots", "vol_mid", "gates"):
    _m[k] = [_shy(q) for q in _m[k]]
_m["q2"] = [[740, 1942], [700, 1944], [640, 1952], [490, 1990], [490, 2180], [490, 2380], [490, 2580], [515, 2620]]
_m["road"] = [[965, 2620], [990, 2580], [990, 2380], [990, 2180], [990, 1990], [840, 1952], [780, 1944], [740, 1870]]
_m["st"] = {"st_waimai": [400, 2060, 5], "st_ifon": [580, 2060, 5], "st_mingbiao": [900, 2060, 5], "st_paoche": [1080, 2060, 5],
            "st_shougongcu": [400, 2300, 5], "st_xifei": [580, 2300, 5], "st_baogu": [900, 2300, 5], "st_shoubao": [1080, 2300, 5],
            "st_zhishan": [740, 2520, 5]}
_C = [[740, 2160], [740, 1990], [866, 1960], [866, 1850], [770, 1850]]
_m["paths"] = {"st_waimai": [[400, 2160]] + _C, "st_ifon": [[580, 2160]] + _C, "st_mingbiao": [[900, 2160]] + _C, "st_paoche": [[1080, 2160]] + _C,
               "st_shougongcu": [[400, 2340], [400, 2420], [620, 2420], [620, 2160]] + _C, "st_xifei": [[580, 2340], [620, 2420], [620, 2160]] + _C,
               "st_baogu": [[900, 2340], [860, 2420], [860, 2160]] + _C, "st_shoubao": [[1080, 2340], [1080, 2420], [860, 2420], [860, 2160]] + _C,
               "st_zhishan": [[740, 2560], [740, 2440], [620, 2420], [620, 2160]] + _C}
_m["vol_mid"] = [[740, 2160]]
_dress(M4, "l5", (D2X, D2Y), _gate_blocks(740, 1770))

# ---------------- 第 6 關（ci 5）地府集團：總部大廈外圍。骨架照第 2 關（大排檔喺村東一條、野外區喺東北／東南），大排檔補到 9 檔 ----------------
M5 = copy.deepcopy(M1)
M5.update({"ground": "zone6_ground", "look": dict(LOOKS["l6"], key="l6"), "gate_side": "E", "cam": {"home": [900, 1150], "zoom": 1.0}})
_z = {z["id"]: z for z in M5["zones"]}
_z["w_kgrave"].update({"id": "w_gate", "n": ["野外區　集團正門", "野外區　集團正門"],
   "bosses": [_boss("zb_niutou", "牛頭保安主任", "niutou", ["zhiren", "niutou", "zhiren"], 20.5),
              {"id": "zb_wuchang", "n": ["黑白無常", "黑白無常"], "art": "heiwu", "main": True, "chapter": [5, 1]}],
   "decor": [["zt_guardbooth", 1470, 150, 130], ["zt_turnstile", 1690, 170, 120], ["zt_tubelamp", 1420, 420, 100], ["zt_tubelamp", 1760, 430, 100],
             ["zq_firehose", 1730, 300, 64], ["zq_cartons", 1450, 300, 70], ["zt_pillar", 1590, 90, 120]]})
_z["w_rubber"].update({"id": "w_board", "n": ["野外區　董事會走廊", "野外區　董事會走廊"],
   "bosses": [_boss("zb_mamian", "馬面秘書長", "mamian", ["zhiren", "mamian", "youhun"], 21.5),
              {"id": "zb_huang", "n": ["黃總", "黃總"], "art": "huang", "main": True, "chapter": [5, 2]}],
   "decor": [["zt_pillar", 1450, 1880, 120], ["zt_pillar", 1730, 1880, 120], ["zq_filecab", 1440, 2180, 52], ["zq_chair", 1740, 2200, 56],
             ["zq_deadplant", 1460, 2050, 56], ["zq_punch", 1740, 2050, 58], ["zt_tubelamp", 1590, 2220, 100]]})
_z["market"]["n"] = ["開放區　陰間大排檔（集團員工飯堂）", "開放區　陰間大排檔（集團員工飯堂）"]
_z["A"].update({"n": ["資源區 A　地庫碳粉房", "資源區 A　地庫碳粉房"], "power": 27000, "loss": 0.3, "col": "#2a2a30",
   "fields": {"b_toner": {"nodes": [[600, 430], [720, 404], [840, 436], [680, 524]], "sign": [790, 600]}},
   "shops": {"b_ink": {"pos": [1150, 560], "need": {"b_toner": 3}}},
   "stage": {"en": ["zhiren", "niutou", "zhiren"], "boss": "zhiren", "p": 20}})
_z["B"].update({"n": ["資源區 B　頂樓孟婆茶園", "資源區 B　頂樓孟婆茶園"], "power": 31000, "loss": 0.3, "col": "#2a4a32",
   "fields": {"b_tea": {"nodes": [[90, 990], [210, 960], [320, 1000], [150, 1090], [290, 1110]], "sign": [220, 1210], "n": ["孟婆茶園", "孟婆茶園"]}},
   "shops": {}, "nofac": True,
   "stage": {"en": ["youhun", "mamian", "youhun"], "boss": "youhun", "p": 21}})
_z["C"].update({"n": ["資源區 C　紙紮部禾稈倉", "資源區 C　紙紮部禾稈倉"], "power": 35000, "loss": 0.3, "col": "#6a5a2a",
   "fields": {"b_straw": {"nodes": [[600, 1930], [700, 1905], [800, 1945], [660, 2020]], "sign": [770, 2080], "n": ["紙紮禾稈倉", "紙紮禾稈倉"]}},
   "shops": {"b_rope": {"pos": [1150, 2010], "need": {"b_straw": 3}}},
   "stage": {"en": ["zhiren", "niutou", "zhiren"], "boss": "zhiren", "p": 22}})
for _b in M5["barriers"]:
    if _b["k"] == "void": _b["style"] = "hq"
    if _b.get("key") in ("zt_pagar",): _b["key"] = "zt_rail"
    if _b.get("fence") == "zt_pagar": _b["fence"] = "zt_rail"
    if _b["k"] == "belt": _b["key"] = "zt_pillar"; _b["step"] = 96
M5["scenery"] = [["zt_pillar", 120, 210, 130], ["zt_tubelamp", 300, 470, 110], ["zt_pillar", 90, 1880, 130], ["zt_guardbooth", 320, 2140, 130],
                 ["zt_tubelamp", 1000, 2180, 110], ["zt_pillar", 600, 120, 120], ["zt_turnstile", 1220, 150, 120]]
M5["village"] = village_at(D1X, D1Y, [1372, 1208], {"scarecrow": "scarecrow", "grave": "grave", "banana": "willo"})
_m = M5["market"]
_m["st"] = {"st_mengpotang": [1510, 800, 5], "st_xizhuang": [1710, 800, 5], "st_zhiku": [1510, 1010, 5], "st_biaoge": [1710, 1010, 5],
            "st_jiabandeng": [1710, 1200, 5], "st_tangyi": [1510, 1460, 5], "st_daka": [1710, 1460, 5], "st_shoubao": [1510, 1660, 5], "st_zhishan": [1710, 1660, 5]}
_m["paths"] = {"st_mengpotang": [[1590, 846], [1600, 1190]], "st_xizhuang": [[1640, 846], [1604, 1190]], "st_zhiku": [[1590, 1056], [1600, 1190]],
               "st_biaoge": [[1640, 1056], [1604, 1190]], "st_jiabandeng": [[1650, 1240], [1604, 1196]],
               "st_tangyi": [[1638, 1500], [1638, 1196], [1570, 1196]], "st_daka": [[1640, 1500], [1640, 1196], [1570, 1196]],
               "st_shoubao": [[1566, 1700], [1566, 1600], [1638, 1500], [1638, 1196], [1570, 1196]], "st_zhishan": [[1640, 1700], [1640, 1196], [1570, 1196]]}
_dress(M5, "l6", (D1X, D1Y), _gate_blocks(1372, 1208))

# [zone2] 資源區自然填充（唔空洞）：避開資源點、名牌、加工廠、門口、路；[圖鍵或 proc:種類, x, y, 闊]
ZFILL = {
  1: {"A": ["zt_banana", "zb_bush", "proc:grass", "zq_cocohusk", "proc:flowers", "zt_banana"], "B": ["zb_bush", "proc:grass", "zq_latexcups", "proc:flowers", "zb_bush"],
      "C": ["zb_bush", "zt_banana", "proc:grass", "zb_rock2", "proc:grass"]},
  2: {"A": ["proc:grass", "zb_rock2", "zt_cliffpine", "proc:grass", "zq_lanternpost"], "B": ["zq_sandals", "zb_rock2", "proc:grass", "zp_deadtree", "proc:grass"],
      "C": ["zb_rock2", "proc:grass", "zq_trough", "proc:pebbles", "zq_stonetable"]},
  3: {"A": ["zt_reeds", "zt_reeds", "proc:grass", "zb_bush", "zb_rock2"], "B": ["zt_reeds", "zq_floats", "zt_reeds", "zq_nets"],
      "C": ["zt_reeds", "zq_cocohusk", "zb_bush", "proc:grass", "zt_banana"]},
  4: {"A": ["zq_cones", "proc:pebbles", "zb_rock2", "zq_bins", "proc:grass"], "B": ["zq_newsstack", "zq_bins", "proc:pebbles", "zq_planter"],
      "C": ["zb_rock2", "proc:grass", "zq_planter", "proc:pebbles", "zb_bush"]},
  5: {"A": ["zq_tonerbox", "zq_cartons", "proc:pebbles", "zq_filecab"], "B": ["zq_deadplant", "proc:grass", "zb_bush", "zq_chair", "proc:grass"],
      "C": ["zq_cartons", "proc:pebbles", "zq_firehose", "zb_rock2", "proc:grass"]}}
FW_ = {"zt_banana": (56, 70), "zb_bush": (60, 76), "zq_cocohusk": (52, 60), "zq_latexcups": (52, 60), "zb_rock2": (44, 56), "zt_cliffpine": (64, 80),
       "zq_lanternpost": (44, 50), "zq_sandals": (44, 52), "zp_deadtree": (56, 68), "zq_trough": (58, 66), "zq_stonetable": (58, 66), "zt_reeds": (54, 70),
       "zq_floats": (48, 56), "zq_nets": (60, 70), "zq_cones": (60, 70), "zq_bins": (52, 60), "zq_newsstack": (48, 56), "zq_planter": (58, 66),
       "zq_tonerbox": (60, 70), "zq_cartons": (60, 70), "zq_filecab": (44, 50), "zq_deadplant": (48, 56), "zq_chair": (46, 52), "zq_firehose": (54, 60)}
def _zfill(M, ci):
    rnd = random.Random(7000 + ci)
    PS = _paths_samples(M)
    for z in M["zones"]:
        if z["type"] != "res" or z["id"] not in ZFILL.get(ci, {}): continue
        kinds = ZFILL[ci][z["id"]]; r = z["rect"]
        bl = []
        for f in z.get("fields", {}).values():
            for n in f["nodes"]: bl.append((n[0] - 46, n[1] - 66, n[0] + 46, n[1] + 24))
            sg = f["sign"]; bl.append((sg[0] - 54, sg[1] - 60, sg[0] + 54, sg[1] + 14))
        for sd in z.get("shops", {}).values():
            q = sd["pos"]; bl.append((q[0] - 70, q[1] - 110, q[0] + 70, q[1] + 20))
        if z.get("nofac"): bl.append((r[2] - 200, r[3] - 80, r[2], r[3]))
        d = z["door"]["rect"]; bl.append((d[0] - 40, d[1] - 40, d[2] + 40, d[3] + 40))
        cx, cy = (r[0] + r[2]) / 2, r[1] + 40; bl.append((cx - 180, r[1], cx + 180, r[1] + 80))   # 區名牌
        bl.append((cx - 120, (r[1] + r[3]) / 2 - 60, cx + 120, (r[1] + r[3]) / 2 + 80))   # 黑霧鎖／戰力字
        props = []
        for gy in range(int(r[1]) + 70, int(r[3]) - 10, 64):
            for gx in range(int(r[0]) + 34, int(r[2]) - 30, 64):
                if rnd.random() > 0.62: continue
                x = gx + rnd.uniform(-18, 18); y = gy + rnd.uniform(-14, 14)
                k = kinds[rnd.randrange(len(kinds))]
                w = rnd.uniform(*FW_[k]) if k in FW_ else 0
                fw = max(26, w * 0.6)
                box = (x - fw / 2, y - 16, x + fw / 2, y + 4)
                if box[0] < r[0] + 8 or box[2] > r[2] - 8 or box[3] > r[3] - 4: continue
                if any(box[0] < b[2] and box[2] > b[0] and box[1] < b[3] and box[3] > b[1] for b in bl): continue
                if any(abs(px - x) < hw + fw / 2 + 6 and abs(py - y) < hw * 0.7 + 12 for (px, py, hw, kk) in PS): continue
                props.append([k, round(x), round(y), round(w)]); bl.append((box[0] - 6, box[1] - 10, box[2] + 6, box[3] + 4))
        props.sort(key=lambda e: e[2])
        z["props"] = props
_zfill(M1, 1); _zfill(M2, 2); _zfill(M3, 3); _zfill(M4, 4); _zfill(M5, 5)

# 劇情事件 id（zone 線 ↔ 劇情線 zstory）：每張圖嘅事件清單（id＝zone id／boss id）
def _events(M):
    ev = [{"kind": "map_enter", "id": ""}]
    for z in M["zones"]:
        if z["type"] in ("res", "wild"): ev.append({"kind": "zone_seen", "id": z["id"]})
    for z in M["zones"]:
        if z["type"] == "res": ev.append({"kind": "zone_cap", "id": z["id"]})
    for z in M["zones"]:
        if z["type"] == "wild":
            for b in z["bosses"]: ev += [{"kind": "boss_pre", "id": b["id"]}, {"kind": "boss_win", "id": b["id"]}]
    for z in M["zones"]:
        if z["type"] == "res" and z.get("shops"): ev.append({"kind": "factory", "id": z["id"], "bid": list(z["shops"])[0]})
    ev.append({"kind": "liberate", "id": ""})
    return ev
for _M in (M0, M1, M2, M3, M4, M5): _M["events"] = _events(_M)

# ================= [fogfix] 出村門外跟主線逐步解霧（zone_data.gd cond_ok；報告列清楚等老闆確認） =================
# 第 1 關：出村門外由開局起全部黑霧；每區喺「佢自己對應嗰個主線任務」完成先散（hint 由遊戲按任務名自動生成）
#   quest_done：[t, key]，key＝任務嘅 b／s／n（D.QUESTS 搵；Guide 插入任務都唔影響）；舊存檔亦用狀態判斷（等級／S.cleared／S.bld）
Q_REVEAL1 = {"market": ["level", "3"],        # 出村：「升到 3 級」完成 → 下一步主線「夜班巡陰：第一章 1-1」要出村門
             "w_pit": ["stage", "1-1"],       # 餓鬼坑：「夜班巡陰：第一章 1-1」完成（之後 1-2、1-3「擊敗餓鬼王」）
             "w_graves": ["stage", "1-2"],    # 亂葬崗：「夜班巡陰：第一章 1-2」完成
             "A": ["bLevel", "wood"],         # 後山竹林：「把伐木場升到 2 級」完成
             "B": ["stage", "1-3"],           # 枯井巷：「擊敗餓鬼王」完成
             "C": ["build", "home"]}          # 荒田禾稈場：「建造民宅（增加雜鬼名額）」完成
H_ENTER = ["睇完呢關開場劇情先開放", "看完這關開場劇情後開放"]
# 第 2–4 關資源區：A＝大排檔開檔劇情（when.t open）播完；B＝第一個新檔劇情（unlock）；C＝賣貨劇情（sold）
RES_BEAT = {"A": "open", "B": "unlock", "C": "sold"}
def _reveal(M, first):
    for z in M["zones"]:
        t = z["type"]; zid = z["id"]
        if first:
            if zid in Q_REVEAL1: z["reveal"] = {"quest_done": Q_REVEAL1[zid]}
        else:       # 第 2–4 關：拔營到埗 → 大排檔即開；野外區喺該關開場劇情（map_enter）後開；資源區跟劇情逐個開
            if t == "wild": z["reveal"] = {"enter": True, "hint": H_ENTER}
            elif t == "res": z["reveal"] = {"beat_t": RES_BEAT[zid]}   # hint 由遊戲按劇情標題自動生成
_reveal(M0, True); _reveal(M1, False); _reveal(M2, False); _reveal(M3, False); _reveal(M4, False); _reveal(M5, False)

_dress(M0)

# ================= [landmark] 地標（zones.json 新 type "landmark"；畫面／規則喺 game/zone/landmark.gd） =================
#   無名義山（hill）：每關村邊一座（拔營跟住搬，見下面 HILL_AT）；解鎖＝第 1 關打完 1-2；開過一次每關都開
#   破塔樓（tower）：第 2 關起每關一座，喺村外一塊空地（由虛空挖出嚟，主角之後可以行過去）；解鎖＝到埗、睇完該關開場劇情
#   解鎖條件用 "unlock"（唔用 "reveal"：地標嘅黑霧／解鎖由 landmark.gd 自己管，唔影響出村門外解霧嘅計數）
#   at＝底邊中心（畫圖、行動目標位）；stand＝玩完返嚟主角企嘅位；rect＝黑霧／撳嘅範圍
# [landmark] 19:00 老闆：無名義山要大（約 3.5～4 棟民宅並排、似一座小山），用 lm_hill_big.webp（1314×867）
#   村子入面冇咁大嘅空位（六關村內布局一樣、塞滿建築／槐樹／稻田／路）→ 每關揀村邊一塊虛空／山岩空地放（拔營＝每關都喺村邊）
#   at＝圖底邊中心；stand＝主角企位（山腳前面，行動目標位）；cut＝挖走虛空／山岩（山＋外圍亂葬崗都喺入面，之後全圖可走時行得到）
HILL_W = 375; HILL_H = round(HILL_W * 867 / 1314, 1)
HILL_AT = {0: {"at": [1116, 2262], "stand": [1010, 2292], "cut": [892, 2010, 1340, 2330]},     # 村南：過河右邊（營帳對面）
           1: {"at": [226, 610], "stand": [330, 640], "cut": [0, 330, 452, 668]},              # 村西北：竹林區左邊
           2: {"at": [1293, 1720], "stand": [1158, 1706], "cut": [1184, 1474, 1480, 1792]},    # 村東南：破塔樓下面（山左腳搭入村邊空位）
           3: {"at": [1740, 585], "stand": [1640, 606], "cut": [1500, 320, 1980, 618]}}        # 村東北：河對面
HILL_AT[4] = HILL_AT[2]; HILL_AT[5] = HILL_AT[1]
# 山腳外圍「亂葬崗／廢墟」過渡：用現有道具圖（w_graves／draw_ruin 嗰批）；唔可撳、唔擋路，每件自己 y 排序
RING_KIT = [("grave", 26, 34, 3), ("zb_rock1", 30, 44, 3), ("zb_rock2", 26, 38, 3), ("zp_deadtree", 52, 70, 2), ("zp_jars", 28, 36, 2),
            ("zb_stakes", 48, 62, 2), ("zb_wall", 46, 60, 2), ("zb_bush", 32, 44, 2), ("zp_woodpile", 34, 42, 1), ("proc:bones", 18, 24, 3),
            ("fg_d1", 56, 74, 2), ("fg_d3", 56, 74, 2), ("fg_g2", 48, 64, 2), ("fg_r2", 40, 52, 2)]
RING_CAP = {"proc:bones": 4, "zp_deadtree": 3, "zb_wall": 2, "zb_stakes": 2, "zp_woodpile": 1, "zp_jars": 3, "grave": 6, "zb_bush": 3}
# 通用「道具散佈」：喺 (cx, cy) 為中心嘅橢圓環（內 rx0/ry0、外 rx1/ry1）入面隨機（seed 固定）但唔擠埋一嚿咁擺道具
#   kit：[(圖鍵, 最細闊, 最大闊, 權重)]；caps：每款最多幾件；box：只可以擺喺呢個框入面；back：背後（上半環）擺唔擺（山會遮住就唔擺）
#   唔入村／資源區／大排檔／野外（M 嘅非地標區）；回 [[圖鍵, x, y, 闊, 左右翻]]（按 y 排好，每件自己 y 排序）
def _scatter(M, cx, cy, rx0, ry0, rx1, ry1, kit, seed, n, box, caps=None, back=True, avoid=()):
    rnd = random.Random(seed); caps = caps or {}
    bag = [k for k in kit for _ in range(k[3])]
    others = [z["rect"] for z in M["zones"] if z["type"] != "landmark"] + list(avoid)
    out = []
    for tries in range(1500):
        if len(out) >= n: break
        a = rnd.uniform(0, math.tau); f = math.sqrt(rnd.uniform(0, 1))
        x = cx + math.cos(a) * (rx0 + (rx1 - rx0) * f); y = cy + math.sin(a) * (ry0 + (ry1 - ry0) * f)
        if not back and math.sin(a) < 0.15 and abs(math.cos(a)) < 0.9: continue
        k = rnd.choice(bag); w = round(rnd.uniform(k[1], k[2]))
        if sum(1 for o in out if o[0] == k[0]) >= caps.get(k[0], 99): continue
        if not (box[0] + w * 0.5 + 4 < x < box[2] - w * 0.5 - 4 and box[1] + 30 < y < box[3] - 6): continue
        if any(r[0] - w * 0.5 < x < r[2] + w * 0.5 and r[1] - 6 < y < r[3] + 40 for r in others): continue
        if any((x - o[1]) ** 2 + ((y - o[2]) * 1.6) ** 2 < (o[3] * 0.5 + w * 0.5) ** 2 * 0.55 for o in out): continue
        out.append([k[0], round(x), round(y), w, rnd.random() < 0.5])
    out.sort(key=lambda e: e[2])
    return out
def _hill_ring(M, ci, at, cut):
    cy = at[1] - HILL_H * 0.17 + 6; rx = HILL_W * 0.5; ry = HILL_H * 0.17
    return _scatter(M, at[0], cy, rx, ry * 1.15, rx * 1.28, ry * 1.9, RING_KIT, 7100 + ci, 26, cut, RING_CAP, back=False)
# [landmark] 紙錢陣（老闆 19:42 定稿）：主陣圖 lm_zhiqian.webp（1316×871，草地邊已羽化、平鋪地面）＋外圍散件 zq_*
#   汽水樽（19:59 換咗冇牌子直身玻璃樽）、膠袋紅汽水都用；大小同無名義山同級（闊 375）；第 3、5 關村邊得 300 闊空位 → 闊 290。解鎖：第 1 關打低餓鬼王（1-3）
ZQ_W = 375
ZQ_AT = {0: {"at": [224, 2292], "stand": [330, 2318], "cut": [0, 2010, 448, 2400]},          # 村南：過河左邊（同無名義山隔住 C 區相對）
         1: {"at": [226, 2080], "stand": [334, 2106], "cut": [0, 1600, 452, 2240]},          # 村西南（原破塔樓位，塔樓搬去無名義山後面）
         2: {"at": [150, 2010], "stand": [236, 2034], "cut": [0, 1734, 300, 2320], "w": 290},  # 村西南：C 區下面
         3: {"at": [1715, 1900], "stand": [1505, 1862], "cut": [1450, 1636, 1980, 2240]}}     # 村東南：B 區右邊（塔樓搬落下面）
ZQ_AT[4] = ZQ_AT[2]; ZQ_AT[5] = ZQ_AT[1]
ZQ_KIT = [("zq_ingots", 44, 56, 3), ("zq_burn_bucket", 30, 38, 2), ("zq_candles", 32, 40, 3), ("zq_lantern_pole", 44, 52, 2), ("zq_coin_pole", 44, 52, 2),
          ("zq_paper_horse", 50, 60, 2), ("zq_paper_sedan", 50, 60, 2), ("zq_parcels", 44, 54, 3), ("zq_ribbon_post", 36, 44, 2), ("zq_zebras", 48, 58, 2),
          ("zq_dancer", 30, 36, 1), ("zq_soda_bottles", 30, 36, 1), ("zq_soda_bags", 36, 44, 1), ("fg_g2", 46, 60, 2), ("fg_g1", 46, 60, 2)]
ZQ_CAP = {"zq_soda_bottles": 2, "zq_soda_bags": 2, "zq_dancer": 2, "zq_zebras": 2, "zq_paper_sedan": 2, "zq_paper_horse": 2, "zq_burn_bucket": 2, "fg_g1": 3, "fg_g2": 3}
def _sub_rect(r, h):
    """r 減去 h（都係 [x0,y0,x1,y1]）→ 最多四塊"""
    if h[0] >= r[2] or h[2] <= r[0] or h[1] >= r[3] or h[3] <= r[1]: return [r]
    o = []
    if h[1] > r[1]: o.append([r[0], r[1], r[2], h[1]])
    if h[3] < r[3]: o.append([r[0], h[3], r[2], r[3]])
    y0 = max(r[1], h[1]); y1 = min(r[3], h[3])
    if h[0] > r[0]: o.append([r[0], y0, h[0], y1])
    if h[2] < r[2]: o.append([h[2], y0, r[2], y1])
    return [q for q in o if q[2] - q[0] >= 8 and q[3] - q[1] >= 8]
def _carve(M, cut, pad):
    for b in M.get("barriers", []):   # 虛空／山岩挖一塊空地出嚟
        if b["k"] in ("void", "cliff"):
            nr = []
            for r in b["rects"]: nr += _sub_rect(r, cut)
            b["rects"] = nr
    M["scenery"] = [s for s in M.get("scenery", []) if not (cut[0] - pad < s[1] < cut[2] + pad and cut[1] < s[2] < cut[3] + pad)]
TOWER_AT = {1: {"rect": [330, 140, 450, 340], "at": [390, 326], "stand": [300, 342]},           # 紙錢陣嚟咗：搬去無名義山後面（村西北）
            2: {"rect": [1196, 1060, 1470, 1470], "at": [1330, 1430], "stand": [1236, 1452]},
            3: {"rect": [1540, 2040, 1700, 2238], "at": [1600, 2222], "stand": [1690, 2230]}}       # 紙錢陣嚟咗：塔樓搬去陣下面
TOWER_AT[4] = TOWER_AT[2]; TOWER_AT[5] = TOWER_AT[1]
def _landmarks(M, ci):
    H = HILL_AT[ci]; hx, hy = H["at"]
    hr = [round(hx - HILL_W / 2 - 6), round(hy - HILL_H - 6), round(hx + HILL_W / 2 + 6), hy + 14]
    _carve(M, H["cut"], 60)
    ring = _hill_ring(M, ci, H["at"], H["cut"])
    fr = [min([hr[0]] + [e[1] - e[3] // 2 for e in ring]), hr[1], max([hr[2]] + [e[1] + e[3] // 2 for e in ring]), max([hr[3]] + [e[2] + 8 for e in ring])]   # 黑霧範圍：山＋外圍
    M["zones"].append({"id": "lm_hill", "type": "landmark", "lm": "hill", "rect": fr, "n": ["地標　無名義山", "地標　無名義山"], "col": "#4a4458",
                       "at": [hx, hy], "stand": list(H["stand"]), "unlock": {"quest_done": ["stage", "1-2"]}, "ring": ring})
    V = M["village"]   # 山圖範圍內嘅村內自然填充擺設拎走（第 3、5 關山左腳搭入村邊）
    V["props"] = [p for p in V.get("props", []) if not (hr[0] - 16 < p[1] < hr[2] + 16 and hr[1] + 40 < p[2] < hr[3] + 20)]
    # 村內擺設（DECOR 嘅墳／樹）同山圖疊：拎走（第 3、5 關山左腳搭入村邊）
    V["DECOR"] = [d for d in V.get("DECOR", []) if not (hr[0] < d[1] < hr[2] and hr[1] + 40 < d[2] < hr[3] + 20)]
    Q = ZQ_AT[ci]; qw = Q.get("w", ZQ_W); qh = round(qw * 871 / 1316, 1); qx, qy = Q["at"]
    _carve(M, Q["cut"], 60)
    qr = [round(qx - qw / 2 - 4), round(qy - qh - 4), round(qx + qw / 2 + 4), qy + 6]
    tav = [TOWER_AT[ci]["rect"]] if ci in TOWER_AT else []
    zring = _scatter(M, qx, qy - qh * 0.5, qw * 0.5 + 6, qh * 0.5 + 6, qw * 0.5 + 92, qh * 0.5 + 62, ZQ_KIT, 7300 + ci, 22, Q["cut"], ZQ_CAP, avoid=tav)
    zfr = [min([qr[0]] + [e[1] - e[3] // 2 for e in zring]), min([qr[1]] + [e[2] - e[3] for e in zring]), max([qr[2]] + [e[1] + e[3] // 2 for e in zring]), max([qr[3]] + [e[2] + 8 for e in zring])]
    zq = {"id": "lm_zhiqian", "type": "landmark", "lm": "zhiqian", "rect": zfr, "n": ["地標　紙錢陣", "地標　紙錢陣"], "col": "#5a2a26",
          "at": [qx, qy], "stand": list(Q["stand"]), "unlock": {"quest_done": ["stage", "1-3"]}, "ring": zring}
    if "w" in Q: zq["w"] = qw
    M["zones"].append(zq)
    if ci in TOWER_AT:
        T = TOWER_AT[ci]
        M["zones"].append({"id": "lm_tower", "type": "landmark", "lm": "tower", "rect": list(T["rect"]), "n": ["地標　破塔樓", "地標　破塔樓"], "col": "#3e3a48",
                           "at": list(T["at"]), "stand": list(T["stand"]), "unlock": {"enter": True, "hint": H_ENTER}})
        _carve(M, [T["rect"][0] - 10, T["rect"][1] - 10, T["rect"][2] + 10, T["rect"][3] + 10], 60)
for _ci, _M in enumerate((M0, M1, M2, M3, M4, M5)): _landmarks(_M, _ci)

D = {"v": 1, "maps": {"0": M0, "1": M1, "2": M2, "3": M3, "4": M4, "5": M5}}

# ================= [paddyfix] 槐樹林／稻田：冇「似樹似田但撳唔到」嘅裝飾 =================
#   1) 任何裝飾都唔可以用可砍槐樹（tree／tree_bare／stump）或可割稻田（paddy／paddy_cut）嘅圖
#   2) 可砍槐樹 GROVE_R 內唔擺樹形裝飾（枯樹、灌木樹、松、香蕉樹）→ 換碎石：玩家一眼睇得出邊幾棵係槐樹林
INTERACTIVE_ART = {"tree", "tree_bare", "stump", "paddy", "paddy_cut", "deco:tree", "deco:paddy"}
TREE_SHAPED = {"zp_deadtree", "zb_bush", "zt_cliffpine", "zt_banana", "zt_mangrove", "banana", "deco:banana"}
GROVE_R = 130.0
def _grove_clear(M):
    V = M["village"]; T = V["TREE_POS"]
    for pr in V["props"]:
        if pr[0] in TREE_SHAPED and min(math.hypot(pr[1] - tx, pr[2] - ty) for tx, ty in T) < GROVE_R:
            pr[0] = "zb_rock2"; pr[3] = 46
    V["DECOR"] = [d for d in V["DECOR"] if not (d[0] in TREE_SHAPED and min(math.hypot(d[1] - tx, d[2] - ty) for tx, ty in T) < GROVE_R)]
for _c, _m in D["maps"].items():
    _grove_clear(_m)
    _V = _m["village"]
    assert len(_V["TREE_POS"]) == 8 and len(_V["PADDY_POS"]) == 6, ("槐樹要 8 棵、稻田要 6 格", _c)
    _all = [("props", p) for p in _V["props"]] + [("DECOR", d) for d in _V["DECOR"]] + [("scenery", s) for s in _m.get("scenery", [])]
    for _z in _m["zones"]: _all += [(_z["id"], p) for p in _z.get("props", []) + _z.get("decor", [])]
    for _w, _p in _all: assert _p[0] not in INTERACTIVE_ART, ("裝飾用咗槐樹／稻田圖", _c, _w, _p)
# [mapbattle] 紅線：兒童形象（toyol、xiaogui）唔做圍欄／被打嘅雜兵、守區怪；Toyol 只可以係主線第 2 章主 Boss（chapter 原關卡）
CHILD_ART = {"toyol", "xiaogui"}
for _c, _m in D["maps"].items():
    for _z in _m["zones"]:
        _sts = [_z.get("stage")] + [b.get("stage") for b in _z.get("bosses", [])]
        for _st in _sts:
            if _st: assert not (set(_st["en"]) | {_st.get("boss")}) & CHILD_ART, ("兒童形象做咗雜兵／守區怪", _c, _z["id"], _st)
        for _b in _z.get("bosses", []):
            assert _b.get("art") not in CHILD_ART or _b.get("chapter"), ("兒童形象做咗王", _c, _b["id"])
# ================= [mapx] 野外分圈擴展（老闆 2026-11-23 09:30） =================
#   每關以村為中心，原有地圖（w×h，村／大排檔／野外區／資源區／地標全部唔郁）外面加 4 圈：
#     1 近郊（低級）→ 2 荒野（中級，枯林／墳地）→ 3 深處（高級＋野外王，破廟遺址／沼澤）→ 4 最外圈（最難，深山）
#   ext：擴大後嘅世界範圍 [x0,y0,x1,y1]（x0／y0 係負數；w／h 照舊＝原有核心地圖，舊程式唔受影響）
#   rings：[{ring,key,n,lv,inner,outer,rects,ground,kit,art}]（rects＝圈帶拆成四塊矩形；art＝換圖接口：docs/art/terrain/<key>_*.webp）
#   ring_props：[[圖鍵或 proc:種類, x, y, 闊, 左右翻, ring]]（唔可撳、唔擋路；zone_view 淨係畫鏡頭入面）
#   sorties：[{id, ring, lv, pos:[x,y], ring_key:bool, king:bool, route:[[x,y]…], march_s}]（只出座標同等級，戰鬥由 sortie 線寫）
#     route：由村門沿可走路（挑夫路→大排檔→野外門→野外區→出口）行到據點；march_s＝以 rts 行軍速度 72px/s 計嘅秒數（≤ 40）
#   ring_key：打低呢個據點 → 下一圈散霧（zone_data.open_ring）；king：野外王據點（深處圈）
MARCH_SPD = 72.0; MARCH_MAX = 40.0
RING_W = [400, 360, 360, 320]
# [mapx] 老闆 09:39：地面改瓦片烘圖（tools/mapx_ground.py → assets/img/mapx_ground_<ci>.webp）；道具只做點綴（少量）
#   tr_*（總指揮地貌圖，約 300×250）畫闊 96–140；每關每款最多 RING_TR_CAP 件；吊橋（tr_mt_bridge）冇深溝暫唔擺
RING_DEF = [
  {"key": "outskirt", "n": ["近郊", "近郊"], "ground": "#2e3824", "kit": [("zb_bush", 54, 72, 3), ("zb_rock2", 38, 52, 2), ("proc:grass", 0, 0, 5), ("proc:flowers", 0, 0, 2), ("zp_deadtree", 56, 70, 1)]},
  {"key": "wilds", "n": ["荒野", "荒野"], "ground": "#36302a", "kit": [("tr_wood_deadtrees", 120, 140, 3), ("tr_wood_log", 96, 116, 2), ("tr_wood_thorn", 90, 110, 2), ("tr_wood_fence", 100, 120, 1), ("grave", 28, 36, 4), ("proc:bones", 0, 0, 2), ("zp_deadtree", 56, 72, 2)]},
  {"key": "depths", "n": ["深處", "深處"], "ground": "#232e2c", "kit": [("tr_ruin_arch", 110, 130, 2), ("tr_ruin_wall", 110, 130, 2), ("tr_swamp_roots", 104, 124, 2), ("zt_reeds", 50, 64, 4), ("grave", 28, 36, 2), ("zq_candles", 32, 40, 1)]},
  {"key": "peaks", "n": ["最外圈　深山", "最外圈　深山"], "ground": "#292a33", "kit": [("tr_mt_rocks", 110, 136, 3), ("tr_mt_pine_cliff", 114, 136, 3), ("tr_mt_watchpost", 108, 124, 1), ("zb_rock2", 40, 56, 4), ("zb_rock1", 40, 56, 3)]},
]
RING_TR_CAP = 6
LV_BASE = [1, 11, 21, 31, 41, 51]       # 第 1 關 Lv1～12，往後每關 +10
RING_LV = [(0, 2), (3, 5), (6, 8), (9, 11)]   # 每圈喺該關嘅等級段（加 LV_BASE）
RING_N = [4, 4, 4, 3]
def _grow(r, d): return [r[0] - d, r[1] - d, r[2] + d, r[3] + d]
def _band_rects(inner, outer):
    return [[outer[0], outer[1], outer[2], inner[1]], [outer[0], inner[3], outer[2], outer[3]],
            [outer[0], inner[1], inner[0], inner[3]], [inner[2], inner[1], outer[2], inner[3]]]
def _in_r(p, r, pad=0): return r[0] + pad <= p[0] <= r[2] - pad and r[1] + pad <= p[1] <= r[3] - pad
def _plen(pts): return sum(math.dist(pts[i], pts[i + 1]) for i in range(len(pts) - 1))
def _wild_gate(z):
    r = z["rect"]; g = z.get("gate", {}); d = float(g.get("dir", 1))
    gy = float(g.get("y", r[3] + 10 if d > 0 else r[1] - 10))
    return [float(g.get("x", (r[0] + r[2]) / 2)), gy], d
def _base_route(M, wz):
    """村門 → 挑夫路 → 大排檔 → 野外門 → 野外區（同 ctl_walk._hop／rts.stage_path 一樣嘅路點）"""
    mk = M["market"]; por = [list(map(float, q)) for q in mk["porter"]]
    vr = next(z["rect"] for z in M["zones"] if z["type"] == "village"); mr = next(z["rect"] for z in M["zones"] if z["type"] == "market")
    iv = max(i for i, q in enumerate(por) if _in_r(q, vr)) if any(_in_r(q, vr) for q in por) else 0
    im = min(i for i, q in enumerate(por) if _in_r(q, mr)) if any(_in_r(q, mr) for q in por) else len(por) - 1
    o = list(por[iv:im + 1] if iv < im else por[:3])   # 由挑夫路喺村入面最後一點（村門口內）出發
    c, d = _wild_gate(wz)
    def cl(r, p, ins=22): return [min(max(p[0], r[0] + ins), r[2] - ins), min(max(p[1], r[1] + ins + 10), r[3] - ins)]
    o.append(cl(mr, [c[0], c[1] + d * 70])); o.append(cl(wz["rect"], [c[0], c[1] - d * 70]))
    return o
def _exits(M, wz):
    """野外區貼住地圖邊嗰幾條邊 → 出口（邊中點，再推出去 30）"""
    r = wz["rect"]; W, H = M["w"], M["h"]; o = []
    if r[1] <= 0: o.append(([(r[0] + r[2]) / 2, 0.0], (0, -1)))
    if r[3] >= H: o.append(([(r[0] + r[2]) / 2, float(H)], (0, 1)))
    if r[0] <= 0: o.append(([0.0, (r[1] + r[3]) / 2], (-1, 0)))
    if r[2] >= W: o.append(([float(W), (r[1] + r[3]) / 2], (1, 0)))
    return o
# [dirs4] 四方向出路（老闆 11:06）：每關東南西北都有一條路出核心地圖。
#   野外區本身貼住嗰邊 → 沿用野外區出口（route 經大排檔、野外門）；冇嘅方向 → 由村門口（挑夫路村內點）
#   用格網 A* 喺「村／區與區之間嘅罅」行到地圖邊（唔穿資源區、地標、大排檔、野外區）
#   M["exits4"]＝[{dir:"N/E/S/W", kind:"wild"/"path", wz, pts:[[x,y]…]（由村門口到地圖邊外 60）, look:"bridge"/"steps"/"wild"}]
DIRV = {"N": (0, -1), "S": (0, 1), "W": (-1, 0), "E": (1, 0)}
G4 = 5
def _astar_exit(M, start, dv):
    import heapq
    W, H = M["w"], M["h"]; nx, ny = W // G4 + 1, H // G4 + 1
    vr = next(z["rect"] for z in M["zones"] if z["type"] == "village")
    blk = [z["rect"] for z in M["zones"] if z["type"] != "village"]
    def ok(i, j):
        x, y = i * G4, j * G4
        if _in_r((x, y), vr, 0): return True   # 村入面（出路喺村柵欄開後門）
        return not any(_in_r((x, y), r, 1) for r in blk)
    def goal(i, j): return (dv[1] < 0 and j == 0) or (dv[1] > 0 and j == ny - 1) or (dv[0] < 0 and i == 0) or (dv[0] > 0 and i == nx - 1)
    s = (int(round(start[0] / G4)), int(round(start[1] / G4)))
    dist = {s: 0.0}; prev = {}; pq = [(0.0, s)]; end = None
    while pq:
        d, c = heapq.heappop(pq)
        if d > dist.get(c, 1e18): continue
        if goal(*c): end = c; break
        for di in (-1, 0, 1):
            for dj in (-1, 0, 1):
                if not di and not dj: continue
                n = (c[0] + di, c[1] + dj)
                if not (0 <= n[0] < nx and 0 <= n[1] < ny) or not ok(*n): continue
                if di and dj and not (ok(c[0] + di, c[1]) and ok(c[0], c[1] + dj)): continue   # 斜行唔准切角
                # 出村門口要經村邊（唔准斜穿柵欄）；離開村之後喺罅入面行
                nd = d + math.hypot(di, dj) * G4 * (1.0 if _in_r((n[0] * G4, n[1] * G4), vr, 14) else 1.15)
                if nd < dist.get(n, 1e18): dist[n] = nd; prev[n] = c; heapq.heappush(pq, (nd, n))
    if end is None: return None
    path = [end]
    while path[-1] != s: path.append(prev[path[-1]])
    path.reverse(); pts = [[float(i * G4), float(j * G4)] for i, j in path]
    # 簡化：共線點刪走（保留轉角）
    o = [pts[0]]
    for i in range(1, len(pts) - 1):
        a, b, c = o[-1], pts[i], pts[i + 1]
        if abs((b[0] - a[0]) * (c[1] - b[1]) - (b[1] - a[1]) * (c[0] - b[0])) > 1e-6: o.append(b)
    o.append(pts[-1]); e = o[-1]
    o.append([e[0] + dv[0] * 60, e[1] + dv[1] * 60])
    return o
def _exits4(M):
    out = []
    wz_all = [z for z in M["zones"] if z["type"] == "wild"]
    for d, dv in DIRV.items():
        got = None
        for wz in wz_all:
            for ex, nv in _exits(M, wz):
                if tuple(nv) == dv and got is None:
                    base = _base_route(M, wz); ba = list(map(float, wz["boss_at"]))
                    got = {"dir": d, "kind": "wild", "wz": wz["id"], "look": "wild",
                           "pts": base + [ba, [ex[0] - nv[0] * 30, ex[1] - nv[1] * 30], [ex[0] + nv[0] * 60, ex[1] + nv[1] * 60]]}
        if got is None:
            st = _base_route(M, wz_all[0])[0]
            pts = _astar_exit(M, st, dv)
            assert pts, ("四方向出路搵唔到", d)
            got = {"dir": d, "kind": "path", "wz": "", "look": "bridge" if d in "EW" else "steps", "pts": pts}
        got["pts"] = [[round(q[0]), round(q[1])] for q in got["pts"]]
        out.append(got)
    M["exits4"] = out
    return out
def _rings(M, ci):
    core = [0, 0, M["w"], M["h"]]
    acc = 0; rings = []; prev = core
    for k, wd in enumerate(RING_W):
        acc += wd; outer = _grow(core, acc)
        lo, hi = RING_LV[k]
        rings.append({"ring": k + 1, "key": RING_DEF[k]["key"], "n": RING_DEF[k]["n"], "lv": [LV_BASE[ci] + lo, LV_BASE[ci] + hi],
                      "inner": prev, "outer": outer, "rects": _band_rects(prev, outer), "ground": RING_DEF[k]["ground"],
                      "art": "terrain/%s" % RING_DEF[k]["key"]})
        prev = outer
    M["ext"] = prev; M["rings"] = rings
    # 據點：每個野外區出口向外，喺每圈圈帶中段揀候選點；條路長 ≤ 40 秒；互相隔 ≥ 200；揀散啲（最遠點取樣）
    # [dirs4] 據點：四個方向出路各自向外，喺每圈圈帶中段揀候選點；條路長 ≤ 40 秒；互相隔 ≥ 200
    cands = {k: {d: [] for d in DIRV} for k in range(1, 5)}
    for e4 in _exits4(M):
        nv = DIRV[e4["dir"]]; tv = (-nv[1], nv[0]); out_pt = e4["pts"][-1]
        ex = [out_pt[0] - nv[0] * 60, out_pt[1] - nv[1] * 60]
        for k, rg in enumerate(rings):
            d0 = rg["inner"]; din = (ex[0] - d0[0]) if nv[0] < 0 else (d0[2] - ex[0]) if nv[0] > 0 else (ex[1] - d0[1]) if nv[1] < 0 else (d0[3] - ex[1])
            for f in (0.35, 0.5, 0.65):
                dep = din + RING_W[k] * f
                for lat in range(-900, 901, 90):
                    p = [ex[0] + nv[0] * dep + tv[0] * lat, ex[1] + nv[1] * dep + tv[1] * lat]
                    if not _in_r(p, rg["outer"], 70) or _in_r(p, _grow(rg["inner"], 70)): continue
                    # 據點要喺呢個方向嗰邊（唔好由東出路行去北邊）
                    cx, cy = (p[0] - M["w"] / 2) / M["w"], (p[1] - M["h"] / 2) / M["h"]
                    side = ("E" if cx > 0 else "W") if abs(cx) > abs(cy) else ("S" if cy > 0 else "N")
                    if side != e4["dir"]: continue
                    route = list(e4["pts"]) + [p]
                    L = _plen(route)
                    if L / MARCH_SPD > MARCH_MAX - 1.0: continue
                    cands[k + 1][e4["dir"]].append((L, [round(p[0]), round(p[1])], [[round(q[0]), round(q[1])] for q in route], e4["dir"]))
    so = []; dcount = {d: 0 for d in DIRV}
    for k in range(1, 5):
        pick = []
        # 輪流：該圈據點最少嗰個方向優先；每個方向揀最短（行軍近）而又同其他據點隔 ≥ 200 嘅候選
        while len(pick) < RING_N[k - 1]:
            order = sorted([d for d in DIRV if d not in [c[3] for c in pick]] or list(DIRV), key=lambda d: (dcount[d], len(cands[k][d]) == 0))
            done = False
            def stag(c, d=None):   # 同方向據點左右交錯（全景名牌唔會疊成一條柱）：同前幾個同方向據點橫向隔 ≥ 420
                nv = DIRV[c[3]]; lat = c[1][0] if nv[0] == 0 else c[1][1]
                near = [s for s in so if s["dir"] == c[3] and abs((s["pos"][0] if nv[0] == 0 else s["pos"][1]) - lat) < 420]
                return c[0] + 900 * len(near)
            for d in order:
                for c in sorted(cands[k][d], key=stag):
                    if all(math.dist(c[1], s["pos"]) >= 200 for s in so) and all(math.dist(c[1], q[1]) >= 200 for q in pick):
                        pick.append(c); dcount[d] += 1; done = True; break
                if done: break
            if not done:   # 呢圈其他方向冇位：同一方向再揀
                for d in sorted(DIRV, key=lambda d: dcount[d]):
                    for c in sorted(cands[k][d], key=lambda c: c[0]):
                        if all(math.dist(c[1], s["pos"]) >= 200 for s in so) and all(math.dist(c[1], q[1]) >= 200 for q in pick):
                            pick.append(c); dcount[d] += 1; done = True; break
                    if done: break
            assert done, ("據點候選唔夠", ci, k, {d: len(v) for d, v in cands[k].items()})
        pick.sort(key=lambda c: c[0])
        lo, hi = rings[k - 1]["lv"]; n = len(pick)
        for j, c in enumerate(pick):
            lv = lo + round((hi - lo) * j / max(1, n - 1))
            so.append({"id": "so%d_r%d_%d" % (ci + 1, k, j + 1), "ring": k, "lv": lv, "pos": c[1], "ring_key": k < 4 and j == n - 1,
                       "king": k == 3 and j == n - 1, "route": c[2], "march_s": round(c[0] / MARCH_SPD, 1), "dir": c[3]})
    M["sorties"] = so
    # 地貌散件：每圈按 kit 散佈（避開據點 110、路線 50）；圈帶每塊矩形按面積分配數量
    avoid_pts = [s["pos"] for s in so]
    segs = []
    for s in so:
        rt = s["route"]
        for i in range(len(rt) - 1): segs.append((rt[i], rt[i + 1]))
    def segd(p, a, b):
        ax, ay = a; bx, by = b; dx, dy = bx - ax, by - ay; L2 = dx * dx + dy * dy
        t = 0 if L2 == 0 else max(0, min(1, ((p[0] - ax) * dx + (p[1] - ay) * dy) / L2))
        return math.dist(p, (ax + dx * t, ay + dy * t))
    props = []
    rnd = random.Random(9100 + ci)
    for k, rg in enumerate(rings):
        kit = RING_DEF[k]["kit"]; bag = [e for e in kit for _ in range(e[3])]
        for rr in rg["rects"]:
            area = (rr[2] - rr[0]) * (rr[3] - rr[1]); n = int(area / 70000)
            got = 0
            for _ in range(n * 6):
                if got >= n: break
                x = rnd.uniform(rr[0] + 30, rr[2] - 30); y = rnd.uniform(rr[1] + 50, rr[3] - 10)
                e = rnd.choice(bag); w = round(rnd.uniform(e[1], e[2])) if e[2] else 0
                if e[0].startswith("tr_") and sum(1 for o in props if o[0] == e[0]) >= (2 if e[0] == "tr_mt_watchpost" else RING_TR_CAP): continue
                if any(math.dist((x, y), q) < 110 + w * 0.5 for q in avoid_pts): continue
                if any(segd((x, y), a, b) < 44 + w * 0.4 for a, b in segs): continue
                if any(abs(x - o[1]) < (w + o[3]) * 0.5 + 10 and abs(y - o[2]) < max(26, (w + o[3]) * 0.3) for o in props): continue
                props.append([e[0], round(x), round(y), w, rnd.random() < 0.5, k + 1]); got += 1
    # [dirs4] 出路畫面（唔擋路、唔可撳）：東／西＝吊橋 tr_mt_bridge（出核心地圖邊、跨虛空）；南／北（非野外區）＝下山石級 proc:steps
    for e4 in M["exits4"]:
        if e4["kind"] != "path": continue
        nv = DIRV[e4["dir"]]; q = e4["pts"][-1]; ex = [q[0] - nv[0] * 60, q[1] - nv[1] * 60]
        if e4["look"] == "bridge":
            props = [o for o in props if math.dist((o[1], o[2]), (ex[0] + nv[0] * 110, ex[1])) > 170]
            props.append(["tr_mt_bridge", round(ex[0] + nv[0] * 96), round(ex[1] + 46), 200, nv[0] < 0, 1])
        else:
            props = [o for o in props if math.dist((o[1], o[2]), (ex[0], ex[1] + nv[1] * 110)) > 150]
            for i in range(6): props.append(["proc:steps", round(ex[0]), round(ex[1] + nv[1] * (14 + i * 26)), 56, False, 1])
    props.sort(key=lambda e: e[2])
    M["ring_props"] = props
for _ci, _M in enumerate((M0, M1, M2, M3, M4, M5)): _rings(_M, _ci)
# [mapx] 合規檢查：每圈 3～5 個據點、等級隨圈遞增、行軍 ≤ 40 秒、唔重疊、喺自己嗰圈圈帶入面（核心地圖外）、每圈（除最外圈）得一個 ring_key
for _c, _m in D["maps"].items():
    _so = _m["sorties"]
    for _k in range(1, 5):
        _r = [s for s in _so if s["ring"] == _k]
        assert 3 <= len(_r) <= 5, ("每圈據點數", _c, _k)
        assert sum(1 for s in _r if s["ring_key"]) == (1 if _k < 4 else 0), ("ring_key", _c, _k)
        if _k > 1: assert min(s["lv"] for s in _r) > max(s["lv"] for s in _so if s["ring"] == _k - 1), ("等級要隨圈遞增", _c, _k)
        _rg = _m["rings"][_k - 1]
        for s in _r: assert _in_r(s["pos"], _rg["outer"]) and not _in_r(s["pos"], _rg["inner"]), ("據點唔喺自己嗰圈", _c, s["id"])
    for s in _so:
        assert _plen(s["route"]) / MARCH_SPD <= MARCH_MAX, ("行軍超過 40 秒", _c, s["id"])
        _a, _b = s["route"][-2], s["route"][-1]   # 出咗核心地圖之後嗰段唔可以再穿返入核心（山岩／虛空）
        for _i in range(41):
            _q = (_a[0] + (_b[0] - _a[0]) * _i / 40, _a[1] + (_b[1] - _a[1]) * _i / 40)
            assert not _in_r(_q, [1, 1, _m["w"] - 1, _m["h"] - 1]), ("圈外路線穿入核心", _c, s["id"])
        for t in _so:
            if t is not s: assert math.dist(s["pos"], t["pos"]) >= 200, ("據點重疊", _c, s["id"], t["id"])
    assert len({s["id"] for s in _so}) == len(_so)
    # [dirs4] 四方向：每關東南西北都有出路、都有據點（每方向 ≥ 3）；村外嗰段出路唔穿資源區／地標／大排檔／野外區
    _e4 = {e["dir"]: e for e in _m["exits4"]}
    assert set(_e4) == {"N", "E", "S", "W"}, ("四方向出路", _c)
    for _d in "NESW":
        assert sum(1 for s in _so if s["dir"] == _d) >= 3, ("方向據點唔夠", _c, _d, [s["dir"] for s in _so])
        _e = _e4[_d]
        if _e["kind"] != "path": continue
        _vr = next(z["rect"] for z in _m["zones"] if z["type"] == "village")
        _bl = [z["rect"] for z in _m["zones"] if z["type"] != "village"]
        _pp = _e["pts"]
        for _i in range(len(_pp) - 1):
            for _t in range(21):
                _q = (_pp[_i][0] + (_pp[_i + 1][0] - _pp[_i][0]) * _t / 20, _pp[_i][1] + (_pp[_i + 1][1] - _pp[_i][1]) * _t / 20)
                assert not any(_in_r(_q, r, 1) for r in _bl), ("出路穿過建築區", _c, _d, _q)
    for s in _so: assert s["route"][:len(_e4[s["dir"]]["pts"])] == _e4[s["dir"]]["pts"], ("據點路線唔係經佢方向出路", _c, s["id"])
# [mapx] 其他線直接改 zones.json 嘅大排檔檔位（militia 線 st_bingqi 兵器檔、第 4／6 關檔位微調，唔喺本檔定義）：重新產生時保留舊檔值，唔好洗走
if os.path.exists(OUT):
    try: _old = json.load(open(OUT, encoding="utf-8"))
    except Exception: _old = {}
    for _c, _m in D["maps"].items():
        _om = _old.get("maps", {}).get(_c, {}).get("market", {})
        for _k in ("st", "paths"):
            for _sid, _v in (_om.get(_k) or {}).items():
                _m["market"].setdefault(_k, {})[_sid] = _v   # 舊檔有嘅檔位（含其他線手動改過嘅座標）以舊檔為準
json.dump(D, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("wrote", OUT)
