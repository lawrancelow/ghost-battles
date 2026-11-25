# mkp.sh <base.pck> <newdir(有 Linux.pck 同 godot/)> <ver> <outdir>
set -e
B=$1; ND=$2; V=$3; O=$4; PK=/home/claude/ghost-battles/godot/tools/update/pck.py; G=/opt/godot/Godot_v4.3-stable_linux.x86_64
mkdir -p $O; if [ "$B" = none ]; then echo "{}" > /tmp/upgtools/base.json; else python3 $PK manifest $B /tmp/upgtools/base.json >/dev/null; fi
rm -rf /tmp/upgtools/d$V; python3 $PK diff $ND/Linux.pck /tmp/upgtools/base.json /tmp/upgtools/d$V >/dev/null
cd $ND/godot && $G --headless -s /home/claude/ghost-battles/godot/tools/update/make_pck.gd -- /tmp/upgtools/d$V/_list.json $O/p_0101_linux_$V.pck >/dev/null 2>&1
python3 - $O $V <<'P'
import json,hashlib,os,sys
o,v=sys.argv[1],int(sys.argv[2]); fn="p_0101_linux_%d.pck"%v; d=open(os.path.join(o,fn),'rb').read()
json.dump({"base":{"0.10.1":{"linux":{"ver":v,"file":fn,"md5":hashlib.md5(d).hexdigest(),"size":len(d)}}}},open(os.path.join(o,"version.json"),"w"))
print(fn,len(d))
P
