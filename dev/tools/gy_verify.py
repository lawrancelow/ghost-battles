#!/usr/bin/env python3
# 亂葬崗・無名墳 獨立驗證器
# 只看「玩家看得到的字」：墓碑卡（姓名、生卒、生前、碑文、祭品、位置）＋每個魂說的話。
# 用自己的正則把每句話反解成條件，自己算方位，再暴力列舉所有擺法：必須剛好一種、且等於遊戲的答案。
import json, re, subprocess, sys, itertools, collections, os
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PER = int(sys.argv[1]) if len(sys.argv) > 1 else 2000
JS = r'''
const fs=require('fs');const src=fs.readFileSync(process.argv[1],'utf8');
const {GY_GEN}=new Function(src+'\nreturn {GY_GEN};')();
const per=+process.argv[2], out=[];
for (const [lv,night] of [[1,1],[2,3],[3,5],[4,8]]) for (let i=0;i<per;i++){
  const seed=(lv*1000003+i*7919+12345)>>>0, p=GY_GEN.gen(night + (i%2 && lv<4 ? 1 : 0), seed);
  out.push({lv:p.level, night:p.night, graves:p.graves.map(GY_GEN.card), souls:p.souls.map(s=>({tag:s.tag, lines:s.lines})), answer:p.souls.map(s=>s.grave)});
}
process.stdout.write(JSON.stringify(out));
'''
data = json.loads(subprocess.check_output(['node', '-e', JS, os.path.join(ROOT, 'src/graveyard.js'), str(PER)]))

# ---- 方位：直接由背景座標算（不抄遊戲裡的 row/side） ----
XY = {'A': (0.25, 0.375), 'B': (0.76, 0.37), 'C': (0.52, 0.475), 'D': (0.24, 0.585), 'E': (0.76, 0.58)}
TREE = (0.12, 0.72)   # 石牌坊
def row(s): y = XY[s][1]; return 0 if y < 0.42 else 1 if y < 0.53 else 2
def side(s): x = XY[s][0]; return 0 if x < 0.40 else 1 if x < 0.62 else 2
dist = {s: ((XY[s][0]-TREE[0])**2 + (XY[s][1]-TREE[1])**2) ** .5 for s in XY}
near = sorted(dist, key=dist.get)
assert near[0] == 'D' and dist[near[1]] > 1.8 * dist['D'], dist   # 牌坊旁邊那座 = A，而且差距明顯
# 同一排／同一側的高低左右差異要小到肉眼看不出（不會有人以為 A 比 B 高）
for a in XY:
    for b in XY:
        if row(a) == row(b): assert abs(XY[a][1]-XY[b][1]) < 0.02
        if side(a) == side(b): assert abs(XY[a][0]-XY[b][0]) < 0.04
        if row(a) != row(b): assert abs(XY[a][1]-XY[b][1]) > 0.09   # 梯田分層，畫面上一眼分得出
        if side(a) != side(b): assert abs(XY[a][0]-XY[b][0]) > 0.20

TAG = '①②③④⑤'
DEC = {'二': 2, '三': 3, '四': 4, '五': 5, '六': 6, '七': 7, '八': 8}
ROWW = {'上排': 0, '正中間那座': 1, '下排': 2}
SIDEW = {'左側': 0, '右側': 2}
J = '([①②③④⑤])'
P = [  # (regex, kind)
    (r'我生前是(.+)。', 'job_is'), (r'每天上班、下班……我是(.+)。', 'job_is'),
    (r'我生前不是(.+)。', 'job_not'), (r'我沒做過(.+)。', 'job_not'),
    (J + r'生前不是(.+)。', 'ojob_not'), (J + r'沒做過(.+)。', 'ojob_not'),
    (r'我的墳前，有人放了(.+)。', 'off_is'), (r'我記得墳前放著(.+)。', 'off_is'),
    (r'我的墳前放的不是(.+)。', 'off_not'),
    (r'碑文我只記得『(.+)』。', 'quote'), (r'我的碑文裡有『(.+)』。', 'quote'),
    (r'我的碑文裡沒有『(.+)』。', 'quote_not'),
    (r'我走的時候([二三四五六七八])十幾歲。', 'age'),
    (r'我姓(.)。', 'surname'),
    (r'我睡在(上排|下排|正中間那座)。', 'row_is'), (r'我不是睡在(上排|下排|正中間那座)。', 'row_not'),
    (r'我睡在(左側|右側)。', 'side_is'), (r'我不是睡在(左側|右側)。', 'side_not'),
    (r'我睡在牌坊旁邊那座。', 'tree'), (r'我不是睡在牌坊旁邊那座。', 'tree_not'),
    (r'我的墳在' + J + r'的墳(上面|下面|左邊|右邊)。', 'rel'),
    (r'我和' + J + r'睡在同一排。', 'same_row'),
    (r'我比' + J + r'(早走|晚走)。', 'died'),
]
def parse(line):
    hits = [(k, m) for rx, k in P for m in [re.fullmatch(rx, line)] if m]
    # 「我睡在牌坊旁邊那座」不會被 row/side 吃掉；但「我生前不是」與「我沒做過」等不會重疊，這裡要求唯一
    kinds = {k for k, _ in hits}
    assert len(kinds) == 1, (line, kinds)
    return hits[0]

stats = collections.defaultdict(collections.Counter)
for P_ in data:
    lv, G, souls, ans = P_['lv'], P_['graves'], P_['souls'], P_['answer']
    n, g = len(souls), len(G)
    st = stats[lv]; st['puzzles'] += 1
    assert (n, g) == {1: (3, 3), 2: (4, 4), 3: (4, 5), 4: (5, 5)}[lv]
    # 墓碑卡本身
    cards = []
    for c in G:
        b, d = map(int, re.fullmatch(r'(\d{4}) – (\d{4})', c['years']).groups())
        age = d - b
        assert 2 <= age % 10 <= 8, c   # 實歲 age-1、虛歲 age+1 都在同一個十位
        assert 20 <= age < 90
        cards.append(dict(c, birth=b, death=d, age=age))
    for f in ('name', 'job', 'ep', 'off', 'spot'):
        assert len({c[f] for c in cards}) == g, (f, cards)
    assert len({c['name'][0] for c in cards}) == g
    ds = sorted(c['death'] for c in cards); assert all(y - x >= 2 for x, y in zip(ds, ds[1:]))
    # 句子
    allines = [l for s in souls for l in s['lines']]
    assert len(allines) == len(set(allines)), allines           # 同一晚沒有兩句一樣
    preds = []; sem = set()
    for i, s in enumerate(souls):
        assert s['tag'] == TAG[i] and 2 <= len(s['lines']) <= 3, s
        for line in s['lines']:
            k, m = parse(line); st['k_' + k] += 1; st['lines'] += 1
            a = m.groups()
            # 換個說法、換個人講，也算同一件事：先化成「事實」再比
            if k in ('job_is', 'job_not'): fact = ('job', i, a[0])
            elif k == 'ojob_not': fact = ('job', TAG.index(a[0]), a[1])
            elif k == 'same_row': fact = ('row=',) + tuple(sorted((i, TAG.index(a[0]))))
            elif k == 'died': o_ = TAG.index(a[0]); fact = ('died', i, o_) if a[1] == '早走' else ('died', o_, i)
            elif k == 'rel':
                o_ = TAG.index(a[0]); fact = {'上面': ('above', i, o_), '下面': ('above', o_, i), '左邊': ('leftof', i, o_), '右邊': ('leftof', o_, i)}[a[1]]
            else: fact = (k, i) + a
            assert fact not in sem, ('兩個魂講同一件事', line); sem.add(fact)
            jj = None
            if k in ('ojob_not', 'rel', 'same_row', 'died'):
                jj = TAG.index(a[0]); assert jj < n and jj != i, line   # 不提不存在的魂、不提自己
            # 不可能的引用：提到的職業／祭品／碑文字句，一定出現在今晚某座碑上
            if k in ('job_is', 'job_not'): assert any(c['job'] == a[0] for c in cards), line
            if k == 'ojob_not': assert any(c['job'] == a[1] for c in cards), line
            if k in ('off_is', 'off_not'): assert any(c['off'] == a[0] for c in cards), line
            if k in ('quote', 'quote_not'): assert any(a[0] in c['ep'] for c in cards), line
            if k in ('tree', 'tree_not'): assert any(c['spot'] == near[0] for c in cards), line
            if k in ('row_is', 'row_not'): assert any(row(c['spot']) == ROWW[a[0]] for c in cards), line
            if k in ('side_is', 'side_not'): assert any(side(c['spot']) == SIDEW[a[0]] for c in cards), line
            def f(me, o, k=k, a=a):
                if k == 'job_is': return me['job'] == a[0]
                if k == 'job_not': return me['job'] != a[0]
                if k == 'ojob_not': return o['job'] != a[1]
                if k == 'off_is': return me['off'] == a[0]
                if k == 'off_not': return me['off'] != a[0]
                if k == 'quote': return a[0] in me['ep']
                if k == 'quote_not': return a[0] not in me['ep']
                if k == 'age': return me['age'] // 10 == DEC[a[0]]
                if k == 'surname': return me['name'][0] == a[0]
                if k == 'row_is': return row(me['spot']) == ROWW[a[0]]
                if k == 'row_not': return row(me['spot']) != ROWW[a[0]]
                if k == 'side_is': return side(me['spot']) == SIDEW[a[0]]
                if k == 'side_not': return side(me['spot']) != SIDEW[a[0]]
                if k == 'tree': return me['spot'] == near[0]
                if k == 'tree_not': return me['spot'] != near[0]
                if k == 'rel':
                    return {'上面': row(me['spot']) < row(o['spot']), '下面': row(me['spot']) > row(o['spot']),
                            '左邊': side(me['spot']) < side(o['spot']), '右邊': side(me['spot']) > side(o['spot'])}[a[1]]
                if k == 'same_row': return row(me['spot']) == row(o['spot'])
                if k == 'died': return me['death'] < o['death'] if a[1] == '早走' else me['death'] > o['death']
            preds.append((i, jj, f, line))
    # 暴力列舉所有單射擺法
    sols = []
    for perm in itertools.permutations(range(g), n):
        if all(f(cards[perm[i]], cards[perm[jj]] if jj is not None else None) for i, jj, f, _ in preds): sols.append(perm)
    assert len(sols) == 1, (len(sols), P_)
    assert list(sols[0]) == ans, (sols, ans)
    # 每句都有用：單看這句，一定能排除某些擺法（沒有廢話）
    for i, jj, f, line in preds:
        ok = [f(cards[a], cards[b] if jj is not None else None) for a in range(g) for b in (range(g) if jj is not None else [0]) if jj is None or a != b]
        assert not all(ok), line
    # 沒有任何多餘的魂可以被兩種位置滿足（同上已涵蓋）；記錄難度
    direct = sum(1 for i, jj, f, _ in preds if jj is None and sum(f(c, None) for c in cards) == 1)
    st['direct'] += direct; st['maxdirect'] = max(st['maxdirect'], direct)
    st['rel_lines'] += sum(1 for p in preds if p[1] is not None)
    st['decoy'] += g - n
    # 「N 個正確」提示的計算：任何其他擺法的正確數 < n
    for perm in itertools.permutations(range(g), n):
        k = sum(1 for i in range(n) if perm[i] == ans[i])
        assert (k == n) == (list(perm) == ans)

print('驗證通過（每一關 %d 晚）' % PER)
for lv in sorted(stats):
    st = stats[lv]; N = st['puzzles']
    kinds = ', '.join('%s %d' % (k[2:], v) for k, v in sorted(st.items(), key=lambda x: -x[1]) if k.startswith('k_'))
    print(f"L{lv}: {N} 晚，唯一解 {N}/{N}；平均每晚 {st['lines']/N:.2f} 句、直接指認句 {st['direct']/N:.2f}（最多 {st['maxdirect']}）、魂與魂關係句 {st['rel_lines']/N:.2f}、空墳 {st['decoy']//N}")
    print('   句型分佈：' + kinds)
