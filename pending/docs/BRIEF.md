# 頭腦風暴共用簡報：過勞鬼大作戰「百鬼克制＋魂魄招降系統」

## 老闆原話要求（17:06／19:35）
- 名鬼至少 100 種，每隻能力不同；對手形形色色，不同對手有克制關係；要不斷換配搭才能打得最好，不能練幾隻就通關（要耐玩）。
- 除少數大魔王外，所有對手都可招降：重複打他們掉「魂魄」（碎片），存夠魂魄到祭壇召喚／祭煉突破。
- 19:35：「這些東西網絡上應該不缺，也不是什麼新穎的概念。我希望你和團隊盡可能完整、完善、縝密地安排。」→ 要參考業界成熟做法（數值、坑、玩家體驗），但最終要有我們自己的特色，不可照搬某一款遊戲的核心循環換皮。

## 遊戲背景
- Godot 4.3 手機直屏遊戲。主角阿福（過勞死打工仔）在陰間經營村子（收貨、商店、大排檔、兵營），派陰兵＋遊魂兵＋名鬼出村，在地圖上半即時自動戰鬥（game/rts/），不細控每隻兵，名鬼技能是地圖上的小按鈕。
- 野外：每關以村為中心分 3～4 圈據點，野外出擊（game/sortie/）會消耗資源，可重複打，首勝特殊獎勵，極稀有掉落＋保底。另有主線關卡（6 章）、野外王、資源區、惡鬼襲擾。
- 風格：黑色幽默、港式粵語對白、多元文化民俗鬼怪（中國、馬來 Pocong 等、日本等）。
- 紅線：不碰宗教、真實品牌、兒童做目標、種族／國家／性別；不用 AI 重畫老闆原有角色。
- 熱更新限制：不可新增 class_name／autoload，不可改 project.godot；新腳本用 preload。存檔新欄位讀取一律 .get(key, 預設)。

## 現有數據（詳細見 /home/claude/bs/data_dump.txt）
- data/core.json：GHOSTS 73（阿福＋72 名鬼，全部有圖；欄位只有 name/title/q/base[3]/range/trait，trait 只是文字；69 近戰 4 遠程）；SKILLS 82（hit 57/aoe 24/heal 1；apply: down 腳軟/push 嚇退/air 嚇彈起）；ENEMY_T 78（[血倍率, 攻倍率, 名字]）；COMBOS 2。
- repo：/home/claude/ghost-battles/godot（只讀，不要改、不要 commit）。重要檔：game/rts/rts_sim.gd、rts.gd、game/sortie/、data/nat/zones.json、ui/main.gd、game/game.gd、tools/devkit/session_20261123/*.md（rts_design、sortie_design、militia_design）、STORY_BIBLE.md。
- 交接：/home/claude/bs/HANDOFF.md

## 輸出要求
- 全部用中文寫，寫入 /home/claude/bs/<你的線名>.md。要具體：數字、表格、公式、名單、檔案與函數名，不要空話。
- 列出：設計、理由（引用業界例子和數據來源 URL）、風險與對策、和其他線的接口、未決問題（給出預設建議值）。
- 不要改 repo 任何檔案。
