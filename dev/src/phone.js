// ===================== 手機（仿 WhatsApp）：開場與主選單 =====================
const ICON = {
  back:'<svg viewBox="0 0 24 24"><path d="M15 5 8 12l7 7" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/></svg>',
  video:'<svg viewBox="0 0 24 24"><rect x="3" y="7" width="12" height="10" rx="2" fill="none" stroke="currentColor" stroke-width="1.8"/><path d="m15 11 6-3v8l-6-3" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/></svg>',
  call:'<svg viewBox="0 0 24 24"><path d="M6.6 3.5 9 6.8 7.4 9c1 2.5 3 4.5 5.6 5.6l2.2-1.6 3.3 2.4-1 3.1c-.3.8-1.1 1.3-2 1.1C9.3 18.6 5.4 14.7 3.4 8.5c-.2-.9.3-1.7 1.1-2z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/></svg>',
  dots:'<svg viewBox="0 0 24 24"><circle cx="12" cy="5" r="1.8" fill="currentColor"/><circle cx="12" cy="12" r="1.8" fill="currentColor"/><circle cx="12" cy="19" r="1.8" fill="currentColor"/></svg>',
  cam:'<svg viewBox="0 0 24 24"><path d="M4 8h3l2-3h6l2 3h3v11H4z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/><circle cx="12" cy="13" r="3.4" fill="none" stroke="currentColor" stroke-width="1.8"/></svg>',
  smile:'<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" stroke-width="1.8"/><circle cx="9" cy="10" r="1.2" fill="currentColor"/><circle cx="15" cy="10" r="1.2" fill="currentColor"/><path d="M8 14.5c2 2 6 2 8 0" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>',
  clip:'<svg viewBox="0 0 24 24"><path d="m15.5 7-7 7a2 2 0 0 0 2.8 2.8l7.5-7.5a3.6 3.6 0 0 0-5-5L6.2 11.9a5 5 0 0 0 7.1 7.1l6-6" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>',
  mic:'<svg viewBox="0 0 24 24"><rect x="9" y="3" width="6" height="11" rx="3" fill="currentColor"/><path d="M5.5 11a6.5 6.5 0 0 0 13 0M12 17.5V21" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>',
  send:'<svg viewBox="0 0 24 24"><path d="M4 12 20 4l-4 16-4-6.5z" fill="currentColor"/><path d="m12 13.5 8-9.5" stroke="#0b141a" stroke-width="1.4"/></svg>',
  pin:'<svg viewBox="0 0 24 24"><path d="M9 3h6l-1 6 3 3H7l3-3zM12 12v9" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/></svg>',
  mute:'<svg viewBox="0 0 24 24"><path d="M4 9h4l5-4v14l-5-4H4z" fill="currentColor"/><path d="m16 9 5 6m0-6-5 6" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>',
  chat:'<svg viewBox="0 0 24 24"><path d="M4 5h16v11H9l-5 4z" fill="currentColor"/><path d="M8 9.5h8M8 12.5h5" stroke="#00a884" stroke-width="1.6" stroke-linecap="round"/></svg>',
};
const TICK = (blue, two) => `<span class="tk${blue ? ' blue' : ''}">${two ? '✓✓' : '✓'}</span>`;
function waAvatar(av, size) {
  if (av === 'sys') { const c = ART.sysIcon(size * 2); return `<span class="av sys" style="width:${size}px;height:${size}px"><img src="${c.toDataURL()}" alt=""></span>`; }
  return `<span class="av" style="width:${size}px;height:${size}px;background:${av[1]};font-size:${Math.round(size * 0.42)}px">${av[0]}</span>`;
}
function waStatus(time, batt, low) {
  return `<div class="wa-status"><b>${time}</b><span class="wa-sig"><i></i><i></i><i></i><i></i></span><span class="wa-batt ${low ? 'low' : ''}"><em style="width:${low ? 8 : 70}%"></em></span><small>${batt}</small></div>`;
}
const pad2 = (n) => (n < 10 ? '0' : '') + n;
function nowHM() { const d = new Date(); return pad2(d.getHours()) + ':' + pad2(d.getMinutes()); }

// ---------------- 聊天內容 ----------------
// 生前：凌晨兩點十三分
const CHATS_PRE = [
  { id:'boss', name:'黃總', av:['黃','#5a6a7a'], time:'02:13', unread:1, prev:'阿福，明早九點董事會，PPT 要再改。', main:true },
  { id:'q3', name:'Q3 衝刺作戰群', av:['群','#6a5a3a'], time:'02:11', unread:47, mute:true, prev:'Kelvin：收到 👍', sub:'黃總、Kelvin、Jessica、你',
    msgs:[['黃總','01:58','誰還沒睡？'],['Kelvin','01:59','我 👋'],['黃總','02:01','很好。有狼性。'],['Jessica','02:03','黃總，我老公在醫院，可以明天再交嗎？'],['黃總','02:04','醫院有 Wi-Fi 嗎？'],['Jessica','02:10','有……'],['Kelvin','02:11','收到 👍']] },
  { id:'mom', name:'媽', av:['媽','#b06a5a'], time:'星期日', unread:2, prev:'阿福，那下個月呢？',
    msgs:[['媽','星期三 19:02','阿福，最近天天下大雨，出門記得帶傘。'],['我','星期三 23:40','嗯'],['媽','星期五 20:15','你爸說想你了。他不會說，但我知道。'],['媽','星期五 20:16','這個月回來吃飯嗎？'],['我','星期六 01:22','下次吧，最近很忙'],['媽','星期日 18:30','媽煲了你最愛的蓮藕湯，給你留了一碗。'],['媽','星期日 21:04','阿福，那下個月呢？']], hold:'（你打算明天再回）' },
  { id:'ins', name:'保險經紀 阿明', av:['明','#3a6a8a'], time:'上星期', prev:'不用了，我還年輕。', mine:true,
    msgs:[['阿明','上星期 14:20','陳先生您好！人生無常，有沒有興趣看看我們的人壽保險？'],['阿明','上星期 14:21','特別適合常常 OT 的專業人士 😊'],['我','上星期 23:58','不用了，我還年輕。']] },
  { id:'food', name:'外賣 Abang Ali', av:['A','#8a6a2a'], time:'21:47', prev:'Boss, makanan saya letak depan pintu ya 🙏',
    msgs:[['Abang Ali','21:46','Boss, dah sampai. Tekan loceng takde orang.'],['Abang Ali','21:47','Boss, makanan saya letak depan pintu ya 🙏']] },
  { id:'land', name:'房東 Mr. Lim', av:['林','#5a5a5a'], time:'昨天', prev:'下個月開始屋租起 RM200，水電費自己 settle 哦。',
    msgs:[['Mr. Lim','昨天 10:02','阿福，下個月開始屋租起 RM200，水電費自己 settle 哦。'],['Mr. Lim','昨天 10:03','反正你整天在公司，應該沒所謂吧？']] },
  { id:'gym', name:'FitLife 健身中心', av:['F','#2a7a5a'], time:'昨天', prev:'Hi 陳先生！您已經 3 年沒來了，現在 renew 打 8 折哦！',
    msgs:[['FitLife','昨天 09:00','Hi 陳先生！您已經 3 年沒來了，現在 renew 打 8 折哦！'],['FitLife','昨天 09:01','健康是最好的投資 💪']] },
  { id:'clinic', name:'康健診所', av:['診','#4a7a8a'], time:'3 星期前', prev:'您的體檢報告出來了，請盡快回來見醫生。',
    msgs:[['康健診所','3 星期前','陳先生，您的體檢報告出來了，請盡快回來見醫生。'],['康健診所','2 星期前','提醒：您的報告有幾項指數不太好，請盡快回來見醫生。']] },
];
// 死後：陰間版（內容隨劇情進度改變）
function chatsPost() {
  const sn = (id) => !!S.seen[id]; const out = [];
  out.push({ id:'kpi', name:S.ended ? '陰司好好系統' : '陰司 KPI 系統', av:'sys', time:nowHM(), unread:1, pin:true, main:true,
    prev:S.ended ? '親，今天沒有 KPI，想來就來。' : '親，鬼怪們都在等你上班哦～' });
  // 媽
  const mm = [['媽','頭七','阿福，頭七了。媽給你燒了一個傭人，叫小紙，你別欺負人家。']];
  if (sn('gift_phone')) mm.push(['媽','清明前','手機收到了嗎？店家說下面也能用 WhatsApp。'], ['媽','清明前','媽不知道你看不看得到，就當媽自言自語吧。']);
  if (sn('ch3_end')) mm.push(['媽','中元前','媽幫你看了一塊新的地，坐北向南，前面有樹，風水第一流。'], ['媽','中元前','負責的人說前面是垃圾場。媽跟他講：那叫聚財。']);
  if (sn('gift_car')) mm.push(['媽','中元節','車也燒給你了，你開慢點。生前你那麼急，現在慢慢來。']);
  if (sn('epilogue')) mm.push(['媽','清明','媽給你燒了一張假條。這次你一定要放。'], ['我','清明','媽，我不忙了。'], ['媽','清明','……阿福？']);
  const last = mm[mm.length - 1];
  out.push({ id:'mom2', name:'媽', av:['媽','#b06a5a'], time:last[1], unread:sn('epilogue') ? 0 : mm.filter(m => m[0] === '媽').length, prev:(last[0] === '我' ? '' : '') + last[2], mine:last[0] === '我', msgs:mm, hold:sn('epilogue') ? '' : '（訊息傳不出去：對方在陽間）' });
  // 黃總
  const bm = [['黃總','02:47','好？句號呢？'], ['黃總','09:12','阿福？董事會開始了。'], ['黃總','09:40','阿福你人呢？'], ['黃總','下午 3:03','HR 說你過世了。節哀。'], ['黃總','下午 3:04','PPT 誰接手？密碼是什麼？']];
  if (sn('ch6_end')) bm.push(['黃總','最近','阿福，我在村裡學包包子。'], ['黃總','最近','很難。我包了一百個，孟婆說九十九個不合格。'], ['黃總','最近','剩下那一個是我自己。']);
  const bl = bm[bm.length - 1]; out.push({ id:'boss2', name:'黃總', av:['黃','#5a6a7a'], time:bl[1], unread:sn('ch6_end') ? 3 : 2, prev:bl[2], msgs:bm, hold:'（你已離職，無法回覆此對話）' });
  // 村民群
  if (sn('ch2_intro')) {
    const gm = [['小紙','早上','今天的壽包誰偷吃了？少了三個。'], ['餓鬼王','早上','不是我，我的喉嚨只能一次吞一粒米。']];
    if (sn('ch2_end')) gm.push(['Toyol','早上','也不是我！我只偷錢，不偷吃的！'], ['小紙','早上','……你剛剛承認了什麼？']);
    if (sn('ch3_end')) gm.push(['老殭','中午','本官昨夜跳去人間，看見有人在跳廣場舞。'], ['老殭','中午','他們跳得比本官還僵硬。']);
    if (sn('ch4_end')) gm.push(['Pontianak','晚上','誰把我的香蕉拿去做香蕉煎餅了？'], ['餓鬼王','晚上','……好吃。']);
    if (sn('ch5_end')) gm.push(['Penanggal','半夜','提醒大家：倉庫那缸醋是我的，不是調味料。誰再拿去沾餃子，我就飛過去。'], ['Pocong','半夜','（舉手）']);
    if (sn('ch6_mengpo')) gm.push(['孟婆','半夜','今晚湯底換了，喝了不會忘事，只會忘記熱量。']);
    const gl = gm[gm.length - 1];
    out.push({ id:'vg', name:'落魄村村民群', av:['群','#3f6a5a'], time:gl[1], unread:gm.length, mute:true, prev:gl[0] + '：' + gl[2], sub:'小紙、餓鬼王、你…', msgs:gm });
  }
  if (sn('ch6_end')) out.push({ id:'opt', name:'落魄村優化小組', av:['優','#7a4a3a'], time:'00:00', unread:2, mute:true, prev:'黃總：不要給我藉口。', sub:'黃總、你…', msgs:[['黃總','23:58','明天早上，大家提早半個小時出來。'], ['黃總','23:59','KPI：每隻鬼每天嚇三個人。'], ['小紙','00:00','黃總，我們是鬼，早上不能出來的。'], ['黃總','00:00','不要給我藉口。']], hold:'（已讀。你決定不回。）' });
  out.push({ id:'ins2', name:'保險經紀 阿明', av:['明','#3a6a8a'], time:'上個月', unread:2, prev:'那份人壽保險……現在買還來得及嗎？',
    msgs:[['我','很久以前','不用了，我還年輕。'], ['阿明','上個月','陳先生，聽說您走了，節哀。'], ['阿明','上個月','那份人壽保險……現在買還來得及嗎？']] });
  out.push({ id:'land2', name:'房東 Mr. Lim', av:['林','#5a5a5a'], time:'上個月', unread:2, prev:'Deposit 不還了。',
    msgs:[['Mr. Lim','上個月','阿福，你在屋裡走的，現在變凶宅，租不出了 lah。'], ['Mr. Lim','上個月','Deposit 不還了。'], ['Mr. Lim','上星期','還有，這個月的屋租你還沒給。']] });
  out.push({ id:'gym2', name:'FitLife 健身中心', av:['F','#2a7a5a'], time:'今天', unread:2, prev:'違約金 RM1,200，可以分期哦 🙏',
    msgs:[['FitLife','昨天','陳先生，系統顯示您已 3 年 2 個月未到店。'], ['FitLife','昨天','請問您還活著嗎？若否，請回覆 0 取消會籍。'], ['FitLife','今天','收到您家人的通知，節哀。提早取消會籍的違約金 RM1,200，可以分期哦 🙏']] });
  out.push({ id:'food2', name:'外賣 Abang Ali', av:['A','#8a6a2a'], time:'上個月', prev:'Boss, makanan masih depan pintu… dah berkulat 😅',
    msgs:[['Abang Ali','21:47','Boss, makanan saya letak depan pintu ya 🙏'], ['Abang Ali','三天後','Boss, makanan masih depan pintu… dah berkulat 😅'], ['Abang Ali','三天後','Tapi tolong bagi 5 bintang ya boss 🙏']] });
  out.push({ id:'tel', name:'地府電訊', av:['冥','#6a3a3a'], time:'每月一號', prev:'您的「永生無限」月租計劃已自動續約。',
    msgs:[['地府電訊','每月一號','您的「永生無限」月租計劃已自動續約：每月 100 億冥幣，請家屬按時焚燒。'], ['地府電訊','每月一號','溫馨提示：陽間來電一律轉接至語音信箱。']] });
  out.push({ id:'clinic2', name:'康健診所', av:['診','#4a7a8a'], time:'上個月', prev:'建議您多休息。',
    msgs:[['康健診所','3 星期前','陳先生，您的體檢報告出來了，請盡快回來見醫生。'], ['康健診所','上個月','因為您一直沒回來複診，報告已經寄到府上：建議您多休息。']] });
  return out;
}

// ---------------- 手機畫面 ----------------
const Phone = {
  on:false, phase:'pre',
  el() { return $('#phone'); },
  home(phase) {
    this.on = true; this.phase = phase;
    const el = this.el(); el.className = 'on';
    const pre = phase === 'pre', list = pre ? CHATS_PRE : chatsPost();
    const time = pre ? '02:13' : nowHM();
    let h = `<div class="wa">${waStatus(time, pre ? '3%' : '∞', pre)}
      <div class="wa-top"><b>WhatsApp</b>${pre ? '' : '<i class="hell">陰間版</i>'}<button class="wa-snd" aria-label="聲音">${Sound.isOn() ? '🔊' : '🔇'}</button><span class="ic">${ICON.cam}</span><span class="ic">${ICON.dots}</span></div>
      <div class="wa-search">在 WhatsApp 中搜尋…</div>
      <div class="wa-chips"><span class="on">全部</span><span>未讀 ${list.filter(c => c.unread).length}</span><span>群組</span></div>
      <div class="wa-list">`;
    for (const c of list) {
      h += `<div class="wa-row ${c.main ? 'main' : ''}" data-id="${c.id}">${waAvatar(c.av, 50)}
        <div class="wr-mid"><div class="wr-l1"><b>${c.name}</b><small class="${c.unread ? 'g' : ''}">${c.time}</small></div>
        <div class="wr-l2"><span>${c.mine ? TICK(true, true) + ' ' : ''}${c.prev}</span>${c.pin ? `<i class="pin">${ICON.pin}</i>` : ''}${c.mute ? `<i class="mut">${ICON.mute}</i>` : ''}${c.unread ? `<em>${c.unread}</em>` : ''}</div></div></div>`;
    }
    h += `<div class="wa-lockline">${pre ? '🔒 你的個人訊息已受端對端加密保護' : '🔒 訊息已陰陽兩界加密，活人看不到'}</div></div>
      <button class="wa-fab" aria-label="新對話">${ICON.chat}</button>
</div>`;
    el.innerHTML = h;
    el.querySelectorAll('.wa-row').forEach(r => r.onclick = () => { Sound.play('click'); this.openChat(list.find(c => c.id === r.dataset.id)); });
    el.querySelector('.wa-snd').onclick = (e) => { e.stopPropagation(); const on = Sound.toggle(); e.target.textContent = on ? '🔊' : '🔇'; };
    Sound.setMode(pre ? 'office' : 'story');
  },
  openChat(c) {
    if (c.main) { this.enter(); return; }
    const pre = this.phase === 'pre';
    const el = this.el();
    let h = `<div class="wa wa-chat">${waStatus(pre ? '02:13' : nowHM(), pre ? '3%' : '∞', pre)}
      <div class="wa-head"><span class="wa-back">${ICON.back}</span>${waAvatar(c.av, 38)}<div class="wa-who"><b>${c.name}</b><small>${c.sub || (pre ? '最後上線時間：今天' : '最後上線時間：很久以前')}</small></div><span class="ic">${ICON.video}</span><span class="ic">${ICON.call}</span><span class="ic">${ICON.dots}</span></div>
      <div class="wa-body"><div class="wa-lock">${pre ? '🔒 訊息和通話皆已端對端加密。' : '🔒 訊息已陰陽兩界加密。'}</div>`;
    let lastDay = '';
    for (const [who, when, text] of c.msgs) {
      const day = when.split(' ')[0]; if (when.includes(' ') && day !== lastDay) { h += `<div class="wa-day">${day}</div>`; lastDay = day; }
      const tm = when.includes(' ') ? when.split(' ')[1] : when; const me = who === '我';
      h += `<div class="bub ${me ? 'me' : 'them'}">${c.sub && !me ? `<b class="nm">${who}</b>` : ''}<span>${text}</span><i>${tm}${me ? ' ' + TICK(true, true) : ''}</i></div>`;
    }
    h += `</div><div class="wa-input"><div class="wa-field dim">${ICON.smile}<span class="wa-txt">${c.hold || '輸入訊息'}</span>${ICON.clip}</div><button class="wa-send">${ICON.mic}</button></div></div>`;
    el.innerHTML = h;
    const body = el.querySelector('.wa-body'); body.scrollTop = body.scrollHeight;
    el.querySelector('.wa-back').onclick = () => { Sound.play('click'); this.home(this.phase); };
  },
  enter() {
    const pre = this.phase === 'pre';
    this.close();
    if (pre) { ['prologue_chat', 'prologue_narr', 'prologue_road', 'prologue_sys'].forEach(id => Story.queue(id)); }
    else { offlineGain(); Sound.setMode('village'); }
  },
  close() { this.on = false; this.el().className = ''; this.el().innerHTML = ''; },
};

// ===================== 封面：《過勞鬼大作戰》 =====================
const Title = {
  show(fresh) {
    const el = $('#title'); el.className = 'on';
    const cover = SPR_SRC.cover || '', bNew = SPR_SRC.btn_new || '', bCont = SPR_SRC.btn_cont || '';
    const hasSave = !fresh;
    el.innerHTML = `<div class="tt-cover" style="background-image:url(${cover})"></div>
      <div class="tt-fog"></div>
      <div class="tt-btns">
        <button class="tt-btn" id="tt-new" aria-label="開始新遊戲">${bNew ? `<img src="${bNew}" alt="">` : '<span>開始新遊戲</span>'}</button>
        <button class="tt-btn ${hasSave ? '' : 'off'}" id="tt-cont" aria-label="繼續遊戲">${bCont ? `<img src="${bCont}" alt="">` : '<span>繼續遊戲</span>'}</button>
        <small class="tt-hint" id="tt-hint">${hasSave ? '' : '還沒有存檔'}</small>
      </div>
      <button class="tt-snd" aria-label="聲音">${Sound.isOn() ? '🔊' : '🔇'}</button>`;
    Sound.setMode('story');
    el.querySelector('.tt-snd').onclick = (e) => { e.stopPropagation(); const on = Sound.toggle(); e.target.textContent = on ? '🔊' : '🔇'; };
    $('#tt-cont').onclick = () => { if (!hasSave) { Sound.play('click'); return; } Sound.play('gong'); this.hide(); Phone.home('post'); };
    $('#tt-new').onclick = (e) => {
      if (hasSave && !$('#tt-new').dataset.armed) {
        $('#tt-new').dataset.armed = 1; $('#tt-hint').textContent = '會刪掉現在的存檔。再點一次「開始新遊戲」確定。';
        setTimeout(() => { delete $('#tt-new').dataset.armed; $('#tt-hint').textContent = ''; }, 3500); Sound.play('click'); return;
      }
      Sound.play('gong');
      if (hasSave) { try { localStorage.removeItem(SAVE_KEY); } catch (er) {} S = newState(); const d = newState(); for (const k in d) S[k] = d[k]; save(); }
      this.hide(); Phone.home('pre');
    };
  },
  hide() { const el = $('#title'); el.className = ''; el.innerHTML = ''; },
};
