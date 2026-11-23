# 過勞鬼大作戰 — 補丁 28 交接（2026-11-24 清晨）

新對話框開工先讀本文件，再讀 claude/HC_GhostBattles_SoulCounter_Plan_20261123.md（統一方案）、claude/HC_GhostBattles_Handoff_20261123.md（環境、流程、老闆規則）。

## 一、線上狀態
- 熱更新 0.10.1 **ver 28**：p_0101_{android,linux}_28.pck，md5 `9d5e52e6e3290b687c435ccda1952c81`，52.7 MB／1092 檔（Pages 已核對）。
- GitHub lawrancelow/ghost-battles：`revamp-p1` @ 0a9501f（源碼＝integ 全部線合併）；`main` @ f87d8f8（發佈庫）。
- **未做升級測試**：新容器冇 0.10.1 APK（/tmp/apk101/Linux.pck 由 APK 還原），patch 用 repo 內 base_0101 manifest diff（同以往做法）。下次要升級測試：叫老闆提供 GhostBattles_v0.10.1.apk，跑 tools/devkit/base_from_apk.sh。
- 驗證（28）：selftest 34/34、全程 301 秒 0 錯誤；全套 16 項：rts 67、abil 66＋mech 37、abform 71、cdata 61、sortie 45、soul 74、soul2 73、newghost 92、abui 62、mapbattle 108、zone 328、equip 57、militia 58、roster2 45、qaudit 45，全部 bad=0、SCRIPT_ERR=0。

## 二、補丁 28 內容（百鬼克制＋魂魄招降＋武器裝備）
- 名鬼 131 隻（阿福＋72 舊＋牛頭馬面＋26 新〔nw_*〕＋30 第二批〔nw_*，data/nat/newghost2.json〕），敵人 149 種，大魔王 7（bm_*，龐總用 npc_kpiboss 原圖），新雜兵 8（zd_*）。
- 能力引擎 game/rts/abil.gd＋data/abil.json（40 積木、13 機制、兩層克制：8 系×8 嚇法＋機制×10 應對標籤、合體技 30 組、AB.OFF 全域開關）。
- 陣型與 AI game/rts/abform.gd（威脅值揀目標、每目標 ≤3 近戰、AoE 130、前排護衛、自動施放）。
- 數據與據點 data/nat/counter.json（24 鬼幫按真實方向、90＋6 魔王據點、駐守／雙駐守 guard2、魂魄來源、ch_k／sortie_k＝SOFT 步驟 A、yin_k.hp 1.6）。
- 魂魄祭壇 game/soul/（品級 pin 凡靈煞王、掉魂、怨氣、升職試用→合夥人、散魂、心願供品、舊存檔遷移 S.soul.mig、存在感改「休養」）；soul2：抄功課、圖鑑 131 格、演出、王座重遊。
- 武器裝備 game/equip/（40 件：民用 14〔兵器檔 A/B 款〕＋名鬼 26〔兵器／護身／隨身〕；加成封頂 +25%、最多補 1 標籤；153 隻人工錨點）。顯示方案開關 eq_view.gd `VIEW_DEFAULT`：pin（現行，預設）／float（B 鬼物飄浮）／strike（C 出手才現形）。
- 畫面：頭頂狀態、偵察卡、揀軍師、技能長按自動／手動、戰鬥字防重疊（ab_lay.gd）、免疫字節流；**正式戰鬥圖示 29 個已批准入庫（art/ab/）**。
- 平衡：報告 /home/claude/docs/balance_report.md（容器內），調整唯一來源 tools/balance/bal_scale.json＋apply_bal.py。

## 三、等老闆決定／待辦
1. **裝備顯示方案 A/B/C 未揀**（比較圖 compare_*.png、b_anim.mp4 已發）。揀咗改 eq_view.gd `VIEW_DEFAULT` 出小補丁。
2. **美術未批**（未入遊戲，用暫代圖）：第二批 30 隻（/home/claude/docs/art_pending/b2/，拼圖 batch2_01–05＋batch2_redo）、裝備 40 件（art_pending/equip/held/eqi_*.webp、icon/*.png；拼圖 equip_01–03）。批准後：b2 → assets/spr/<id>.webp；裝備 held → assets/spr/eqi_<id>.webp、icon → assets/spr/eqi_<id>_i（見 eq_art.gd），登記 spr_manifest。注意 art_pending 在容器，重建會冇——原圖在 /home/claude/art_work/raw/，ChatGPT 對話「Generate Character Sheet」。驅風油綠瓶紅蓋似真實品牌，老闆未回覆要唔要改色。
3. 平衡未合格：萬能度 U 0.88–0.99（目標 ≤0.85）；霸體、突襲、嚇氣光環 3 機制要 abcore 加數值參數；第 3、4 章外圈據點靠縮放（0.16–0.4），建議下版減敵人數；so4_r4_3 隨機隊 17%；SOFT 停步驟 A。
4. 扣血數字未入防重疊排版（老闆未表態）。
5. 「犼」出處待核對。

## 四、本輪新增老闆規則（已寫入記憶與 LINES.md）
- ★規則第一條：不要因為老闆說話就擅自停掉任何任務。
- 生圖必須單獨經老闆審批；一般鬼不要腳（知名鬼、獸形、物件除外）；骷髏兵要東方。
- 進度回報：先每 15 分鐘，02:47 起改每 1 小時。
