# 過勞鬼大作戰 — 總交接（2026-11-23 晚，補丁 27 後）

新對話框開工先讀本文件，再讀：
- claude/HC_GhostBattles_SoulCounter_Plan_20261123.md（百鬼克制＋魂魄招降統一方案，下一個大任務）
- claude/HC_GhostBattles_Patch26_Handoff_20261123.md（補丁 25／26 細節）
- claude/HC_GhostBattles_Patch24_Handoff_20261123.md、Patch23、BigUpdate（更早背景）
- repo 內 godot/tools/devkit/session_20261123/LINES.md（多線共用規則＋老闆全部要求，必讀）

---

## 一、線上狀態
- 熱更新 0.10.1 **ver 27**：p_0101_{android,linux}_27.pck，md5 `23fa8aa01bdeec24c0586cabc2660e17`（Pages 已驗證）。
- GitHub：lawrancelow/ghost-battles
  - `revamp-p1` @ fb0f43b = 源碼（整合版 integ25 ＋ 交接備份）
  - `main` @ ed9c59f = 發佈庫（godot-update/ 熱更新檔＋version.json，GitHub Pages）
- 底包：APK 0.10.1（base manifest tools/devkit/base_0101；/tmp/apk101/Linux.pck 由 APK 還原，devkit base_from_apk.sh）。

## 二、今天做完的（補丁 23→27）
- 23：效能、操作、三個地標、兵營、襲擊。
- 24：顧客只買村子有的貨、兵器檔、遊魂兵（民兵）、野外重平衡。
- 25：戰鬥全面改地圖半即時（game/rts）、野外出擊（game/sortie：消耗資源、首勝獎、極稀有＋保底、重生）、分圈擴展野外地圖（tiles）、東南西北四方向出路、陣型。
- 26：地圖戰鬥用夜班巡陰同一套攻擊特效（game/fxkit）；任務審查：野外王任務自動補「（先打低 XX 頭目）」、去掉舊「營地」字眼、招魂台／倉庫／鬼宅任務字補途徑。
- 27：第 5 關敵人血攻 ×0.55、第 6 關 ×0.5（rts.gd `_soften`／SOFT 表）；修 rts_sim「你追我走」（1-1 交戰 31→18.8 秒）；ctl、zone 舊測試修好；新測試 qaudit_test 由新開檔只用玩家操作一路通到 6-3（49/49）。
- 驗證（27）：selftest 34/34；全程 291 秒 0 錯誤；26→27 升級正常；rts 67、sortie 45、mapx 130、ctl 52、zone 328、zstory 615、storyhook 339、landmark 278、pace 74、qaudit audit 49，全部 bad=0、SCRIPT_ERR=0。

## 三、等老闆／測試員（太太）試玩回饋
1. 第 5、6 關打折後可能偏易（測試每場一次贏）。
2. 第 1 關「派 1 隻鬼打工」會把唯一的小紙調離出陣，之後打餓鬼王必輸 → 建議加提示（未做）。
3. 地圖戰鬥某些陣容弱過舊引擎（陰兵小隊幾秒死光、名鬼兩翼被圍）；今次只用打折頂住，根本原因未修（統一方案第 4 節會修）。
4. 練嚇功到 Lv2 約 29 分鐘，新手任務偏長。
5. 新介面無地方揀「軍師」，但戰鬥仍有軍師加成。
6. 陣型接觸後變一團；主角跨圈行走繞經村子；蒸壽包任務條帶去包子鋪而不是蒸籠。

## 四、下一個任務（老闆 17:06 指定；統一方案見 claude/HC_GhostBattles_SoulCounter_Plan_20261123.md）
**百鬼克制＋魂魄招降系統**
- 名鬼至少 100 種，每隻能力不同；對手形形色色，不同對手有克制；要不斷換配搭才打得最好，不能練幾隻就通關（要耐玩）。
- 除少數大魔王外，所有對手都可招降：重複打掉「魂魄」（碎片），存夠到祭壇召喚／祭煉突破。
- 2026-11-23 19:35–20:24：五線頭腦風暴完成（研究／能力／克制／魂魄／名冊），合併成統一方案 v1；老闆 20:24 定案新鬼：狐狸精改稱「狐妖」、天狗保留、Bajang 保留（只取鬼本身）、Sundel Bolong 去掉（Teke Teke 頂上）。
- 各線原稿在容器 /home/claude/bs/（research／ability／counter／soul／roster.md，模擬腳本 counter_tool、soul_sim）；容器重建會丟，要重跑頭腦風暴前先查 Project 方案。
- 修正工期：約 3 天，分 3 階段（可玩第一版約 1.5 天 → 補滿百鬼約 1 天 → 平衡上線約 0.5 天），每階段出一個熱更新。

## 五、環境與流程（新容器要重建）
- repo：clone revamp-p1 到 /home/claude/ghost-battles；main 分支 worktree 到 /home/claude/wt/main（發佈用）。
- 腳本備份：godot/tools/devkit/session_20261123/（gbrun.sh、edtest.sh、prep.sh、mkpatch.sh、st25.sh、upg25.sh）＋ devkit 原有 env.sh、build_and_selftest.sh 等。路徑寫死 /home/claude/...、/tmp/...，重建時照原路徑放（腳本複製到 /home/claude/setup/）。
- Godot 4.3（/opt/godot/Godot_v4.3-stable_linux.x86_64＋export templates 4.3.stable，可由 GitHub releases 直接下載）。
- 新 worktree 一定要先 `--import`（或複製 .godot＋*.import），否則海量 SCRIPT ERROR。
- 測試：`bash edtest.sh <godotdir> <tag> res://tools/tests/x.gd <func> <秒>`（flock 排隊）；達標＝RESULT bad=0 且 SCRIPT_ERR=0。其他開 Godot 指令包 gbrun.sh。機器只有 2 核。
- 打包上線：
  1. `prep.sh <commit> /tmp/new11 0.10.1`
  2. `st25.sh`（改 PT 路徑；selftest 34＋全程「[full] done」0 錯誤）
  3. 先複製 wt/main/godot-update 到 /tmp/srvNN（舊版，給升級測試）
  4. `mkpatch.sh /tmp/apk101 0.10.1 <n>`
  5. `upg25.sh`（改 srv 路徑；8822 舊／8823 新；看 state.json ver＝新號、selftest 34、SE 0）
  6. commit＋push main（`git -c push.negotiate=true push`）和 revamp-p1
  7. curl Pages 的 version.json 和 pck 核 md5
  8. 寫交接到 Project
- 熱更新硬限制：不可新增 class_name／autoload，不可改 project.godot；新腳本用 preload。

## 六、出圖
- ChatGPT Plus 在 Chrome「Browser 1」（deviceId 45b51715-db70-4796-b097-d71539e554c6），對話「Generate Crayon Map Art」；用 JS 疊層＋放大存圖，Python/scipy 切。Browser 2 是免費帳號（額度用完）。
- 不可覆蓋 ChatGPT 新對話框裡另一工作流的草稿。所有生成必須可商用；RunningHub 用 RH 幣。

## 七、老闆工作規則（必守）
- **★ 第一條（2026-11-23 20:26，最高優先）：不要因為老闆說話就擅自停掉任何任務。** 老闆提問、發意見、插話時，所有線和背景任務照跑；誤停了立刻重開續做。
- 回覆一律中文大白話。
- 全部由我們做，老闆不用自己動手；最大化多線並行。
- 老闆對某一項提意見時，其他線照跑不准停；被提到的項目商定後自動繼續。
- 線被系統中斷就直接重開續做，不問老闆。
- 長任務跑完要主動通知老闆，不要等他問；老闆催時要給實際時間並收窄範圍。
- 紅線：不碰宗教、真實品牌、兒童做目標、種族／國家／性別；不用 AI 重畫老闆原有角色；不提交 keystore；不碰 commit 2253435。
