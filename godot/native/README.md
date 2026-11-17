# 原生改寫（規則層）做法

目標：網頁版 61 個模塊逐個改寫成原生 GDScript，取代 `jsgen/` 自動轉譯版。

## 機制
- `js/jsrun.gd` `load_modules`：`res://native/<模塊>.gd` 存在就載入佢，唔載 `jsgen/<模塊>.gd`。
- 原生模塊介面同轉譯版一樣：`extends RefCounted`，`func run(_env)` 入面設返同一批全局（`J.G["GP"] = {...}`），有 `window` 就 `J.sp(window, 名, 物件)`。
- 對外物件係 Dictionary：函數值係 `func(_this, a: Array)`（同轉譯版 Callable 簽名一樣，其他未改寫嘅模塊照叫得到）；常數／資料照放。
- 模塊載入時嘅副作用（加 `<style>`、建 DOM、setTimeout 開機、掛 window 事件）要照做。
- 存檔格式唔變（`J.G.S`）。
- `GB_NONAT=1` 全部用轉譯版；`GB_NONAT_<模塊>=1` 單一模塊用轉譯版（對照用）。

## 寫法
- 範本：`native/gpower.gd`。內部邏輯用有型別嘅 static func；同其他模塊互動先用 `J.G.get(...)`、`J.mc`、`J.gp`、`J.num`、`J.str`、`J.t`。
- 內部函數（JS 閉包私有函數）直接寫做 static func，唔好再經 J。
- 數值、隨機數用法、字串（粵語原句＋中文）要同 JS 原碼一模一樣。原碼：`/home/claude/gb/src/<模塊>.js`；轉譯前補丁：`tools/jsgd/patches.js`（補丁效果都要保留，例如 `__nat_*` 交俾原生）。
- 唔好改 `jsgen/`；唔好改其他線嘅模塊。共用檔（bridge.gd、patches.js、main.gd）要改就喺 `/tmp/git.lock` 入面改完即刻提交。

## 驗證（每個模塊都要）
1. 對照：`tools/tests/native_xcheck.gd` 加 `func <模塊>(_t)`（`load_trans` 載轉譯版），同一狀態逐函數比輸出（`check(...)`），會改 S 嘅函數用 `S` 深拷貝各跑一次比結果。要 `bad=0`。
2. 實玩：用舊存檔（`/tmp/claude-0/save_code.txt`）入相關玩法截圖，0 個 SCRIPT ERROR。
3. 全面自檢（`GB_SELFTEST=1`）34 項全過先提交。
- 測試喺自己嘅副本（`/tmp/<線>/godot`，複製 `.godot` 快取），Godot 一次只開一個：`flock /tmp/godot.lock`。
- 提交：`flock /tmp/git.lock` 入面 `git add` 自己嘅檔即刻 commit。

## 啟用名單（重要）
- 只有列喺 `native/ACTIVE.txt` 嘅模塊先會生效；寫緊、未驗證嘅檔可以放喺 `native/`，唔會影響其他線。
- 測試自己寫緊嘅模塊：`GB_NAT_EXTRA=mod1,mod2`（逗號分隔）臨時加入。
- 驗證完（對照 bad=0、實玩截圖、自檢 34 項）：喺 git lock 入面把模塊名加入 ACTIVE.txt 同埋 commit 你嘅檔。
- 純資料模塊統一用 `native/_datamod.gd`（`data/nat/<模塊>.json`，工具 `tools/tests/dump_datamod.gd`）。
- 測試副本：唔好喺副本刪檔（會要權限），用 GB_NAT_EXTRA 揀要測嘅模塊就得。

## 測試唔使刪資料夾（避免要權限）
每次要乾淨用戶資料：喺自己測試副本嘅 project.godot `[application]` 加（每次換個新名）：
```
config/use_custom_user_dir=true
config/custom_user_dir_name="gbt_L2_<時間戳>"
```
用戶資料就會喺 `~/.local/share/gbt_L2_<時間戳>/`，全新、唔使刪。全面自檢結果睇嗰度嘅 selftest.json。

## 注意：瀏覽器內建函數唔喺 J.G（2026-11-16 L2 發現）
`J.G.get("setTimeout")`、`J.G.get("setInterval")` 係 null，`J.cl(null, ...)` 會靜靜咁乜都唔做——計時器、模塊開機重試（boot）全部失效，唔會報錯。
`document` 嘅方法亦唔好用 `J.mc(J.G.document, ...)`（搵唔到 `#sheet` 等）。照轉譯版寫法：
- `setTimeout(f, ms)` → `J.F_setTimeout([f, ms])`；`setInterval` → `J.F_setInterval`；`clearInterval/clearTimeout` → `J.F_clearInterval([id])`／`J.F_clearTimeout`
- `document.querySelector(...)` 等方法 → `J.S_document_("querySelector", [...])`；屬性（`document.body`、`.head`）照用 `J.gp(J.G.get("document"), "body")`
- `window.addEventListener` → `J.S_window_("addEventListener", [...])`；`performance.now()` → `J.S_performance_("now", [])`；`getComputedStyle(x)` → `J.F_getComputedStyle([x])`
- 自訂全局函數（save、canPay、ghostById…）照用 `J.cl(J.G.get("save"), null, [...])`
對照工具（native_xcheck）只比函數輸出，捉唔到呢類錯；要加探針確認包裝（wrapper）真係裝咗、計時器真係行到。

## 紅線：品牌名
原生模塊唔經 build.sh 嘅品牌替換。寫字串時直接用替換後嘅名（WhatsApp→ApaKhabar、TikTok→GoyangGoyang、Grab→Tumpang、Google→Cari、iPhone→iFon、Netflix→Tonton、Spotify→Dengar、麥當勞→漢堡包、Excel→試算表、法拉利／保時捷→跑車、Waze→導航、Touch 'n Go→儲值卡、RapidKL→輕快鐵、PTPTN→學債）。提交前 grep 一次。
