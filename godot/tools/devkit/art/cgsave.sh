# cgsave.sh <name> <leftpng> <rightpng>
D=/home/claude/ghost-battles/dev/art_wip_cg/cg23
python3 /home/claude/ghost-battles/dev/art_wip_cg/stitch.py "$2" "$3" $D/$1_full.png /home/claude/ghost-battles/godot/assets/spr/$1.webp
