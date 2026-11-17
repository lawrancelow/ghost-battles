# 測試版準備報告（L4）

## 1. 建置（tools/build_beta.sh）
- 用法：`BETA_OUT=/tmp/<自己資料夾> bash godot/tools/build_beta.sh <版本名> <版本號> [--selftest]`
  - 一定要設 BETA_OUT：兩條線同時用預設 /tmp/beta 會互相 rm -rf（已發生過一次，自檢途中資料夾被刪）。
- 0.8.9（code 23）測試建置：剔走 55 個 jsgen 模塊；保留 jsgen：scare、moves_chain、n30_moves（原生版仍會載入）。
- 結果：見下（待填）。

## 2. 全遊戲一條龍（tools/tests/full_run.json）
待填。

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
