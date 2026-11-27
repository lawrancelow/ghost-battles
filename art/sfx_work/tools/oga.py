import sys,re,subprocess,html
def get(u):
    return subprocess.run(["curl","-s","-m","30",u],capture_output=True,text=True).stdout
def info(slug):
    t=get("https://opengameart.org/content/"+slug)
    lic=re.findall(r'licenses/(cc0|by/[\d.]+|by-sa/[\d.]+|gpl|oga-by)',t,re.I)
    lic2=re.findall(r"class='license-name'>([^<]*)",t)
    files=re.findall(r'href="(https://opengameart.org/sites/default/files/[^"]+)"',t)
    title=re.search(r'<title>([^<]*)',t)
    return (title.group(1) if title else slug), sorted(set(lic2 or lic)), sorted(set(files))
if __name__=="__main__":
    for s in sys.argv[1:]:
        ti,l,f=info(s); print("##",s,"|",ti,"|",l); [print("   ",x) for x in f[:12]]
