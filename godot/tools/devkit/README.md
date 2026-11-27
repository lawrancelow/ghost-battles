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

## 2026-11-25 補丁 35：更新唔使重開（開機畫面大進度條）
- 主場景 res://main.tscn 改為開機畫面（ui/launch.gd）；遊戲主畫面搬去 res://ui/main_game.tscn（節點名照舊 Main）。
- 10 個 autoload（DB、Spr、MeshAnim、Limbs、Art、G、Tst、JSRun、Snd、QX）嘅檔案變成空殼，真正代碼喺 `*_impl.gd`
  （例：core/db.gd → core/db_impl.gd）。**以後改 autoload 代碼要改 *_impl.gd**，外殼檔唔好加任何嘢。
- 流程：開機畫面查 version.json → 有新補丁即場下載（進度、MB、速度、斷線自動續傳兩次）→ 分幀校驗 md5 → load_resource_pack
  → 將 *_impl.gd 掛上 autoload 節點（同引擎開機一樣次序：先全部 set_script，再逐個入樹行 _ready）→ 載入 main_game.tscn
  → main.gd 載模塊時繼續推同一條進度條（GBLoad 節點：handoff/prog/finish/hide_now）→ 標題畫面。
- 原理：更新前只載入咗 Boot（底包）、10 個空殼、launch.gd，所以裝完新補丁再載入嘅全部都係新版代碼。
  autoload 喺分析器眼中只係 Node（成員存取變「不安全存取」，照行）；所以唔好寫 `var x := Spr.get_tex(...)` 呢類由 autoload 推斷型別（會報錯），用 `var x: Texture2D = ...`。
- launch.gd 只可以用引擎類，唔好用 UIKit／J 等 class_name，唔好 preload 遊戲檔；佢自己改咗要下次開機先生效，介面（handoff/prog/text/finish/hide_now/ver_label）要保持。
- 同底包 Boot 分工：開機畫面一開始將 state.json 嘅 ver 寫做好大（Boot 背景檢查就當已是最新），查完寫返真版本；真版本另記 lv。冇網時即刻寫返，Boot 背景更新照做後備。
- 由舊版（補丁 34 或之前）升上 35：舊 Boot 背景落 35，仍然要重開一次；35 之後每次更新都唔使重開。
- 測試：GB_LAUNCH_SHOTS=<目錄> 開機畫面每秒截圖。升級實測腳本（限速／續傳／壞檔伺服器）寫喺交接文件。

## 2026-11-27 底包 0.10.2（新安裝包，補丁歸零重新累積）
- 原因：0.10.1 補丁累積到 46 已 104.5MB，撞 GitHub 單檔 100MiB 上限。0.10.2 底包＝補丁 46 全部內容（連 cover2_wide），之後補丁只算對 0.10.2 嘅改動。
- 版本：project.godot config/version＝0.10.2，Android version/code＝32（0.10.1 係 31）。分支 base0102。
- 底包 manifest：`base_0102/android.json`、`linux.json`（由 0.10.2 打包版 pck 生成，4454 檔）。
- 出 0.10.2 補丁：`prep.sh <commit> /tmp/new12 0.10.2` → `NEW=/tmp/new12 mkpatch.sh <repo>/godot/tools/devkit/base_0102 0.10.2 <號>`（目錄冇 pck 就直接用 json diff）。補丁號沿用 47、48…（Boot／launch 只比較同一底包內嘅 ver，換底包自動清舊補丁）。
- version.json：0.10.1 條目（ver 46）**唔好郁**，舊機照拎 46；0.10.2 未有補丁時唔使加條目（launch.gd 搵唔到條目＝已是最新）。
- **簽名**：Android 覆蓋安裝一定要用 0.10.1 同一把簽名：舊容器 `~/.local/share/godot/keystores/debug.keystore`（SHA-256 bb26b868…），11-19 已備份去老闆 Mac `~/Downloads/GhostBattles_debug.keystore`。新容器 env.sh 會生一把新 debug.keystore，**唔可以用嚟出畀老闆裝嘅 APK**（簽名唔同要先卸載，存檔會冇）。拎到原 keystore 後：放 ~/keys/gb_debug.keystore，editor_settings 嘅 debug_keystore 指去佢（user androiddebugkey／pass android，如不符再問），再 `--export-debug Android`。出完用 `apksigner verify --print-certs` 核對 SHA-256 開頭係 bb26b868。**唔好 commit keystore。**
