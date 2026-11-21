#!/usr/bin/env python3
"""檢查 data/nat/taunts.json（MAPBATTLE 嘲諷台詞）。
用法：python3 tools/taunts_check.py        （任何目錄都得；路徑以本檔位置計）
查：格式／句數、長度、重複（檔內＋同遊戲其他文本）、紅線字表、主 Boss 劇透字、id 對 zones.json、
    女版覆蓋（性別稱呼／主角生前份工 → fem.json 要有女版，或者喺 taunts_src.FEM_OK 白名單）、字型缺字（fonts/sans_r.otf）。
有錯 → exit 1。
"""
import glob, json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))   # godot/
D = lambda *p: os.path.join(ROOT, *p)
sys.path.insert(0, os.path.join(ROOT, "tools"))
import taunts_src as SRC

MAX_YUE, MAX_ZH = 22, 24          # 泡泡一行半：粵語 ≤ 22 字、中文 ≤ 24 字（連標點）
NEED = {"lose": 8, "idle": 8, "rematch": 2, "defeat": 2}        # 王（rematch／defeat 係「啱啱」2 句）
NEED_CAP = {"lose": 3, "idle": 3, "defeat": 1}                    # 資源區頭目（至少）
RAID_N = 4

# ---- 紅線字表 ----
RED = {
 "粗口": r"屌|撚|閪|柒|鳩|㞗|𨳒|冚家|仆你|頂你個肺|戇|痴線|黐線|食屎|on9|ON9",
 "種族": r"鬼佬|鬼妹|黑鬼|阿差|嚤囉|番鬼|支那|印度|華人|馬來人|菲律賓|泰國|印尼|外勞|黑人|白人|種族|膚色",
 "宗教": r"佛|菩薩|觀音|上帝|耶穌|阿拉|真主|神父|和尚|尼姑|道士|念經|唸經|符咒|靈符|拜神|神明|神仙|教堂|清真|廟|超渡|超度|閻王|天堂|地獄|輪迴|宗教|祈禱|阿門|法師",
 "性別": r"男|女|娘娘腔|乸|基佬|姣婆",
 "身體缺陷": r"盲|聾|啞|跛|瘸|殘廢|傷殘|弱智|低能|白痴|智障|肥|矮|禿|瘦|醜|樣衰|口吃|黐脷|獨腳|單腳|冇頭|無頭|駝背|斷手|斷腳",
 "家人": r"媽|爸|老豆|老竇|老母|阿爺|嫲|老公|老婆|仔女|兒子|女兒|家人|屋企人|爹|阿妹|阿弟|家姐",
 "性": r"性交|性感|性愛|做愛|色情|好色|鹹濕|胸|裸|脫衫|除衫|上床|姣",
 "兒童": r"細路|小朋友|BB|學童|兒童|小學|幼稚園|幼兒",
 "品牌": r"麥當勞|肯德基|KFC|星巴克|Starbucks|iPhone|Apple|蘋果|Samsung|三星|可口可樂|Coca|百事|7-Eleven|7-11|Grab|Shopee|Lazada|Petronas|Nike|Adidas|Gucci|LV|Uber|淘寶|Facebook|WhatsApp|微信|TikTok|YouTube|漢堡",
}
# 再加埋劇本線／大排檔線嘅禁字（outpost_check.BANNED、story_check.EXTRA），全遊戲同一把尺
def _ext():
    out = []
    for mod, name in (("outpost_check", "BANNED"), ("story_check", "EXTRA")):
        try:
            src = open(os.path.join(ROOT, "tools", mod + ".py"), encoding="utf-8").read()
            m = re.search(r"^%s\s*=\s*(\[.*?\])" % name, src, re.S | re.M)
            if m: out += eval(m.group(1), {})
        except Exception as e:
            print("提示：讀唔到 %s.%s（%s）" % (mod, name, e))
    return out
RED["禁字表"] = "|".join(re.escape(w) for w in _ext() if w)
LIGHT = r"仆街"           # 輕口語：全檔最多 3 次
LIGHT_MAX = 3
# 主 Boss：收編後先揭曉／主線專用嘅嘢，叫囂唔可以講
SPOIL = {
 "zb_eguiking": r"收編|兄弟|填坑|種菜|點解咁香",
 "zb_toyol": r"搬屋|搬咗|冇帶我|白偷|老闆|漢堡",
 "zb_laojiang": r"攰|累|膝|坐唔落|坐不下|人生態度|棺材板",
 "zb_pontianak": r"產房|公司走唔開|公司走不開|電話|老公|好耐，冇咁靜|溫柔|夜班",
}
# 女版覆蓋
RX_GENDER = r"後生仔|打工仔|阿哥|靚仔|兄弟|先生|少爺|小子|小伙子|陳生|他(?!們)"
RX_WORK = r"返工|上班|打工|老細|老闆|人工|工資|加班|通頂|OT|公司|員工|試用期|升職|履歷|PPT|email|同事|寫字樓|辦公"
# 遊戲其他文本（查跨檔撞句）
OTHER = [D("data", "story_v2.json"), D("data", "core.json"), D("data", "quests.json"), D("data", "lang_zh.json")] + \
        [p for p in sorted(glob.glob(D("data", "nat", "*.json"))) if not p.endswith("taunts.json")]

err = []
def E(msg): err.append(msg)

def pairs_of(o, need, where, exact=()):
    out = []
    for k, n in need.items():
        v = o.get(k)
        if not isinstance(v, list): E("%s：冇 %s" % (where, k)); continue
        if (k in exact and len(v) != n) or len(v) < n: E("%s.%s：%d 句（要%s %d）" % (where, k, len(v), "" if k in exact else "至少", n))
        for i, p in enumerate(v):
            if not (isinstance(p, list) and len(p) == 2 and all(isinstance(s, str) and s.strip() for s in p)):
                E("%s.%s[%d]：唔係 [粵, 中]" % (where, k, i)); continue
            out.append(("%s.%s[%d]" % (where, k, i), p))
    nm = o.get("name")
    if not (isinstance(nm, list) and len(nm) == 2 and all(isinstance(s, str) and s for s in nm)): E("%s：name 唔係 [粵, 中]" % where)
    return out

def main():
    T = json.load(open(D("data", "nat", "taunts.json"), encoding="utf-8"))
    Z = json.load(open(D("data", "nat", "zones.json"), encoding="utf-8"))
    FEMJ = json.load(open(D("data", "fem.json"), encoding="utf-8"))
    if T.get("v") != 1: E("v 唔係 1")

    # ---- id 對 zones.json ----
    want_b, want_c = {}, {}
    for ci in ("0", "1", "2", "3", "4", "5"):
        for zz in Z["maps"][ci]["zones"]:
            for b in zz.get("bosses", []): want_b[b["id"]] = ci
            if zz.get("type") == "res": want_c.setdefault(ci, set()).add(zz["id"])
    bs = T.get("bosses", {})
    for b in want_b:
        if b not in bs: E("bosses 缺 %s" % b)
    for b in bs:
        if b not in want_b: E("bosses 多咗 %s（zones.json 冇）" % b)
    cap = T.get("cap", {})
    for ci, ids in want_c.items():
        got = set(cap.get(ci, {}))
        if got != ids: E("cap[%s]：%s，zones.json 係 %s" % (ci, sorted(got), sorted(ids)))
    for ci in cap:
        if ci not in want_c: E("cap 多咗關 %s" % ci)
    raid = T.get("raid", {})
    if set(raid) != set(want_c): E("raid 關 %s，要 %s" % (sorted(raid), sorted(want_c)))

    # ---- 收集句 ----
    allp = []        # (where, owner, [粵, 中])
    for b, o in bs.items():
        for w, p in pairs_of(o, NEED, "bosses." + b, exact=("rematch", "defeat")): allp.append((w, b, p))
    for ci, zs in cap.items():
        for zid, o in zs.items():
            for w, p in pairs_of(o, NEED_CAP, "cap.%s.%s" % (ci, zid)): allp.append((w, "cap%s%s" % (ci, zid), p))
    for ci, v in raid.items():
        if len(v) != RAID_N: E("raid[%s]：%d 句（要 %d）" % (ci, len(v), RAID_N))
        for i, p in enumerate(v):
            if not (isinstance(p, list) and len(p) == 2 and all(isinstance(s, str) and s.strip() for s in p)):
                E("raid[%s][%d]：唔係 [粵, 中]" % (ci, i)); continue
            allp.append(("raid.%s[%d]" % (ci, i), "raid" + ci, p))

    # ---- 長度 ----
    for w, _, (y, z) in allp:
        if len(y) > MAX_YUE: E("%s 粵語 %d 字 > %d：%s" % (w, len(y), MAX_YUE, y))
        if len(z) > MAX_ZH: E("%s 中文 %d 字 > %d：%s" % (w, len(z), MAX_ZH, z))

    # ---- 重複（檔內：每一句粵／中都要獨一無二；同一個王嘅句當然包埋）----
    seen = {}
    for w, _, p in allp:
        for s in p:
            k = re.sub(r"\s", "", s)
            if k in seen: E("重複句：%s（%s／%s）" % (s, seen[k], w))
            else: seen[k] = w
    # 同遊戲其他文本撞句
    other = set()
    def walk(o):
        if isinstance(o, str): other.add(re.sub(r"\s", "", o))
        elif isinstance(o, list):
            for x in o: walk(x)
        elif isinstance(o, dict):
            for k, v in o.items(): other.add(re.sub(r"\s", "", k)); walk(v)
    for fp in OTHER: walk(json.load(open(fp, encoding="utf-8")))
    for k, w in seen.items():
        if k in other: E("同遊戲現有文本撞句：%s（%s）" % (k, w))

    # ---- 紅線 ----
    light = 0
    femv = {SRC.FEM[k] for k in SRC.FEM}
    texts = [(w, o, s) for w, o, p in allp for s in p] + [("fem:" + k, "", v) for k, v in SRC.FEM.items()]
    for w, o, s in texts:
        for cat, rx in RED.items():
            if cat == "性別" and s in femv: continue          # 女版本身可以有「女」（後生女）
            m = re.search(rx, s)
            if m: E("紅線［%s］「%s」：%s（%s）" % (cat, m.group(0), s, w))
        light += len(re.findall(LIGHT, s))
        rx = SPOIL.get(o)
        if rx:
            m = re.search(rx, s)
            if m: E("主 Boss 劇透／主線專用字「%s」：%s（%s）" % (m.group(0), s, w))
    if light > LIGHT_MAX: E("「仆街」用咗 %d 次 > %d" % (light, LIGHT_MAX))

    # ---- 女版覆蓋 ----
    ok_list = set(SRC.FEM_OK)
    nfem = 0
    for w, _, p in allp:
        for s in p:
            m = re.search(RX_GENDER, s) or re.search(RX_WORK, s)
            if not m: continue
            if s in SRC.FEM:
                nfem += 1
                if FEMJ.get(s) != SRC.FEM[s]: E("fem.json 未寫入女版：%s（請跑 tools/taunts_src.py）" % s)
                fv = SRC.FEM[s]
                if re.search(RX_GENDER, fv): E("女版仲有男性稱呼：%s" % fv)
            elif s not in ok_list:
                E("要女版（「%s」）：%s（%s）— 加入 taunts_src.FEM，或者核對後加入 FEM_OK" % (m.group(0), s, w))
    alls = {s for _, _, p in allp for s in p}
    for k in SRC.FEM:
        if k not in alls: E("FEM key 唔係 taunts 句：%s" % k)
    for k in SRC.FEM_OK:
        if k not in alls: E("FEM_OK 句唔係 taunts 句：%s" % k)
    fvals = list(SRC.FEM.values())
    for v in fvals:
        if fvals.count(v) > 1: E("女版句重複：%s" % v)
        if re.sub(r"\s", "", v) in seen or re.sub(r"\s", "", v) in other: E("女版句同現有句撞：%s" % v)
        if len(v) > MAX_ZH: E("女版句太長：%s" % v)

    # ---- 字型缺字 ----
    from fontTools.ttLib import TTFont
    chars = set("".join(s for _, _, s in texts)) | set("".join(n for o in bs.values() for n in o.get("name", []))) \
        | set("".join(n for zs in cap.values() for o in zs.values() for n in o.get("name", [])))
    chars = {c for c in chars if not c.isspace()}
    warn = []
    for fn, must in (("sans_r", True), ("sans_b", False)):
        cmap = TTFont(D("fonts", fn + ".otf")).getBestCmap()
        miss = sorted(c for c in chars if ord(c) not in cmap)
        if miss:
            (E if must else warn.append)("fonts/%s.otf 缺字：%s（換字或者跑 tools/font_subset.py）" % (fn, "".join(miss)))

    # ---- 報告 ----
    nb = sum(1 for w, o, _ in allp if w.startswith("bosses."))
    nc = sum(1 for w, o, _ in allp if w.startswith("cap."))
    nr = sum(1 for w, o, _ in allp if w.startswith("raid."))
    print("王 %d 個：%d 句；資源區 %d 個：%d 句；告急 %d 關：%d 句；共 %d 句（%d 條字串）" % (
        len(bs), nb, sum(len(z) for z in cap.values()), nc, len(raid), nr, len(allp), len(allp) * 2))
    for b, o in bs.items():
        print("  %-16s %-18s lose %d  idle %d  rematch %d  defeat %d" % (b, o["name"][0], len(o["lose"]), len(o["idle"]), len(o["rematch"]), len(o["defeat"])))
    ly = max(len(p[0]) for _, _, p in allp); lz = max(len(p[1]) for _, _, p in allp)
    print("最長：粵 %d 字（上限 %d）、中 %d 字（上限 %d）；女版 %d 條（%d 句需要）；FEM_OK %d 句；「仆街」%d 次" % (
        ly, MAX_YUE, lz, MAX_ZH, len(SRC.FEM), nfem, len(SRC.FEM_OK), light))
    for w in warn: print("提示：", w)
    if err:
        print("有問題（%d）：" % len(err))
        for e in err: print("  ✗", e)
        return 1
    print("OK")
    return 0

if __name__ == "__main__":
    sys.exit(main())
