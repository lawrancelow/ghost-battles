# 標題封面 V3「凌晨三點辦公室」分層素材

- `portrait/`（1024×1536）、`wide/`（1672×941）：各層與原圖同尺寸、位置對齊，按 z 順序直接疊放＝原圖（逐像素驗證差異 0）。
- 層：L0_background（角色已移除，LaMa 補畫）、L1_ghosts_left/right（隔板後鬼怪）、L2_ceiling_left/right（天花板鬼）、L3_male / L3_female（男女主）。
- 光源遮罩（灰階，白＝發光區）：glow_lights（日光燈）、glow_monitors（螢幕）、glow_lamps（檯燈）、glow_moon（紅月）。
- `layers.json`：檔名、z、建議視差係數、bbox、動畫類型與錨點。
- 分割：SAM（facebook/sam-vit-large，Apache-2.0）；補畫：LaMa ONNX（Carve/LaMa-ONNX，Apache-2.0）。腳本在 tools/。
- 注意：L1 鬼怪下半身被隔板擋住，位移請 ≤3px；L0 角色後方補畫區只在角色移動時露出少量，視差勿過大。
