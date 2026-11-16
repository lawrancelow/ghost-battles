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
