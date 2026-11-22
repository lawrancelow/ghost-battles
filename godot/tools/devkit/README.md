# devkit（開發／打包工具，tools/ 唔會入包）

原本放喺容器 /home/claude/setup 同 /tmp，新對話容器會冇，所以抄一份入 repo。新環境用法：

1. `bash godot/tools/devkit/env.sh`：裝 Godot 4.3、匯出模板、Android SDK。
2. `mkdir -p /home/claude/setup && cp godot/tools/devkit/* /home/claude/setup/`：腳本入面寫死咗 /home/claude/setup 路徑。
3. 底包 0.10.1 manifest 喺 base_0101/（android.json、linux.json）。mkpatch.sh 要 /tmp/apk101/{Android,Linux}.pck，同 manifest 擺埋一齊。
   - pck 由老闆手上嘅 GhostBattles_v0.10.1.apk 抽：APK 入面嘅 assets/*.pck。Linux.pck 同 Android.pck 內容一樣，可以直接複製一份。
   - 如果冇 pck，可以修改 mkpatch.sh，跳過 `pck.py manifest` 嗰行，直接用 base_0101 入面嘅 json 做 diff。
4. prep.sh 會由 /home/claude/gbgd/godot/.godot 抄匯入快取；冇嘅話，刪咗嗰行 cp，等 --import 自己重做（慢啲）。
5. run_all_suites.sh 跑全套 23 組測試；build_and_selftest.sh 打包、跑自檢、跑一條龍（要先改 commit 同 /tmp/vNN）；update_test.sh 跑升級實測。
6. repro/：用大禮包存檔碼新開局，自動過名字卡同開場（GB_TEST=t.json）。

## 2026-11-22 補充（補丁 18–22 期間用過、原本只喺 /tmp 嘅工具）
- `st16.sh`：打包版自檢 34 項＋一條龍（改入面 PT=/tmp/vNN；背景跑 timeout 要 ≥1800 秒）。
- `perf/p.gd`：效能量度，逐個畫面層隱藏，比較每格耗時（GB_TEST gdrun 用，見 probe/run.sh 寫法）。
- `probe/p.gd`＋`run.sh`：新開局實測劇情／任務節奏，記錄每段劇情、提示、任務欄，並截圖。
- `hero/h.gd`、`x.gd`＋`run.sh`、`runx.sh`：主角／小紙／名冊截圖（runx.sh 設 XF=1 試女主）。
- `shots/`：各關分區截圖腳本（e.gd＋rune.sh，BS_CH 揀關）。
- `art/stitch.py`：AI 地面圖拼接（切黑邊、inpaint 地圖外暗帶、羽化貼返、還原地圖外暗區）；`cutsheet*.py`：道具表切圖。
- `art/yinbing_prompt.txt`：陰兵三款造型生圖提示（未送出）。
- 注意：上面腳本入面嘅路徑寫死 /tmp/…，用之前抄去對應位置或者改路徑。
- 大禮包存檔碼 `/tmp/gift/GiftSave_Player1.txt`（repro、gift_test 用）**唔喺 repo**：容器重開後已經冇咗，要老闆再提供。
