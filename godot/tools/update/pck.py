#!/usr/bin/env python3
# Godot 4 .pck 讀取工具：列出檔案＋md5（做「基礎清單」）、抽出指定檔案（做補丁）
import struct, sys, json, os, hashlib

def read_index(path):
    f = open(path, 'rb')
    magic, ver, vmaj, vmin, vpat, flags, file_base = struct.unpack('<IIIIIIQ', f.read(32))
    assert magic == 0x43504447, 'not a pck'
    f.read(16 * 4)
    rel = flags & 2
    n, = struct.unpack('<I', f.read(4))
    out = []
    for _ in range(n):
        ln, = struct.unpack('<I', f.read(4))
        p = f.read(ln).rstrip(b'\0').decode('utf-8')
        off, size = struct.unpack('<QQ', f.read(16))
        md5 = f.read(16).hex()
        fl, = struct.unpack('<I', f.read(4))
        out.append({'path': p, 'off': off + file_base, 'size': size, 'md5': md5})
    return f, out

# 呢啲唔可以／唔應該熱更新
SKIP = ('res://project.binary', 'res://.godot/global_script_class_cache.cfg', 'res://.godot/uid_cache.bin')

if __name__ == '__main__':
    cmd = sys.argv[1]
    if cmd == 'manifest':          # pck.py manifest game.pck out.json
        f, idx = read_index(sys.argv[2])
        json.dump({e['path']: e['md5'] for e in idx}, open(sys.argv[3], 'w'), indent=0, sort_keys=True)
        print(len(idx), 'files')
    elif cmd == 'diff':            # pck.py diff new.pck base_manifest.json outdir  → 抽出有改動嘅檔案
        f, idx = read_index(sys.argv[2])
        base = json.load(open(sys.argv[3]))
        outdir = sys.argv[4]; os.makedirs(outdir, exist_ok=True)
        lst = []; bad = []
        for e in idx:
            if e['path'] in SKIP or base.get(e['path']) == e['md5']: continue
            if e['path'] not in base and e['path'].endswith('.gdc'):
                pass
            f.seek(e['off']); data = f.read(e['size'])
            rel = e['path'][6:]
            dst = os.path.join(outdir, rel); os.makedirs(os.path.dirname(dst), exist_ok=True)
            open(dst, 'wb').write(data)
            lst.append([e['path'], dst])
        json.dump(lst, open(os.path.join(outdir, '_list.json'), 'w'))
        print(len(lst), 'changed files', sum(os.path.getsize(d) for _, d in lst), 'bytes')
        for p, _ in lst[:40]: print('  ', p)
