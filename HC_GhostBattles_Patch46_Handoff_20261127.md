# 過勞鬼大作戰 補丁 46 交接：新標題畫面＋設置功能（2026-11-27）

## 一、線上狀態
- 0.10.1 底包＋補丁 **46**：p_0101_{android,linux}_46.pck，md5 af99b91eef9a8ec0a753f32d007cb1c1，104,479,072 bytes（2492 檔）。
- 源碼：分支 `title-settings`／`p46`（以補丁 46 上線內容為準）；之後新工作由 p46 開分支。
- worktree：/home/claude/wt/title（title-settings）、/home/claude/wt/main（只放 godot-update）。美術組工作區 /home/claude/ghost-battles（art-title），程序組唔好喺嗰度打包。

## 二、今次做咗乜
### 標題畫面（ui/title/title_view.gd，main._show_title 改用佢）
- 封面 cover2（V3「凌晨三點辦公室」），慢推鏡、飄霧、鬼火粒子（安全畫面模式唔出粒子／模糊）、Logo 輕浮動、按鈕依次淡入、主按鈕輕擺。
- Logo：title_logo（B 款降飽和蠟筆）。按鈕：btn_new2／btn_cont2（黃牌紅毛筆「加班」）。底部「設置」「導入網頁版存檔」並排；右下版本號。
- 無存檔只出「開始新遊戲」；有存檔出「繼續遊戲」＋「開始新遊戲」（再撳一次確定刪檔，照舊）。
- 素材讀取次序：cover2→cover；title_logo；btn_main（未採用，代碼已關）→btn_new2/btn_cont2→btn_new/btn_cont。`tex()` 先查檔存在，唔喺包就回 null。
- 直屏：封面闊度鋪滿靠頂，下面漸變接底色（唔見硬邊）。
- 橫屏（PC）：有 cover2_wide 就鋪滿，Logo＋按鈕擺左欄（唔遮主角），左邊壓暗；冇就 cover2 高度鋪滿置中＋兩邊模糊延伸＋羽化，Logo 左上、按鈕右下。
- 開機畫面（launch.gd，只用引擎類）同 main._boot_js 載入畫面：同樣優先 cover2＋title_logo，直屏／橫屏自適應。launch.gd 改動要下次開遊戲先生效（佢自己喺更新前載入）。
- 橫屏縮放：視窗闊過高時 root.content_scale_aspect 改 EXPAND（原本 keep_width 喺 1920×1080 只得 390×219 邏輯尺寸）；直屏照舊 keep_width。launch.gd 同 prefs.watch_orient 都有做。

### 設置功能（game/settings/prefs.gd＋ui/settings/settings_panel.gd）
- 存 user://settings.cfg 嘅 [prefs] 段（裝置設定，唔跟存檔碼走；同段檔 ui/dialogue_lang 共存）。
- 五頁：
  - 聲音：聲音開關（Snd.toggle）、總音量、音樂、音效、語音。新增 Music／SFX／Voice 音軌；Snd 的 _mus/_bed/_bed2→Music、_sfx/_f43p→SFX、story_vox→Voice。
  - 畫面：流暢模式、幀率上限 30/60（流暢模式開時鎖 30；perf_mode 關時改用設置幀率，唔再係 0 無上限）、螢幕常亮、安全畫面模式；PC 專屬（PF.is_pc()：pc 且非 mobile/web）：顯示模式（視窗／全螢幕／無邊框）、解析度（1280×720／1600×900／1920×1080）、垂直同步。未揀過解析度唔會郁視窗。
  - 劇情：對白語言中文／粵語、文字速度慢／中／快／即時、自動播放（等語音播完＋按字數等，WhatsApp 模式唔自動）。
  - 存檔：備份存檔碼、導入存檔碼、重新開始（二次確認；無存檔時停用）。
  - 支援：版本與更新狀態、製作、錯誤記錄、全面自檢。
- 面板：闊螢幕置中、最大闊 600；Esc／Android 返回鍵關閉。
- 入口：標題畫面「設置」、遊戲頂欄右上「設置」（取代「聲／靜」）、劇情回顧頁（main.open_story、menus.gd）一粒「設置」掣（取代原本散落嘅語言、存檔碼、安全畫面、流暢模式、自檢、錯誤記錄、刪檔；改名、恢復備份、看手機保留）。

## 三、測試
- 專項 tools/tests/settings_test.gd：logic 16/16、ui 32/32（450×975）、wide 14/14（1920×1080，用 /home/claude/setup/title/edtest_wide.sh）。
- 打包版自檢 34/34、0 腳本錯誤；打包版一條龍 full_run 完成（done）、0 腳本錯誤。
- 回歸：perf 33/0、away bryan 18/0、run_all_suites 22 組除 gift（缺老闆存檔碼）外全 0 失敗。
- 注意：容器 CPU 慢，full_run 要 timeout ≥3300 秒，唔好同其他測試同時跑；timeout 殺進程時會出一堆假 SCRIPT ERROR（typeof() 不存在、Unreferenced static string），唔係代碼問題。

## 四、⚠ 補丁大小上限（重要）
- GitHub 單檔上限 100MiB（104,857,600 bytes）。補丁係對 0.10.1 底包嘅累積差異，45 已經 103MB；46 加新封面後 105.4MB，推 main 被 pre-receive hook 拒。
- 今次做法：cover2_wide（PC 專用 1920×1080 橫版封面）**唔入手機補丁**（prep.sh 支援 `EXTRA_EXC="assets/spr/cover2_wide.webp"`），補丁 104.48MB，只剩約 0.37MB 空位。
- mkpatch.sh 已加檢查：超過 100MiB 即停。
- **下一個補丁幾乎一定會超**。要喺之前決定：(a) 出新底包（新 APK，補丁歸零）；或 (b) 改 launch.gd 支援分包下載（多個 pck 逐個 load_resource_pack），但 launch.gd 要裝咗一次之後先生效，所以要喺一個未超標嘅補丁先帶出去；或 (c) 補丁改放 GitHub Release 資產（上限 2GB，但要確認倉庫私有／公開問題）。
- PC（Steam）版會係獨立完整包，cover2_wide 到時直接入包。

## 五、腳本
- /home/claude/setup/title/：prep.sh、mkpatch.sh、st16.sh、run_all_suites.sh、edtest_wide.sh、reg.sh（路徑改為 wt/title）。repo 內 godot/tools/devkit 的 prep.sh／mkpatch.sh 已同步 EXTRA_EXC 同大小檢查。
- 底包 pck 冇（/tmp/apk101 只放 base_0101 的 android.json／linux.json），mkpatch 直接用 json diff；update_test（升級實測）需要底包 pck，今次冇跑。

## 六、待辦
1. 補丁大小問題（見第四節），下次出補丁前要處理。
2. 美術組 btn_main／btn_sub／ico_gear 素材未採用（老闆揀咗加班按鈕＋程序畫小按鈕）。
3. 遊戲內其他畫面（村子、戰鬥等）未做橫屏版面；PC 版要另外規劃。
4. 舊待辦照 Patch45_Full_Handoff。
