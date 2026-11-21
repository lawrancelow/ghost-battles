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
