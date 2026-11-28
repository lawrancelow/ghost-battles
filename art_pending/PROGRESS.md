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

# 第四班（2026-11-28 17:50–18:00，只用 Plus e3d5ff2f）
## 額度：Plus 今天的圖像生成額度已用完
- 本班只成功生成 2 張，第 3 張起 ChatGPT 回覆「你已用完圖像生成額度，請於明天上午 9:11 再試一次」。三個免費號也要明天 11:00–14:38 才恢復。今晚不能再生新圖。
- 已送出但因限額沒生成的提示詞（明天可直接重送）：第 4 章商品 16 格、第 4 章新攤 A（炸香蕉、碼頭工人背心、可峇雅紙衫、香蕉莖盾、鐵釘護頸）、第 4 章新攤 B（白花髮夾、紅鞋鞋扣、紙紮吹風筒、Lui Char 熱帶款）。
## 已完成（sheet_08.jpg；未進遊戲）
- market_stall/stall_ch3_sheet_a.jpg（5 欄×3 段）、stall_ch3_sheet_b.jpg（4 欄×3 段），切好在 market_stall/cut_ch3/（27 件，cut.py 用 DIL=2 全過）。
## 取圖
- 沿用第三班流程，本班 1 批成功（HCGB_b10.tar 留在 Mac 下載資料夾，沒刪）。存圖 helper：window.HC（db/put/vis/save），tar 打包在新分頁做；可同時開 3 個分頁各送一張。IndexedDB 已清，分頁已全關。
## 自審
- 墨斗線攤的墨斗畫成帶輪盤的小木箱，不太像傳統墨斗（船形帶線輪），可接受但不準確；其餘無文字、無人物、無西方元素，色調暖棕。
- Bryan 市集插圖：人物設定文檔寫明 Bryan 立繪用老闆原創 npc_rival、不交 AI 重畫；畫插圖勢必要 AI 畫 Bryan，動手前請統籌先問老闆。
## 沒做（全部因限額）
- 黃泉路男女分層（road_m、road_f，老闆 17:56 新增，要做動態）
- 第 4 章商品、第 4 章新攤 9 台；市集開張插圖男女各一；Bryan 市集插圖
- 第 5 章商品與新攤 8 台；第 6 章商品與新攤 9 台；潮流榜介面素材
- 分層：男主 office、exile、joss_flood；女主 lobby、office、exile、tavern、pang_visit、joss_flood、joss_note

# 第五班（2026-11-28 18:28–18:56，改用 Gemini；ChatGPT 各號今晚沒額度，沒碰）
## 用 Gemini 的做法（已穩定）
- 上傳：Gemini 沒有常駐的 file input。先在頁內掛鉤攔截 `HTMLInputElement.prototype.click`（type=file 時不彈系統選檔視窗，改把 input 掛進 DOM、id=hcgb_fi），再點「上傳與工具 → 上傳檔案」，用 find 找 file-input，**第 2 個**就是它，file_upload 進去（一次可多張，合計 <3.8MB）。每開一個新分頁要重掛鉤；同一分頁點「新對話」鉤子還在。
- 取圖：直接用真實點擊按圖片右上角「下載完整尺寸」，檔案進 Mac 下載資料夾（Gemini_Generated_Image_*.jpeg，約 1200×896），不受「每分頁一次自動下載」限制；device_list_dir 按時間對應順序 → device_stage_files 取回。本班 21 張全數取回。下載鈕位置用頁內 JS 取（按鈕 aria-label 含「下載完整尺寸／Download full」）。
- 同一對話可追問第二個編輯（「回到最初上傳的原圖…」），一張圖一個對話出「純背景」＋「角色原位去背」兩張。
- 同一帳號不要兩個分頁同時生成（會回 something went wrong）；分頁不在前景時進度會停。
- 伺服器過載（temporarily overloaded）時按「重做 → 重試」即可。
## 分層新做法：原位去背（比角色表好用）
- 提示詞 A（純背景）：移除全部角色並補全背景，其餘不變。提示詞 B（原位去背）：背景全部換純白，角色留在原位、原大小、不重畫。
- `/home/claude/scripts/inplace.py <layers目錄> <原圖>`：把 B 對齊原圖尺寸 → chars_inplace.png（整張透明）＋各連通塊 char_NN.png ＋ **layout.json（座標即原圖座標，可直接疊回 bg.png）** ＋ _compare.jpg（原圖｜純背景｜重組｜角色）。
- 限制：互相重疊的角色會連成一塊（例如黃泉路的主角＋黑白無常＋排隊鬼是一件），被遮住的部分沒有補；要各自獨立動，需再逐個角色單獨提取。
- 試驗結論（art_pending/gemini_vs_chatgpt_layers.jpg）：純背景 Gemini 更忠於原圖（逐像素對齊）；「角色表（分開排列）」ChatGPT 更忠於原圖，Gemini 會改姿勢、多畫角色。
## 各 Chrome 的 Gemini 狀況
- e3d5ff2f（Low Zen keong，免費）：已登入，本班 14 張後出現「limit resets」限額。
- 6441589f（LawranceLow，免費）：已登入，本班 7 張後出現限額（Image Editing／Generation Limit Reached）。
- 369be60b、45b51715（zen keong low，免費）：已登入，但第一次上傳會彈「根據圖片和檔案生成內容——請確認你擁有上傳圖片的必要權利…同意／取消」。這是同意條款，沒有老闆明確許可我不能代按，兩個都按了取消，沒用到。**老闆在這兩個 Chrome 各按一次「同意」（或明確授權）後就能用。**
## 已完成（sheet_09.jpg 分層對照、sheet_10.jpg 新圖；全部未進遊戲）
- 分層（vil2/art/layers/，各有 _bg_raw.jpg、_inplace_raw.jpg、bg.png、chars_inplace.png、char_NN.png、layout.json、_compare.jpg）：road_m、road_f、office_m、exile_m、joss_flood_m、f_lobby、f_office；另 lobby_m_gemini（試驗）。
- 第 4 章商品 16 樣：market_goods/goods_ch4_sheet.jpg（cut_ch4/，16 件全過）。
- 第 4 章新攤 9 台三段：market_stall/stall_ch4_sheet_a.jpg、_b.jpg（cut_ch4/，27 件全過）。
- 潮流榜介面素材：market_ui/trend_ui_sheet.jpg（cut/ 按連通塊切）。
- 市集開張插圖男主版：cg_m/cg_market_open_m.jpg。
## 自審備註
- 第 4 章商品筆觸比 ChatGPT 版略乾淨、蠟筆顆粒感較淡；「紅鞋鞋扣」畫成一雙紅繡花鞋；「紙紮兵器」和已定稿的招牌款不同（招牌三樣本來就沿用舊圖，這格可不用）。
- 潮流榜素材多畫了一個徽章（4 個：金、銀、銀灰、銅），排列不是整齊 3×3。
- 開張插圖男主版：小紙是照參考圖畫的，和遊戲內立繪可能不同；夜空仍偏紫，匾面空白。
- office_m、exile_m、f_office 的原位去背：Gemini 把被桌子遮住的下半身補畫了（龐總有腿，是西裝人物可接受），疊回時桌子要另拆一層或用遮罩。
- joss_flood_m 純背景保留了滿地包裹（屬物件，不是角色）。
## 沒做（兩個可用帳號都到限額）
- 分層：女主 exile、tavern、pang_visit、joss_flood、joss_note；化寶爐廢墟、Dato' 金匾 v2、交接便條；caught 的紅色大印與雙手、he_wake 的毯子。
- 新圖：市集開張插圖女主版（提示詞已送出、因限額未生成）；第 5 章商品與新攤 8 台；第 6 章商品與新攤 9 台。Bryan 市集插圖按指示沒畫。

# 第六班（2026-11-28 19:40–20:15，只用 Gemini；Chrome 369be60b）
- 369be60b 的上傳權利確認框：老闆 19:27 授權代按「同意」，已按一次，之後不再彈。45b51715 本班沒用到（同意框還沒按）；e3d5ff2f、6441589f 沒重試。
- 369be60b 本班成功 10 張，未遇限額。
- 注意：新對話第一則訊息偶爾會失敗（側欄出現對話但打開顯示「對話不存在」，草稿文字還在、附圖消失）——重新上傳附圖再按送出鈕即可；送出用點擊送出鈕，不要用 Enter。選單「上傳檔案」的位置會隨輸入框高度變，點之前先截圖。
- 原位去背提示詞要寫「所有背景和物件塗成完全純白色，不要留下任何線稿或輪廓；只留下全彩的角色」，否則攤位會留成白色線稿（market_open_m／f 就是這樣）。f_tavern_v2 用新寫法是乾淨的。
- 完成：cg_shared/cg_dato_plaque_v3.jpg（紅褐底鎏金「拿督」，最佳）、_v3b（全金匾）——字是圖上直接雕刻，兩字筆畫核對正確；cg_f/cg_tavern_f_v2.jpg（女主酒館換男主同款麻繩木板匾，匾面留空）；cg_f/cg_market_open_f.jpg（市集開張女主版，暖棕）；分層 market_open_m、market_open_f、f_tavern_v2；plaque.json 加 tavern_f、office_f、exile_f、dato_plaque_v3；sheet_11.jpg。
- 女主 office／exile 的匾和男主同款，沒改圖。
- 沒做：女主 exile、pang_visit、joss_flood、joss_note 的分層；化寶爐廢墟、交接便條分層；caught 大印與雙手、he_wake 毯子；market_open_m／f 的原位去背用新提示詞重做（去掉線稿攤位）；第 5、6 章商品與攤位。
