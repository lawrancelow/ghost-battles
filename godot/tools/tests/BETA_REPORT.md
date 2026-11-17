# 測試版準備報告（L4）

## 1. 建置（tools/build_beta.sh）
- 用法：`BETA_OUT=/tmp/<自己資料夾> bash godot/tools/build_beta.sh <版本名> <版本號> [--selftest]`
  - 一定要設 BETA_OUT：兩條線同時用預設 /tmp/beta 會互相 rm -rf（已發生過一次，自檢途中資料夾被刪）。
- 0.8.9（code 23）測試建置：剔走 55 個 jsgen 模塊；保留 jsgen：scare、moves_chain、n30_moves（原生版仍會載入）。
- 結果（HEAD 2968cb1，`BETA_OUT=/tmp/L4b/beta … 0.8.9 23 --selftest`）：
  - 剔走 59 個 jsgen；匯出冇錯；**自檢 34 項全過**。
  - APK **89.6MB**（v0.8.3 約 90MB，差唔多；大頭係 libgodot_android.so 65MB，解壓後共 150MB）。
  - 開機時間（電腦軟件渲染）：首次冷開機 9.5–12.8 秒（含開機探測），之後重開約 1.6–2.1 秒（modules 約 0.8–0.9 秒）。手機要以實機為準。
  - 檔案：/tmp/L4b/beta/build/GhostBattles.apk（亦複製到 /mnt/user-data/outputs/GhostBattles_v0.8.9.apk）。呢個係測試包，唔係正式交付版；未包含之後 street／daily_work／daily_plaza 嘅改動。

## 2. 全遊戲一條龍（tools/tests/full_run.json）
跑法：HEAD 6001cc0 乾淨副本、乾淨用戶資料（冇存檔）、Xvfb 450×975、GL Compatibility（CPU 軟件渲染，幀率只作相對參考，手機會唔同）。
全程 277 秒跑完，冇卡死、冇黑畫面、冇閃退；存檔→重開→讀檔正常（save_check lv=18 ghosts=7）。截圖 /tmp/L4b/run1/full_<段>.png（同 /tmp/full_<段>.png）。

| 段 | 幀率 | 截圖檢查 | 問題 |
|---|---|---|---|
| phone（新遊戲→ApaKhabar） | 37.6 | 正常 | — |
| prologue 序章 | 48.8 | 正常 | — |
| village_task 村子任務 | 50.9 | 正常 | — |
| import_save / village_save | 37.2 | 正常 | — |
| battle 戰鬥 | 33.9 | 「首次通關」正常 | — |
| world 地圖 | 57.0 | 正常 | — |
| patrol 夜巡 | 23.4 | 正常 | 幀率偏低（軟件渲染） |
| scare_night 夜班嚇人 | 20.6 | 正常 | 幀率最低一段，手機要留意 |
| squad_select 帶隊出更 | 31.6 | **成版空白** | 見問題 1（已修） |
| tower 樓裡有鬼 | 30.0 | 正常 | — |
| street 陽間街（未原生） | 41.7 | 地圖正常 | 只記錄，唔改 |
| gstreet 冥街夜市 | 25.3 | 正常 | — |
| gyard 亂葬崗 | 26.7 | 正常 | — |
| sports 運動會 | 47.2 | 正常 | — |
| theater 地府劇場 | 43.0 | 正常 | — |

### 問題
1. **帶隊出更版面空白**（`ui/scare_select/sc_select.gd:43` site 係 Nil）：`ScareX.open` 收到搵唔到嘅場地（測試傳 null）就成版空白，只得標題。遊戲內正常入口都會傳場地，但保險起見已加後備：搵唔到就用第一個場地。測試亦改為傳真場地。
2. **測試腳本假錯（已修）**：第一次跑報 4666 個 SCRIPT ERROR（sc_run.gd:66 `_drag`、native/game.gd:16 `_S`、bridge.gd:138 `busy`、tower.gd:1298 `parts`…），全部係測試重開場景前冇 `JSRun.reset_world()`，舊場景嘅閉包繼續跑。遊戲本身所有重開（main.restart_with、匯入存檔、自檢）都有呼叫，所以唔係玩家會遇到嘅問題。修正後只剩問題 1 一個錯。
3. **環境注意**：伺服器重啟後 Xvfb 冇咗，要用 `xvfb-run`；複製嘅 .godot 快取舊過 HEAD（缺 CpuSkin、JossFxN class_name）會令 main.gd 載入失敗兼卡住——跑測試前要先 `--headless --import`（build_beta.sh 已有呢步）。
4. 結束時 Godot 報貼圖／RID 洩漏（退出時先出現，唔影響遊戲中）。

## 3. 新遊戲流程喺手機上嘅高風險呼叫（Fold4／Adreno 730 首次開新遊戲閃退）
新遊戲流程：標題 → `_title_new` → `_hide_title` → `refresh()` → `phone_home("pre")`（ApaKhabar）→ 序章劇情 → 村子。

| # | 位置 | 做咩 | 風險 | 備註 |
|---|---|---|---|---|
| 1 | `js/baker.gd` `_bake`（`core/ctx.gd:502` drawImage 子畫布 >120 筆、`js/recorder.gd:70` >400 筆 → `Baker.request`） | SubViewport 渲染一次再 `get_texture().get_image()` 由 GPU 讀返 | 高：GLES 讀返 framebuffer；首次遇到大畫布先觸發，開機探測（bake）只測過細圖 | 開機探測 `bake` 喺手機通過，但新遊戲時第一次烘大圖／多張同時烘未測。`G.gfx_bad.has("bake")` 會跳過 |
| 2 | `core/meshanim.gd:40`、`native/special.gd:204`、`game/patrol/pt_gfx.gd` mesh_for | `tex.get_image()`（由 GPU 讀返貼圖計透明格） | 中：每張貼圖第一次用時讀一次；村子開場第一次畫角色（打工鬼、廣場鬼、阿福）就會觸發多張 | 夜班嚇人等模式喺手機安全模式下用過同類呼叫冇事 |
| 3 | `ui/main.gd:740` `_gray_mat()` | 冇存檔時「繼續遊戲」掣用灰階 ShaderMaterial | 低：sh_gray 探測已過 | 標題畫面已顯示得到，唔係閃退點 |
| 4 | `core/cpu_skin.gd` | CPU 蒙皮 + 衣服換色 `Image.create`／`create_from_image` | 中：新遊戲後村民第一次出現 | 開機暗測 `cpuskin2` 已覆蓋身體；衣服換色（mode 1）冇覆蓋 |
| 5 | `ui/whatsapp.gd` `create_from_image` | 手機畫面 SVG 圖示 → Image → ImageTexture | 低～中：ThorVG 解 SVG；序章先用 | `ng:phone` 記號可以分辨 |

建議（未改）：
- 新遊戲流程入面 Baker 改為「同一幀最多烘一張、每張之間隔一幀」，並喺 `ng:` 記號加 `bake:<尺寸>`，閃退時救命畫面就知係咪烘圖。
- 老闆手機下次閃退後救命畫面嘅「ng:xxx」步驟名，直接對應上表。
