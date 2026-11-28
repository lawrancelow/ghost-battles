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
