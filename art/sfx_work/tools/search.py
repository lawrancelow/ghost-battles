import sys,re,subprocess
from oga import info
seen=set()
for kw in sys.argv[1:]:
    t=subprocess.run(["curl","-s","-m","30",f"https://opengameart.org/art-search-advanced?keys={kw}&field_art_type_tid%5B%5D=13&sort_by=count&sort_order=DESC&items_per_page=24"],capture_output=True,text=True).stdout
    for s in sorted(set(re.findall(r'href="/content/([^"/]+)"',t))):
        if s in seen or s=="faq": continue
        seen.add(s)
        ti,l,f=info(s)
        if any("CC0" in x for x in l):
            print(f"{kw}\t{s}\t{ti.split('|')[0].strip()}\t{len(f)}\t"+" ".join(f[:4]))
