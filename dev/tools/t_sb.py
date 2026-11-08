from playwright.sync_api import sync_playwright
ids=['pontianak','shuigui','tianhua','npc_guard','npc_auntie','npc_boss']
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_page(viewport={'width':420,'height':1300},device_scale_factor=1); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    for i in ids:
        pg.goto(f'file:///tmp/claude-0/demo/SpecialB.html?c={i}'); pg.wait_for_timeout(1500)
        cs=pg.query_selector_all('canvas'); cs[-1].screenshot(path=f'/tmp/claude-0/sbx_{i}.png')
    print(errs); b.close()
