# -*- coding: utf-8 -*-
"""移動村：大地圖版面＋生產台動態（引擎線）。由 tools/outpost_build.py 最尾叫 apply(data)，寫入：
  MAPS[].layout = {
    "w":390, "h":地圖高, "fence_y":圍欄線, "counter":[x,y] 櫃台底中, "house":[x,y] 紙紮大屋底中, "serve":[x,y] 客人收貨位,
    "road":[[x,y],...]  由入口（road[0]，地圖底）一路上到頂；"j": 櫃台路口係 road 第幾點,
    "st": {sid:[x,y,ri]}  台底中位置、ri＝接 road 第幾點（員工搬貨路線：台前 → road[ri] → … → road[j] → 櫃台後）,
    "decor":[{"k":種類,"x","y","s":大細倍數,"f":左右反}...]   種類：現有圖鍵（tree、lamppost…）或者程序畫（grass、rock、lantern、stream、bridge、fogbank）
    "camp_y": 營地頂（= h；營地喺地圖底、紙紮大屋後面，排法由 game/outpost/mv_camp.gd 計，每張圖一樣）
  }
  [camp] 2026-11-19：客人入口（road[0]）改由右邊入（唔再由地圖底入），地圖底留俾「營地」（原本村子嘅建築）。
  STATIONS[].anim = {"fx":[動態名,...], "pts":[[u,v],...]（台圖入面嘅相對位置 0–1，v 由頂計）, "c":"#顏色"}
引擎：game/outpost/mv_data.gd（讀）、mv_fx.gd（畫動態）。
"""
import math, random

W = 390
STEP = 270          # 台與台之間嘅高度
TOP = 430           # 最頂嗰個台嘅 y
FENCE_Y = 230       # 圍欄線（上面係孤魂野鬼出沒）
FIRST = 570         # 最近櫃台嗰個台離地圖底幾遠

THEME = {
    0: [("tree", 1.0), ("tree_bare", 0.9), ("stump", 0.7), ("scarecrow", 0.8), ("paddy", 0.8), ("grass", 1), ("grass", 1), ("rock", 1), ("lantern", 1)],
    1: [("banana", 1.0), ("paddy", 0.8), ("street_lanternR", 0.7), ("pr_stools", 0.6), ("tree", 0.9), ("grass", 1), ("grass", 1), ("rock", 1), ("lantern", 1)],
    2: [("tree", 1.0), ("tree_bare", 1.0), ("rock", 1), ("lamppost", 0.8), ("stump", 0.8), ("grass", 1), ("grass", 1), ("lantern", 1), ("pr_cart", 0.6)],
    3: [("banana", 1.1), ("banana", 0.9), ("pr_boxes", 0.6), ("pr_durianbox", 0.6), ("grass", 1), ("grass", 1), ("rock", 1), ("lantern", 1), ("pr_puddle", 0.7)],
    4: [("lamppost", 0.9), ("street_lanternW", 0.7), ("pr_cone", 0.5), ("pr_motorbike", 0.6), ("pr_bin", 0.6), ("pr_sign", 0.6), ("grass", 1), ("rock", 1), ("pr_wire", 0.7)],
    5: [("of_plant", 0.6), ("of_water", 0.6), ("of_cabinet", 0.6), ("lamppost", 0.8), ("pr_boxes", 0.6), ("grass", 1), ("lantern", 1), ("rock", 1), ("pr_bin", 0.5)],
}
TALL = {"tree", "tree_bare", "banana", "lamppost", "lantern", "scarecrow", "street_lanternR", "street_lanternW"}
STREAM = {0: 0.62, 2: 0.45, 3: 0.55}   # 有小河嘅圖：喺邊個高度（比例），條路過橋

# 每個台嘅生產動態（全部唔同；pts 係台圖入面嘅相對位置）
# 2026-11-19：花轎、影印紙西裝、單褲管紙褲、磚窯、躺椅、錶攤換咗專屬圖（mvs_huajiao／copier／umbrella／kiln／lounge／watch），動態跟新造型重做
ANIM = {
 "st_shoubao":       {"fx": ["steam", "lid"],      "pts": [[0.45, 0.18], [0.45, 0.22]], "c": "#f2efe6"},
 "st_zhishan":       {"fx": ["snip", "scraps"],    "pts": [[0.62, 0.45], [0.5, 0.4]], "c": "#e8d8b0"},
 "st_douhua":        {"fx": ["bucket", "drip"],    "pts": [[0.5, 0.3], [0.5, 0.62]], "c": "#fbf6e8"},
 "st_nuomici":       {"fx": ["mill", "flow"],      "pts": [[0.5, 0.45], [0.72, 0.62]], "c": "#f4f1ea"},
 "st_guancaichuang": {"fx": ["flame", "smoke"],     "pts": [[0.5, 0.62], [0.5, 0.12]], "c": "#ff8a3a"},
 "st_yeketan":       {"fx": ["flame", "sparks"],   "pts": [[0.5, 0.55], [0.5, 0.4]], "c": "#ff9a3a"},
 "st_tuoxie":        {"fx": ["drip", "bob"],       "pts": [[0.35, 0.35], [0.5, 1.0]], "c": "#e0a040"},
 "st_zhulong":       {"fx": ["wiggle", "puff"],    "pts": [[0.5, 1.0], [0.5, 0.15]], "c": "#eef2e4"},
 "st_liulian":       {"fx": ["drop_bounce", "leaves"], "pts": [[0.55, 0.25], [0.5, 0.15]], "c": "#8fa040"},
 "st_yejiangfan":    {"fx": ["bubbles", "bend"],   "pts": [[0.5, 0.35], [0.2, 0.7]], "c": "#f8f4e8"},
 "st_caoxie":        {"fx": ["hop", "straw"],      "pts": [[0.5, 1.0], [0.5, 0.5]], "c": "#d8b860"},
 "st_wucha":         {"fx": ["mist", "glow"],      "pts": [[0.5, 0.4], [0.3, 0.3]], "c": "#cfd8e8"},
 "st_jiuban":        {"fx": ["heat", "stack"],     "pts": [[0.5, 0.3], [0.8, 0.85]], "c": "#a07040"},
 "st_huajiao":       {"fx": ["sway", "petals"],     "pts": [[0.5, 0.0], [0.5, 0.2]], "c": "#e84a5a"},
 "st_xunren":        {"fx": ["sheets", "slap"],    "pts": [[0.5, 0.2], [0.5, 0.4]], "c": "#f0e6c8"},
 "st_jiaoye":        {"fx": ["curl", "fireflies"], "pts": [[0.5, 0.35], [0.5, 0.3]], "c": "#a8e060"},
 "st_xianyu":        {"fx": ["fishswing", "salt"], "pts": [[0.5, 0.3], [0.5, 0.25]], "c": "#ffffff"},
 "st_ningmeng":      {"fx": ["arm", "lemons"],     "pts": [[0.2, 0.5], [0.5, 0.5]], "c": "#f0d830"},
 "st_duihuan":       {"fx": ["sway", "coins"],     "pts": [[0.5, 0.0], [0.5, 0.3]], "c": "#e8c870"},
 "st_jiushengquan":  {"fx": ["ring", "blow"],      "pts": [[0.5, 0.45], [0.3, 0.6]], "c": "#e84a3a"},
 "st_chuanpiao":     {"fx": ["ripple", "quill"],   "pts": [[0.5, 0.92], [0.55, 0.45]], "c": "#9ec8f0"},
 "st_waimai":        {"fx": ["wheel", "heat"],     "pts": [[0.3, 0.85], [0.6, 0.25]], "c": "#ffd080"},
 "st_ifon":          {"fx": ["zap", "eye"],        "pts": [[0.5, 0.3], [0.5, 0.45]], "c": "#a0e0ff"},
 "st_mingbiao":      {"fx": ["pendulum", "tick"],  "pts": [[0.5, 0.2], [0.3, 0.55]], "c": "#f0e0c0"},
 "st_paoche":        {"fx": ["exhaust", "beam"],   "pts": [[0.15, 0.8], [0.85, 0.7]], "c": "#c0c0c8"},
 "st_shougongcu":    {"fx": ["bubbles", "bob"],    "pts": [[0.5, 0.3], [0.5, 1.0]], "c": "#b8e080"},
 "st_xifei":         {"fx": ["bulbs", "flicker"],  "pts": [[0.5, 0.15], [0.5, 0.45]], "c": "#ffe890"},
 "st_mengpotang":    {"fx": ["ladle", "chill"],    "pts": [[0.5, 0.35], [0.5, 0.25]], "c": "#d0f0ff"},
 "st_xizhuang":      {"fx": ["copier", "paperout"], "pts": [[0.5, 0.35], [0.75, 0.5]], "c": "#f4f4f4"},
 "st_zhiku":         {"fx": ["umbrella", "bounce"], "pts": [[0.5, 0.2], [0.5, 1.0]], "c": "#c83a3a"},
 "st_biaoge":        {"fx": ["frost", "stamp"],    "pts": [[0.5, 0.4], [0.5, 0.45]], "c": "#c8ecff"},
 "st_jiabandeng":    {"fx": ["glow", "stack"],     "pts": [[0.5, 0.3], [0.2, 0.85]], "c": "#ffe070"},
 "st_tangyi":        {"fx": ["rock", "zzz"],       "pts": [[0.5, 1.0], [0.55, 0.3]], "c": "#e8e0ff"},
}

def _road_x(ci, i):
    return 195 + 55 * math.sin(i * 1.25 + ci * 0.9)

def layout(ci, sids):
    n = len(sids)
    h = TOP + STEP * (n - 1) + FIRST
    road = [[404, h - 36], [262, h - 140], [240, h - 268]]   # [camp] 入口喺右邊
    j = 2
    st = {}
    jr = random.Random(5150 + ci * 37)
    for i, sid in enumerate(sids):
        y = h - FIRST - i * STEP
        rx = _road_x(ci, i)
        road.append([round(rx), round(y + 36)])
        side = 1 if i % 2 == 0 else -1    # 第一個台喺右邊（左邊係紙紮大屋）
        jx = jr.uniform(-22, 22); jy = jr.uniform(-26, 26)   # [camp] 村莊感：台前後左右錯落（固定種子）
        x = max(92, min(298, rx + side * 112 + jx))
        y = y + jy
        road[-1] = [round(rx + jx * 0.4), round(y + 36)]
        st[sid] = [round(x), round(y), 3 + i]
    road.append([195, FENCE_Y + 20])   # 到圍欄
    rnd = random.Random(20261119 + ci)
    decor = []
    sy = STREAM.get(ci)
    stream_y = None
    if sy is not None:
        # 揀兩個台之間嘅空位放河
        stream_y = round(h - FIRST - STEP * (n - 1) * sy + STEP * 0.5)
        decor.append({"k": "stream", "x": 195, "y": stream_y, "s": 1})
        # 搵條路喺嗰個高度嘅 x
        bx = 195
        for a, b in zip(road, road[1:]):
            if (a[1] - stream_y) * (b[1] - stream_y) <= 0 and a[1] != b[1]:
                bx = a[0] + (b[0] - a[0]) * (stream_y - a[1]) / (b[1] - a[1])
        decor.append({"k": "bridge", "x": round(bx), "y": stream_y, "s": 1})
    def road_x_at(y):
        for a, b in zip(road, road[1:]):
            if (a[1] - y) * (b[1] - y) <= 0 and a[1] != b[1]:
                return a[0] + (b[0] - a[0]) * (y - a[1]) / (b[1] - a[1])
        return 195
    th = THEME.get(ci, THEME[0])
    tries = 0
    counter = [118, h - 250]
    camp = camp_layout(ci, h, road, st, counter)   # [camp] 營地（原本村子嘅建築）
    def camp_hit(x, y, tall):
        r = [x - 16, y - (90 if tall else 24), x + 16, y + 6]
        return any(_ov(r, f, 6) for f in camp["_fp"]) or _near_path(camp["road"], x, y, 34)
    while len([d for d in decor if d["k"] not in ("stream", "bridge")]) < 24 and tries < 4000:
        tries += 1
        y = rnd.uniform(FENCE_Y + 60, h - 40)
        x = rnd.uniform(14, W - 14)
        if abs(x - road_x_at(y)) < 48: continue
        if stream_y is not None and abs(y - stream_y) < 40: continue
        k, s = th[rnd.randrange(len(th))]
        tall = k in TALL
        # 唔好遮住台、名牌、員工位：高嘅佈景（樹、燈柱）由腳底向上畫，要避開台下面嗰段
        if any(abs(x - p[0]) < (150 if tall else 105) and (p[1] - 60) < y < (p[1] + (230 if tall else 110)) for p in st.values()): continue
        if any(math.hypot(x - p[0], y - p[1]) < 115 for p in st.values()): continue
        if abs(x - counter[0]) < 170 and counter[1] - 140 < y < counter[1] + (200 if tall else 90): continue
        if any(math.hypot(x - d["x"], y - d["y"]) < (70 if tall else 48) for d in decor): continue
        if camp_hit(x, y, tall): continue   # [camp]
        decor.append({"k": k, "x": round(x), "y": round(y), "s": round(s * rnd.uniform(0.85, 1.15), 2), "f": rnd.random() < 0.5})
    decor.extend(camp.pop("_decor"))   # [camp] 營地夾樹、石、草叢
    camp.pop("_fp")
    decor.sort(key=lambda d: d["y"])
    for i in range(3):
        decor.append({"k": "fogbank", "x": round(rnd.uniform(0, W)), "y": round(h * (0.2 + 0.3 * i)), "s": round(rnd.uniform(0.8, 1.3), 2)})
    return {"w": W, "h": h, "fence_y": FENCE_Y, "counter": counter, "house": [104, h - 318], "serve": [236, h - 232],
            "road": road, "j": j, "st": st, "decor": decor, "camp_y": h, "camp": camp, "fence_art": False}

# ================= [camp] 營地：原本村子嘅建築（舊十間＋後院拓展建築），喺紙紮大屋後面沿住彎路散落 =================
# layout.camp = {"top": 營地頂, "bottom": 全部建築起晒嘅營地底, "sign": [x, y] 營地木牌（底中）,
#                "road": [[x, y], ...] 營地泥路（由櫃台側邊落去）, "slots": {建築鍵: [x, y, s]}（建築底中、大細倍數）}
#   建築鍵：舊建築 = BLD_ORDER 鍵（wood、rice、plank…）；拓展建築 = chain.json 嘅 bid（b_well…）。
#   畫面（game/outpost/mv_camp.gd）只畫已起／已解鎖／下一張圖預告嘅；冇 slot 嘅（新加建築）自動排喺最底。
#   唔疊：每間建築佔位（圖＋頂上牌＋門口打工鬼＋名牌）互相唔撞，唔撞櫃台、紙紮大屋、排隊線、營地泥路、木牌。
CAMP_OLD = ["wood", "rice", "plank", "bun", "store", "house", "home", "camp", "altar", "furnace"]
CAMP_BW = {"house": 112, "furnace": 66}
CAMP_RATIO = {"house": 0.96, "wood": 0.92, "rice": 0.95, "plank": 0.93, "bun": 0.87, "store": 0.96, "home": 0.96, "camp": 0.94, "altar": 0.97, "furnace": 1.14}
IMG_MAXH = 96
CAMP_W = 100            # 建築圖闊（大細倍數 s 再乘）
def _camp_ids():
    import json, os
    p = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "data", "nat", "chain.json")
    ids = []
    try:
        d = json.load(open(p, encoding="utf-8"))
        o = 0; rows = []
        for kk, kind in (("GATHER", 0), ("WORKSHOPS", 1)):
            for b, e in d.get(kk, {}).items():
                if not e.get("old"): rows.append((int(e.get("unlock", {}).get("ci", 0)), kind, o, b))
                o += 1
        rows.sort()
        ids = [r[3] for r in rows]
    except Exception:
        pass
    return CAMP_OLD + ids
def _ov(a, b, m=0):
    return a[0] - m < b[2] and b[0] - m < a[2] and a[1] - m < b[3] and b[1] - m < a[3]
def _seg_d(px, py, a, b):
    ax, ay = a; bx, by = b; dx = bx - ax; dy = by - ay
    L = dx * dx + dy * dy
    u = 0 if L == 0 else max(0, min(1, ((px - ax) * dx + (py - ay) * dy) / L))
    return math.hypot(px - (ax + u * dx), py - (ay + u * dy))
def _near_path(P, x, y, d):
    return any(_seg_d(x, y, a, b) < d for a, b in zip(P, P[1:]))
def _rect_path(r, P, d):   # 矩形同路（闊 d）有冇撞
    for a, b in zip(P, P[1:]):
        for k in range(9):
            u = k / 8.0; x = a[0] + (b[0] - a[0]) * u; y = a[1] + (b[1] - a[1]) * u
            if r[0] - d < x < r[2] + d and r[1] - d < y < r[3] + d: return True
    return False
_NAMES = None
def _name_len(bid):   # 名牌闊要計埋（同 mv_camp.gd _plate_w 一致：字數 × 15 + 46，60–120）
    global _NAMES
    if _NAMES is None:
        import json, os
        root = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "data", "nat")
        _NAMES = {}
        try:
            for k, e in json.load(open(os.path.join(root, "data.json"), encoding="utf-8")).get("BUILDINGS", {}).items(): _NAMES[k] = len(e.get("name", ""))
            d = json.load(open(os.path.join(root, "chain.json"), encoding="utf-8"))
            for kk in ("GATHER", "WORKSHOPS"):
                for k, e in d.get(kk, {}).items(): _NAMES[k] = max(len(e["n"][0]), len(e["n"][1]))
        except Exception:
            pass
    return _NAMES.get(bid, 5)
def camp_fp(bid, x, y, s):   # 建築佔位（世界座標 [x0, y0, x1, y1]）
    w = CAMP_BW.get(bid, CAMP_W) * s
    hh = w * CAMP_RATIO.get(bid, 0.833)
    if hh > IMG_MAXH * s: hh = IMG_MAXH * s
    pw = min(120, max(60, _name_len(bid) * 15 + 46))
    hw = max(w / 2, 52, pw / 2 + 2)
    return [x - hw, y + 6 - hh - 10, x + hw, y + 52]
def camp_layout(ci, h, road, st, counter):
    rnd = random.Random(880000 + ci * 131)
    top = h - 170
    # 營地泥路：由櫃台左下角開始，彎彎曲曲落去
    path = [[150, h - 214], [118, h - 120]]
    y = h - 120; k = 0
    while y < h + 3200:
        y += rnd.uniform(190, 250); k += 1
        path.append([round(195 + 105 * math.sin(k * 0.8 + ci * 1.3) + rnd.uniform(-14, 14)), round(y)])
    sign = [round(path[1][0] + 70), h - 132]
    # 唔准撞：櫃台、紙紮大屋、排隊線（serve → road[1] → road[0]，客人高 90）、木牌、最底嗰個台
    queue = [[236, h - 232]] + [road[1], road[0]]
    ex = [[counter[0] - 100, counter[1] - 70, counter[0] + 100, counter[1] + 24],
          [104 - 90, h - 318 - 150, 104 + 90, h - 318 + 8],
          [sign[0] - 70, sign[1] - 76, sign[0] + 70, sign[1] + 30]]
    for p in st.values(): ex.append([p[0] - 90, p[1] - 150, p[0] + 90, p[1] + 70])
    def bad(r):
        if r[0] < 2 or r[2] > W - 2: return True
        if any(_ov(r, e, 6) for e in ex): return True
        for a, b in zip(queue, queue[1:]):
            for kk in range(9):
                u = kk / 8.0; qx = a[0] + (b[0] - a[0]) * u; qy = a[1] + (b[1] - a[1]) * u
                if r[0] - 26 < qx < r[2] + 26 and r[1] - 6 < qy < r[3] + 100: return True   # 客人企喺線上，身高約 90
        return _rect_path(r, path, 12)
    slots = {}; fps = []
    cur = h - 60
    for bid in _camp_ids():
        for rounds in range(30):
            cands = []
            for tries in range(1500):
                yy = rnd.uniform(h - 80, cur + 260)
                px = None
                for a, b in zip(path, path[1:]):
                    if a[1] <= yy <= b[1]: px = a[0] + (b[0] - a[0]) * (yy - a[1]) / max(1, b[1] - a[1])
                if px is None: continue
                side = -1 if rnd.random() < 0.5 else 1
                x = px + side * rnd.uniform(66, 250)
                sc = round(rnd.uniform(0.9, 1.08), 2)
                r = camp_fp(bid, x, yy, sc)
                if bad(r) or any(_ov(r, f, 10) for f in fps): continue
                cands.append((yy + rnd.uniform(0, 50), x, yy, sc, r))
                if len(cands) >= 40: break
            if cands:
                cands.sort(key=lambda c: c[0])
                _, x, yy, sc, r = cands[0]
                slots[bid] = [round(x), round(yy), sc]; fps.append(r)
                cur = max(cur, yy)
                break
            cur += 60
    bottom = max(v[1] for v in slots.values()) + 110
    path = [p for p in path if p[1] < bottom + 60]
    # 夾啲樹、石、草叢、燈（唔撞建築佔位、泥路、木牌）
    th = THEME.get(ci, THEME[0]); dec = []
    for tries in range(3000):
        if len(dec) >= int((bottom - top) / 55): break
        x = rnd.uniform(14, W - 14); yy = rnd.uniform(h - 40, bottom)
        kd, s0 = th[rnd.randrange(len(th))]
        tall = kd in TALL
        r = [x - (30 if tall else 14), yy - (110 if tall else 26), x + (30 if tall else 14), yy + 6]
        if any(_ov(r, f, 4) for f in fps) or any(_ov(r, e, 0) for e in ex[2:3]): continue
        if _rect_path(r, path, 16): continue
        if any(math.hypot(x - d["x"], yy - d["y"]) < (64 if tall else 40) for d in dec): continue
        dec.append({"k": kd, "x": round(x), "y": round(yy), "s": round(s0 * rnd.uniform(0.85, 1.1), 2), "f": rnd.random() < 0.5})
    return {"top": top, "bottom": round(bottom), "sign": sign, "road": path, "slots": slots, "_decor": dec, "_fp": fps + [ex[2]]}

# ================= [unify] 合一地圖：「村子」分頁頂段 =================
# 村子分頁一張直向連續地圖：村外惡鬼區＋柵欄＋大排檔區（新背景 bgm<圖>_a／_b，世界 0..EH）→ 出村門 → 原版村子（唔變）。
# 大排檔區世界 y = 村子 y + EH（村子 y = -EH..0）。台擺喺彎泥路兩邊空地；櫃台喺底（出村門上面）；客人由左右兩邊入；
# 隨村台（嘆氣蒸籠、補丁紙衫攤）擺最底一行近出村門。台數固定：第 1–6 張圖 5、5、6、6、7、7（＋2 隨村台），
# 資料唔夠嘅台位留空（layout.spare：「待開檔」）。
EH = 1110               # 大排檔區總高（兩塊 390×585，接縫 60）
U_FENCE = 150           # 背景柵欄線
U_ROWS = [780, 620, 460, 300]   # 台嘅行（由近櫃台起，第一個台最近櫃台）
U_CARRY_Y = 925         # 隨村台嗰行
U_TARGET = [5, 5, 6, 6, 7, 7]
U_CARRY = ["st_shoubao", "st_zhishan"]
U_COUNTER = [195, 1058]
U_SERVE = [195, 1100]
_ROADS = None
def _roads():
    global _ROADS
    if _ROADS is None:
        import json, os
        p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "unify_roads.json")
        _ROADS = {int(k): v for k, v in json.load(open(p, encoding="utf-8")).items()}
    return _ROADS
def _rx(ci, y):
    R = _roads()[ci]
    best = min(R, key=lambda q: abs(q[1] - y))
    return best[0]
def unify_layout(ci, sids):
    reg = [s for s in sids if s not in U_CARRY]
    car = [s for s in U_CARRY if s in sids] or U_CARRY
    # 台位：每行左右各一個（彎泥路兩邊），由近櫃台嗰行起
    slots = []
    for y in U_ROWS:
        rx = _rx(ci, y)
        lx = max(70, min(150, rx - 112)); rgt = min(320, max(240, rx + 112))
        slots.append([round(lx), y]); slots.append([round(rgt), y])
    # 路：road[0]＝右邊入口、road[1]＝右邊排隊位、road[2]＝櫃台路口（j），之後沿彎泥路一路上到柵欄
    R = _roads()[ci]
    up = [p for p in R if p[1] <= 1000 and p[1] % 40 == 0]
    up.sort(key=lambda p: -p[1])
    road = [[430, 1094], [300, 1104], [195, 1018]] + [[p[0], p[1]] for p in up] + [[_rx(ci, 160), U_FENCE + 14]]
    j = 2
    def ri_of(y):
        best = 3; bd = 1e9
        for i in range(3, len(road)):
            d = abs(road[i][1] - (y + 30))
            if d < bd: bd = d; best = i
        return best
    st = {}
    for i, sid in enumerate(reg[:len(slots)]):
        x, y = slots[i]
        st[sid] = [x, y, ri_of(y)]
    cpos = [[72, U_CARRY_Y], [318, U_CARRY_Y]]
    for i, sid in enumerate(car[:2]):
        x, y = cpos[i]
        st[sid] = [x, y, ri_of(y) if i else 3]
    tgt = U_TARGET[ci] if ci < len(U_TARGET) else 5
    spare = [slots[i] for i in range(len(reg), min(tgt, len(slots)))]
    q2 = [U_SERVE, [96, 1104], [-40, 1094]]   # 左邊入口嘅排隊線（收貨位 → 左邊）
    return {"w": W, "h": EH, "fence_y": U_FENCE, "counter": U_COUNTER, "house": [195, EH + 70], "serve": U_SERVE,
            "road": road, "j": j, "st": st, "decor": [], "fence_art": True, "unify": True, "eh": EH, "q2": q2,
            "spare": spare, "target": tgt}

def apply(data):
    for m in data["MAPS"]:
        m["layout"] = unify_layout(m["ci"], m["stations"])   # [unify] 合一地圖（舊 layout()／營地 camp_layout() 唔再用）
        m["bg_tiles"] = ["bgm%d_a" % m["ci"], "bgm%d_b" % m["ci"]]
    for sid, s in data["STATIONS"].items():
        if sid in ANIM: s["anim"] = ANIM[sid]
    return data
