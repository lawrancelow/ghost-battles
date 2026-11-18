#!/usr/bin/env python3
"""女版文本（fem.json）掃描＋檢查。
用法：
  python3 tools/fem_scan.py scan [關鍵字正則]   # 列出候選句（file  path  講者  句）
  python3 tools/fem_scan.py check               # 檢查 data/fem.json：每條 key 存在、冇重複
在 godot/ 目錄或任何地方跑都得（路徑以本檔位置計）。唔理 jsgen/。
"""
import json, os, re, sys, glob

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))  # godot/
D = lambda *p: os.path.join(ROOT, *p)
CJK = re.compile(r'[…　-〿㐀-鿿＀-￯]')  # 中文字＋全形標點（「……Bryan。」都要收）

def load(p):
    with open(p, encoding='utf-8') as f: return json.load(f)

def walk(o, path, out, spk=None):
    if isinstance(o, str):
        out.append((path, spk, o)); return
    if isinstance(o, list):
        # [講者, 句] 或 [講者, [粵, 中]]
        if len(o) >= 2 and isinstance(o[0], str) and len(o[0]) <= 12 and (isinstance(o[1], str) or (isinstance(o[1], list) and o[1] and all(isinstance(x, str) for x in o[1]))):
            sp = o[0]
            for i, x in enumerate(o[1:], 1): walk(x, f"{path}[{i}]", out, sp)
            return
        for i, x in enumerate(o): walk(x, f"{path}[{i}]", out, spk)
        return
    if isinstance(o, dict):
        for k, v in o.items():
            if isinstance(k, str) and CJK.search(k): out.append((f"{path}{{key}}", spk, k))
            walk(v, f"{path}.{k}", out, o.get('who') if isinstance(o.get('who'), str) else spk)

def collect():
    """回傳 [(file, path, 講者, 句)]；core.json 同時收原句同 story_v2 subs 替換後嘅句（遊戲實際顯示嘅係替換後）。"""
    out = []
    v2 = load(D('data', 'story_v2.json'))
    subs = v2.get('subs', [])
    def sub(s):
        for a, b in subs: s = s.replace(a, b)
        return s
    files = [D('data', 'story_v2.json'), D('data', 'core.json'), D('data', 'quests.json'), D('data', 'lang_zh.json')] + sorted(glob.glob(D('data', 'nat', '*.json')))
    for fp in files:
        rel = os.path.relpath(fp, ROOT)
        tmp = []
        walk(load(fp), '', tmp)
        for p, s, t in tmp:
            if not CJK.search(t): continue
            out.append((rel, p, s, t))
            if rel == 'data/core.json':
                t2 = sub(t)
                if t2 != t: out.append((rel + '(subs)', p, s, t2))
    lit = re.compile(r'"((?:[^"\\\n]|\\.)*)"')
    for fp in sorted(glob.glob(D('native', '*.gd'))):
        rel = os.path.relpath(fp, ROOT)
        with open(fp, encoding='utf-8') as f:
            for n, line in enumerate(f, 1):
                for m in lit.finditer(line):
                    t = m.group(1)
                    if CJK.search(t):
                        try: t = json.loads('"' + t + '"')
                        except Exception: pass
                        out.append((rel, f"L{n}", None, t))
    return out

DEFAULT_RE = r'隔籬|老細|會議室|生前|返工|上班|打工|公司|八年|十年|員工證|實習生證|report|兒子|個仔|男|三十三|33 歲|阿福哥|陳大福|Kelvin|PPT|寫字樓|辦公|加班|OT|份工|同事|入職|兄弟|他'

def scan(rx):
    r = re.compile(rx)
    seen = set()
    for f, p, s, t in collect():
        if not r.search(t) or t in seen: continue
        seen.add(t)
        print(f"{f}\t{p}\t{s or '-'}\t{t}")

def check():
    fp = D('data', 'fem.json')
    with open(fp, encoding='utf-8') as f: raw = f.read()
    pairs = json.loads(raw, object_pairs_hook=lambda kv: kv)
    keys = [k for k, _ in pairs]
    ok = True
    dupk = {k for k in keys if keys.count(k) > 1}
    if dupk: ok = False; print("重複 key：", dupk)
    vals = [v for _, v in pairs]
    dupv = {v for v in vals if vals.count(v) > 1}
    if dupv: ok = False; print("重複女版句：", dupv)
    allt = {t for _, _, _, t in collect()}
    hit = [k for k in keys if k in allt]
    miss = [k for k in keys if k not in allt]
    same = [k for k, v in pairs if k == v]
    print(f"fem.json 共 {len(keys)} 條；命中 {len(hit)}／{len(keys)}")
    for k in miss: ok = False; print("  搵唔到原句：", k)
    for k in same: ok = False; print("  女版同原句一樣：", k)
    # 女版句唔應該同遊戲現有任何一句撞（避免同一場兩個角色講同一句）
    clash = [v for v in vals if v in allt]
    for v in clash: ok = False; print("  女版句同現有句撞：", v)
    print("OK" if ok else "有問題")
    return 0 if ok else 1

if __name__ == '__main__':
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'scan'
    if cmd == 'check': sys.exit(check())
    scan(sys.argv[2] if len(sys.argv) > 2 else DEFAULT_RE)
