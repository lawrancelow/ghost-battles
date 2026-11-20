#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""[story] 劇本線檢查：大排檔客人對白＋每關故事線＋圍欄外惡鬼對白。
用法：python3 tools/story_check.py [data/nat/outpost.json] [data/nat/mv_story.json]
（先跑 tools/outpost_build.py data/nat/outpost.json，佢會同時寫 mv_story.json）

檢查：
  1. 每關（mv_story.json 有嘅關）每種客人：say 四類（q 排隊／buy 買到／wait 等太耐／vol 變義勇軍）都有，合共 ≥ 4 句唔重複
  2. 同一關內：所有客人、拔營句、故事線、惡鬼句，粵／中各自冇兩句一樣（唔同角色唔准講同一句）
  3. 故事線結構：open 一個、move 一個、中段事件 2–3 個；觸發條件合法（台／貨屬於呢關、need.after 指向前面嘅 beat）
  4. 惡鬼：head ≥ 3、roam ≥ 4、wave ≥ 3
  5. 紅線字（outpost_check.BANNED ＋ 本檔 EXTRA）
  6. 女主：有男性字眼嘅句要喺 data/fem.json 有女版（女版唔可以再有男性字眼）；客人氣泡唔經 DB.N()，所以客人句唔准直接叫「阿福／少爺／陳大福」
  7. 字型缺字：godot/fonts/sans_r.otf cmap
  8. [zstory] 分區地圖劇情（第 1–4 關，tools/zone_story_src.py）：
     每關 map_enter 1 個（用該章敘事形式、6–10 句）；每個資源區／野外區 zone_seen、每個資源區 zone_cap、每個王 boss_pre＋boss_win、
     每個有加工廠嘅資源區 factory、liberate 1 個；過程 beat 2–5 句；id 對得上 zones.json（有定義嗰張圖）；
     收編角色（餓鬼王／Toyol／老殭／Pontianak／天花姐）講嘢要有 has:／seen: 出場條件（佢自己嘅 boss_win 除外）；
     line 第 4 格只可以係 has:／seen:（可加 !）；舊大排檔 beat 嘅 need.after 可以指向分區 beat。
"""
import json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
OUTPOST = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "data", "nat", "outpost.json")
STORY = sys.argv[2] if len(sys.argv) > 2 else os.path.join(ROOT, "data", "nat", "mv_story.json")

errs, warns = [], []
def E(m): errs.append(m)
def W(m): warns.append(m)
def load(p):
    with open(p, encoding="utf-8") as f: return json.load(f)
def pair(v): return isinstance(v, list) and len(v) == 2 and all(isinstance(s, str) and s.strip() for s in v)

# 紅線：outpost_check 嘅 BANNED（照讀原檔，唔重複維護）＋劇本線額外
def banned():
    src = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "outpost_check.py"), encoding="utf-8").read()
    m = re.search(r"BANNED = (\[.*?\])\n", src, re.S)
    b = eval(m.group(1)) if m else []
    return b
EXTRA = ["老天爺", "天公", "神靈", "鬼神", "拜神", "拜山", "燒香", "香爐", "冥紙錢莊", "經文", "念經", "誦經", "唸經", "觀音", "上帝",
         "耶穌", "真主", "阿拉", "牧師", "神父", "教堂", "清真", "祭品", "祭拜", "祭祖", "供品", "超渡", "陰德", "報應", "投胎", "地獄十八層",
         "閻羅王", "神婆", "降頭", "巫師", "做法事", "法事", "開光", "靈符", "護身符", "平安符",
         "種族", "馬來人", "華人", "印度人", "鬼佬", "番鬼", "支那", "黑鬼",
         "色情", "性感", "裸體", "上床",
         "BMW", "Mercedes", "Toyota", "Honda", "Proton", "Perodua", "Grab", "Shopee", "Lazada", "WhatsApp", "Facebook", "TikTok",
         "Starbucks", "McDonald", "麥當勞", "肯德基", "KFC", "可口可樂", "Coca", "Pepsi", "百事", "Milo", "美祿", "Samsung", "三星", "Huawei", "華為"]
BAN = banned() + EXTRA

# 男性字眼（指主角先要女版；指其他角色嘅可以喺 OK_MALE 白名單）
MALE = ["陳生", "陳先生", "靚仔", "後生仔", "先生", "兄弟", "小伙子", "帥哥", "男仔", "哥哥", "少年", "男人", "男鬼", "細佬", "老公", "公子", "爺們"]
HERO = ["阿福", "陳大福", "少爺", "Kelvin"]
JOB = ["返工", "上班", "老細", "老闆話", "公司", "PPT", "加班", "辦公室", "同事", "開會", "打工"]

def chars_in_font():
    try:
        from fontTools.ttLib import TTFont
        return set(chr(c) for c in TTFont(os.path.join(ROOT, "fonts", "sans_r.otf")).getBestCmap())
    except Exception as e:
        W("讀唔到字型 cmap：%s" % e); return None

def zone_check(tag, ci, beats, ZS, zm):
    zb = [b for b in beats if b.get("when", {}).get("t") == "zone"]
    got = {}
    for b in zb:
        w = b["when"]; k = (w.get("kind"), w.get("id", ""))
        if k in got: E(tag + " 分區事件重複：%s %s" % k)
        got[k] = b
    zi = ZS.ZIDS[ci]
    need = [("map_enter", ""), ("liberate", "")]
    for z in zi["res"]: need += [("zone_seen", z), ("zone_cap", z)]
    for z in zi["factory"]: need.append(("factory", z))
    for w, bs in zi["wild"].items():
        need.append(("zone_seen", w))
        for x in bs: need += [("boss_pre", x), ("boss_win", x)]
    for k in need:
        if k not in got: E(tag + " 分區事件冇 beat：%s %s" % k)
    for k in got:
        if k not in need: E(tag + " 分區 beat 唔喺 ZIDS：%s %s" % k)
    if zm:   # zones.json 有呢張圖：id 要對得上
        res = [z["id"] for z in zm.get("zones", []) if z.get("type") == "res"]
        wild = {z["id"]: [x["id"] for x in z.get("bosses", [])] for z in zm.get("zones", []) if z.get("type") == "wild"}
        fac = [z["id"] for z in zm.get("zones", []) if z.get("type") == "res" and z.get("shops")]
        if sorted(res) != sorted(zi["res"]): E(tag + " 資源區 id 對唔上 zones.json：%s ≠ %s" % (zi["res"], res))
        if sorted(fac) != sorted(zi["factory"]): E(tag + " 加工廠區對唔上 zones.json：%s ≠ %s" % (zi["factory"], fac))
        if wild != zi["wild"]: E(tag + " 野外區／王 id 對唔上 zones.json：%s ≠ %s" % (zi["wild"], wild))
    else: W(tag + " zones.json 未有呢張圖：分區 id 用緊佔位（ZIDS）")
    ent = got.get(("map_enter", ""))
    if ent:
        if ent["scene"].get("style") != ZS.OPEN_STYLE[ci]: E(tag + " 開場敘事形式要係 %s" % ZS.OPEN_STYLE[ci])
        n0 = len([l for l in ent["scene"]["lines"] if len(l) == 3])
        if not (6 <= n0 <= 10) or len(ent["scene"]["lines"]) > 10: E(tag + " 開場要 6–10 句（而家無條件 %d／全部 %d）" % (n0, len(ent["scene"]["lines"])))
    for b in zb:
        w = b["when"]; ln = b["scene"].get("lines", [])
        if w.get("kind") != "map_enter":
            n0 = len([l for l in ln if len(l) == 3])
            if n0 < 2 or len(ln) > 5 + (2 if w.get("kind") == "liberate" else 0): E(tag + " %s 過程劇情要 2–5 句（無條件 %d／全部 %d）" % (b["id"], n0, len(ln)))
            if "zs%d_map_enter" % ci not in b.get("need", {}).get("after", []): E(tag + " %s 要 need.after 開場" % b["id"])
        if w.get("kind", "").startswith("boss_"):
            z, i = ZS._where(ci, w.get("id"))
            if w.get("z") != z or w.get("bi") != i: E(tag + " %s 王位置 z/bi 錯" % b["id"])
        own = None
        if w.get("kind") == "boss_win":
            for nm, k in ZS.RECRUIT.items():
                if ZS.MAIN_BOSS.get(ci) == w.get("id") and k in str(w.get("id")): own = nm
        for l in ln:
            if not isinstance(l, list) or len(l) < 3: continue
            if l[0] in ZS.RECRUIT and l[0] != own and (len(l) < 4 or not re.match(r"^(has|seen):", l[3])):
                E(tag + " %s：「%s」出場前唔可以講嘢（要 has:／seen: 條件）：%s" % (b["id"], l[0], l[1]))

def main():
    global FEM_OK
    try:
        import mv_story_src; FEM_OK = set(getattr(mv_story_src, "FEM_OK", []))
        import zone_story_src; FEM_OK |= set(getattr(zone_story_src, "ZFEM_OK", []))
    except Exception: FEM_OK = set()
    op = load(OUTPOST); st = load(STORY); fem = load(os.path.join(ROOT, "data", "fem.json"))
    core = load(os.path.join(ROOT, "data", "core.json"))
    spk_art = core.get("SPEAKER_ART", {})
    ghosts = core.get("GHOSTS", {})
    G = op["GOODS"]; S = op["STATIONS"]; CU = {c["id"]: c for c in op["CUSTOMERS"]}
    OPM = {m["ci"]: m for m in op["MAPS"]}
    cmap = chars_in_font()
    STYLES = {"chat", "notice", "talk", "mail", "radio", "letter", "report", "narr", "news", "sys"}
    BGS = {"hq", "road", "field", "banana", "kampung", "office", "village"}
    TRIG = {"open", "unlock", "level", "sold", "inf_below", "wave", "goal", "boss_next", "move", "all_done", "zone"}
    try:
        import zone_story_src as ZS
    except Exception as e:
        ZS = None; E("讀唔到 zone_story_src：%s" % e)
    zmaps = {}
    try: zmaps = load(os.path.join(ROOT, "data", "nat", "zones.json")).get("maps", {})
    except Exception as e: W("讀唔到 zones.json：%s" % e)
    ids_all = {b.get("id") for sm in st.get("MAPS", []) for b in sm.get("beats", [])}
    all_text = []      # (出處, 句)
    seen_beat = set()
    stat = []

    for sm in st.get("MAPS", []):
        ci = sm.get("ci"); m = OPM.get(ci)
        tag = "第 %d 關（ci %s）" % ((ci or 0) + 1, ci)
        if m is None: E(tag + " outpost.json 冇呢張圖"); continue
        sids = set(m["stations"]); gids = {S[s]["good"] for s in sids if s in S}
        texts = []   # (出處, 粵, 中)
        # --- 1. 客人 ---
        ncust, nline = 0, 0
        for cid in m["customers"]:
            c = CU.get(cid)
            if c is None: E(tag + " 客人 %s 唔存在" % cid); continue
            sy = c.get("say")
            if not isinstance(sy, dict): E(tag + " 客人 %s 冇 say（排隊／買到／等太耐／變義勇軍）" % cid); continue
            ncust += 1
            own = []
            for k in ("q", "buy", "wait", "vol"):
                a = sy.get(k)
                if not (isinstance(a, list) and len(a) >= 1 and all(pair(p) for p in a)): E(tag + " 客人 %s say.%s 至少 1 句粵＋中" % (cid, k)); continue
                for p in a:
                    own.append(p); texts.append(("客人 %s.%s" % (cid, k), p[0], p[1]))
                    for h in HERO:
                        if h in p[0] or h in p[1]: E(tag + " 客人 %s 句直接叫主角「%s」（客人氣泡唔經 DB.N）：%s" % (cid, h, p[0]))
                    for lang in (0, 1):
                        if len(p[lang]) > 44: W(tag + " 客人 %s 句太長（%d 字，氣泡會好高）：%s" % (cid, len(p[lang]), p[lang]))
            if len({p[0] for p in own}) < 4 or len({p[1] for p in own}) < 4: E(tag + " 客人 %s 唔重複對白少過 4 句" % cid)
            nline += len(own)
            if c.get("lines") != sy.get("q", []) + sy.get("buy", []): E(tag + " 客人 %s lines 唔等於 say.q＋say.buy（要重跑 outpost_build）" % cid)
        for p in m.get("move_line", []): texts.append(("拔營句", p[0], p[1]))
        # --- 3. 故事線 ---
        beats = sm.get("beats", [])
        kinds = [b.get("when", {}).get("t") for b in beats]
        if kinds.count("open") != 1: E(tag + " 故事線要有 1 個 open（開檔開場），而家 %d" % kinds.count("open"))
        last = ci == len(op["MAPS"]) - 1   # 最後一張圖冇得拔營：收尾用 all_done
        ck = "all_done" if last else "move"
        if kinds.count(ck) != 1 or kinds.count("all_done" if not last else "move"): E(tag + " 故事線要有 1 個 %s 收尾" % ck)
        mid = len(beats) - kinds.count("open") - kinds.count("move") - kinds.count("all_done") - kinds.count("zone")
        if not (2 <= mid <= 3): E(tag + " 中段事件要 2–3 個，而家 %d" % mid)
        here = []
        nsl = 0
        for b in beats:
            bid = b.get("id", ""); w = b.get("when", {}); t = w.get("t")
            bt = tag + " beat %s" % bid
            if not bid or bid in seen_beat: E(bt + " id 空或重複")
            seen_beat.add(bid)
            if t not in TRIG: E(bt + " when.t 唔識：%s" % t)
            if t in ("unlock", "level") and w.get("k") not in sids: E(bt + " 台 %s 唔喺呢張圖" % w.get("k"))
            if t == "level" and not isinstance(w.get("n"), int): E(bt + " level 要 n")
            if t == "sold" and not (w.get("k") == "*" or w.get("k") in gids): E(bt + " sold k 要 '*' 或者呢張圖嘅貨")
            if t in ("sold", "inf_below", "wave") and not isinstance(w.get("n"), (int, float)): E(bt + " %s 要 n" % t)
            if t == "goal" and not (isinstance(w.get("i"), int) and 0 <= w["i"] < len(m["goals"])): E(bt + " goal i 超出目標數")
            nd = b.get("need", {})
            for a in nd.get("after", []):
                if a not in here and not (str(a).startswith("zs") and a in ids_all): E(bt + " need.after %s 唔係前面嘅 beat" % a)
            if t == "boss_next" and not nd.get("boss_alive"): W(bt + " boss_next 冇 need.boss_alive（主線已打低 Boss 會矛盾）")
            sc = b.get("scene", {})
            if sc.get("style") not in STYLES: E(bt + " style 唔識：%s" % sc.get("style"))
            if sc.get("bg") is not None and sc.get("bg") not in BGS: E(bt + " bg 唔識：%s" % sc.get("bg"))
            if sc.get("title") is not None:
                if not pair(sc["title"]): E(bt + " title 要粵＋中")
                else: all_text.append((bt + " title", sc["title"][0])); all_text.append((bt + " title", sc["title"][1]))
            ln = sc.get("lines", [])
            if t != "zone" and len(ln) < 3: E(bt + " 對白少過 3 句")
            art = b.get("art", {})
            for i, l in enumerate(ln):
                if not (isinstance(l, list) and len(l) in (3, 4) and all(isinstance(x, str) and x.strip() for x in l)): E(bt + " 第 %d 行要 [講者, 粵, 中(, 條件)]" % i); continue
                if len(l) == 4 and not re.match(r"^!?(has|seen):[A-Za-z0-9_]+$", l[3]): E(bt + " 第 %d 行條件唔識：%s" % (i, l[3]))
                texts.append((bt + " [%s]" % l[0], l[1], l[2])); nsl += 1
                if "阿福" in l[2] and "他" in l[2] and not fem.get(l[2]) and l[2] not in FEM_OK: E(bt + " 中文句同時有「阿福」同「他」，要喺 fem.json 補「她」版：%s" % l[2])
                if l[0] == "阿福":   # 主角講自己生前（男版係打工仔，女版係大學生）要有女版
                    for x in (l[1], l[2]):
                        if any(j in x for j in JOB) and not fem.get(x) and x not in FEM_OK: E(bt + " 阿福講生前工作但 fem.json 冇女版：%s" % x)
                all_text.append((bt, l[0]))
                if l[0] not in spk_art and l[0] not in art and l[0] not in ("旁白", "系統", "？？？", "抬棺鬼", "告示", "主播", "DJ", "記者", "聽眾", "稻草人") and sc.get("style") == "talk":
                    W(bt + " 講者「%s」冇圖（SPEAKER_ART／art 都冇）" % l[0])
            for sp, k in art.items():
                if k not in ghosts and k not in core.get("ENEMY_T", {}) and k not in spk_art.values(): W(bt + " art %s→%s 唔係已知鬼圖鍵" % (sp, k))
            here.append(bid)
        # --- 4. 惡鬼 ---
        fo = sm.get("FOE", {})
        for k, lo in (("head", 3), ("roam", 4), ("wave", 3)):
            a = fo.get(k, [])
            if not (len(a) >= lo and all(pair(p) for p in a)): E(tag + " FOE.%s 至少 %d 句粵＋中" % (k, lo))
            for p in a:
                if pair(p): texts.append(("惡鬼 %s" % k, p[0], p[1]))
        # --- 8. 分區地圖劇情 ---
        if ZS is not None and ci in ZS.ZIDS and ci in ZS.ZBEATS: zone_check(tag, ci, beats, ZS, zmaps.get(str(ci)))
        # --- 2. 同關重複 ---
        for lang in (1, 2):
            xs = [t[lang] for t in texts]
            dup = sorted({x for x in xs if xs.count(x) > 1})
            for d in dup:
                who = [t[0] for t in texts if t[lang] == d]
                E(tag + " 同關重複句（%s）：%s ← %s" % ("粵中"[lang - 1], d, "、".join(who)))
        for t in texts: all_text.append((tag + " " + t[0], t[1])); all_text.append((tag + " " + t[0], t[2]))
        stat.append("%s：客人 %d 種／%d 句、故事 %d 段／%d 句、惡鬼 %d 句" % (tag, ncust, nline, len(beats), nsl,
                    sum(len(fo.get(k, [])) for k in ("head", "roam", "wave"))))

    # --- 5. 紅線 ---
    for src, t in all_text:
        for b in BAN:
            if b in t: E("紅線字眼「%s」（%s）：%s" % (b, src, t))
    # --- 6. 女主 ---
    nfem = 0
    for src, t in all_text:
        if any(mk in t for mk in MALE):
            f = fem.get(t)
            if not isinstance(f, str) or not f: E("有男性字眼但 fem.json 冇女版（%s）：%s" % (src, t))
            else:
                nfem += 1
                if any(mk in f for mk in MALE): E("女版仲有男性字眼：%s" % f)
                for b in BAN:
                    if b in f: E("女版紅線字眼「%s」：%s" % (b, f))
                all_text.append(("fem", f))
    # --- 7. 字型 ---
    if cmap is not None:
        miss = {}
        for src, t in all_text:
            for ch in t:
                if ch in "\n\t" or ch in cmap: continue
                miss.setdefault(ch, src)
        for ch, src in sorted(miss.items()): E("字型 sans_r.otf 冇「%s」U+%04X（%s）" % (ch, ord(ch), src))

    for s in stat: print("== " + s)
    print("== 女版：%d 句有男性字眼，已全部有 fem.json 對應" % nfem if not any("女版" in e for e in errs) else "== 女版：有缺")
    for w in warns: print("WARN", w)
    for e in errs: print("ERR ", e)
    print("== story_check：%s（錯 %d、警告 %d）" % ("全中" if not errs else "有錯", len(errs), len(warns)))
    return 1 if errs else 0

if __name__ == "__main__":
    sys.exit(main())
