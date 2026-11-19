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
MALE = ["靚仔", "後生仔", "先生", "兄弟", "小伙子", "帥哥", "男仔", "哥哥", "少年", "男人", "男鬼", "細佬", "老公", "公子", "爺們"]
HERO = ["阿福", "陳大福", "少爺", "Kelvin"]
JOB = ["返工", "上班", "老細", "老闆話", "公司", "PPT", "加班", "辦公室", "同事", "開會", "打工"]

def chars_in_font():
    try:
        from fontTools.ttLib import TTFont
        return set(chr(c) for c in TTFont(os.path.join(ROOT, "fonts", "sans_r.otf")).getBestCmap())
    except Exception as e:
        W("讀唔到字型 cmap：%s" % e); return None

def main():
    op = load(OUTPOST); st = load(STORY); fem = load(os.path.join(ROOT, "data", "fem.json"))
    core = load(os.path.join(ROOT, "data", "core.json"))
    spk_art = core.get("SPEAKER_ART", {})
    ghosts = core.get("GHOSTS", {})
    G = op["GOODS"]; S = op["STATIONS"]; CU = {c["id"]: c for c in op["CUSTOMERS"]}
    OPM = {m["ci"]: m for m in op["MAPS"]}
    cmap = chars_in_font()
    STYLES = {"chat", "notice", "talk", "mail", "radio", "letter", "report", "narr", "news", "sys"}
    BGS = {"hq", "road", "field", "banana", "kampung", "office", "village"}
    TRIG = {"open", "unlock", "level", "sold", "inf_below", "wave", "goal", "boss_next", "move"}
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
        if kinds.count("move") != 1: E(tag + " 故事線要有 1 個 move（拔營收尾），而家 %d" % kinds.count("move"))
        mid = len(beats) - kinds.count("open") - kinds.count("move")
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
                if a not in here: E(bt + " need.after %s 唔係前面嘅 beat" % a)
            if t == "boss_next" and not nd.get("boss_alive"): W(bt + " boss_next 冇 need.boss_alive（主線已打低 Boss 會矛盾）")
            sc = b.get("scene", {})
            if sc.get("style") not in STYLES: E(bt + " style 唔識：%s" % sc.get("style"))
            if sc.get("bg") is not None and sc.get("bg") not in BGS: E(bt + " bg 唔識：%s" % sc.get("bg"))
            if sc.get("title") is not None:
                if not pair(sc["title"]): E(bt + " title 要粵＋中")
                else: all_text.append((bt + " title", sc["title"][0])); all_text.append((bt + " title", sc["title"][1]))
            ln = sc.get("lines", [])
            if len(ln) < 3: E(bt + " 對白少過 3 句")
            art = b.get("art", {})
            for i, l in enumerate(ln):
                if not (isinstance(l, list) and len(l) == 3 and all(isinstance(x, str) and x.strip() for x in l)): E(bt + " 第 %d 行要 [講者, 粵, 中]" % i); continue
                texts.append((bt + " [%s]" % l[0], l[1], l[2])); nsl += 1
                if l[0] == "阿福":   # 主角講自己生前（男版係打工仔，女版係大學生）要有女版
                    for x in (l[1], l[2]):
                        if any(j in x for j in JOB) and not fem.get(x): E(bt + " 阿福講生前工作但 fem.json 冇女版：%s" % x)
                all_text.append((bt, l[0]))
                if l[0] not in spk_art and l[0] not in art and l[0] not in ("旁白", "系統", "？？？", "抬棺鬼", "告示", "主播", "DJ"):
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
