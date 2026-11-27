# [account] 帳號系統設定（熱更新：冇 class_name；const AC = preload("res://game/account/acct_cfg.gd")）
# 換後端只改呢度：
#   "mock"     本機模擬（開發／測試用，現時預設）
#   "firebase" Firebase Spark 免費方案（推薦；填 FB_API_KEY、FB_PROJECT）
#   "supabase" Supabase 免費方案（備選；填 SUPA_URL、SUPA_KEY）
extends RefCounted

const BACKEND := "mock"
const FB_API_KEY := ""      # Firebase 專案設定 → 一般 → 網頁 API 金鑰（公開 key，可以放客戶端；真正保護靠 Firestore 規則）
const FB_PROJECT := ""      # Firebase 專案 ID
const SUPA_URL := ""        # 例：https://xxxx.supabase.co
const SUPA_KEY := ""        # anon public key
const REQUIRE_LOGIN := true # true＝要登入先玩得（老闆 2026-11-27 要求「註冊帳號遊玩」）
const AUTO_SYNC_SEC := 300.0 # 遊戲中每 5 分鐘檢查一次要唔要上傳（只喺有改動先寫，慳免費額度）
const MIN_PW := 8
