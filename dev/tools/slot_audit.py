# 陽間站崗・槽位審核圖：讀 src/street.js 嘅 DATA4（房＋走廊）＋ SITES，
# 每間房畫：背景圖、牆位（紫）／路位（橙）槽框＋編號、路點同路線（黃）、碰撞框（s 實體紅／w 牆邊橙／p 水氹藍／e 電線黃／x 封路洋紅）、props（虛線）
# 另外做自動檢查（路位離路線太遠、牆位壓住路、槽壓住實體障礙、槽重疊、槽出界），寫入 audit_auto.json 俾人睇圖時對照。
# 用法：python3 tools/slot_audit.py [輸出資料夾，預設 /tmp/claude-0/out]
import re, json, sys, os, io, base64, math
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = sys.argv[1] if len(sys.argv) > 1 else '/tmp/claude-0/out'
os.makedirs(OUT, exist_ok=True)
S = open(os.path.join(ROOT, 'src/street.js'), encoding='utf8').read()
A = open(os.path.join(ROOT, 'src/assets.js'), encoding='utf8').read()
D = json.loads(re.search(r'const DATA4 = (\{.*?\});\n', S).group(1))
SITE_IDX = {k: int(v) for k, v in re.findall(r"(\w+):(\d)", re.search(r'const SITE_IDX = \{([^}]*)\}', S).group(1))}
SITES = [(m.group(1), re.findall(r"'(\w+)'", m.group(2))) for m in re.finditer(r"\{ id:'(\w+)'.*?long:\[([^\]]*)\]", re.search(r'const SITES = \[(.*?)\n  \];', S, re.S).group(1))]
RK = 2
CELL = 150 / 1080 / RK            # 槽闊（佔房闊比例）
CW = 0.9                           # 走廊闊（房闊倍數）
FONT = ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc', 22)
FONTS = ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc', 16)
OBS_COL = {'s': (255, 60, 60), 'w': (255, 160, 40), 'p': (70, 150, 255), 'e': (255, 230, 40), 'x': (255, 60, 220)}
IMW = 900


def bg_img(key):
    m = re.search(r'"%s"\s*:\s*"data:image/\w+;base64,([^"]+)"' % re.escape(key), A)
    if not m:
        return None
    return Image.open(io.BytesIO(base64.b64decode(m.group(1)))).convert('RGB')


def seg_dist(p, a, b):
    ax, ay, bx, by = a[0], a[1] * 1.5, b[0], b[1] * 1.5  # 遊戲 dist() 將 y×1.5（畫面高≈1.5×闊）
    px, py = p[0], p[1] * 1.5
    dx, dy = bx - ax, by - ay
    t = 0 if dx == dy == 0 else max(0, min(1, ((px - ax) * dx + (py - ay) * dy) / (dx * dx + dy * dy)))
    return math.hypot(px - ax - t * dx, py - ay - t * dy)


def slot_rect(p, xs=1.0):
    w = CELL * (2 if p.get('s') == 2 and not p.get('d') else 1) / xs
    h = CELL * (2 if p.get('s') == 2 and p.get('d') else 1) / 1.5
    return [p['x'] - w / 2, p['y'] - h / 2, p['x'] + w / 2, p['y'] + h / 2]


def inter(a, b):
    return max(0, min(a[2], b[2]) - max(a[0], b[0])) * max(0, min(a[3], b[3]) - max(a[1], b[1]))


def seg_hit(A, B, o):
    for i in range(21):
        x = A[0] + (B[0] - A[0]) * i / 20; y = A[1] + (B[1] - A[1]) * i / 20
        if o['x0'] < x < o['x1'] and o['y0'] < y < o['y1']:
            return True
    return False


def live_edges(R, nodes, edges):
    # 照 longLay：雪糕筒／跌落招牌（t='x'）封咗嘅分叉，有其他路就剪走；再由入口 E（或走廊 i2）行得到嘅先算
    obs = [o for o in R.get('obs', []) + R.get('props', []) if o['t'] == 'x']
    E2 = {}
    for a, bs in edges.items():
        keep = [b for b in bs if not any(a in nodes and b in nodes and seg_hit(nodes[a], nodes[b], o) for o in obs)]
        E2[a] = keep if keep and len(keep) < len(bs) else list(bs)
    start = 'E' if 'E' in nodes else 'i2'; seen = {start}; st = [start]
    while st:
        a = st.pop()
        for b in E2.get(a, []):
            if b not in seen:
                seen.add(b); st.append(b)
    return {a: [b for b in bs if b in nodes] for a, bs in E2.items() if a in seen}


def auto_check(R, nodes, edges, xs=1.0):
    le = live_edges(R, nodes, edges)
    segs = [(nodes[a], nodes[b]) for a in le for b in le[a] if a in nodes and b in nodes]
    obs = R.get('obs', []) + R.get('props', [])
    out = []
    for i, p in enumerate(R['posts']):
        r = slot_rect(p, xs); area = (r[2] - r[0]) * (r[3] - r[1]); dmin = min(seg_dist((p['x'], p['y']), a, b) for a, b in segs)
        if p['h'] == 0 and dmin > 0.035:  # 0.035 房闊 ≈ 75px（半格）：路線要穿過槽格先算喺路上
            out.append((i, f'路位離最近路線 {dmin:.3f}（> 0.035，約 {dmin*2160:.0f}px）：路線冇穿過槽'))
        if p['h'] == 1 and dmin < 0.035:
            out.append((i, f'牆位離路線只有 {dmin:.3f}：壓住行人路'))
        for o in obs:
            ov = inter(r, [o['x0'], o['y0'], o['x1'], o['y1']]) / area
            if o['t'] == 's' and ov > 0.3:
                out.append((i, f'槽有 {ov:.0%} 壓住實體障礙 {o["k"]}'))
        for j, q in enumerate(R['posts']):
            if j > i and inter(r, slot_rect(q, xs)) / area > 0.15:
                out.append((i, f'同槽 {j} 重疊'))
        if r[0] < 0 or r[2] > 1 or r[1] < 0 or r[3] > 1:
            out.append((i, '槽出界'))
    return out


def render(img, R, nodes, edges, title, xs=1.0):
    W, H = img.size
    img = img.convert('RGBA'); ov = Image.new('RGBA', img.size, (0, 0, 0, 0)); d = ImageDraw.Draw(ov)
    X = lambda x: x * W; Y = lambda y: y * H
    for o in R.get('obs', []) + R.get('props', []):
        c = OBS_COL.get(o['t'], (200, 200, 200)); box = [X(o['x0']), Y(o['y0']), X(o['x1']), Y(o['y1'])]
        if o in R.get('props', []):
            d.rectangle(box, fill=c + (40,))
            for k in range(0, 4):  # 虛線框＝props
                pass
            d.rectangle(box, outline=c + (255,), width=2)
            d.line([box[0], box[1], box[2], box[3]], fill=c + (160,), width=1)
        else:
            d.rectangle(box, fill=c + (55,), outline=c + (255,), width=3)
        d.text((box[0] + 3, box[1] + 1), o['k'] + ('*' if o in R.get('props', []) else ''), font=FONTS, fill=c + (255,), stroke_width=2, stroke_fill=(0, 0, 0, 255))
    le = live_edges(R, nodes, edges)
    for a in edges:
        for b in edges[a]:
            if a in nodes and b in nodes:
                ok = b in le.get(a, [])
                d.line([X(nodes[a][0]), Y(nodes[a][1]), X(nodes[b][0]), Y(nodes[b][1])], fill=(255, 240, 60, 230) if ok else (255, 40, 40, 200), width=4 if ok else 2)  # 紅幼線＝被封／行唔到嘅路
    for k, (x, y) in nodes.items():
        d.ellipse([X(x) - 5, Y(y) - 5, X(x) + 5, Y(y) + 5], fill=(255, 240, 60, 255), outline=(0, 0, 0, 255))
        d.text((X(x) + 6, Y(y) - 8), k, font=FONTS, fill=(255, 255, 160, 255), stroke_width=2, stroke_fill=(0, 0, 0, 255))
    for i, p in enumerate(R['posts']):
        r = slot_rect(p, xs); col = (190, 110, 255) if p['h'] else (255, 150, 50)
        d.rectangle([X(r[0]), Y(r[1]), X(r[2]), Y(r[3])], fill=col + (110,), outline=(255, 255, 255, 255), width=3)
        d.text((X(r[0]) + 3, Y(r[1]) - 1), f"{i}{'牆' if p['h'] else '路'}", font=FONT, fill=(255, 255, 255, 255), stroke_width=3, stroke_fill=(0, 0, 0, 255))
        d.text((X(r[0]), Y(r[3]) + 1), f"{p.get('n','')} ({p['x']:.3f},{p['y']:.3f})", font=FONTS, fill=col + (255,), stroke_width=2, stroke_fill=(0, 0, 0, 255))
    img = Image.alpha_composite(img, ov); d = ImageDraw.Draw(img)
    d.rectangle([0, 0, W, 34], fill=(0, 0, 0, 200)); d.text((8, 4), title, font=FONT, fill=(255, 255, 255, 255))
    # 網格（0.1）方便讀座標
    for k in range(1, 10):
        d.line([X(k / 10), 34, X(k / 10), H], fill=(255, 255, 255, 40)); d.line([0, Y(k / 10), W, Y(k / 10)], fill=(255, 255, 255, 40))
        d.text((X(k / 10) + 2, 36), f'{k/10:.1f}', font=FONTS, fill=(255, 255, 255, 140)); d.text((2, Y(k / 10) + 1), f'{k/10:.1f}', font=FONTS, fill=(255, 255, 255, 140))
    return img.convert('RGB')


def corr_bg(W, H, C):
    # 走廊係程序畫：上下牆帶 0–0.18、0.82–1，中間地磚
    im = Image.new('RGB', (W, H), (70, 70, 64)); d = ImageDraw.Draw(im)
    d.rectangle([0, 0, W, 0.18 * H], fill=(45, 45, 42)); d.rectangle([0, 0.82 * H, W, H], fill=(45, 45, 42))
    d.text((W / 2 - 30, 0.08 * H), '上牆', font=FONT, fill=(150, 150, 140)); d.text((W / 2 - 30, 0.9 * H), '下牆', font=FONT, fill=(150, 150, 140))
    return im


report = {}
for sid, rooms in SITES:
    for r, rk in enumerate(rooms):
        R = D['rooms'][rk]; im = bg_img(R['bg'])
        if im is None:
            print('冇背景', rk, R['bg']); im = Image.new('RGB', (768, 1024), (40, 40, 40))
        im = im.resize((IMW, round(IMW * im.size[1] / im.size[0])))
        title = f"{sid} / 第{r+1}間 {rk}「{R['n'][0]}」 bg={R['bg']}"
        render(im, R, R['nodes'], R['edges'], title).save(os.path.join(OUT, f'audit_{sid}_{rk}.png'))
        report[f'{sid}/{rk}'] = auto_check(R, R['nodes'], R['edges'])
        # 房後走廊
        C = D['corr'][(SITE_IDX.get(sid, 0) + r) % len(D['corr'])]
        nodes = dict(C['nodes']); nodes['i2'] = [0.10, R['nodes']['X'][1]]
        nx = rooms[r + 1] if r + 1 < len(rooms) else None
        nodes['o2'] = [0.95, D['rooms'][nx]['nodes']['E'][1] if nx and D['rooms'][nx]['nodes']['E'][0] == 0 else 0.5]
        edges = dict(C['edges']); edges['i2'] = ['j']; edges['k'] = ['o2']
        CR = dict(C); CR['props'] = []
        cw_ = IMW; ch_ = round(IMW / CW * 1024 / 768)  # 走廊闊 = 0.9 房闊，高同房一樣
        title = f"{sid} / 第{r+1}間後走廊「{C['n'][0]}」（程序畫，x 佔走廊闊）"
        render(corr_bg(cw_, ch_, C), CR, nodes, edges, title, xs=CW).save(os.path.join(OUT, f'audit_{sid}_c{r+1}.png'))
        report[f'{sid}/c{r+1}'] = auto_check(CR, nodes, edges, xs=CW)
json.dump(report, open(os.path.join(OUT, 'audit_auto.json'), 'w'), ensure_ascii=False, indent=1)
for k, v in report.items():
    for i, s in v:
        print(k, i, s)
print('done', OUT)
