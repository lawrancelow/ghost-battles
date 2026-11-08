# 把分段傳回的 Ci 片段接成一個 grab.py 可讀的檔案
import json, re, sys, glob
out = sys.argv[1]; files = sys.argv[2:]
parts = {}
for f in files:
    t = ''.join(x.get('text', '') for x in json.load(open(f)))
    for m in re.finditer(r'C(\d+)START([A-Za-z0-9+/=]*)C\1END', t): parts[int(m.group(1))] = m.group(2)
n = max(parts) + 1; assert all(i in parts for i in range(n)), sorted(parts)
json.dump([{'type': 'text', 'text': 'B64START' + ''.join(parts[i] for i in range(n)) + 'B64END'}], open(out, 'w'))
print('joined', n, 'chunks')
