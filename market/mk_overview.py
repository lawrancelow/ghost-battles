#!/usr/bin/env python3
"""市集實機截圖總覽（給老闆看）：把 shots_ui/、m2_shots/、KPI 考核卡截圖拼成兩張。
用法：python3 mk_overview.py [甄好賣考核卡 png]"""
import os, sys
from PIL import Image, ImageDraw, ImageFont
H = os.path.dirname(os.path.abspath(__file__))
F = "/usr/share/fonts/opentype/noto/NotoSansCJK-DemiLight.ttc"
TW, TH, PAD, LAB = 450, 975, 16, 46
def sheet(title, items, out, cols=5):
    items = [(t, p) for t, p in items if os.path.exists(p)]
    rows = (len(items) + cols - 1) // cols
    W = Image.new("RGB", (cols * (TW + PAD) + PAD, 70 + rows * (TH + LAB + PAD)), (24, 18, 14))
    d = ImageDraw.Draw(W); d.text((PAD, 14), title, font=ImageFont.truetype(F, 38), fill=(240, 222, 170))
    f = ImageFont.truetype(F, 30)
    for i, (t, p) in enumerate(items):
        x = PAD + (i % cols) * (TW + PAD); y = 70 + (i // cols) * (TH + LAB + PAD)
        im = Image.open(p).convert("RGB")
        if im.size != (TW, TH): im = im.resize((TW, TH), Image.LANCZOS)
        d.text((x, y + 4), t, font=f, fill=(240, 222, 170)); W.paste(im, (x, y + LAB))
    W.save(out, quality=88); print(out, W.size, len(items))
U = H + "/shots_ui/"; M = H + "/m2_shots/"
sheet("過勞鬼市集・基本營業（實機截圖）", [
    ("食街 正常營業", U + "s01_normal.png"), ("攤位卡", U + "s03_station_sheet.png"), ("雙貨貨架（Lv25 副貨）", U + "s04_shelf_dual.png"),
    ("櫃檯面板", U + "s06_panel_counter.png"), ("巡邏面板（0–4 隻）", U + "s05_panel_patrol.png"),
    ("偷錢：巡邏鬼去追", U + "s07_steal_cash_chase.png"), ("偷貨", U + "s08_steal_goods.png"), ("插隊", U + "s09_cut_queue.png"),
    ("吵架打鬧", U + "s10_brawl.png"), ("抓到了", U + "s11_caught.png"),
    ("漏網", U + "s12_lost.png"), ("店員過勞趴下", U + "s13_overwork.png"), ("餵包子復活", U + "s14_overwork_revive.png"),
    ("衣街", M + "s14_cloth_street.png"), ("第 3 章 食街", U + "s15_ch3_food.png"),
], H + "/m1_ui_overview.jpg")
kpi = sys.argv[1] if len(sys.argv) > 1 else ""
sheet("過勞鬼市集・進階玩法（實機截圖）", [
    ("過勞營業：加班", M + "s1_overtime.png"), ("累趴：餵包子", M + "s2_down_feed.png"), ("櫃檯員", M + "s2b_counter.png"),
    ("子時高峰 預告", M + "s3_rush_warn.png"), ("高峰＋限時大客＋連單", M + "s4_rush_peak_vip_chain.png"),
    ("高峰後休息", M + "s5_rush_rest.png"), ("陽間潮流榜／名聲", M + "s6_trend_renown.png"), ("里程碑", M + "s7_milestone.png"),
    ("街組合", M + "s8_street_combo.png"), ("評論家甘先生", M + "s9_critic.png"),
    ("熟客", M + "s10_regular.png"), ("名聲升級", M + "s11_renown_up.png"), ("打卡鐘", M + "s12_punch_clock.png"),
    ("限時大客 失敗", M + "s13_vip_fail.png"), ("甄好賣 考核卡", kpi),
    ("最擠情況（全部牌同時出）", M + "s13b_stress.png"), ("街道分頁：四條街鎖", M + "s13c_tabs_locked.png"),
], H + "/m2_overview.jpg")
