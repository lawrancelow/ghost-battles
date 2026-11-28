# 美術總線進度（2026-11-28 下午）
新圖全部在 art_pending/，未進遊戲，等老闆審。
## 帳號（15:20 更新）
- Plus（e3d5ff2f）：出了 16 張，額度正常；15:16 起瀏覽器擴充功能斷線（Mac 可能休眠或 Chrome 忙），Dato' 金匾那張已送出、未取回，在對話「Generate Horror Illustration」裡。
- 免費 369be60b：出 11 張後額度用完，明天 14:38 後恢復。
- 免費 45b51715：0 張，今天額度本來就用完，明天 11:02 後恢復。
- 免費 6441589f：出 2 張後用完，明天 11:04 後恢復。
## 已完成（全部在 art_pending，未進遊戲）
- sheet_01：男主版劇情插圖 8 張全、女主 stall_hook 修腿。
- sheet_02：名鬼 16、甄好賣＋甘先生＋限時大客 6、櫃檯員／巡邏／事件 8、第 1 章商品 12、第 1 章新攤 5 台三段。
- sheet_03：熟客 8、道具 16。
- sheet_04：衣街／兵器街／飾品街重畫、店員過勞其餘 3 款、被抓包、第 2 章商品 9＋Toyol 等。
- sheet_05：何大睡驚醒、錢不漏咬冥幣。
## 未做
- 共用插圖：dato_plaque（已送出未取回）、nuopo_taste、joss_ruin、note
- 立繪：牛頭／馬面考核官版、三更嬸
- 已選定插圖分層約 20 張
- 市集：五條街其餘章節與寬屏版、第 3–6 章商品與攤位、潮流榜 UI、開張插圖男女各一、Bryan 市集插圖
## 已知瑕疵（送審時要說明）
- 過勞兵器街、飾品街兩張只存到中解析度（538×806），原圖在免費號 369be60b 對話裡，可再取。
- 熟客 8 位膚色偏活人，和其他鬼不一致，建議重畫或調色。
- 魏大狀穿黑袍白領帶（馬來西亞律師袍），算不算西方元素要老闆判斷。
- 第 2 章防盜紙褲畫成布料工裝褲，不像紙紮；竹蒸籠頭盔沒有小腳。
- 何大睡驚醒圖的鬧鐘有鐘面刻度（無數字）。

# 第二班（2026-11-28 16:00–17:00，只用 Plus e3d5ff2f）
## 連線與額度
- Plus 連線正常，本班生成 24 張，沒遇到限額。三個免費號沒碰。
- **16:33 起伺服器端「截圖存檔」失效**：claude-in-chrome 的 save_to_disk 累計寫滿約 128MB 後不再落檔（清空暫存目錄也沒用，只剩很小的圖能存）。改走「下載到 Mac 再取回」需要連接老闆 Mac 的資料夾，申請被系統拒絕。所以 16:33 之後生成的圖都還留在 ChatGPT 對話裡，沒取回。
## 已取回（sheet_06.jpg）
- 共用插圖：cg_shared/cg_dato_plaque.jpg、cg_nuopo_taste.jpg
- 男主酒館換匾：cg_m/cg_tavern_m_v2.jpg；三張牌匾空白匾面座標 cg_m/plaque.json（目測值，已畫框核對）
- 衣街／飾品街第三版：market_street/m3_cloth_v3.jpg、m5_acc_v3.jpg（824×1234，比其他街 896×1344 略小）
- 市集人物鬼化：market_people/people_sheet2.jpg（切好在 cut_v2/mp_*.png）
- 熟客：regulars_sheet3.jpg＝照劇本的 8 位（阿一、老蔡、陳太、阿 Ben、跳哥、阿蘭、布哥、Ivy；cut_v2/rg_*.png）；regulars_sheet2.jpg＝舊 8 位造型鬼化（備選，舊造型和劇本人物對不上）
- 第 1 章商品重畫候選：market_goods/goods_ch1_redo.jpg（上排豆花擔 3 款、下排紙紮兵器 3 款；cut_redo/），等老闆選款後再換進整格
- 分層素材（vil2/art/layers/）：f_soup、f_bribe、b2_soup_v2、lobby_m —— 各有 _sheet_raw.jpg 與切好的透明 PNG；f_soup、f_bribe 有 _bg_raw.jpg；lobby_m 只有低解析背景 _bg_raw_lowres_571.jpg；都還沒做 layout.json 定位
## 已生成但沒取回（都在 Plus 號的 ChatGPT 對話裡，每個對話第 1 張是純背景、第 2 張是角色表）
- lobby_m 純背景全尺寸：https://chatgpt.com/c/6b0a90fd-58b8-83ec-b88d-b9e677f1ca26
- stall_hook_m：https://chatgpt.com/c/6b0a91f7-8b7c-83ec-a5e0-f5abef4a04ee
- stall_hook_f：https://chatgpt.com/c/6b0a9303-4358-83ec-8cba-dc0c5211b827
- pang_visit_m：https://chatgpt.com/c/6b0a9444-aeb4-83ec-9931-eec7b6205cea
- joss_note_m：https://chatgpt.com/c/6b0a9553-9018-83ec-b927-1021d21d20bb
## 沒做
- 過勞兵器街／飾品街店員原解析度圖（免費號舊對話，沒去取）
- 分層：caught、he_wake、qian_bite、兵器街
- 共用插圖 joss_ruin、note；黃泉路 cg_road、cg_road_f
- 立繪：牛頭／馬面考核官版、三更嬸
- 第 2 章新攤、第 3 章商品
## 自審備註
- f_bribe 角色表：老闆連椅子一起畫了；牛頭旁邊帶一疊簿子；女主和馬面因為遞蒸籠相連，切成一件 heroine_mamian.png。
- cg_dato_plaque：右邊站著穿紫色西裝戴墨鏡的人（當作龐總）；Dato' 雙手抱金匾。
- 熟客跳哥（殭屍）有腳、布哥（Pocong）整個裹住，屬知名鬼例外。
- 工具：sv.sh／sv2.sh（存圖）、lay.sh（角色表按連通塊切透明 PNG，DIL 可調）。

# 第三班（2026-11-28 17:10–18:00，只用 Plus e3d5ff2f 生圖）
## 取圖新方法（穩定，已用 5 次）
- 伺服器端瀏覽器存檔已失效，改走 Mac「下載」資料夾（老闆已授權 /Users/lawrancelow/Downloads）。
- Chrome 每個分頁只放行一次自動下載（之後會被「多檔下載」提示擋住，我們點不到）。做法：在工作分頁用頁內 JS 把圖片 blob 存進 IndexedDB（庫名 hcgb）→ 另開一個新分頁到 chatgpt.com，用 JS 把全部圖打成一個 HCGB_bNN.tar 觸發一次下載 → device_stage_files 取回 /mnt/user-data/uploads/Downloads/ → tar 解開。每批換一個新分頁。
- ChatGPT 頁面不准 eval，輔助函式要每次整段貼進 javascript_tool；在同一分頁用點側欄連結／「新對話」的方式換頁（SPA 不重載）函式會保留。數圖片要只數「目前可見」的（getBoundingClientRect().width>100），舊對話的圖會殘留在 DOM。
- 檔案上傳：find「附加檔案」取最後一個 file-input 的 ref。
- Mac 下載資料夾裡留有 HCGB_*.tar／HCGB_lobby_m_1.png 共 7 個檔（約 130MB），沒有刪，老闆可自行刪。IndexedDB 已清。
## 用量
- Plus 本班生成 27 張，沒遇到限額。免費號沒生圖；369be60b 只打開舊對話下載了 2 張原圖。
## 已完成（sheet_07.jpg；全部未進遊戲）
- 取回上一班未取回的 9 張：stall_hook_m、stall_hook_f、pang_visit_m、joss_note_m 分層（vil2/art/layers/<名>/_bg_raw.jpg、_sheet_raw.jpg、char_NN.png）＋ lobby_m 全尺寸背景 _bg_raw.jpg。
- 新分層 6 組：tavern_m_v2、nuopo_taste、caught、he_wake（另有 _sheet_raw_alt.jpg）、qian_bite、weapon_street。都還沒有 layout.json。
- Dato' 金匾 v2：cg_shared/cg_dato_plaque_v2.jpg（展腳幞頭、匾面空白）；plaque.json 加了 dato_plaque（quad＋clear_quad）。
- 第 1 章商品 v2：market_goods/goods_ch1_sheet_v2.jpg、cut_v2/（豆花擔第 1 款、紙紮兵器第 3 款）。
- 新插圖：cg_m/cg_road_m.jpg、cg_f/cg_road_f.jpg、cg_shared/cg_joss_ruin.jpg（備選 _alt）、cg_shared/cg_note.jpg（紙面空白，程序加字）。
- 立繪：portrait/por_niutou_sheet.jpg、por_mamian_sheet.jpg、por_sangeng_sheet.jpg（鬼膚色；原膚色版 _alt_pink），切好在 portrait/cut/。
- 市集：market_stall/stall_ch2_sheet.jpg（cut_ch2/ 15 件）、market_goods/goods_ch3_sheet.jpg（cut_ch3/ 12 件）；過勞兵器街／飾品街店員換成原解析度 1024×1536。
## 自審備註
- 色調：本班新插圖已照「暖棕、土黃、深褐夜色」寫提示詞；分層素材是照原圖重現，沿用原圖的紫色調。
- cg_road_m 是 3:2（1536×1024），其他插圖是 4:3；兩張黃泉路路邊有圓頂石碑，像墓碑，介意可重畫成方柱路碑。
- cg_road_f：筆記本漂浮，但筆畫在黑無常手邊，像是他拿著。
- caught 分層：原圖中飛來的紅色大印和前景遞蒸籠的雙手，背景和角色表都沒有，動態線可從原圖摳。
- he_wake 分層：粉色毯子沒進角色表。
- 馬面配件：把夾板和放大鏡換成竹裝巡查簿和銅手鏡（避免西式文具）；牛頭的鬧鐘是雙鈴銅鬧鐘（鐘面空白）。
- 三更嬸鬼膚色版和已選用酒館插圖裡的膚色（偏粉）不一致，要老闆選一種。
- 第 3 章商品「黃符髮夾」上只有紅色漩渦，沒有字。
## 沒做
- 女主 f_* 其餘插圖、男主 office／exile／flood 的分層（沒被點名加動態）
- 市集：第 3–6 章攤位、第 4–6 章商品、其餘章節街景與寬屏版、潮流榜 UI、開張插圖男女各一、Bryan 市集插圖
