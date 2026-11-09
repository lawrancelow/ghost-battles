# 《過勞鬼大作戰》交接說明（2026-11-09 更新）

給新對話的 Claude：先讀完這份再動手。用戶 Lawrance，所有回覆用中文；線上版本 2026.11.08e 正常可玩。

## 1. 基本資料
- 線上網址：https://lawrancelow.github.io/ghost-battles/ （GitHub Pages PWA，會自動更新）
- 發佈 repo：lawrancelow/ghost-battles（本機路徑 /home/claude/ghost-battles，只放 build 好的 site/）
- 原始碼：/home/claude/gb/src（不是 git repo）。美術：/home/claude/gb/art（raw 原圖、cut 切好的圖、pack.py 打包進 src/assets.js）
- **注意：容器會重置，/home/claude 和 /tmp 不一定還在。** 原始碼已備份在 GitHub repo lawrancelow/ghost-battles 的 `dev/` 資料夾（dev/src 全部原始碼含 assets.js、dev/build.py、dev/art/*.py 工具、dev/tools/ 測試腳本、dev/HANDOFF.md 本文件）。新容器：clone repo → 把 dev/ 內容放回 /home/claude/gb 對應位置即可 build。美術原圖（art/raw、art/cut）沒有備份，但都已打包在 assets.js 內。
- Build：`python3 /home/claude/gb/build.py` → GhostBattles.html + site/
- 上線：改 src/web.js 的 GAME_VER（目前 '2026.11.08e'）→ build → `cp -r site/. /home/claude/ghost-battles/` → git commit（結尾加 Co-Authored-By / Claude-Session 兩行）→ push
- 回歸測試（都在 /tmp/claude-0）：t_smoke2.py、t_act.py、t_sc.py、t_world.py、t_craft_fx.py、t_gy.py、reltests/t_chatter.py，加 /home/claude/gb/tools/gy_verify.py（亂葬崗唯一解）

## 2. 已上線的內容（截至 08e）
- 村子經營、戰鬥、56 隻新鬼（n30_*：40 隻傳統鬼怪＋16 隻死法鬼）及收服、圖鑑
- 出村地圖：冥街夜市、亂葬崗（墳前直接掛祭品牌）、出征、回陽間
- 陰間日常 37 段、棟篤笑 9 段、主線串場、收服劇情 67 段、冤家 18 對、碎碎念（每隻名鬼 ≥20 句，雜鬼 50 種性格、64 種入村）
- 三個死對頭：龐總（npc_kpiboss，陰間上司）、Bryan（npc_rival，籃球同事）、冼小姐（npc_hr，HR），都是無腳鬼
- 中文／粵語對白切換（預設中文）
- 回陽間：整層無縫全景（老闆房｜開放辦公區｜茶水間｜會議室），手指拖動、小地圖、單挑嚇人、旁人笑「冇人信」、穿崩度→道士林師傅、怕／唔怕分明、6 個 NPC（阿Ken、小晴、美美、陳總、清潔安娣、保安阿伯），星級 [1100,1300,1480]

## 3. 做到一半、未上線（2026-11-08 19:28 因額度不足停下）
用戶決定的新主線（靈感來自陳柏霖電影《鬼才之道》，但不照搬名字台詞）：鬼要衝 KPI，否則在陰間真的消失。
- **A. 回陽間部分**（未完成）：檔案 src/scare_squad.js（新）、src/scare.js、src/rooms.js、style.css 已被改動，狀態未驗證，可能 build 不過。
  - 每晚從收服的鬼挑 3 隻帶去，每隻一招專屬嚇人法（對應怕的類別）
  - 都市傳說熱度：每地點 Lv1–5，熱度高了來探險網紅、道士更早到
  - Bryan 偶爾也來搶場
  - 晚上結束要發 `gb:nightEnd` 事件給 B 用
- **B. 存在感／合約部分**（未完成）：src/presence.js、src/presence_data.js（新）
  - 每隻鬼有存在感，會流失，嚇人／傳說熱度補回；低了變透明；歸零前有警告和三天倒數，消失後可在招魂台招回但失憶（孟婆湯梗）
  - 阿福的試用期合約（龐總給），達標升職：打工鬼→正式鬼→組長→經理，每級解鎖實際東西；失敗觸發「淡化危機」劇情，不會 game over
- 這兩部分的舊幫手對話已停，不能保證還能接續。**新對話建議：先跑 build 和測試看半成品狀態，能用就補完，不能用就照上面規格重做。**

## 4. 之後的計劃（用戶已同意方向）
1. 完成第 3 點的存在感主線並上線
2. 去掉《熱血大作戰》的影子：村子產出改為服務 KPI（棺材板、壽包變道具／供品，兵營變嚇人訓練班）；戰鬥由推關改成搶陽間地盤；連招改用「怕什麼」組合
3. 陰間運動會：殭屍跳遠、舌頭對脖子拔河、天花板倒掛耐力、河童游泳等，贏了加存在感
4. 未回覆的舊樣板：廣場、鎮上活人日常動作（PlazaDailyDemo、TownDailyDemo）

## 5. 用戶的硬性要求（務必遵守）
- 全部回覆用中文；遊戲對白用地道港式粵語／自然的馬來西亞華語
- 美術：永不用 AI 重畫已有角色，只能剪原圖、網格變形；新角色才用他的 ChatGPT 生圖（同一蠟筆畫風）
- 紅線：不碰宗教（閻王等神明都不能用）、種族、國與國、未成年人、色情；吊死鬼只講舌頭
- 先給樣板再上線（他明確說「放進去」時可直接上）；已批准的工作不要逐步問他
- 同一場景不能兩個角色講同一句；推理題要證明唯一解
- 交檔用英文檔名；**額度緊張：精簡回覆，盡量少派幫手**


## 6. 2026-11-09 更新：存在感主線已上線（2026.11.09a）
- 第 3 點 A、B 兩部分已驗證可用並上線：帶隊回陽間、都市傳說熱度、靈探 KOL、Bryan 搶場、gb:nightEnd → 存在感、試用期合約、升職、淡化危機、魂飛魄散倒數、重新招魂（失憶）
- 修正：劇情播放中會被重複排隊，導致合約 KPI 被清零／可能重複升職（presence.js 加 has()）
- 修正：升職「多帶一隻鬼」原本沒生效，隊伍上限改為 3＋職級加成；合夥鬼名冊金邊補上；選隊名單字色加深
- 新測試：dev/tools/t_pres2.py（合約→夜晚 KPI→升職→危機→補救）、t_fw.py（倒數→消失→招回）
- 下一步：第 4 點計劃 2（去掉《熱血大作戰》影子）

## 7. 2026-11-09 大改版（只在樣板版 /preview/，正式版未上）
- 樣板網址 https://lawrancelow.github.io/ghost-battles/preview/ ；`PREVIEW=1 OUT=GhostBattles_preview.html python3 build.py` → site_preview/（獨立存檔 ghostBattles_preview，第一次打開複製正式版進度；快取名 gbp-）
- src/rework.js：戰鬥「怕什麼」連嚇（敵鬼怕／唔怕表 EFEAR，新鬼自動）、嚇人訓練班練嚇功（S.drill，Lv 門檻 300/1000/2500/5000）、陰兵由民宅自來、供品／道具箱（S.scareKit）、搶地盤（S.turf：每日收租、鄰村 8~14 小時搶一個、奪回）
- presence.js：合約面板「上供」（30 壽包 → 存在感 +12，每鬼每日一次）
- src/sports.js：陰間運動會四項（跳遠、拔河、倒掛、游泳），每項每日首次贏 Bryan 有獎；入口在「地盤」頁
- daily_work.js：訓練班工人動作 boo／grimace／blow 取代踏步敬禮操練
- 未做：訓練班建築圖仍是軍營帳篷（有兵器架），等 Lawrance 用 ChatGPT 生新圖；孟婆湯研究所（烹飪）未做
- 他說「上線／放進去」時：src/web.js GAME_VER 改新版本 → python3 build.py → cp site/. 到 repo 根目錄 → push
- 回陽間・近身操作（src/scare_ops.js，樣板版）：揀中人後按佢做緊乜出「手機／電腦／茶水間」；手機四個 app 揭到情報（_intel）解鎖針對性訊息；冒充發訊息、篡改電腦、六種茶水間嚇法；全部經 Scare.hit() 計分；有反效果（trap）同陰德（warm）選項；陳總唔聽陌生號碼，但冒充 Master Lee 就會睇
