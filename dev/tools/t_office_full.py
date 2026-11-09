# 回陽間 office full-night QA: sim a night fast, flag stuck/wall/bounds/overlap/no-anim acts,
# screenshot every room + close-ups of each NPC per act, exercise every prop / ghost / phone / ScareOps option.
# usage: python3 tools/t_office_full.py [--calm] [--nobuild]   (out: /tmp/claude-0/qa/)
import sys, os, json, subprocess, shutil
from playwright.sync_api import sync_playwright
O = '/tmp/claude-0/qa/'
CALM = '--calm' in sys.argv
if '--nobuild' not in sys.argv: subprocess.run(['python3', '/home/claude/gb/build.py'], check=True, stdout=subprocess.DEVNULL)
shutil.rmtree(O, ignore_errors=True); os.makedirs(O + 'rooms', exist_ok=True); os.makedirs(O + 'npc', exist_ok=True)
SAMPLE = 1.0   # sim seconds per sample
DT = 1 / 30
STUCK_S, WALL_S, OVER_S = 6, 3, 5
J = lambda pg, s: pg.evaluate(s)

def boot(b):
    pg = b.new_context(viewport={'width': 390, 'height': 844}, device_scale_factor=2).new_page(); errs = []
    pg.on('pageerror', lambda e: errs.append('PAGEERR ' + str(e)))
    pg.on('console', lambda m: errs.append('CONSOLE ' + m.text) if m.type == 'error' else None)
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(1200)
    J(pg, "()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');const S=G.S();S.seen.prologue_sys=1;S.seen.ch1_end=1;S.seen.sc_intro=1;save();Scare.start('office',['afu','tianhua','pontianak'])}")
    for i in range(12):
        J(pg, "()=>{const b=[...document.querySelectorAll('button')].find(b=>b.offsetParent&&/跳過/.test(b.textContent));if(b)b.click();else if(Story.busy()){document.querySelector('#dlg').click()}}"); pg.wait_for_timeout(250)
    pg.wait_for_timeout(800)
    J(pg, "()=>{Scare.paused=false;Scare.follow=false;Scare.camTo=null;Scare.timeScale=0.0001}")  # rAF still draws; sim time only advances via our step()
    return pg, errs

def frame(pg): J(pg, "()=>new Promise(r=>requestAnimationFrame(()=>requestAnimationFrame(r)))")
def cam(pg, x): J(pg, f"()=>{{Scare.follow=false;Scare.camTo=null;Scare.camX=Scare.clampCam(({x})-Scare.viewW()/2)}}")

SAMPLE_JS = """()=>{const S=Scare,OF=typeof OFFICE!=='undefined';return S.npcs.map(n=>{let pose='?',seated=false;try{pose=S.npcPose(n).pose;seated=OF&&OFFICE.seated(n)}catch(e){pose='ERR'}
 return {k:n.d.k,x:n.x,y:n.y,act:n.act,out:!!n.out,gone:!!n.gone,flee:!!n.fleeing,fear:Math.round(n.fear),room:OFFMAP.roomAt(n.x).k,pose,seated,guard:!!n.d.guard,mis:n.d.k==='mis',mact:n.mis?n.mis.act:null,blk:!!(n.step&&!n.step.arrived&&n.act!=='walk'&&!n.wait)}})}"""

def run_night(b):
    pg, errs = boot(b)
    G = J(pg, "()=>({WW:OFFMAP.WW,WALLS:OFFMAP.WALLS.map(v=>[v/1165,(v+OFFMAP.WALLW)/1165]),ROOMS:OFFMAP.ROOMS.map(r=>({k:r.k,cx:r.cx,x0:r.x0,x1:r.x1})),NIGHT:180})")
    log, flags, seen = [], [], {}
    st = {}  # per-npc timers
    over = {}
    room_moments = [5, 90, 170]
    t = 0.0; ended = False
    while t < 182:
        scare = '' if CALM else "if(Math.floor(S.t/15)!==Math.floor((S.t-%f)/15)){const c=S.npcs.filter(n=>!n.gone&&!n.out&&!n.fleeing&&!n.d.guard);if(c.length){S.mana=100;try{S.usePhone(c[Math.floor(S.t)%%c.length])}catch(e){console.error('auto usePhone '+e)}}}" % SAMPLE
        r = J(pg, f"()=>{{const S=Scare;if(!S.active)return 'ended';try{{for(let i=0;i<{int(SAMPLE/DT)};i++){{S.step({DT});if(!S.active)break;}}{scare}}}catch(e){{console.error('step: '+e.stack);return 'err'}}return S.t}}")
        if r == 'ended' or r == 'err': ended = r; break
        t = r; frame(pg)
        snap = J(pg, SAMPLE_JS); log.append({'t': round(t, 1), 'npcs': snap})
        vis = [s for s in snap if not s['out'] and not s['gone']]
        for s in snap:
            k = s['k']; T = st.setdefault(k, {'pos': None, 'still': 0, 'wall': 0, 'blk': 0, 'fl': set()})
            if s['out'] or s['gone']: T['pos'] = None; T['still'] = 0; T['wall'] = 0; continue
            if not (-0.01 <= s['x'] <= G['WW'] + 0.01): flags.append(f"t={t:.0f} {k} OUT OF WORLD x={s['x']:.3f}")
            p = (round(s['x'], 4), round(s['y'], 4))
            if s['act'] == 'walk' and p == T['pos']: T['still'] += SAMPLE
            else: T['still'] = 0
            if T['still'] > STUCK_S and 'stuck' not in T['fl']: T['fl'].add('stuck'); flags.append(f"t={t:.0f} {k} STUCK walking at x={s['x']:.3f} y={s['y']:.3f} room={s['room']} for >{STUCK_S}s")
            if T['still'] <= SAMPLE: T['fl'].discard('stuck')
            T['pos'] = p
            T['blk'] = T['blk'] + SAMPLE if s.get('blk') and p == T.get('bp') else 0; T['bp'] = p
            if T['blk'] > STUCK_S and 'blk' not in T['fl']: T['fl'].add('blk'); flags.append(f"t={t:.0f} {k} FROZEN mid-route (step not arrived, act={s['act']}) at x={s['x']:.3f} room={s['room']} >{STUCK_S}s")
            if not T['blk']: T['fl'].discard('blk')
            inwall = any(a <= s['x'] <= b2 for a, b2 in G['WALLS'])
            T['wall'] = T['wall'] + SAMPLE if inwall and s['act'] != 'walk' else 0
            if T['wall'] > WALL_S and 'wall' not in T['fl']: T['fl'].add('wall'); flags.append(f"t={t:.0f} {k} INSIDE WALL strip x={s['x']:.3f} act={s['act']} >{WALL_S}s")
            if not inwall: T['fl'].discard('wall')
            key = (k, s['act'], s['pose'], s['seated'])
            if key not in seen: seen[key] = {'t': t, **s}
            if s['pose'] == 'ERR': flags.append(f"t={t:.0f} {k} npcPose threw (act={s['act']})")
        for i in range(len(vis)):
            for j in range(i + 1, len(vis)):
                a, c = vis[i], vis[j]; pk = a['k'] + '+' + c['k']
                if abs(a['x'] - c['x']) < 0.04 and abs(a['y'] - c['y']) < 0.03: over[pk] = over.get(pk, 0) + SAMPLE
                else: over[pk] = 0
                if over[pk] == OVER_S + SAMPLE: flags.append(f"t={t:.0f} OVERLAP {pk} at x={a['x']:.3f} ({a['room']}) acts={a['act']}/{c['act']} >{OVER_S}s")
        # close-ups for first sighting of each (npc, act, pose)
        for s in vis:
            key = (s['k'], s['act'], s['pose'], s['seated'])
            if seen[key].get('shot'): continue
            seen[key]['shot'] = closeup(pg, s['k'], f"{s['k']}_{s['act']}_{s['pose']}{'_seat' if s['seated'] else ''}_t{int(t)}")
        if room_moments and t >= room_moments[0]:
            m = room_moments.pop(0)
            for R in G['ROOMS']: cam(pg, R['cx']); frame(pg); pg.screenshot(path=O + f"rooms/t{m:03d}_{R['k']}.png")
    pg.wait_for_timeout(600); pg.screenshot(path=O + 'end_screen.png')
    pg.close()
    return G, log, flags, seen, errs, ended

def closeup(pg, k, name):
    J(pg, f"()=>{{const n=Scare.npcs.find(n=>n.d.k==='{k}');Scare.follow=false;Scare.camTo=null;Scare.camX=Scare.clampCam(n.x-Scare.viewW()/2)}}"); frame(pg)
    r = J(pg, f"""()=>{{const n=Scare.npcs.find(n=>n.d.k==='{k}');const cv=document.querySelector('#sc-cvs')||document.querySelector('#scare canvas');if(!n||!cv||!Scare.active)return null;const R=cv.getBoundingClientRect();
      const [x,y]=Scare.pt(n.vX!=null?n.vX:n.x,n.vY!=null?n.vY:n.y);const h=Scare.hh(n.y);return [R.left+x,R.top+y,h]}}""")
    if not r: return 'nocanvas'
    x, y, h = r; w = max(120, h * 1.6); top = y - h * 1.35; hgt = h * 1.55
    clip = {'x': max(0, x - w / 2), 'y': max(0, top), 'width': min(w, 390 - max(0, x - w / 2)), 'height': min(hgt, 844 - max(0, top))}
    if clip['width'] < 20 or clip['height'] < 20: return 'offscreen'
    p = O + 'npc/' + name + '.png'; pg.screenshot(path=p, clip=clip); return p

def exercise(b):
    pg, errs = boot(b); res = []
    info = J(pg, "()=>({npcs:Scare.npcs.map(n=>n.d.k),props:Object.keys(SCARE_PROPS),team:Scare.team})")
    RESET = "n.fear=0;n.peak=0;n.fleeing=false;n.gone=false;n.out=false;n.rx=null;n.combo=0;S.mana=100;S.pcd={};S._opcd={};for(const q in S.cd)S.cd[q]=0;S.caught={};S.expo=0;S.expelled=false;S.endAt=0;S.alert=false;"
    def call(k, label, body):
        e0 = len(errs)
        r = J(pg, f"""()=>{{const S=Scare,n=S.npcs.find(n=>n.d.k==='{k}');if(!S.active)return 'inactive';{RESET}let toast=null;const ot=S.toast;S.toast=m=>{{toast=m}};
          try{{{body};for(let i=0;i<60;i++)S.step(1/30);}}catch(e){{S.toast=ot;return 'THROW '+e.message}}S.toast=ot;return toast?('toast:'+toast):'ok'}}""")
        frame(pg); e = errs[e0:]
        res.append((k, label, r, e[:2]))
    for k in info['npcs']:
        for p in info['props']:
            call(k, 'prop:' + p, f"const P=SCARE_PROPS['{p}'];if(!P.group&&P.front){{n.x=P.front[0];n.y=P.front[1]}}else if(P.group){{S.camX=S.clampCam(n.x-S.viewW()/2)}};S.sel=n;S.useProp('{p}',n)")
        for g in info['team']: call(k, 'ghost:' + g, f"S.useGhost('{g}',n)")
        call(k, 'phone', "S.usePhone(n)")
        call(k, 'breath', "S.useBreath&&S.useBreath(n)")
        ops = J(pg, f"()=>{{const O=ScareOps.OPS['{k}'];return {{msgs:O&&O.msgs?O.msgs.map(o=>o.id):[],pc:O&&O.pc?O.pc.ops.map(o=>o.id):[],pantry:ScareOps.PANTRY.map(o=>o.id)}}}}")
        for kind, lst in ops.items():
            src = {'msgs': f"ScareOps.OPS['{k}'].msgs", 'pc': f"ScareOps.OPS['{k}'].pc.ops", 'pantry': 'ScareOps.PANTRY'}[kind]
            for oid in lst: call(k, f'op:{kind}:{oid}', f"ScareOps.act(S,n,{src}.find(o=>o.id==='{oid}'),'{'msg' if kind == 'msgs' else kind}')")
        # also open the UI panels once (renders HTML)
        call(k, 'ui:panels', "S.sel=n;S.renderTarget&&S.renderTarget();ScareOps.openPhone(S,n);ScareOps.openPC(S,n);ScareOps.openPantry(S,n);document.querySelectorAll('[data-x]').forEach(b=>b.click())")
    pg.screenshot(path=O + 'after_exercise.png'); pg.close()
    return info, res, errs

with sync_playwright() as p:
    b = p.chromium.launch(executable_path='/usr/bin/google-chrome')
    G, log, flags, seen, nerrs, ended = run_night(b)
    info, res, xerrs = exercise(b)
    b.close()

json.dump({'log': log, 'flags': flags}, open(O + 'night_log.json', 'w'), ensure_ascii=False)
# act coverage: acts that fall back to the generic idle pose (no dedicated animation)
GENERIC = {}
for (k, act, pose, seat), s in seen.items():
    if not seat and not s['mis'] and pose == 'idle' and act not in ('idle',) and not s['guard']:
        GENERIC.setdefault(act, set()).add(k)
print(f"=== NIGHT ({'calm' if CALM else 'with auto phone scare every 15s'}) — sim reached t={log[-1]['t'] if log else 0}s, ended={ended}")
print(f"page/console errors during night: {len(nerrs)}"); [print('  ', e[:220]) for e in dict.fromkeys(nerrs).keys().__iter__() if True][:0]
for e in list(dict.fromkeys(nerrs))[:10]: print('  ', e[:220])
print(f"flags: {len(flags)}"); [print('  ', f) for f in flags[:40]]
print("acts per NPC (act/pose[seat]):")
by = {}
for (k, act, pose, seat) in seen: by.setdefault(k, []).append(f"{act}/{pose}{'*' if seat else ''}")
for k, v in by.items(): print(f"   {k}: {', '.join(sorted(v))}")
print("acts drawn with generic 'idle' pose (no dedicated animation):", {a: sorted(v) for a, v in GENERIC.items()} or 'none')
bad = [r for r in res if r[2].startswith('THROW') or r[3]]
toasts = [r for r in res if r[2].startswith('toast')]
print(f"=== EXERCISE: {len(res)} calls, {len(bad)} with errors, {len(toasts)} refused (toast)")
for r in bad[:30]: print('   ERR', r[0], r[1], r[2], [e[:160] for e in r[3]])
from collections import Counter
tc = Counter((r[1], r[2]) for r in toasts)
for (lab, t), c in sorted(tc.items()): print(f"   refused x{c}: {lab} -> {t[:60]}")
print(f"exercise-run page errors: {len(set(xerrs))}"); [print('  ', e[:220]) for e in list(dict.fromkeys(xerrs))[:8]]
print("shots:", O + 'rooms/', f"({len(os.listdir(O + 'rooms'))})", O + 'npc/', f"({len(os.listdir(O + 'npc'))})")
