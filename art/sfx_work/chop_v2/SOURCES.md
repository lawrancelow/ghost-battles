# 伐木（斧頭砍樹）（wk_chop_hit）新候選 D–K

對照：目前遊戲用 C，頻譜自查：金屬殘響

頻譜欄位：b_lo＜300Hz、b_mid 300–1500Hz、b_metal 1.5–6kHz、b_air＞6kHz 能量佔比；tail＝峰值 60ms 後尾音能量佔比；ring＝尾音中 300Hz–9kHz 的尖峰（金屬鳴響）能量指標，＞0.015 判金屬殘響；dec30＝衰減到 -30dB 的秒數。

| 候選 | 特點 | 陰間化 | 長度(s) | b_lo | b_mid | b_metal | b_air | tail | ring | dec30 | 自查 | 素材（作者／來源／授權） |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| D | 厚實「篤」＋細木纖維裂聲 |  | 0.161 | 0.527 | 0.417 | 0.056 | 0.0 | 0.017 | 0.0029 | 0.095 | OK | wood_hit_04.ogg（rubberduck，https://opengameart.org/content/100-cc0-metal-and-wood-sfx，CC0 1.0）；wood_cracking_01.ogg（rubberduck，https://opengameart.org/content/100-cc0-metal-and-wood-sfx，CC0 1.0） |
| E | 低沉「咚」，斧頭深砍入樹幹 |  | 0.168 | 0.359 | 0.597 | 0.044 | 0.0 | 0.02 | 0.0001 | 0.093 | OK | wood_slam_04.ogg（rubberduck，https://opengameart.org/content/100-cc0-metal-and-wood-sfx，CC0 1.0）；wood_cracking_04.ogg（rubberduck，https://opengameart.org/content/100-cc0-metal-and-wood-sfx，CC0 1.0） |
| F | 悶實短促，帶乾木碎裂 |  | 0.14 | 0.368 | 0.532 | 0.089 | 0.011 | 0.004 | 0.0003 | 0.077 | OK | wood_hit_08.ogg（rubberduck，https://opengameart.org/content/100-cc0-metal-and-wood-sfx，CC0 1.0）；wood_cracking_02.ogg（rubberduck，https://opengameart.org/content/100-cc0-metal-and-wood-sfx，CC0 1.0） |
| G | 中低頻「篤」，像砍進濕木 |  | 0.123 | 0.532 | 0.404 | 0.063 | 0.0 | 0.0 | 0.0002 | 0.06 | OK | wood_close_02.ogg（rubberduck，https://opengameart.org/content/100-cc0-metal-and-wood-sfx，CC0 1.0）；wood_cracking_01.ogg（rubberduck，https://opengameart.org/content/100-cc0-metal-and-wood-sfx，CC0 1.0） |
| H | 較清脆的乾柴一劈 |  | 0.108 | 0.326 | 0.546 | 0.117 | 0.011 | 0.0 | 0.0 | 0.064 | OK | wood_slam_01.ogg（rubberduck，https://opengameart.org/content/100-cc0-metal-and-wood-sfx，CC0 1.0）；wood_cracking_02.ogg（rubberduck，https://opengameart.org/content/100-cc0-metal-and-wood-sfx，CC0 1.0） |
| I | 程式合成：純木質撞擊＋纖維爆裂，完全無金屬 |  | 0.128 | 0.115 | 0.759 | 0.123 | 0.003 | 0.002 | 0.0 | 0.06 | OK | —（音效組程式合成（本專案原創），—，原創（程式合成，無外部素材）） |
| J | 陰間化：E 壓低音調＋空洞迴響（非金屬） | 是 | 0.293 | 0.458 | 0.51 | 0.032 | 0.0 | 0.009 | 0.0047 | 0.101 | OK | wood_slam_04.ogg（rubberduck，https://opengameart.org/content/100-cc0-metal-and-wood-sfx，CC0 1.0）；wood_cracking_04.ogg（rubberduck，https://opengameart.org/content/100-cc0-metal-and-wood-sfx，CC0 1.0） |
| K | 陰間化：合成木擊壓低，悶沉陰森（無金屬） | 是 | 0.257 | 0.129 | 0.818 | 0.053 | 0.0 | 0.047 | 0.0099 | 0.157 | OK | —（音效組程式合成（本專案原創），—，原創（程式合成，無外部素材）） |
| 對照 C（舊） | 目前遊戲用 | | 0.252 | 0.226 | 0.724 | 0.05 | 0.0 | 0.151 | 0.0465 | 0.179 | 金屬殘響 | 見 ../SOURCES.md |
