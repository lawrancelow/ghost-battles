# prep.sh <commit> <outdir> <version>  : 照 build_beta 嘅做法砌一份匯出用副本
set -e
C=$1; OUT=$2; VER=$3
rm -rf $OUT && mkdir -p $OUT
(cd /home/claude/wt/fix56 && git archive $C godot | tar -x -C $OUT)
[ -d /home/claude/wt/int/godot/.godot ] && cp -r /home/claude/wt/int/godot/.godot $OUT/godot/
cd $OUT/godot
sed -i "s/config\/version=\"[^\"]*\"/config\/version=\"$VER\"/" project.godot
DROP=()
for m in $(grep -v '^#' native/ACTIVE.txt | sed 's/[[:space:]]//g' | grep -v '^$'); do
	[ -f "jsgen/$m.gd" ] || continue
	if grep -q "res://jsgen/$m.gd" "native/$m.gd" 2>/dev/null && ! grep -qx "$m" native/JSGEN_DROP_OK.txt 2>/dev/null; then continue; fi
	DROP+=("jsgen/$m.gd")
done
EXC="tools/*${EXTRA_EXC:+,$EXTRA_EXC}"; for f in "${DROP[@]}"; do EXC="$EXC,$f"; done
python3 - "$EXC" <<'P'
import sys,re
p='export_presets.cfg'; s=open(p).read(); s=re.sub(r'exclude_filter="[^"]*"', 'exclude_filter="%s"' % sys.argv[1], s); open(p,'w').write(s)
P
timeout 900 /opt/godot/Godot_v4.3-stable_linux.x86_64 --headless --path . --import >/dev/null 2>&1 || true
for P in Android Linux; do timeout 900 /opt/godot/Godot_v4.3-stable_linux.x86_64 --headless --path . --export-pack $P $OUT/$P.pck > $OUT/$P.log 2>&1; ls -la $OUT/$P.pck; done
