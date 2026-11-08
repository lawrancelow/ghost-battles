# 專屬招式要用的額外拆件（原圖切出來，不重畫）：用 cutlimb.py 同一套切法，輸出成另外的檔名，不會蓋掉 __arm / __body。
# 用法：python3 cutspirit.py <id> [id...]
# 規格寫在 limbs.json 該角色的 "sp" 底下：{ "<件名>": { "from": 原圖檔名(預設 = id), "body": 拿掉這件之後的身體檔名(選用),
#                                                    shapes / patch / fillfrom / close / holeclip / noinpaint / erase … 跟 cutlimb.py 一樣 } }
# 輸出：cut/<id>__<件名>.png（整張原圖大小、同位置，pack.py 會自動打包），有 body 的話 cut/<id>__<body>.png
import sys, json, os, shutil, importlib.util
P = '/home/claude/gb/art/'
TMP = '/tmp/claude-0/cutspirit/'
spec = json.load(open(P + 'limbs.json'))
sys_argv = sys.argv; sys.argv = [sys_argv[0]]
sp_ = importlib.util.spec_from_file_location('cutlimb', P + 'cutlimb.py'); CL = importlib.util.module_from_spec(sp_); sp_.loader.exec_module(CL)
sys.argv = sys_argv
import numpy as np, cv2
from PIL import Image
def seam(src, bodyp, w):
    # 拆走之後身體露出的切口：沿切口補一條跟原圖一樣的深色描邊（原本被手擋住的那段輪廓線）
    a0 = np.array(Image.open(src).convert('RGBA')); b = np.array(Image.open(bodyp).convert('RGBA'))
    W = b.shape[1]; r = max(2, int(round(w * W)))
    removed = ((a0[:, :, 3] > 128) & (b[:, :, 3] < 60)).astype(np.uint8)
    near = cv2.dilate(removed, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (2 * r + 1, 2 * r + 1)))
    edge = (near > 0) & (b[:, :, 3] > 100)
    dark = (a0[:, :, :3].sum(2) < 160) & (a0[:, :, 3] > 200)
    col = np.median(a0[dark][:, :3], axis=0) if dark.any() else np.array([50, 34, 30])
    rng = np.random.default_rng(3); n = rng.normal(0, 9, b.shape[:2])
    k = cv2.GaussianBlur(edge.astype(np.float32), (3, 3), 0)
    for c in range(3): b[:, :, c] = (b[:, :, c] * (1 - k) + np.clip(col[c] + n, 0, 255) * k).astype(np.uint8)
    Image.fromarray(b).save(bodyp)
def post(src, bodyp, S):
    # clip：身體上再挖掉的形狀（切口改成順的輪廓）；hfill：[y0,y1, x0,x1, sx0,sx1] 被拿走的那段橫條（皮帶、褲子），用旁邊同一條的原圖來回鋪
    a0 = np.array(Image.open(src).convert('RGBA')); b = np.array(Image.open(bodyp).convert('RGBA')); H, W = b.shape[:2]
    for y0, y1, x0, x1, sx0, sx1 in S.get('hfill', []):
        Y0, Y1, X0, X1, S0, S1 = int(y0 * H), int(y1 * H), int(x0 * W), int(x1 * W), int(sx0 * W), int(sx1 * W); L = S1 - S0
        for x in range(X0, X1):
            q = (x - X0) % (2 * L); q = q if q < L else 2 * L - 1 - q; sx = S1 - 1 - q
            col = b[Y0:Y1, x]; src_ = b[Y0:Y1, sx]; m = (a0[Y0:Y1, x, 3] > 60)
            col[m] = src_[m]
    if S.get('clip'): b[:, :, 3] = (b[:, :, 3] * (1 - CL.mask(S['clip'], W, H))).astype(np.uint8)
    Image.fromarray(b).save(bodyp)
for id in sys.argv[1:]:
    for name, S in spec[id].get('sp', {}).items():
        src = S.get('from', id)
        os.makedirs(TMP + 'cut', exist_ok=True)
        shutil.copy(P + f'cut/{src}.png', TMP + f'cut/{id}.png')
        CL.P = TMP; CL.spec = {id: S}
        CL.run(id)
        shutil.copy(TMP + f'cut/{id}__arm.png', P + f'cut/{id}__{name}.png')
        if S.get('body'):
            post(TMP + f'cut/{id}.png', TMP + f'cut/{id}__body.png', S)
            if S.get('seam'): seam(TMP + f'cut/{id}.png', TMP + f'cut/{id}__body.png', S['seam'])
            shutil.copy(TMP + f'cut/{id}__body.png', P + f'cut/{id}__{S["body"]}.png')
        shutil.copy(f'/tmp/claude-0/limb_{id}.png', f'/tmp/claude-0/sp_{id}_{name}.png')
        print('ok', id, name, '<-', src)
