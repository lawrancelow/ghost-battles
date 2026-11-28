G=/home/claude/wt/fix56/godot; SL="bash /home/claude/gbslot.sh"
$SL timeout 900 xvfb-run -a /opt/godot/Godot_v4.3-stable_linux.x86_64 --headless --path $G --import >/dev/null 2>&1
$SL bash /tmp/p56tools/ed56.sh $G p56 res://tools/tests/p56_test.gd logic 900
$SL bash /home/claude/setup/edtest.sh $G fogfix res://tools/tests/fogfix_test.gd logic 900
$SL bash /home/claude/setup/edtest.sh $G paddyfix res://tools/tests/paddyfix_test.gd logic 900
$SL bash /home/claude/setup/edtest.sh $G qaudit res://tools/tests/qaudit_test.gd play 1500
mkdir -p /tmp/meter56; METER_SHOTS=/tmp/meter56/ METER_MIN=24 $SL bash /home/claude/setup/edtest.sh $G meter56 res://tools/tests/meter_test.gd run 1700
echo SUITEDONE
