PT=/tmp/edt/hero; rm -rf $PT; mkdir -p $PT/x
echo '[["wait",3],["gdrun","/tmp/hero/h.gd","all"],["quit"]]' > $PT/t.json
cd /home/claude/ghost-battles/godot && env BS_OUT=/tmp/hero/shots XDG_DATA_HOME=$PT/x GB_UPDATE_URL=http://127.0.0.1:8799/none.json GB_TEST=$PT/t.json timeout 200 xvfb-run -a -s '-screen 0 450x975x24' /opt/godot/Godot_v4.3-stable_linux.x86_64 --path . --rendering-driver opengl3 --resolution 450x975 > $PT/log 2>&1
echo "err=$(grep -c 'SCRIPT ERROR' $PT/log)"; grep -E '\[hero\]|SCRIPT ERROR' -A2 $PT/log | head
cd /tmp/hero/shots && python3 -c "
from PIL import Image
import glob
fs=sorted(glob.glob('*.png')); ims=[Image.open(f).convert('RGB') for f in fs]
W=Image.new('RGB',(460*len(ims),975))
for i,im in enumerate(ims): W.paste(im,(460*i,0))
W.save('/tmp/hero/sheet.jpg',quality=82); print(fs)"
