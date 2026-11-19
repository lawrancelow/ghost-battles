# -*- coding: utf-8 -*-
"""移動村：大地圖版面＋生產台動態（引擎線）。由 tools/outpost_build.py 最尾叫 apply(data)，寫入：
  MAPS[].layout = {
    "w":390, "h":地圖高, "fence_y":圍欄線, "counter":[x,y] 櫃台底中, "house":[x,y] 紙紮大屋底中, "serve":[x,y] 客人收貨位,
    "road":[[x,y],...]  由入口（road[0]，地圖底）一路上到頂；"j": 櫃台路口係 road 第幾點,
    "st": {sid:[x,y,ri]}  台底中位置、ri＝接 road 第幾點（員工搬貨路線：台前 → road[ri] → … → road[j] → 櫃台後）,
    "decor":[{"k":種類,"x","y","s":大細倍數,"f":左右反}...]   種類：現有圖鍵（tree、lamppost…）或者程序畫（grass、rock、lantern、stream、bridge、fogbank）
  }
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
    road = [[292, h + 30], [262, h - 140], [240, h - 268]]
    j = 2
    st = {}
    for i, sid in enumerate(sids):
        y = h - FIRST - i * STEP
        rx = _road_x(ci, i)
        road.append([round(rx), round(y + 36)])
        side = 1 if i % 2 == 0 else -1    # 第一個台喺右邊（左邊係紙紮大屋）
        x = max(92, min(298, rx + side * 112))
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
        decor.append({"k": k, "x": round(x), "y": round(y), "s": round(s * rnd.uniform(0.85, 1.15), 2), "f": rnd.random() < 0.5})
    decor.sort(key=lambda d: d["y"])
    for i in range(3):
        decor.append({"k": "fogbank", "x": round(rnd.uniform(0, W)), "y": round(h * (0.2 + 0.3 * i)), "s": round(rnd.uniform(0.8, 1.3), 2)})
    return {"w": W, "h": h, "fence_y": FENCE_Y, "counter": counter, "house": [104, h - 318], "serve": [236, h - 232],
            "road": road, "j": j, "st": st, "decor": decor}

def apply(data):
    for m in data["MAPS"]:
        m["layout"] = layout(m["ci"], m["stations"])
    for sid, s in data["STATIONS"].items():
        if sid in ANIM: s["anim"] = ANIM[sid]
    return data
