# Gemini 面板生成評估（2026-11-27，美術二組）

## 方向清單（A–K，總覽圖 gen/HC_GB_UI_AllDirections_Gemini.jpg）
| 字母 | 名稱 | 主要元素 | 檔案 |
|---|---|---|---|
| A | 辦公室鐵櫃 | 生鏽鐵框＋便利貼、工作證、紅筆；木雕窗格角 | A_office_mix_v4.png（PC 寬屏試作 A_pc_wide_v1.png） |
| B | 大排檔（改良） | 紅木招牌框＋鐵皮棚、燈泡、膠凳（老闆不太喜歡，保留比較） | B_daipaidong_v2.png |
| C | 蠟筆繪本 | 粗蠟筆描邊＋角落小鬼手 | C_picbook_v2.png |
| D | 陰間走廊 | 舊花磚牆＋日光燈＋鐵閘 | D_corridor_v1.png |
| E | 告示板 | 軟木板＋圖釘便利貼＋竹簾木雕框 | E_board_v2.png（截圖接縫，總覽用 _seamfix） |
| F | 診所藥櫃 | 中藥百子櫃＋牛皮檔案夾＋碎屏手機 | F_clinic_v1_fix.png（已抹英文印章字、赤腳圖示） |
| G | 月洞門 | 月洞門木框＋霓虹燈管＋紅燈籠 | G_moongate_v2.png |
| H | 舊電視 | 木殼舊電視＋雕花茶几＋藤屏風 | H_crt_v1.png（截圖接縫，總覽用 _seamfix） |
| I | 當舖帳簿 | 大帳簿＋算盤＋收據機、計算機 | I_ledger_v2.png |
| J | 粉筆黑板 | 黑板＋毛筆架＋無數字時鐘＋碎屏手機 | J_chalk_v2.png |
| K | 褪色牆紙 | 花牆紙＋霓虹燈條＋流蘇＋遙控、插座 | K_wallpaper_v2.png |

## Gemini 總評
- 風格貼合：好。暗黑蠟筆粉彩質感、手繪毛邊、現代＋古代混搭都能做出，比預期貼近遊戲。
- 中文字：能寫準確（A 第一版「嘆氣蒸籠」字正），但面板文字仍由程序疊加，生成圖要求無字。
- 亂加東西：最大毛病。會自加手機狀態列、英文標籤（Title Bar、Main…）、英文印章字、帶數字時鐘、手機底部橫條、赤腳圖示；必須每張檢查，靠「no text, no letters, no status bar」提示＋重出或局部修補。
- 速度：單張約 20–40 秒；4 台 Chrome 並行，約 30 分鐘出 11 個方向（含重出）。
- 一致性：同一對話內改圖能保留構圖（J、K 修正版即是）；跨方向一致性要靠固定提示詞。
- 取圖：頁內 <img> 為 704×1520；用頁內遮罩全屏顯示＋2 倍 zoom 截圖可得約 700×1500 無接縫圖。舊的分段截圖會留 64px 黑色接縫（E、H、J 第一版）。正式素材要更高解析度時，需要另找下載原圖的方法或放大。

## 商用條款（查證）
- 第三方整理（terms.law，引 Gemini API Additional Terms／Google Workspace Terms）：Google 不主張生成內容所有權，生成輸出歸用戶，可商用；但純 AI 生成圖在美國可能無法取得版權保護。
- 該整理未涵蓋消費版 Gemini App 專屬條款與 SynthID 隱形浮水印；正式大量入遊戲前，建議老闆再看 Google 消費版 Gemini 條款與生成式 AI 禁用政策確認。
- 來源：https://www.terms.law/ai-output-rights/gemini/ 、https://ai.google.dev/gemini-api/terms
