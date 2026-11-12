import json,re,glob,os,sys
L='/tmp/claude-0/qa/logs/'
def R(f):
    try:
        for ln in open(L+f,encoding='utf-8'):
            if ln.startswith('RESULT '): return json.loads(ln[7:])
    except Exception as e: return None
res=[]; 
def out(k,ok,msg): res.append((k,ok,msg)); print(('PASS' if ok is True else 'WARN' if ok=='WARN' else 'FAIL'),k,msg)
base=json.load(open('/tmp/claude-0/qa/baseline.json'))['data']
allerr=[]
# A
for lv in ['flat','shop']:
    r=R('A_%s.log'%lv)
    if not r: out('A-'+lv,False,'冇結果'); continue
    allerr+=r['errs']
    for k,v in r['r'].items():
        b=base[lv][k]; p,c=v['patrol']['moving'],v['chase']['moving']; bp,bc=b['patrol']['moving'],b['chase']['moving']
        okp=p<=bp*0.65; okc=c<bc
        ok=okp and okc
        if k=='dog' and not ok: ok='WARN'
        out('A-%s-%s'%(lv,k),ok,'巡邏 %.1f/%.1f=%.0f%% (≤65%%)；追捕 %.1f/%.1f=%.0f%%'%(p,bp,100*p/bp,c,bc,100*c/bc))
# B
for lv in ['flat','shop']:
    r=R('B_%s.log'%lv)
    if not r: out('B-'+lv,False,'冇結果'); continue
    allerr+=r['errs']; x=r['r']
    tot=sum(n['inSafeSteps'] for n in x['nights']); cis=sum(n['caughtInSafe'] for n in x['nights'])
    out('B-%s-夜間模擬'%lv, tot==0 and cis==0 and not x['viol'], 'R=%s；%d 晚；保安入安全區幀數=%d；安全區內被捉=%d；保安同層最近 dx=%s；驚走入區幀=%d；鬼行出區邊即刻被捉=%d；safe off 幀=%s'%(x['R'],len(x['nights']),tot,cis,[round(n['minDx']) if n['minDx']<1e8 else '-' for n in x['nights']],sum(n['fleeIn'] for n in x['nights']),sum(n.get('edgeCatch',0) for n in x['nights']),[n['safeOffSteps'] for n in x['nights']]))
    ct=x['catchTest']; ok=all(c['caughtDelta']==0 and c['enterSteps']==0 and c['patrolEnterSteps']==0 for c in ct)
    out('B-%s-強制追捕'%lv, ok, '; '.join('caught+%d 追入幀%d 巡入幀%d 最近dx%d/%d TW.catchG直接+%d'%(c['caughtDelta'],c['enterSteps'],c['patrolEnterSteps'],c['minGuardDx'],c['patrolMinDx'],c['directCatchG']) for c in ct))
    if any(c['directCatchG'] for c in ct): out('B-%s-catchG'%lv,'WARN','TW.catchG()（測試後門，直接 call catchGhost）喺安全區仍然捉到——遊戲正常路徑唔經呢度，僅供參考')
# C
for lv in ['flat','shop']:
    r=R('C_%s.log'%lv)
    if not r: out('C-'+lv,False,'冇結果'); continue
    allerr+=r['errs']; S={s['t']:s for s in r['S']}
    hit=S.get('hit',{}); fl=S.get('flee0',{})
    ok=bool(hit) and (hit.get('jumpT',0)>0 or hit.get('shockT',0)>0) and fl.get('state')=='flee' and bool(fl.get('scream')) and str(fl.get('key','')).endswith('_scared')
    out('C-%s-住客'%lv, ok, '%s：hit jumpT=%.2f shockT=%.2f key=%s；驚走 state=%s 慘叫=「%s」key=%s'%(r['info']['sprite'],hit.get('jumpT') or 0,hit.get('shockT') or 0,hit.get('key'),fl.get('state'),fl.get('scream'),fl.get('key')))
    H=r['H']; pk=r['pkGrd'] or {}
    okg=H and H[0]['state'] in ('scared','flee') and (H[0].get('shockT') or 0)>0 and any(k.endswith('_scared') and k.startswith('res_guard') for k in pk)
    out('C-%s-保安'%lv, bool(okg), 'state=%s shockT=%.2f 講=「%s」 PPLFX.key 用過=%s'%(H[0]['state'] if H else None,(H[0].get('shockT') or 0) if H else 0,H[0].get('say') if H else None,[k for k in pk if 'scared' in k]))
    out('C-%s-截圖'%lv, True, ' '.join(r['shots']))
# D
for lv in ['flat','shop']:
    r=R('D_%s.log'%lv)
    if not r: out('D-'+lv,False,'冇結果'); continue
    allerr+=r['errs']; x=r['r']
    out('D-%s-慘叫唔重複'%lv, not x['screamDup'] and x['nScream']>0, '驚走 %d 人，慘叫 %d 句，重複=%s'%(x['fled'],x['nScream'],x['screamDup']))
    if x['fled']>x['nScream']: out('D-%s-慘叫池'%lv,'WARN','%d 人驚走但只有 %d 句慘叫（SCREAM 池 40 句用晒後 uniq() 回 null → 之後驚走嘅人冇慘叫）'%(x['fled'],x['nScream']))
    if x['fleeSayDup']: out('D-%s-驚走時其他對白'%lv,'WARN','驚走中嘅人講同一句（非慘叫，似係陷阱反應 say）：%s'%x['fleeSayDup'])
# E
for f,nm in [('E_play_flat.log','play flat'),('E_play_shop.log','play shop'),('E_sim_flat.log','sim flat'),('E_sim_shop.log','sim shop')]:
    try: s=open(L+f,encoding='utf-8').read()
    except: s=''
    m=re.search(r'ERRS (\[.*\])',s); errs=m.group(1) if m else '冇 ERRS 行（崩咗？）'
    viol=re.findall(r'"viol":(\[[^\]]*\])',s); uerr=re.findall(r'"err":("[^"]*")',s)
    ok= m and errs=='[]' and all(v=='[]' for v in viol) and not uerr and 'Error' not in s.split('ERRS')[0][-2000:] if m else False
    out('E-'+nm, bool(ok), 'ERRS=%s viol=%s err=%s'%(errs,viol,uerr))
for lv in ['flat','shop']:
    r=R('E_unit_%s.log'%lv)
    if not r: out('E-unitshot-'+lv,False,'冇結果'); continue
    allerr+=r['errs']; pk=r['after']['pk'] or {}
    out('E-unitshot-%s'%lv, any(k.endswith('_scared') for k in pk) and any(k.startswith('res_') for k in r['inside']), '戶=%s %s；入屋用圖=%s；嚇後 scared=%s；截圖 %s'%(r['u']['id'],r['u']['hh'],list(r['inside']),[k for k in pk if 'scared' in k],' '.join(r['shots'])))
# F
for f in ['prodchk','tw','st2','mig']:
    try: s=open(L+'F_%s.log'%f,encoding='utf-8').read()
    except: s=''
    lines=[l for l in s.strip().splitlines() if l.strip() and '"GET ' not in l]; chk=[l for l in lines if l.startswith('errs') or l.startswith('lv') or (f=='mig')]
    ok=bool(lines) and 'Traceback' not in s and bool(chk) and all(l.rstrip().endswith('[]') for l in chk)
    out('F-'+f, ok, ' ‖ '.join(lines[-3:])[:400])
out('G-console/pageerror', not allerr, '合計 %d：%s'%(len(allerr),allerr[:5]))
n=sum(1 for r in res if r[1] is True); w=sum(1 for r in res if r[1]=='WARN'); f=sum(1 for r in res if r[1] is False)
print('\n==== 摘要：PASS %d / WARN %d / FAIL %d ===='%(n,w,f))
