# 插圖分層（給程序組 VI）
每張圖一個資料夾 layers/<圖名>/：
- bg.png：無角色純背景（與完整圖同尺寸 canvas）
- <角色>.png：單角色透明 PNG（高解析原尺寸 src_size）
- layout.json：canvas 尺寸；每層 x,y（左上角）、w,h（畫面顯示尺寸）、scale（src→畫面）、z（越大越上層）
- _recomposite.jpg：用 bg + 各層按 layout 重組的核對圖；_compare.jpg：原圖 vs 重組對照
（底線開頭的檔案是工作檔，不用進遊戲）

產線（tools/）：stitch.py 拼截圖；matte.py 黑白底差分取透明度；place.py 角色表→模板匹配定位→輸出 layout；sheet.py 角色預覽。
ChatGPT 流程：完整圖 →「純背景版」(同構圖去掉角色) →「角色提取」(同一張透明底 PNG 排開所有角色，全身補全)。
