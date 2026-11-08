// ===================== 新鬼 40 隻：原圖變形骨架（MeshAnim）＋走路／待機方式 =====================
// 還沒進名冊：主公挑 30 隻之後再放進 data.js。每隻自成一條（下面 G('id', {...}) 一行）：
//   刪一隻 = 刪這裡那一行（招式 n30_moves.js、平日 n30_daily.js 的同名條目沒被呼叫就不會跑，可一併刪；art/pack.py 的 N30 名單刪名字）。
// 只動原圖：整張原圖網格變形；招式要用的件是 art/n30cut.py 從原圖剪下來的（cut/n30_<id>__<件>.png + __fill 補丁）。
// rig 欄位（原圖比例 0~1，跟 MeshAnim.mk 一樣）：c 身體中線x、n 脖子y、h 頭x、ht 頭頂y、hr 頭半徑、L/R 畫面左右手 [肩x,肩y,手x,手y]、
//   legs [髖y, 左腳x, 右腳x] 或 tail 尾尖x、hair [左x, 右x]；x = 額外骨頭 [名, 父, 支點x,y, 末端x,y, 半徑]；bones = 整套自訂骨頭。
// loco：走路／待機方式  float 飄、onefoot 單腳跳、bottle 瓶子跳、stride 長腿跨步、neck 長脖子搖、heavy 笨重、skitter 蟲爬、creep 駝背潛行、drunk 醉、shiver 發抖、stumble 冒失
// sec：次要擺動 { 骨頭: [幅度, 頻率, 相位] }（頭髮、飾物、翅膀、尾巴、繩子…）
const N30 = (() => {
  const DEF = {};
  const G = (id, d) => { DEF[id] = d; };
  G('diaosi',      { zh:'吊死鬼', h:60, solid:1, loco:'creep', rig:{ c:0.50, n:0.36, ht:0.03, hr:0.30, L:[0.30, 0.48, 0.10, 0.66], R:[0.70, 0.48, 0.88, 0.66], legs:[0.78, 0.36, 0.62], hair:[0.14, 0.86], x:[['rope', 'head', 0.58, 0.42, 0.60, 0.58, 0.07]] }, sec:{ rope:[0.10, 2.2, 0.5] }, cut:['tongue'] });
  G('wutou',       { zh:'無頭鬼', h:62, solid:1, rig:{ c:0.38, n:0.24, h:0.34, ht:0.04, hr:0.16, L:[0.20, 0.36, 0.06, 0.62], R:[0.58, 0.36, 0.86, 0.58], legs:[0.84, 0.32, 0.52], x:[['held', 'armB', 0.72, 0.42, 0.74, 0.70, 0.17]] }, sec:{ head:[0.12, 1.4, 0] }, cut:['head'] });
  G('yecha',       { zh:'夜叉', h:66, solid:1, loco:'heavy', rig:{ c:0.56, n:0.40, h:0.62, ht:0.05, hr:0.30, L:[0.40, 0.44, 0.20, 0.50], R:[0.76, 0.46, 0.86, 0.68], legs:[0.74, 0.44, 0.74], hair:[0.40, 0.92] }, sec:{ hairL:[0.08, 1.7, 0], hairR:[0.10, 1.7, 1] }, cut:['trident'] });
  G('hanba',       { zh:'旱魃', h:60, solid:1, loco:'creep', rig:{ c:0.48, n:0.36, ht:0.02, hr:0.34, L:[0.32, 0.44, 0.08, 0.52], R:[0.66, 0.44, 0.92, 0.54], legs:[0.76, 0.42, 0.58], hair:[0.30, 0.66] } });
  G('changgui',    { zh:'倀鬼', h:62, solid:1, loco:'creep', rig:{ c:0.40, n:0.42, h:0.33, ht:0.03, hr:0.30, L:[0.30, 0.48, 0.04, 0.50], R:[0.58, 0.46, 0.64, 0.70], legs:[0.70, 0.30, 0.54], x:[['tiger', null, 0.80, 0.99, 0.79, 0.70, 0.15], ['tie', 'head', 0.60, 0.13, 0.76, 0.17, 0.07]] }, sec:{ tiger:[0.05, 3.1, 0] }, cut:['tiger'] });
  G('guixinniang', { zh:'鬼新娘', h:62, solid:0, loco:'float', rig:{ c:0.47, n:0.45, ht:0.02, hr:0.30, L:[0.24, 0.48, 0.30, 0.62], R:[0.64, 0.48, 0.56, 0.66], tail:0.48, hair:[0.08, 0.88] }, sec:{ hairL:[0.05, 1.3, 0], hairR:[0.05, 1.3, 1.2] }, cut:['ball'] });
  G('shanxiao',    { zh:'山魈', h:64, solid:1, loco:'onefoot', rig:{ bones:[
      ['hips', null, 0.48, 0.62, 0.48, 0.50, 0.22], ['legB', 'hips', 0.50, 0.64, 0.50, 0.98, 0.10], ['legF', 'hips', 0.40, 0.60, 0.33, 0.66, 0.09],
      ['body', 'hips', 0.47, 0.58, 0.45, 0.36, 0.26], ['head', 'body', 0.42, 0.36, 0.42, 0.04, 0.30],
      ['armF', 'body', 0.26, 0.40, 0.12, 0.86, 0.13], ['armB', 'body', 0.72, 0.40, 0.88, 0.86, 0.13],
      ['hairL', 'head', 0.16, 0.30, 0.10, 0.60, 0.12], ['hairR', 'head', 0.80, 0.30, 0.88, 0.60, 0.12]] } });
  G('baigujing',   { zh:'白骨精', h:64, solid:0, loco:'float', rig:{ c:0.48, n:0.32, h:0.45, ht:0.02, hr:0.28, L:[0.36, 0.38, 0.22, 0.30], R:[0.62, 0.40, 0.80, 0.66], tail:0.52, hair:[0.22, 0.72], x:[['orn', 'head', 0.84, 0.12, 0.85, 0.30, 0.06]] }, sec:{ orn:[0.14, 2.6, 0] } });
  G('qionggui',    { zh:'窮鬼', h:56, solid:0, loco:'float', rig:{ c:0.40, n:0.38, ht:0.02, hr:0.30, L:[0.26, 0.46, 0.10, 0.62], R:[0.56, 0.46, 0.66, 0.62], tail:0.30, x:[['moth', null, 0.84, 0.46, 0.84, 0.40, 0.07]] }, sec:{ moth:[0.25, 5, 0] }, cut:['moth'] });
  G('dugui',       { zh:'賭鬼', h:58, solid:0, loco:'float', rig:{ c:0.45, n:0.50, ht:0.04, hr:0.34, L:[0.30, 0.56, 0.15, 0.50], R:[0.66, 0.56, 0.84, 0.44], tail:0.25 }, cut:['dice'] });
  G('jiugui',      { zh:'酒鬼', h:58, solid:0, loco:'drunk', rig:{ c:0.40, n:0.36, h:0.32, ht:0.02, hr:0.30, L:[0.24, 0.42, 0.36, 0.52], R:[0.56, 0.40, 0.68, 0.48], tail:0.25, x:[['tie', 'head', 0.16, 0.16, 0.02, 0.20, 0.08]] } });
  G('yangui',      { zh:'煙鬼', h:58, solid:0, loco:'float', nr:1, rig:{ c:0.40, n:0.38, ht:0.03, hr:0.32, L:[0.30, 0.44, 0.34, 0.38], R:[0.50, 0.44, 0.64, 0.44], tail:0.34 } });
  G('guhangui',    { zh:'孤寒鬼', h:60, solid:1, loco:'creep', rig:{ c:0.46, n:0.42, h:0.40, ht:0.02, hr:0.30, L:[0.30, 0.48, 0.16, 0.36], R:[0.70, 0.50, 0.70, 0.64], legs:[0.78, 0.30, 0.55], x:[['orn', 'head', 0.83, 0.13, 0.83, 0.40, 0.06]] }, sec:{ orn:[0.12, 2.3, 0] }, cut:['abacus'] });
  G('taozhai',     { zh:'討債鬼', h:62, solid:1, loco:'heavy', rig:{ c:0.50, n:0.42, h:0.48, ht:0.03, hr:0.30, L:[0.30, 0.42, 0.17, 0.28], R:[0.72, 0.46, 0.80, 0.60], legs:[0.74, 0.34, 0.60], x:[['tie', 'head', 0.74, 0.27, 0.84, 0.38, 0.07], ['paper', 'armF', 0.12, 0.28, 0.12, 0.66, 0.11]] }, sec:{ paper:[0.06, 1.9, 0.4] }, cut:['bucket'] });
  G('danxiao',     { zh:'膽小鬼', h:56, solid:1, loco:'shiver', nr:1, rig:{ c:0.50, n:0.40, ht:0.02, hr:0.32, L:[0.32, 0.44, 0.60, 0.48], R:[0.66, 0.44, 0.40, 0.50], legs:[0.76, 0.40, 0.60], hair:[0.20, 0.82] } });
  G('maoshi',      { zh:'冒失鬼', h:58, solid:1, loco:'stumble', rig:{ c:0.42, n:0.42, h:0.30, ht:0.04, hr:0.30, L:[0.28, 0.46, 0.04, 0.42], R:[0.52, 0.44, 0.62, 0.40], legs:[0.66, 0.38, 0.62] } });
  G('hanturaya',   { zh:'Hantu Raya', h:76, solid:1, loco:'heavy', rig:{ c:0.48, n:0.28, ht:0.02, hr:0.26, L:[0.26, 0.32, 0.14, 0.82], R:[0.72, 0.32, 0.86, 0.82], legs:[0.62, 0.36, 0.62], hair:[0.08, 0.90] }, sec:{ hairL:[0.10, 1.2, 0], hairR:[0.10, 1.2, 1.5] } });
  G('polong',      { zh:'Polong', h:58, solid:1, loco:'bottle', rig:{ bones:[
      ['body', null, 0.48, 0.97, 0.48, 0.62, 0.30], ['tail1', 'body', 0.46, 0.58, 0.44, 0.44, 0.13], ['tail2', 'tail1', 0.44, 0.44, 0.40, 0.32, 0.12],
      ['head', 'tail2', 0.36, 0.33, 0.32, 0.03, 0.22], ['armF', 'tail1', 0.34, 0.40, 0.08, 0.43, 0.10], ['armB', 'tail1', 0.50, 0.42, 0.48, 0.52, 0.09],
      ['hairL', 'head', 0.18, 0.25, 0.08, 0.40, 0.10], ['hairR', 'head', 0.55, 0.15, 0.92, 0.40, 0.16]] }, sec:{ hairR:[0.10, 1.6, 0] }, cut:['spirit'] });
  G('pelesit',     { zh:'Pelesit', h:42, solid:1, loco:'skitter', rig:{ bones:[
      ['body', null, 0.60, 0.70, 0.30, 0.45, 0.30], ['head', 'body', 0.30, 0.45, 0.14, 0.45, 0.17],
      ['hairL', 'head', 0.22, 0.30, 0.42, 0.05, 0.10], ['hairR', 'head', 0.26, 0.30, 0.70, 0.08, 0.10],
      ['legF', 'body', 0.30, 0.66, 0.20, 0.95, 0.12], ['legB', 'body', 0.70, 0.50, 0.86, 0.96, 0.15], ['cape', 'body', 0.55, 0.40, 0.85, 0.45, 0.14]] } });
  G('jenglot',     { zh:'Jenglot', h:50, solid:1, loco:'creep', rig:{ c:0.45, n:0.40, h:0.42, ht:0.03, hr:0.30, L:[0.32, 0.44, 0.20, 0.74], R:[0.58, 0.44, 0.66, 0.72], legs:[0.78, 0.36, 0.56], x:[['hairL', 'head', 0.18, 0.30, 0.08, 0.86, 0.15], ['hairR', 'head', 0.76, 0.30, 0.88, 0.86, 0.15]] }, sec:{ hairL:[0.06, 1.3, 0], hairR:[0.06, 1.3, 1.1] } });
  G('hantugalah',  { zh:'Hantu Galah', h:86, solid:1, loco:'stride', nr:1, rig:{ c:0.46, n:0.24, h:0.55, ht:0.02, hr:0.40, L:[0.36, 0.28, 0.28, 0.50], R:[0.60, 0.28, 0.86, 0.36], legs:[0.50, 0.30, 0.62], hair:[0.24, 0.80], ar:0.18 } });
  G('jerangkung',  { zh:'Jerangkung', h:62, solid:1, loco:'creep', nr:1, rig:{ c:0.38, n:0.32, h:0.48, ht:0.03, hr:0.28, L:[0.36, 0.33, 0.06, 0.58], R:[0.50, 0.34, 0.92, 0.44], legs:[0.64, 0.18, 0.54], hair:[0.30, 0.66] }, cut:['arm'] });
  G('genderuwo',   { zh:'Genderuwo', h:70, solid:1, loco:'heavy', rig:{ c:0.50, n:0.34, ht:0.02, hr:0.30, L:[0.26, 0.40, 0.10, 0.78], R:[0.74, 0.40, 0.90, 0.74], legs:[0.74, 0.32, 0.66] } });
  G('bunian',      { zh:'Orang Bunian', h:62, solid:0, loco:'float', nr:1, rig:{ c:0.48, n:0.28, ht:0.02, hr:0.26, L:[0.34, 0.36, 0.14, 0.42], R:[0.60, 0.36, 0.86, 0.40], tail:0.52, hair:[0.32, 0.66] }, sec:{ hairL:[0.06, 1.2, 0], hairR:[0.06, 1.2, 1] } });
  G('maenak',      { zh:'Mae Nak', h:62, solid:1, rig:{ c:0.64, n:0.38, h:0.62, ht:0.02, hr:0.28, L:[0.56, 0.40, 0.06, 0.48], R:[0.78, 0.45, 0.88, 0.72], legs:[0.74, 0.55, 0.70], hair:[0.52, 0.90], ar:0.10 }, cut:['arm', 'hand'] });
  G('phiam',       { zh:'Phi Am', h:54, solid:1, loco:'heavy', rig:{ c:0.42, n:0.50, ht:0.08, hr:0.34, L:[0.20, 0.52, 0.14, 0.78], R:[0.62, 0.52, 0.60, 0.78], legs:[0.80, 0.20, 0.56], x:[['tie', 'head', 0.62, 0.16, 0.84, 0.25, 0.10]] } });
  G('churel',      { zh:'Churel', h:64, solid:1, rig:{ c:0.42, n:0.34, h:0.40, ht:0.02, hr:0.30, L:[0.30, 0.40, 0.14, 0.62], R:[0.62, 0.40, 0.66, 0.64], legs:[0.72, 0.42, 0.60], hair:[0.14, 0.86] }, sec:{ hairR:[0.06, 1.4, 0] } });
  G('vetala',      { zh:'Vetala', h:66, solid:1, loco:'creep', rig:{ c:0.46, n:0.34, h:0.36, ht:0.04, hr:0.28, L:[0.30, 0.40, 0.12, 0.48], R:[0.56, 0.40, 0.62, 0.62], legs:[0.72, 0.38, 0.64], x:[['cape', 'body', 0.70, 0.30, 0.88, 0.52, 0.12]] } });
  G('kappa',       { zh:'河童', h:54, solid:1, loco:'creep', rig:{ c:0.48, n:0.36, h:0.45, ht:0.02, hr:0.30, L:[0.36, 0.44, 0.16, 0.42], R:[0.62, 0.46, 0.62, 0.70], legs:[0.70, 0.32, 0.58] } });
  G('rokurokubi',  { zh:'轆轤首', h:62, solid:1, loco:'neck', rig:{ bones:[
      ['body', null, 0.68, 0.95, 0.64, 0.60, 0.30], ['neck1', 'body', 0.61, 0.58, 0.72, 0.36, 0.08], ['neck2', 'neck1', 0.72, 0.34, 0.48, 0.29, 0.08],
      ['head', 'neck2', 0.44, 0.30, 0.25, 0.10, 0.24], ['armF', 'body', 0.52, 0.64, 0.38, 0.78, 0.10], ['armB', 'body', 0.74, 0.64, 0.70, 0.80, 0.10]] }, cut:['head', 'neck'] });
  G('kuchisake',   { zh:'裂口女', h:62, solid:1, rig:{ c:0.50, n:0.30, h:0.47, ht:0.02, hr:0.26, L:[0.36, 0.38, 0.20, 0.52], R:[0.68, 0.40, 0.74, 0.66], legs:[0.74, 0.42, 0.58], hair:[0.26, 0.80] }, sec:{ hairR:[0.05, 1.3, 0] }, cut:['scissors'] });
  G('yukionna',    { zh:'雪女', h:64, solid:0, loco:'float', rig:{ c:0.56, n:0.33, h:0.55, ht:0.03, hr:0.28, L:[0.42, 0.42, 0.26, 0.48], R:[0.68, 0.42, 0.72, 0.60], tail:0.56, hair:[0.42, 0.94] }, sec:{ hairR:[0.08, 1.1, 0] } });
  G('kasaobake',   { zh:'唐傘妖', h:58, solid:1, loco:'onefoot', nr:1, rig:{ bones:[
      ['body', null, 0.45, 0.98, 0.45, 0.62, 0.13], ['head', 'body', 0.45, 0.62, 0.45, 0.03, 0.45],
      ['tongue', 'head', 0.58, 0.48, 0.75, 0.66, 0.10], ['tie', 'head', 0.12, 0.58, 0.06, 0.74, 0.08], ['legF', 'body', 0.44, 0.75, 0.36, 0.84, 0.06]] }, sec:{ tongue:[0.12, 2.4, 0] }, cut:['tongue'] });
  G('nopperabo',   { zh:'無臉鬼', h:64, solid:1, rig:{ c:0.60, n:0.36, ht:0.02, hr:0.30, L:[0.38, 0.42, 0.22, 0.64], R:[0.78, 0.42, 0.88, 0.68], legs:[0.62, 0.42, 0.70] }, cut:['case'] });
  G('chochin',     { zh:'提燈妖', h:56, solid:0, loco:'float', nr:1, rig:{ bones:[
      ['body', null, 0.50, 0.95, 0.50, 0.20, 0.40], ['head', 'body', 0.50, 0.22, 0.48, 0.10, 0.10], ['tongue', 'body', 0.60, 0.62, 0.70, 0.86, 0.10],
      ['stick', 'body', 0.38, 0.10, 0.10, 0.30, 0.14], ['tie', 'stick', 0.10, 0.30, 0.10, 0.60, 0.09], ['flame', null, 0.90, 0.30, 0.90, 0.08, 0.09]] }, sec:{ tongue:[0.10, 2.2, 0], flame:[0.12, 5.5, 0], stick:[0.03, 1.4, 0.5] } });
  G('gashadokuro', { zh:'餓者髑髏', h:72, solid:1, loco:'heavy', rig:{ bones:[
      ['body', null, 0.70, 0.62, 0.40, 0.30, 0.30], ['head', 'body', 0.32, 0.30, 0.18, 0.18, 0.18],
      ['armF', 'body', 0.32, 0.42, 0.10, 0.88, 0.12], ['armB', 'body', 0.56, 0.40, 0.62, 0.88, 0.12],
      ['legF', 'body', 0.76, 0.50, 0.74, 0.92, 0.11], ['legB', 'body', 0.88, 0.40, 0.88, 0.80, 0.10]] } });
  G('banshee',     { zh:'Banshee', h:62, solid:0, loco:'float', rig:{ c:0.50, n:0.38, ht:0.02, hr:0.30, L:[0.30, 0.46, 0.18, 0.64], R:[0.70, 0.46, 0.80, 0.64], tail:0.50, hair:[0.12, 0.88] }, sec:{ hairL:[0.09, 1.0, 0], hairR:[0.09, 1.0, 1.3] } });
  G('hannya',      { zh:'般若', h:62, solid:0, loco:'float', rig:{ c:0.44, n:0.38, h:0.42, ht:0.02, hr:0.30, L:[0.30, 0.44, 0.06, 0.48], R:[0.66, 0.44, 0.94, 0.50], tail:0.45, hair:[0.14, 0.76] } });
  G('aswang',      { zh:'Aswang', h:60, solid:1, loco:'creep', rig:{ c:0.46, n:0.36, h:0.32, ht:0.04, hr:0.28, L:[0.36, 0.42, 0.18, 0.68], R:[0.52, 0.44, 0.46, 0.72], legs:[0.68, 0.30, 0.60], hair:[0.12, 0.78], x:[['cape', 'body', 0.58, 0.40, 0.86, 0.56, 0.14]] }, cut:['tongue'] });
  G('tikbalang',   { zh:'Tikbalang', h:68, solid:1, loco:'stride', rig:{ c:0.50, n:0.32, h:0.32, ht:0.02, hr:0.24, L:[0.40, 0.36, 0.20, 0.55], R:[0.58, 0.36, 0.70, 0.46], legs:[0.54, 0.40, 0.66], x:[['cape', 'body', 0.70, 0.36, 0.86, 0.66, 0.12]], hair:[0.42, 0.60] } });

  // ---------- 第二批：各種死法的意外鬼（搞笑、無血腥）----------
  G('chehuo',      { zh:'車禍鬼', h:60, solid:1, grp:'death', rig:{ c:0.52, n:0.40, h:0.47, ht:0.02, hr:0.34, L:[0.32, 0.44, 0.24, 0.44], R:[0.76, 0.46, 0.88, 0.70], legs:[0.72, 0.36, 0.64] } });
  G('diansi',      { zh:'電死鬼', h:60, solid:1, grp:'death', loco:'twitch', rig:{ c:0.55, n:0.48, ht:0.02, hr:0.40, L:[0.40, 0.52, 0.18, 0.55], R:[0.68, 0.52, 0.76, 0.74], legs:[0.76, 0.42, 0.62], hair:[0.26, 0.86], x:[['tie', 'armF', 0.14, 0.58, 0.10, 0.90, 0.07]] }, sec:{ hairL:[0.05, 7, 0], hairR:[0.05, 7, 1] } });
  G('dongsi',      { zh:'凍死鬼', h:60, solid:1, grp:'death', loco:'shiver', rig:{ c:0.48, n:0.40, ht:0.02, hr:0.32, L:[0.34, 0.46, 0.50, 0.52], R:[0.64, 0.46, 0.50, 0.50], legs:[0.78, 0.42, 0.62] } });
  G('yezi',        { zh:'椰子砸死鬼', h:58, solid:1, grp:'death', loco:'stumble', rig:{ c:0.44, n:0.48, h:0.42, ht:0.05, hr:0.36, L:[0.26, 0.55, 0.14, 0.66], R:[0.56, 0.52, 0.40, 0.64], legs:[0.78, 0.30, 0.56] } });
  G('liulian',     { zh:'榴槤砸死鬼', h:58, solid:1, grp:'death', rig:{ c:0.46, n:0.48, h:0.42, ht:0.03, hr:0.36, L:[0.30, 0.52, 0.15, 0.66], R:[0.62, 0.52, 0.60, 0.66], legs:[0.78, 0.35, 0.62] } });
  G('yesi',        { zh:'噎死鬼', h:60, solid:1, grp:'death', rig:{ c:0.50, n:0.40, ht:0.02, hr:0.32, L:[0.34, 0.44, 0.14, 0.50], R:[0.68, 0.46, 0.70, 0.64], legs:[0.78, 0.40, 0.66] } });
  G('xiaosi',      { zh:'笑死鬼', h:58, solid:1, grp:'death', loco:'laugh', rig:{ c:0.46, n:0.42, h:0.38, ht:0.02, hr:0.32, L:[0.34, 0.48, 0.40, 0.56], R:[0.60, 0.44, 0.56, 0.56], legs:[0.72, 0.30, 0.70] } });
  G('xiasi',       { zh:'嚇死鬼', h:62, solid:1, grp:'death', loco:'shiver', rig:{ c:0.48, n:0.40, ht:0.02, hr:0.30, L:[0.30, 0.44, 0.08, 0.38], R:[0.66, 0.44, 0.86, 0.38], legs:[0.72, 0.30, 0.62], hair:[0.24, 0.86] }, sec:{ hairL:[0.04, 9, 0], hairR:[0.04, 9, 1] } });
  G('leipi',       { zh:'雷劈鬼', h:58, solid:0, grp:'death', loco:'float', rig:{ c:0.35, n:0.50, h:0.35, ht:0.05, hr:0.30, L:[0.24, 0.55, 0.10, 0.68], R:[0.46, 0.55, 0.64, 0.62], tail:0.30, x:[['umb', 'armB', 0.66, 0.62, 0.74, 0.25, 0.17]] }, sec:{ umb:[0.05, 1.6, 0] } });
  G('zipai',       { zh:'自拍跌死鬼', h:58, solid:0, grp:'death', loco:'float', nr:1, rig:{ c:0.36, n:0.46, h:0.38, ht:0.02, hr:0.30, L:[0.26, 0.52, 0.10, 0.52], R:[0.48, 0.55, 0.62, 0.58], tail:0.32, x:[['stick', 'armB', 0.62, 0.58, 0.80, 0.16, 0.08]] }, sec:{ stick:[0.04, 1.3, 0] } });
  G('zhongshu',    { zh:'中暑鬼', h:60, solid:0, grp:'death', loco:'float', rig:{ c:0.46, n:0.46, h:0.45, ht:0.05, hr:0.34, L:[0.30, 0.52, 0.16, 0.56], R:[0.62, 0.52, 0.70, 0.46], tail:0.40 }, sec:{ armB:[0.04, 2, 0] } });
  G('chengsi',     { zh:'撐死鬼', h:62, solid:0, grp:'death', loco:'float', rig:{ c:0.50, n:0.38, h:0.38, ht:0.02, hr:0.28, L:[0.22, 0.42, 0.08, 0.38], R:[0.66, 0.36, 0.82, 0.26], tail:0.40 } });
  G('shedu',       { zh:'蛇咬鬼', h:60, solid:1, grp:'death', loco:'flee', rig:{ c:0.42, n:0.46, h:0.38, ht:0.02, hr:0.32, L:[0.26, 0.50, 0.04, 0.45], R:[0.36, 0.56, 0.14, 0.64], legs:[0.70, 0.26, 0.46], x:[['snake', 'hips', 0.80, 0.70, 0.90, 0.48, 0.12]] }, sec:{ snake:[0.08, 3.3, 0] }, cut:['snake'] });
  G('shidu',       { zh:'食物中毒鬼', h:58, solid:1, grp:'death', loco:'creep', rig:{ c:0.46, n:0.40, h:0.42, ht:0.02, hr:0.30, L:[0.30, 0.46, 0.42, 0.60], R:[0.62, 0.46, 0.70, 0.62], legs:[0.76, 0.36, 0.60], x:[['tie', 'armB', 0.74, 0.58, 0.80, 0.76, 0.08]] }, sec:{ tie:[0.12, 2.5, 0] } });
  G('daji',        { zh:'打機猝死鬼', h:60, solid:1, grp:'death', loco:'creep', rig:{ c:0.44, n:0.46, h:0.42, ht:0.02, hr:0.32, L:[0.26, 0.52, 0.32, 0.62], R:[0.62, 0.52, 0.52, 0.62], legs:[0.76, 0.36, 0.56], x:[['tie', 'body', 0.14, 0.66, 0.10, 0.88, 0.07]] }, sec:{ tie:[0.06, 1.7, 0] } });
  G('xiangcai',    { zh:'大象踩扁鬼', h:44, solid:1, grp:'death', loco:'paper', rig:{ bones:[
      ['body', null, 0.52, 0.66, 0.45, 0.52, 0.42], ['head', 'body', 0.50, 0.52, 0.44, 0.38, 0.16],
      ['armF', 'body', 0.30, 0.46, 0.06, 0.38, 0.11], ['armB', 'body', 0.72, 0.48, 0.94, 0.36, 0.11],
      ['legF', 'body', 0.30, 0.78, 0.06, 0.82, 0.11], ['legB', 'body', 0.74, 0.78, 0.96, 0.82, 0.11], ['bubble', null, 0.72, 0.30, 0.82, 0.10, 0.16]] }, sec:{ bubble:[0.05, 1.8, 0] } });

  const S = Math.sin;
  // 走路／待機方式：在 MeshAnim 的姿勢上加料（art.js drawMesh 呼叫 RIG.tweak）
  function tweaker(d) {
    const loco = d.loco || 'walk', sec = d.sec || {};
    return function (pz, o) {
      const t = o.t || 0, ps = o.pose;
      const walking = !!(o.walk || ps === 'move' || ps === 'walk' || ps === 'run');
      const idle = !walking && (!ps || ps === 'idle');
      if (!walking && !idle) return; // 攻擊、受擊、倒地、驚嚇：照共用動作
      const A = MeshAnim.ANIM;
      for (const b in sec) { const [am, f, ph] = sec[b]; pz[b] = (pz[b] || 0) + S(t * f + ph) * am * (walking ? 1.6 : 1); }
      if (loco === 'float') {
        pz.legF = 0; pz.legB = 0;
        if (walking) { pz.body = 0.14; pz.armF = S(t * 3) * 0.08; pz.armB = -S(t * 3) * 0.08; pz.y = -0.03 - S(t * 3) * 0.02; pz.tail1 = -0.25 + S(t * 4) * 0.12; pz.tail2 = -0.35 + S(t * 4 - 1) * 0.2; pz.rot = 0.04; }
        else { pz.x = S(t * 0.8) * 0.012; pz.rot = S(t * 1.1) * 0.025; }
      } else if (loco === 'onefoot' || loco === 'bottle') {
        const f = loco === 'bottle' ? 4.5 : 5.5, ph = (t * f) % Math.PI, up = S(ph), land = ph < 0.35 ? 1 - ph / 0.35 : 0;
        if (walking) { pz.y = -0.02 - up * 0.10; pz.sy = 1 - land * 0.08 + up * 0.03; pz.sx = 1 + land * 0.06; pz.body = 0.05; pz.legB = 0; pz.legF = 0.1; pz.armF = up * 0.25; pz.armB = -up * 0.25; }
        else { const b = Math.abs(S(t * 2.2)); pz.y = -0.01 - b * 0.02; pz.sy = 1 + b * 0.015; pz.legB = 0; pz.legF = 0; }
      } else if (loco === 'stride') {
        if (walking) { const w = A.walk(t * 0.62); pz.legF = w.legF * 0.42; pz.legB = w.legB * 0.42; pz.armF = w.armF * 1.2; pz.armB = w.armB * 1.2; pz.body = 0.06; pz.head = S(t * 4.34) * 0.05; pz.y = -Math.abs(S(t * 4.34)) * 0.03; pz.rot = S(t * 4.34) * 0.03; }
        else pz.body = S(t * 0.9) * 0.03;
      } else if (loco === 'neck') {
        pz.neck1 = S(t * 1.1) * 0.10 * (walking ? 1.6 : 1); pz.neck2 = S(t * 1.1 - 0.9) * 0.18 * (walking ? 1.5 : 1); pz.head = (pz.head || 0) - S(t * 1.1 - 1.6) * 0.10;
        if (walking) { pz.legF = 0; pz.legB = 0; pz.y = -Math.abs(S(t * 6)) * 0.012; }
      } else if (loco === 'heavy') {
        if (walking) { const w = A.walk(t * 0.6); pz.legF = w.legF * 1.1; pz.legB = w.legB * 1.1; pz.armF = w.armF * 0.8; pz.armB = w.armB * 0.8; pz.rot = S(t * 4.2) * 0.05; pz.y = -Math.abs(S(t * 4.2)) * 0.03; pz.body = 0.06; }
        else { pz.rot = S(t * 0.9) * 0.015; pz.sy = (pz.sy || 1) + S(t * 1.2) * 0.012; }
      } else if (loco === 'skitter') {
        if (walking) { pz.legF = S(t * 22) * 0.18; pz.legB = S(t * 11) * 0.10; pz.y = -Math.abs(S(t * 11)) * 0.05; pz.body = 0; }
        else { pz.legF = S(t * 9) * 0.03; pz.hairL = S(t * 3) * 0.12; pz.hairR = S(t * 3 + 1) * 0.12; }
      } else if (loco === 'creep') {
        if (walking) { const w = A.walk(t * 0.8); pz.legF = w.legF; pz.legB = w.legB; pz.body = 0.16; pz.head = 0.06 + S(t * 5.6) * 0.04; pz.y = -Math.abs(S(t * 5.6)) * 0.015; }
      } else if (loco === 'drunk') {
        pz.rot = S(t * 1.3) * 0.07 + S(t * 2.9) * 0.03; pz.x = S(t * 0.9) * 0.02; pz.head = (pz.head || 0) + S(t * 1.7) * 0.08;
        if (walking) { pz.rot += S(t * 3.5) * 0.08; }
      } else if (loco === 'shiver') {
        pz.x = (pz.x || 0) + S(t * 47) * 0.005; pz.head = (pz.head || 0) + S(t * 39) * 0.02;
        if (walking) { pz.body = -0.04; pz.y = -Math.abs(S(t * 9)) * 0.02; }
      } else if (loco === 'twitch') { // 觸電：每隔一陣全身抽一下
        const q = (t * 0.9) % 1, j = q > 0.85 ? S(q * 120) : 0; pz.x = (pz.x || 0) + j * 0.012; pz.head = (pz.head || 0) + j * 0.08; pz.armF = (pz.armF || 0) + j * 0.15; pz.armB = (pz.armB || 0) - j * 0.15;
        if (walking) { const w = A.walk(t); pz.legF = w.legF * 0.8; pz.legB = w.legB * 0.8; }
      } else if (loco === 'laugh') { // 笑到彎腰抖
        pz.body = (pz.body || 0) + 0.05 + Math.abs(S(t * 9)) * 0.05; pz.head = (pz.head || 0) + Math.abs(S(t * 9)) * 0.08; pz.y = (pz.y || 0) - Math.abs(S(t * 9)) * 0.01;
      } else if (loco === 'paper') { // 被踩扁：像一張紙，走路時一飄一飄
        pz.legF = 0; pz.legB = 0; const k = walking ? 1 : 0.35; pz.sy = 1 + S(t * (walking ? 6 : 2)) * 0.08 * k; pz.rot = S(t * (walking ? 6 : 2) + 1) * 0.08 * k; pz.y = -0.02 - (walking ? Math.abs(S(t * 6)) * 0.06 : 0); pz.armF = S(t * 3) * 0.15 * k; pz.armB = -S(t * 3) * 0.15 * k;
      } else if (loco === 'flee') { // 一直在逃命的腳步
        if (walking) { const w = A.walk(t * 1.6); pz.legF = w.legF * 1.2; pz.legB = w.legB * 1.2; pz.armF = w.armF * 1.4; pz.armB = w.armB * 1.4; pz.y = -Math.abs(S(t * 11)) * 0.03; }
        else { pz.y = (pz.y || 0) - Math.abs(S(t * 4)) * 0.01; pz.armF = (pz.armF || 0) + S(t * 4) * 0.05; }
      } else if (loco === 'stumble') {
        if (walking) { const q = (t * 0.7) % 1, lurch = q > 0.8 ? S((q - 0.8) / 0.2 * Math.PI) : 0; pz.rot = 0.04 + lurch * 0.18; pz.body = (pz.body || 0) + lurch * 0.2; pz.armF = (pz.armF || 0) - lurch * 0.6; pz.armB = (pz.armB || 0) + lurch * 0.5; }
      }
    };
  }
  // ---------- 登記到遊戲 ----------
  const IDS = Object.keys(DEF).map(k => 'n30_' + k);
  for (const k in DEF) {
    const d = DEF[k], id = 'n30_' + k, r = d.rig;
    const R = r.bones ? { bones:r.bones, legs:!!r.bones.find(b => b[0] === 'legF') } : MeshAnim.mk(r);
    if (r.x) R.bones = R.bones.concat(r.x);
    R.tweak = tweaker(d);
    MeshAnim.RIG[id] = R;
    if (d.nr) MeshAnim.NATIVE_R[id] = 1;
    ART.CHAR_H[id] = d.h;
    if (d.solid) ART.SOLID[id] = 1;
  }
  // ---------- 拆件：身體（原圖 − 件 + 補丁）----------
  // SPR['n30_x__nb'] = 拆掉 cut 裡全部件之後的身體（canvas，網格變形照用同一副骨架）
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  // 原圖 − 件（件的範圍整塊挖乾淨，不留淡淡的邊）＋ 補丁；key = 存回 SPR 的名字。反派 NPC（npc_antag.js）也用
  function cutBody(id, pieces, key) {
    if (SPR[key] && SPR[key]._ok) return key;
    if (!ok(id)) return null; for (const p of pieces) if (!ok(id + '__' + p)) return null;
    const img = SPR[id], c = document.createElement('canvas'); c.width = img.naturalWidth; c.height = img.naturalHeight;
    const g = c.getContext('2d'); g.drawImage(img, 0, 0);
    const mk = document.createElement('canvas'); mk.width = c.width; mk.height = c.height; const mg = mk.getContext('2d');
    for (const p of pieces) mg.drawImage(SPR[id + '__' + p], 0, 0, c.width, c.height);
    try {
      const bd = g.getImageData(0, 0, c.width, c.height), md = mg.getImageData(0, 0, c.width, c.height).data, b = bd.data;
      for (let i = 3; i < b.length; i += 4) { const m = md[i]; if (m > 8) b[i] = 0; else if (m > 0) b[i] = b[i] * (1 - m / 8) | 0; }
      g.putImageData(bd, 0, 0);
    } catch (e) { g.globalCompositeOperation = 'destination-out'; g.drawImage(mk, 0, 0); }
    if (ok(id + '__fill')) { g.globalCompositeOperation = 'destination-over'; g.drawImage(SPR[id + '__fill'], 0, 0, c.width, c.height); }
    c.naturalWidth = c.width; c.naturalHeight = c.height; c._ok = true; c.complete = true;
    SPR[key] = c; if (MeshAnim.RIG[id]) MeshAnim.RIG[key] = MeshAnim.RIG[id];
    return key;
  }
  function body(id) {
    const d = DEF[id.slice(4)]; if (!d || !d.cut) return null;
    return cutBody(id, d.cut, id + '__nb');
  }
  return { DEF, IDS, body, cutBody, name:(id) => (DEF[id.replace(/^n30_/, '')] || {}).zh };
})();
