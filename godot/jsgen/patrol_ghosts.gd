# 自動轉譯自 patrol_ghosts.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["PG_GHOSTS"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f4(this_, a: Array, env):
	var _t6 = env["im"]
	J.sp(_t6, "_ok", true)

func _f3(this_, a: Array, env):
	var v_k_19 = null; var v_src_20 = null
	var _t1 = J.seq(J.typeof_(J.G.get("SPR")), "undefined")
	var _t2 = (_t1 if _t1 else J.seq(J.typeof_(J.G.get("PT_IMG_SRC")), "undefined"))
	var _t3 = (_t2 if _t2 else J.seq(J.typeof_(J.G.get("ART")), "undefined"))
	if (_t3 if _t3 else (not J.t(J.gp(J.G.get("ART"), "CHAR_H")))):
		return null
	for _t4 in J.keys(env["H"]):
		v_k_19 = _t4
		v_src_20 = J.gp(J.G.get("PT_IMG_SRC"), v_k_19)
		if (not J.t(v_src_20)):
			continue
		if (not J.t(J.gp(J.G.get("SPR"), v_k_19))):
			var _s10 = {"__p": env, "im": null}
			_s10["im"] = J.new_("Image", [])
			var _t5 = _s10["im"]
			var _t7 = Callable(self, "_f4").bind(_s10)
			J.sp(_t5, "onload", _t7)
			var _t8 = _s10["im"]
			J.sp(_t8, "src", v_src_20)
			var _t9 = J.G.get("SPR")
			var _t10 = _s10["im"]
			J.sp(_t9, v_k_19, _t10)
		var _t11 = J.gp(J.G.get("ART"), "CHAR_H")
		var _t12 = J.gp(env["H"], v_k_19)
		J.sp(_t11, v_k_19, _t12)

func _f2(this_, a: Array, env):
	var v_v_16 = null
	v_v_16 = J.arg(a, 0)
	return J.round(J.num(J.mul(v_v_16, J.gp(J.gp(env["__p"]["TIER"], env["t"]), "k"))))

func _f5(this_, a: Array, env):
	var v_d_22 = null
	v_d_22 = J.arg(a, 0)
	return J.gp(v_d_22, 0.0)

func _f1(this_, a: Array, env):
	var v_DEF_2 = null; var v_ZH_3 = null; var v_hook_6 = null; var v_k_7 = null; var v_name_8 = null; var v_title_9 = null; var v_base_10 = null; var v_sk_12 = null; var v_trait_13 = null; var v_lore_14 = null; var v_say_15 = null
	var _s2 = {"__p": env, "TIER": null, "H": null}
	v_hook_6 = Callable(self, "_f3").bind(_s2)
	v_DEF_2 = [["pg_tuimo", "推磨鬼", "幫人推磨推到死第二次", [70.0, 50.0, 60.0], 1.0, {"name": "推磨轉轉轉", "kind": "aoe", "mult": 0.8, "apply": "push", "desc": "推住石磨原地轉圈，磨到全場頭暈。"}, "派去包子鋪磨麵粉，一個頂三個，但係要人讚佢。", "《幽明錄·新死鬼》：新死嘅鬼餓到皮包骨，舊鬼教佢去人哋屋企推磨扮靈驗，佢推咗成晚，主人家只當係老天幫手，一粒米都冇畀。", "我推咗成晚磨，佢哋話係「老天爺幫手」。……我呢份功勞，又俾人攞咗。"], ["pg_songding", "被賣鬼", "畀宋定伯賣咗一千五百錢", [55.0, 75.0, 50.0], 2.0, {"name": "變羊回馬槍", "kind": "hit", "mult": 1.7, "apply": "down", "desc": "一變成羊衝過去頂人，頂完先記得自己係鬼。"}, "講嘢好信人。去冥街買嘢，人哋講乜價佢都照畀。", "《列異傳》／《搜神記·宋定伯捉鬼》：書生宋定伯夜行遇鬼，自稱新鬼，問出鬼最怕人吐口水，揹住隻鬼入市集，鬼變成羊，佢就將隻羊賣咗一千五百錢。", "我教佢點做鬼，佢教我點做羊。最後收錢嗰個係佢。"], ["pg_ji", "聻", "鬼死咗之後嘅鬼", [45.0, 50.0, 90.0], 3.0, {"name": "死多一次", "kind": "aoe", "mult": 0.7, "sap": 25.0, "desc": "淡到幾乎睇唔見，所到之處連鬼都覺得好攰，全場削能量。"}, "透明到冼小姐點名時次次記佢缺席。", "《聊齋志異·章阿端》：「人死為鬼，鬼死為聻。鬼之畏聻，猶人之畏鬼也。」鬼都怕佢。", "我做人做到死，做鬼又做到死。而家我係聻……下一份工係乜，冇人話我知。"], ["pg_ex", "前女友鬼", "拍拖七年，佢只係回「哦」", [60.0, 55.0, 70.0], 2.0, {"name": "我有講錯嗎", "kind": "aoe", "mult": 0.75, "apply": "down", "desc": "一句「我有講錯嗎？」全場啞口無言，跪低。"}, "住喺升降機入面，每層都停。冇人敢話佢。", "黑色靈異脫口秀 KS111《鬼可以趕，債趕不走》：分手第二日打邊爐，一粒魚蛋鯁死。之後住喺佢屋企部升降機，師傅嚟到話「唔係鬧鬼，係討債」。", "七年。我講咩佢都係「哦」。我有講錯嗎？"], ["pg_landlady", "二房東", "一間屋劏十間房", [75.0, 60.0, 55.0], 3.0, {"name": "我講第二次", "kind": "aoe", "mult": 0.85, "steal": 20.0, "apply": "push", "desc": "大聲宣讀屋規，全場被罰款；講第二次嗰陣仲會加租。"}, "派佢管倉庫，每格都劏開兩格。", "黑色靈異脫口秀 KS115《我講第二次》：文良港三層排屋劏十間房，每間五百。十一點後唔准沖涼、有嘢 WhatsApp。連自己間房都租埋出去，瞓雜物房唔開冷氣，三十六度焗死。佢個自動回覆「收到」，之後仲覆咗半年。", "十一點之後唔准沖涼。我講第二次！"]]
	v_ZH_3 = {"派去包子鋪磨麵粉，一個頂三個，但係要人讚佢。": "派去包子鋪磨麵粉，一個頂三個，但要有人誇他。", "《幽明錄·新死鬼》：新死嘅鬼餓到皮包骨，舊鬼教佢去人哋屋企推磨扮靈驗，佢推咗成晚，主人家只當係老天幫手，一粒米都冇畀。": "《幽明錄·新死鬼》：新死的鬼餓得皮包骨，老鬼教他去人家家裡推磨顯靈，他推了一整晚，主人家只當是老天幫忙，一粒米都沒給。", "我推咗成晚磨，佢哋話係「老天爺幫手」。……我呢份功勞，又俾人攞咗。": "我推了一整晚的磨，他們說是「老天爺幫忙」。……我的功勞，又被拿走了。", "講嘢好信人。去冥街買嘢，人哋講乜價佢都照畀。": "很容易相信人。去冥街買東西，人家開什麼價他都照付。", "《列異傳》／《搜神記·宋定伯捉鬼》：書生宋定伯夜行遇鬼，自稱新鬼，問出鬼最怕人吐口水，揹住隻鬼入市集，鬼變成羊，佢就將隻羊賣咗一千五百錢。": "《列異傳》／《搜神記·宋定伯捉鬼》：宋定伯夜行遇鬼，自稱新鬼，問出鬼最怕人吐口水，背著鬼進市集，鬼變成羊，他就把羊賣了一千五百錢。", "我教佢點做鬼，佢教我點做羊。最後收錢嗰個係佢。": "我教他怎麼當鬼，他教我怎麼當羊。最後收錢的是他。", "透明到冼小姐點名時次次記佢缺席。": "透明到冼小姐點名時每次都記他缺席。", "《聊齋志異·章阿端》：「人死為鬼，鬼死為聻。鬼之畏聻，猶人之畏鬼也。」鬼都怕佢。": "《聊齋志異·章阿端》：「人死為鬼，鬼死為聻。鬼之畏聻，猶人之畏鬼也。」連鬼都怕他。", "我做人做到死，做鬼又做到死。而家我係聻……下一份工係乜，冇人話我知。": "我做人做到死，做鬼又做到死。現在我是聻……下一份工作是什麼，沒人告訴我。", "住喺升降機入面，每層都停。冇人敢話佢。": "住在電梯裡，每層都停。沒人敢說她。", "黑色靈異脫口秀 KS111《鬼可以趕，債趕不走》：分手第二日打邊爐，一粒魚蛋鯁死。之後住喺佢屋企部升降機，師傅嚟到話「唔係鬧鬼，係討債」。": "黑色靈異脫口秀 KS111《鬼可以趕，債趕不走》：分手第二天吃火鍋，被一顆魚丸噎死。之後住進他家的電梯，師傅來了說「不是鬧鬼，是討債」。", "七年。我講咩佢都係「哦」。我有講錯嗎？": "七年。我說什麼他都是「哦」。我有說錯嗎？", "派佢管倉庫，每格都劏開兩格。": "派她管倉庫，每格都隔成兩格。", "黑色靈異脫口秀 KS115《我講第二次》：文良港三層排屋劏十間房，每間五百。十一點後唔准沖涼、有嘢 WhatsApp。連自己間房都租埋出去，瞓雜物房唔開冷氣，三十六度焗死。佢個自動回覆「收到」，之後仲覆咗半年。": "黑色靈異脫口秀 KS115《我講第二次》：文良港三層排屋隔成十間房，每間五百。十一點後不准洗澡、有事 WhatsApp。連自己的房間都租出去，睡雜物房不開冷氣，三十六度悶死。她的自動回覆「收到」，之後還回了半年。", "十一點之後唔准沖涼。我講第二次！": "十一點之後不准洗澡。我說第二次！", "唔好抬頭。我話你知，你一望，我就高多截。": "不要抬頭。我告訴你，你一看，我就高一截。", "國家銀行每開一次會我就高一次，一連高咗三十五年。": "國家銀行每開一次會我就高一次，連續高了三十五年。"}
	_s2["TIER"] = {"1": {"k": 1.0, "en": [1.7, 1.25]}, "2": {"k": 1.25, "en": [2.3, 1.35]}, "3": {"k": 1.15, "en": [2.9, 1.5]}}
	for _t13 in J.iter(v_DEF_2):
		var _s3 = {"__p": _s2, "t": null}
		var _t14 = J.gp(_t13, 0.0)
		v_k_7 = _t14
		var _t15 = J.gp(_t13, 1.0)
		v_name_8 = _t15
		var _t16 = J.gp(_t13, 2.0)
		v_title_9 = _t16
		var _t17 = J.gp(_t13, 3.0)
		v_base_10 = _t17
		var _t18 = J.gp(_t13, 4.0)
		_s3["t"] = _t18
		var _t19 = J.gp(_t13, 5.0)
		v_sk_12 = _t19
		var _t20 = J.gp(_t13, 6.0)
		v_trait_13 = _t20
		var _t21 = J.gp(_t13, 7.0)
		v_lore_14 = _t21
		var _t22 = J.gp(_t13, 8.0)
		v_say_15 = _t22
		var _t23 = J.G.get("GHOSTS")
		var _t24 = {"name": v_name_8, "title": v_title_9, "q": "名", "base": J.mc(v_base_10, "map", [Callable(self, "_f2").bind(_s3)]), "range": "melee", "trait": v_trait_13, "lore": v_lore_14, "say": v_say_15, "pg": true}
		J.sp(_t23, v_k_7, _t24)
		var _t25 = J.G.get("SKILLS")
		J.sp(_t25, v_k_7, v_sk_12)
		var _t26 = J.G.get("ENEMY_T")
		var _t27 = [J.gp(J.gp(J.gp(_s3["__p"]["TIER"], _s3["t"]), "en"), 0.0), J.gp(J.gp(J.gp(_s3["__p"]["TIER"], _s3["t"]), "en"), 1.0), v_name_8]
		J.sp(_t26, v_k_7, _t27)
	if J.t(J.gp(J.G.get("GHOSTS"), "n30_hantugalah")):
		var _t28 = J.gp(J.G.get("GHOSTS"), "n30_hantugalah")
		J.sp(_t28, "say", "唔好抬頭。我話你知，你一望，我就高多截。")
		var _t29 = J.gp(J.G.get("GHOSTS"), "n30_hantugalah")
		var _t30 = J.add(J.gp(_t29, "lore"), "　黑色靈異脫口秀 KS08《不要抬頭》：佢其實好懶，成日望地下；越多人望佢就越高，「國家銀行每開一次會我就高一次，一連高咗三十五年」，同吉隆坡樓價一樣。")
		J.sp(_t29, "lore", _t30)
		var _t31 = J.gp(J.gp(J.G.get("GHOSTS"), "n30_hantugalah"), "lore")
		var _t32 = J.gp(J.gp(J.G.get("GHOSTS"), "n30_hantugalah"), "lore")
		var _t33 = J.mc(_t32, "replace", ["佢其實好懶，成日望地下；越多人望佢就越高，「國家銀行每開一次會我就高一次，一連高咗三十五年」，同吉隆坡樓價一樣。", "他其實很懶，整天看地上；越多人看他就越高，「國家銀行每開一次會我就高一次，連續高了三十五年」，跟吉隆坡房價一樣。"])
		J.sp(v_ZH_3, _t31, _t33)
	if (not J.seq(J.typeof_(J.G.get("LANG")), "undefined")):
		J.mc(J.G.get("LANG"), "add", [v_ZH_3])
	_s2["H"] = {"pg_tuimo": 58.0, "pg_songding": 58.0, "pg_ji": 54.0, "pg_ex": 60.0, "pg_landlady": 60.0}
	J.cl(v_hook_6, null, [])
	return {"keys": J.mc(v_DEF_2, "map", [Callable(self, "_f5").bind(_s2)]), "hook": v_hook_6}
