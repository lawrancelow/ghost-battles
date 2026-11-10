// 楼里有鬼 M1 — 模拟层（无画面，可在 node 运行）
var LYG_SIM = (function(){
  var DATA = (typeof LYG_DATA !== 'undefined') ? LYG_DATA : require('./data.js');
  var W = 780, RH = 200, ROOF = 130, FLOORS = 6, GROUND_H = 110;
  var WH = ROOF + FLOORS*RH + GROUND_H;
  var NIGHT = 420; // 游戏分钟 23:00→06:00，1 现实秒 = 1 游戏分钟
  function rowTop(f){ return ROOF + (FLOORS-f)*RH; }
  function yCeil(f){ return rowTop(f)+20; }
  function yRoom(f){ return rowTop(f)+128; }
  function yCorr(f){ return rowTop(f)+194; }
  var GROUND_Y = ROOF + FLOORS*RH + 90;
  var ROOF_Y = ROOF - 8;
  function unitX(u){ return 100 + u*226; }
  var GEO = {W:W, RH:RH, ROOF:ROOF, FLOORS:FLOORS, WH:WH, rowTop:rowTop, yCeil:yCeil, yRoom:yRoom, yCorr:yCorr, unitX:unitX, GROUND_Y:GROUND_Y, ROOF_Y:ROOF_Y};

  function rng(seed){ var a = seed>>>0; return function(){ a|=0; a=a+0x6D2B79F5|0; var t=Math.imul(a^a>>>15,1|a); t=t+Math.imul(t^t>>>7,61|t)^t; return ((t^t>>>14)>>>0)/4294967296; }; }

  // ---------- 图 ----------
  function buildGraph(){
    var N = [], E = [], idx = {};
    function node(id, x, y, lane, f, u, room){ var n={id:id,i:N.length,x:x,y:y,lane:lane,f:f,u:u,room:room,adj:[]}; N.push(n); idx[id]=n; return n; }
    function edge(a,b,type,extra){ var e={a:idx[a],b:idx[b],type:type,i:E.length}; if(extra) for(var k in extra) e[k]=extra[k]; e.len=Math.hypot(e.a.x-e.b.x,e.a.y-e.b.y)+(type==='stair'?40:0); E.push(e); e.a.adj.push(e); e.b.adj.push(e); return e; }
    node('S0',30,GROUND_Y,'stair',0); node('K0',80,GROUND_Y,'shaft',0);
    node('desk',300,GROUND_Y,'lobby',0); node('lobbyE',560,GROUND_Y,'lobby',0);
    edge('S0','K0','walk'); edge('K0','desk','walk'); edge('desk','lobbyE','walk');
    for (var f=1; f<=FLOORS; f++){
      node('S'+f,30,yCorr(f),'stair',f); node('K'+f,80,yCorr(f)-34,'shaft',f);
      node('EK'+f,80,yCeil(f),'ceil',f);
      edge('S'+(f-1),'S'+f,'stair'); edge('K'+(f-1),'K'+f,'shaft');
      edge('S'+f,'K'+f,'walk'); edge('K'+f,'EK'+f,'climb');
      var prev='S'+f, prevE='EK'+f;
      for (var u=0; u<3; u++){
        var x0=unitX(u), uid=f+'_'+u;
        node('Cd'+uid,x0+78,yCorr(f),'corr',f,u); node('Cv'+uid,x0+176,yCorr(f),'corr',f,u);
        node('L'+uid,x0+80,yRoom(f),'room',f,u,'L'); node('B'+uid,x0+150,yRoom(f),'room',f,u,'B');
        node('EL'+uid,x0+80,yCeil(f),'ceil',f,u,'L'); node('EB'+uid,x0+170,yCeil(f),'ceil',f,u,'B');
        edge(prev,'Cd'+uid,'walk'); edge('Cd'+uid,'Cv'+uid,'walk'); prev='Cv'+uid;
        edge('Cd'+uid,'L'+uid,'door',{unit:uid}); edge('Cv'+uid,'B'+uid,'vent',{unit:uid});
        edge('L'+uid,'B'+uid,'walk');
        edge(prevE,'EL'+uid,'ceil'); edge('EL'+uid,'EB'+uid,'ceil'); prevE='EB'+uid;
        edge('EL'+uid,'L'+uid,'drop'); edge('EB'+uid,'B'+uid,'drop');
      }
    }
    node('R',30,ROOF_Y,'roof',7); node('KR',80,ROOF_Y,'roof',7); node('TANK',230,ROOF_Y,'roof',7);
    edge('S'+FLOORS,'R','stair'); edge('K'+FLOORS,'KR','shaft'); edge('R','KR','walk'); edge('KR','TANK','walk');
    return {N:N,E:E,idx:idx};
  }
  var GR = buildGraph();

  var ALLOW = {
    eking:   {walk:1,stair:1,door:1},
    toyol:   {walk:1,stair:1,door:1,vent:1,shaft:1},
    tianhua: {walk:1,stair:1,door:1,ceil:1,climb:1,shaft:1,drop:1},
    human:   {walk:1,stair:1,door:1}
  };

  function Game(seed, opts){
    opts = opts||{};
    this.seed = seed|0; this.R = rng(seed*7919+13);
    this.t = 0; this.over = false; this.events = []; this.fx = [];
    this.alert = 0; this.alertT = 0; this.alertFloor = 1; this.scares = 0; this.guardScares = 0;
    this.usedLines = {}; this.stats = {caught:0, stunned:0, datukHits:0};
    this.setup();
  }
  var P = Game.prototype;
  P.rand = function(a,b){ return a + (b-a)*this.R(); };
  P.ri = function(a,b){ return Math.floor(this.rand(a,b+1)); };
  P.pick = function(arr){ return arr[Math.floor(this.R()*arr.length)]; };
  P.node = function(id){ return GR.idx[id]; };

  P.setup = function(){
    var R=this.R, self=this;
    this.units = {}; this.residents = []; this.items = [];
    var archetypes = [
      {sprite:'npc_boss', kind:'伯', brave:1.3},{sprite:'npc_auntie', kind:'姨', brave:1.0},
      {sprite:'npc_ken', kind:'阿', brave:0.9},{sprite:'npc_it', kind:'阿', brave:0.85},{sprite:'npc_mis', kind:'妹', brave:0.8}
    ];
    var usedNames = {}, givenA = ['明','伟','强','杰','华','俊','文','龙','辉','荣','豪','亮','生','宝','发','祥','雄','彬'];
    function makeName(a){
      for (var k=0;k<50;k++){
        var s = self.pick(DATA.surnames), n;
        if (a.kind==='伯') n = s+'伯'; else if (a.kind==='姨') n = s+self.pick(['姨','嫂','婶']);
        else if (a.kind==='妹') n = s+self.pick(['小姐','妹']); else n = '阿'+self.pick(givenA);
        if (!usedNames[n]) { usedNames[n]=1; return n; }
      }
      return '住户'+(self.residents.length+1);
    }
    var unitList = [];
    for (var f=1; f<=FLOORS; f++) for (var u=0; u<3; u++){
      var uid=f+'_'+u;
      var U = {id:uid, f:f, u:u, name:DATA.unitName(f,u), shrine: R()<0.6, doorGod: R()<0.18, locked: R()<0.45,
               salt:false, incense:0, praying:0, supper:null, money:[], stash:null, key:false, residents:[], light:{L:0,B:0}};
      this.units[uid]=U; unitList.push(U);
    }
    // 委托 — 天花姐目标户（有人住、无门神也无所谓，她走天花）
    var cand = unitList.filter(function(U){ return U.f>=2; });
    var tUnit = this.pick(cand);
    tUnit.stash = {amount: this.ri(80,200), target:true};
    // 宵夜：6 户，其中至少 4 户没有门神
    var shuffled = unitList.slice().sort(function(){return R()-0.5;});
    var supperUnits = [], open=0;
    for (var i=0;i<shuffled.length && supperUnits.length<7;i++){
      var U=shuffled[i];
      var acc = !U.doorGod && !U.locked;
      if (acc) open++; else if (supperUnits.length-open >= 3) continue;
      supperUnits.push(U);
    }
    // 保证至少 4 户饿鬼王进得去（没门神、没锁）
    for (var i2=0;i2<supperUnits.length && open<4;i2++){ var U3=supperUnits[i2]; if (U3.doorGod||U3.locked){ U3.doorGod=false; U3.locked=false; open++; } }
    var foods=['炒粿条','云吞面','肉骨茶','椰浆饭','咖喱面','烧鸡翼','福建面','鸡饭','叻沙','炒米粉'].sort(function(){return R()-0.5;});
    supperUnits.forEach(function(U,i){ U.supper = {name:foods[i%foods.length], eatAt: self.ri(110,320)}; });
    // 钱：每户 0–2 笔
    var mt = 0;
    unitList.forEach(function(U){
      var n = self.ri(0,2);
      for (var k=0;k<n;k++){ var room = R()<0.5?'L':'B'; var amt = self.pick([5,10,10,15,20,25,30]); U.money.push({room:room, amt:amt, what: room==='L'?self.pick(['钱包','红包']):self.pick(['硬币罐','枕头底的钱'])}); mt+=amt; }
    });
    // 备用钥匙：锁着的户里抽 3 户
    unitList.filter(function(U){return U.locked && !U.doorGod;}).sort(function(){return R()-0.5;}).slice(0,3).forEach(function(U){ U.key=true; });
    // 魂灯油 2 个在楼梯口
    var oilFloors = [this.ri(1,3), this.ri(4,6)];
    oilFloors.forEach(function(f){ self.items.push({type:'oil', node:'S'+f, x:GR.idx['S'+f].x+16, y:GR.idx['S'+f].y, f:f}); });
    // 住户与作息
    unitList.forEach(function(U){
      var n = self.R()<0.15?0:(self.R()<0.55?1:2);
      if (U.stash && n===0) n=1;
      for (var k=0;k<n;k++){
        var a = self.pick(archetypes); var tries=0; while (U.residents.some(function(o){return o.sprite===a.sprite;}) && tries++<10) a=self.pick(archetypes);
        var r = {id:'r'+self.residents.length, name:makeName(a), sprite:a.sprite, brave:a.brave*self.rand(0.85,1.15), unit:U.id,
                 fear:0, sus:0, tier:0, state:'tv', node:'L'+U.id, x:0, y:0, path:[], busy:0, slot:k, said:0, line:null, lineT:0, edge:null, et:0};
        var tSleep = self.ri(60,230), sched=[];
        sched.push({t:0, act:'tv'});
        if (self.R()<0.6){ var ts=self.ri(15, tSleep-20); sched.push({t:ts, act:'shower'}); sched.push({t:ts+15, act:'tv'}); }
        sched.push({t:tSleep, act:'sleep'});
        if (self.R()<0.5){ var tn=self.ri(tSleep+40, 380); if (tn<400){ sched.push({t:tn, act:'night'}); sched.push({t:tn+8, act:'sleep'}); } }
        sched.sort(function(a,b){return a.t-b.t;});
        r.sched = sched;
        var nd=GR.idx[r.node]; r.x=nd.x; r.y=nd.y;
        self.residents.push(r); U.residents.push(r);
      }
      if (U.shrine && U.residents.length){ U.prayAt = [self.ri(3,60)]; if (self.R()<0.6) U.prayAt.push(self.ri(150,300)); }
      else U.prayAt=[];
    });
    // 保安
    this.guards = [
      {id:'g0', name:'保安老黄', mode:'patrol', node:'S1', x:0,y:0, path:[], edge:null, et:0, dir:1, fear:0, flee:0, route:null, ri:0, wait:0, look:0, lookT:0, hasRadio:true, line:null,lineT:0, searchList:null},
      {id:'g1', name:'保安阿忠', mode:'doze', node:'desk', x:0,y:0, path:[], edge:null, et:0, dir:-1, fear:0, flee:0, route:null, ri:0, wait:0, look:0, lookT:0, hasRadio:true, line:null,lineT:0, searchList:null}
    ];
    this.guards.forEach(function(g){ var n=GR.idx[g.node]; g.x=n.x; g.y=n.y; });
    this.guards[0].route = this.patrolRoute(1);
    // 拿督公巡视（子时、丑时）
    this.datuk = [{at:this.ri(20,105), f:this.ri(1,6), done:false, sweep:-1},{at:this.ri(135,230), f:this.ri(1,6), done:false, sweep:-1}];
    // 鬼
    var self2=this;
    this.ghosts = ['eking','toyol','tianhua'].map(function(k,i){
      var n=GR.idx['TANK'];
      return {id:k, name:DATA.ghosts[k].name, soul:100, node:'TANK', x:n.x-30+i*30, y:n.y, path:[], edge:null, et:0, stun:0, hide:null,
              carry:{supper:[], money:0, stash:0}, done:{supper:[], money:0, stash:0}, exposure:0, reveal:0, onGround:false, hang:0, act:null, target:null, ring:null, keyHint:null};
    });
    this.comm = {
      eking: {text:'吃到三户人家的宵夜', need:3},
      toyol: {text:'偷到 RM50', need:50},
      tianhua: {text:'拿到'+tUnit.name+'衣柜顶的私房钱', need:1, unit:tUnit.id}
    };
    this.active = 0;
  };

  P.patrolRoute = function(startF){
    var r=[]; for (var f=1; f<=FLOORS; f++){ r.push('S'+f); r.push('Cv'+f+'_2'); r.push('S'+f); }
    for (var f2=FLOORS; f2>=1; f2--){ r.push('S'+f2); }
    r.push('S0'); r.push('desk'); r.push('S0');
    return r;
  };

  // ---------- 规则查询 ----------
  P.edgeOpen = function(e, who, fromNode){
    if (who==='human' || who==='guard') return true;
    if (!ALLOW[who][e.type]) return false;
    if (e.type==='door'){
      var U=this.units[e.unit];
      if (fromNode && fromNode.lane==='room') return true; // 出门不挡，只挡进门
      if (U.doorGod) return false;
      if (U.salt) return false; // 盐 / 糯米挡住贴地走的鬼
      if (U.locked && who!=='toyol') return false;
    }
    if (e.type==='vent'){ var U2=this.units[e.unit]; if (U2.salt && false) return false; }
    return true;
  };
  P.edgeCost = function(e, who){
    var c=e.len;
    if (who==='tianhua' && (e.type==='walk'||e.type==='door'||e.type==='stair')) c*=4;
    if (who!=='human' && who!=='guard'){
      var nb=e.b, na=e.a;
      if (this.litNode(na)||this.litNode(nb)) c+=3000;
    }
    return c;
  };
  P.path = function(fromId, toId, who){
    if (fromId===toId) return [];
    var N=GR.N, dist=new Array(N.length).fill(Infinity), prev=new Array(N.length).fill(null), done=new Array(N.length).fill(false);
    var s=GR.idx[fromId].i, t=GR.idx[toId].i; dist[s]=0;
    for (;;){
      var best=-1, bd=Infinity;
      for (var i=0;i<N.length;i++) if(!done[i] && dist[i]<bd){bd=dist[i];best=i;}
      if (best<0 || best===t) break;
      done[best]=true;
      var nd=N[best];
      for (var k=0;k<nd.adj.length;k++){
        var e=nd.adj[k], o=(e.a===nd)?e.b:e.a;
        if (done[o.i] || !this.edgeOpen(e,who,nd)) continue;
        var c=bd+this.edgeCost(e,who);
        if (c<dist[o.i]){dist[o.i]=c;prev[o.i]=best;}
      }
    }
    if (dist[t]===Infinity) return null;
    var p=[], c2=t; while(c2!==s){ p.push(N[c2].id); c2=prev[c2]; } p.reverse(); return p;
  };
  P.findEdge = function(aId,bId){ var a=GR.idx[aId]; for (var k=0;k<a.adj.length;k++){ var e=a.adj[k]; if ((e.a.id===aId&&e.b.id===bId)||(e.b.id===aId&&e.a.id===bId)) return e; } return null; };

  // 神光
  P.lightRect = function(U){
    var x0=unitX(U.u), top=rowTop(U.f)+22, bot=yRoom(U.f);
    if (!U.shrine) return null;
    if (U.praying>0) return {x0:x0, x1:x0+226, y0:top, y1:bot, lvl:2};
    if (U.incense>0) return {x0:x0, x1:x0+113+30, y0:top, y1:bot, lvl:1};
    return {x0:x0, x1:x0+48, y0:top, y1:bot, lvl:0};
  };
  P.litAt = function(x,y,f,lane){
    if (lane!=='room' || !f || f<1 || f>FLOORS) return null;
    var u = Math.floor((x-100)/226); if (u<0||u>2) return null;
    var U=this.units[f+'_'+u], r=this.lightRect(U); if(!r) return null;
    if (x>=r.x0 && x<=r.x1 && y>=r.y0-2 && y<=r.y1+2) return U;
    return null;
  };
  P.litNode = function(n){ return n.lane==='room' ? this.litAt(n.x,n.y,n.f,'room') : null; };

  // 鬼所在的房间
  P.ghostPlace = function(g){
    var n = GR.idx[g.node];
    if (g.edge) { n = g.et<0.5 ? g.edge.from : g.edge.to; }
    return n;
  };
  P.watchers = function(uid, room){
    var U=this.units[uid];
    return U.residents.filter(function(r){ return r.node===room+uid && !r.edge && (r.state==='tv'||r.state==='pray'||r.state==='night'||r.state==='check'||r.state==='salt'||r.state==='eat'); });
  };
  P.roomPeople = function(uid, room){
    var U=this.units[uid];
    return U.residents.filter(function(r){ return r.node===room+uid && !r.edge && r.state!=='shower' && r.state!=='flee' && r.state!=='out'; });
  };

  // ---------- 文本 ----------
  P.say = function(who, cat){
    var pool = DATA.lines[cat]; if(!pool) return;
    var used = this.usedLines; var avail = pool.filter(function(l){ return !used[l]; });
    if (!avail.length) return;
    var l = this.pick(avail); used[l]=1; who.line=l; who.lineT=4.5;
    this.log('say', who.name+'：'+l);
  };
  P.float = function(x,y,text,color){ this.fx.push({x:x,y:y,text:text,color:color||'#fff',t:0}); if (this.onFx) this.onFx(text); };
  P.log = function(type,msg){ this.events.push({t:this.t,type:type,msg:msg}); if(this.events.length>60) this.events.shift(); };
  P.toast = function(msg){ this.log('toast',msg); this.lastToast={msg:msg,t:3.5}; };
  P.clock = function(){ var m=Math.floor(23*60+this.t)%1440; var h=Math.floor(m/60), mm=m%60; return (h<10?'0':'')+h+':'+(mm<10?'0':'')+mm; };

  P.raiseAlert = function(lvl, f, why){
    if (lvl>this.alert){ this.alert=lvl; if (why) this.toast(why); }
    this.alertT = lvl>=2?45:60; this.alertFloor=f;
    var self=this;
    if (lvl>=1){
      this.guards.forEach(function(g){
        if (g.flee>0) return;
        if (g.mode==='doze'){ g.mode='patrol'; g.route=self.patrolRoute(); g.ri=0; }
        if (g.decoy>0) return;
        g.mode = lvl>=2?'hunt':'alert'; g.goalF=f; g.searchList=null; g.path=[];
        if (lvl>=2) self.say(g,'guardHunt'); else self.say(g,'guardAlert');
      });
    }
  };

  // ---------- 玩家指令 ----------
  P.moveGhost = function(gi, toId){
    var g=this.ghosts[gi]; if (g.stun>0) return false; g.channel=null;
    if (g.ring) g.ring=null;
    g.hide=null; g.hang=0;
    var from = g.edge ? (g.et<0.5? g.edge.from.id : g.edge.to.id) : g.node;
    if (g.edge){ // 先回到最近端点
      g.node = from; var nn=GR.idx[from]; g.x=nn.x; g.y=nn.y; g.edge=null;
    }
    var p=this.path(from,toId,g.id);
    if (!p){ this.float(g.x,g.y-70,'过不去','#ff9a9a'); return false; }
    g.path=p; return true;
  };
  // 点击地图 → 目标节点
  P.nodeForTap = function(gi, wx, wy){
    var g=this.ghosts[gi], best=null, bd=1e9;
    for (var i=0;i<GR.N.length;i++){
      var n=GR.N[i];
      if (g.id==='tianhua'){ if (n.lane==='room'||n.lane==='corr') continue; }
      else { if (n.lane==='ceil') continue; if (n.lane==='shaft' && g.id==='eking') continue; }
      var dx=n.x-wx, dy=(n.y-wy)*1.6;
      // 点到房间内部算该房间
      if (n.lane==='room'||n.lane==='ceil'){ var top=rowTop(n.f); if (wy>top && wy<top+130 && Math.abs(wx-n.x)<56) dy=0; }
      var d=dx*dx+dy*dy; if (d<bd){bd=d;best=n;}
    }
    return best? best.id : null;
  };
  // 当前可做的动作
  P.ghostContext = function(gi){
    var g=this.ghosts[gi], ctx={scare:null, take:null, hide:null, radio:!!g.radio};
    if (g.edge || g.stun>0) return ctx;
    var n=GR.idx[g.node];
    // 吓：同房间的人 / 天花上方的房间
    var roomId=null, uid=null;
    if (n.lane==='room'){ roomId=n.room; uid=n.f+'_'+n.u; }
    if (n.lane==='ceil' && n.room && g.id==='tianhua'){ roomId=n.room; uid=n.f+'_'+n.u; }
    if (uid){
      var ppl=this.watchers(uid,roomId);
      var tgt = g.target && ppl.indexOf(g.target)>=0 ? g.target : ppl[0];
      if (tgt) ctx.scare=tgt;
    }
    // 吓保安（同层同带、近距离）
    if (!ctx.scare && n.lane!=='ceil'){
      for (var i=0;i<this.guards.length;i++){ var gd=this.guards[i]; if (gd.flee>0||gd.mode==='doze') continue;
        var gn=GR.idx[gd.node]; if (gn && gn.f===n.f && Math.abs(gd.x-g.x)<90 && Math.abs(gd.y-g.y)<30){ ctx.scare=gd; break; } }
    }
    // 拿
    ctx.take = this.takeable(g, n, uid, roomId);
    // 躲
    if (n.lane==='room' && n.room==='B' && g.id!=='tianhua') ctx.hide = 'wardrobe';
    if (n.lane==='room' && n.room==='L' && g.id==='toyol') ctx.hide = 'sofa';
    return ctx;
  };
  P.takeable = function(g, n, uid, roomId){
    var self=this;
    // 地上掉的东西 / 魂灯油 / 钥匙 / 对讲机
    for (var i=0;i<this.items.length;i++){
      var it=this.items[i];
      if (Math.abs(it.x-g.x)<60 && Math.abs(it.y-g.y)<40){
        if (it.type==='oil' || it.type==='radio') return {kind:it.type, item:it, label: it.type==='oil'?'魂灯油':'对讲机'};
        if (it.type==='drop' && it.owner===g.id) return {kind:'drop', item:it, label:'捡回'};
      }
    }
    if (n.lane==='corr' && n.id.indexOf('Cd')===0){ var U0=this.units[n.f+'_'+n.u]; if (U0.key && U0.locked) return {kind:'key', unit:U0, label:'备用钥匙'}; }
    if (!uid) return null;
    var U=this.units[uid];
    if (g.id==='eking' && n.lane==='room' && roomId==='L' && U.supper && !U.supper.eaten) return {kind:'supper', unit:U, label:'吃宵夜'};
    if (g.id==='toyol' && n.lane==='room'){ for (var k=0;k<U.money.length;k++) if (U.money[k].room===roomId && !U.money[k].gone) return {kind:'money', unit:U, m:U.money[k], label:'偷'+U.money[k].what}; }
    if (g.id==='tianhua' && n.lane==='ceil' && roomId==='B' && U.stash && !U.stash.gone) return {kind:'stash', unit:U, label:'私房钱'};
    return null;
  };

  // 吓：第一下铺垫，第二下爆点
  P.scarePress = function(gi){
    var g=this.ghosts[gi], ctx=this.ghostContext(gi);
    if (g.ring){ return this.scareBurst(gi); }
    if (!ctx.scare){ this.float(g.x,g.y-70,'没人可吓','#ccc'); return; }
    if (g.soul<6){ this.float(g.x,g.y-70,'魂力不够','#ff9a9a'); return; }
    var tgt=ctx.scare; g.ring={target:tgt, t:0, dur:2.4};
    if (g.id==='tianhua') g.hang=1;
    var isGuard = !!tgt.mode;
    var self=this;
    if (!isGuard){
      var n=this.ghostPlace(g), roomId=n.room, uid=n.f+'_'+n.u;
      this.watchers(uid,roomId).forEach(function(r){ r.sus=Math.min(100,r.sus+15); self.float(r.x,r.y-80,'疑心+15','#c9b6ff'); });
      var U=this.units[uid]; U.flicker=1.0;
    } else { tgt.sus=(tgt.sus||0)+15; this.float(tgt.x,tgt.y-80,'疑心+15','#c9b6ff'); }
  };
  P.ringRadius = function(ring){ return 52 - 42*Math.min(1,ring.t/ring.dur); }; // 52 → 10
  P.RING_IN = 18;
  P.scareBurst = function(gi){
    var g=this.ghosts[gi], ring=g.ring; if(!ring) return;
    g.ring=null; g.hang = g.id==='tianhua'?1.2:0;
    var r=this.ringRadius(ring), mult, tag;
    if (Math.abs(r-this.RING_IN)<=5){ mult=2; tag='完美时机×2'; }
    else if (r>this.RING_IN+5 && r<36){ mult=1; tag='还行'; }
    else if (r>=36){ mult=0.6; tag='太早'; }
    else { mult=0.5; tag='太迟'; }
    this.applyScare(g, ring.target, mult, tag);
  };
  P.applyScare = function(g, tgt, mult, tag){
    var base = {eking:26, toyol:20, tianhua:30}[g.id];
    g.soul=Math.max(0,g.soul-6);
    var self=this;
    if (tgt.mode){ // 保安
      var gainG = base*mult*0.8;
      this.float(tgt.x,tgt.y-95,tag,mult>=2?'#ffd54a':'#fff');
      if (gainG<22 || tgt.fear+gainG<40){ tgt.fear+=gainG*0.5; this.float(tgt.x,tgt.y-75,'不怕','#9ad0ff'); this.raiseAlert(2, GR.idx[tgt.node].f||1, tgt.name+'看到怪影，开始搜捕！'); g.reveal=3; return; }
      tgt.fear+=gainG;
      if (tgt.fear>=40){ tgt.flee=40; tgt.mode='flee'; tgt.path=self.pathOrNull(tgt,'desk'); self.say(tgt,'guardScared'); this.guardScares++; this.scares++;
        this.float(tgt.x,tgt.y-75,'吓跑保安！','#ffd54a');
        if (tgt.hasRadio){ tgt.hasRadio=false; var gn=GR.idx[tgt.node]; this.items.push({type:'radio', x:tgt.x, y:tgt.y, f:gn.f, node:tgt.node}); this.float(tgt.x,tgt.y-55,'掉了对讲机','#fff'); }
      }
      return;
    }
    var n=this.ghostPlace(g); var uid=n.f+'_'+n.u, roomId=n.room;
    var ppl=this.watchers(uid,roomId); var cnt=Math.max(1,ppl.length);
    var group = 1/(1+0.4*(cnt-1));
    this.float(tgt.x,tgt.y-112,tag, mult>=2?'#ffd54a':(mult>=1?'#fff':'#ffb27a'));
    if (cnt>1) this.float(tgt.x,tgt.y-132,'群胆 -'+Math.round((1-group)*100)+'%','#9ad0ff');
    ppl.forEach(function(r){
      var gain = base*mult*group*(r===tgt?1:0.5)/r.brave;
      if (r.sus>=90) gain*=0.6; // 已经看穿了一半
      if (gain<10){ self.float(r.x,r.y-92,'不怕','#9ad0ff'); if (r===tgt) self.say(r,'brave'); return; }
      r.fear=Math.min(120,r.fear+gain);
      self.float(r.x,r.y-92,'恐惧+'+Math.round(gain),'#ff8fb0');
      self.react(r);
    });
  };
  P.pathOrNull = function(who, to){ var n = who.edge? (who.et<0.5?who.edge.from.id:who.edge.to.id) : who.node; if (who.edge){ who.node=n; who.edge=null; var nn=GR.idx[n]; who.x=nn.x; who.y=nn.y; } return this.path(n,to,'human')||[]; };
  P.react = function(r){
    var U=this.units[r.unit], self=this;
    if (r.fear>=90 && r.tier<3){
      r.tier=3; this.scares++; this.say(r,'panic');
      this.float(r.x,r.y-72,'惊恐！逃出屋','#ff5d5d');
      U.locked=false; // 逃出去门没锁
      r.state='flee'; r.busy=40; r.path=this.pathOrNull(r,'lobbyE');
      U.residents.forEach(function(o){ if(o!==r && o.state!=='flee'){ o.fear=Math.min(120,o.fear+20); } });
      this.raiseAlert(1, U.f, U.name+'有人尖叫，保安留意！');
      return;
    }
    if (r.fear>=65 && r.tier<2){
      r.tier=2; this.scares++; this.say(r,'hide');
      this.float(r.x,r.y-72,'躲进被里','#ffb0d0');
      r.state='hide'; r.busy=45; r.path=this.pathOrNull(r,'B'+U.id);
      return;
    }
    if (r.fear>=35 && r.tier<1){
      r.tier=1; this.scares++;
      if (U.shrine && U.incense<=0 && U.praying<=0){ r.state='pray'; r.busy=4; r.path=this.pathOrNull(r,'L'+U.id); this.say(r,'pray'); this.float(r.x,r.y-72,'害怕 → 去上香','#ffd27a'); }
      else if (!U.salt){ r.state='salt'; r.busy=3; r.path=this.pathOrNull(r,'L'+U.id); this.say(r,'salt'); this.float(r.x,r.y-72,'害怕 → 门口撒盐','#ffffff'); }
      else { this.say(r,'afraid'); this.float(r.x,r.y-72,'害怕','#ffd27a'); }
    }
  };

  P.takePress = function(gi){
    var g=this.ghosts[gi], ctx=this.ghostContext(gi), tk=ctx.take, self=this;
    if (!tk){ this.float(g.x,g.y-70,'这里没东西拿','#ccc'); return; }
    var n=GR.idx[g.node];
    if (tk.kind==='oil'){ g.soul=Math.min(100,g.soul+30); this.items.splice(this.items.indexOf(tk.item),1); this.float(g.x,g.y-80,'魂力+30','#9affc8'); return; }
    if (tk.kind==='radio'){ g.radio=true; this.items.splice(this.items.indexOf(tk.item),1); this.float(g.x,g.y-80,'拿到对讲机','#9affc8'); this.toast('对讲机可以发一次假消息，把保安调去别层'); return; }
    if (tk.kind==='drop'){ var it=tk.item; g.carry.supper=g.carry.supper.concat(it.supper||[]); g.carry.money+=it.money||0; g.carry.stash+=it.stash||0; this.items.splice(this.items.indexOf(it),1); this.float(g.x,g.y-80,'捡回来了','#9affc8'); return; }
    if (tk.kind==='key'){ tk.unit.locked=false; tk.unit.key=false; this.float(g.x,g.y-80,'地垫底的备用钥匙：门开了','#9affc8'); return; }
    var U=tk.unit, roomId = n.room;
    // 有人看着不能下手
    var w=this.watchers(U.id, roomId);
    if (w.length){ this.float(g.x,g.y-80,'有人看着，先吓走！','#ff9a9a'); return; }
    if (g.channel) return;
    var dur={eking:1.8, toyol:0.5, tianhua:1.2}[g.id]; g.channel={t:0, dur:dur, tk:tk, room:roomId}; this.float(g.x,g.y-84, g.id==='eking'?'开吃……':'动手……','#fff');
  };
  P.finishTake = function(g, tk, roomId){
    var U=tk.unit, self=this;
    if (tk.kind==='supper'){ U.supper.eaten=true; U.supper.byGhost=true; g.carry.supper.push(U.id); g.soul=Math.min(100,g.soul+25); this.float(g.x,g.y-84,'吃掉'+U.supper.name+' 魂力+25','#ffd54a'); }
    if (tk.kind==='money'){ tk.m.gone=true; g.carry.money+=tk.m.amt; this.float(g.x,g.y-84,'+RM'+tk.m.amt,'#ffd54a'); }
    if (tk.kind==='stash'){ U.stash.gone=true; g.carry.stash+=U.stash.amount; this.float(g.x,g.y-84,'私房钱 RM'+U.stash.amount+' 到手！','#ffd54a'); }
    // 动静
    var noisy = this.roomPeople(U.id, roomId).concat(this.roomPeople(U.id, roomId==='L'?'B':'L'));
    noisy.forEach(function(r){ if (r.state==='sleep'){ r.sus+= (g.id==='toyol'?20:35); if (r.sus>=70){ r.state='check'; r.busy=12; r.sus=30; self.say(r,'wake'); self.float(r.x,r.y-72,'被吵醒','#fff'); } } });
    var isComm = (tk.kind==='stash' && U.stash.target);
    if (isComm) this.raiseAlert(2, U.f, '私房钱不见了！保安开始搜捕');
    else if (tk.kind!=='supper' || this.R()<0.3) this.raiseAlert(Math.max(this.alert,1), U.f, null);
  };
  P.hidePress = function(gi){
    var g=this.ghosts[gi], ctx=this.ghostContext(gi);
    if (g.hide){ g.hide=null; this.float(g.x,g.y-70,'出来','#ccc'); return; }
    if (!ctx.hide){ this.float(g.x,g.y-70,'这里没地方躲','#ccc'); return; }
    g.hide=ctx.hide; g.path=[]; g.channel=null; this.float(g.x,g.y-70, ctx.hide==='wardrobe'?'躲进衣柜':'钻进沙发底','#9ad0ff'); if (this.alert>=2 && ctx.hide==='wardrobe') this.float(g.x,g.y-92,'搜捕中保安会拉开衣柜！','#ff9a9a');
  };
  P.radioPress = function(gi){
    var g=this.ghosts[gi]; if(!g.radio) return;
    g.radio=false; var self=this;
    var myF = GR.idx[this.ghostPlace(g).id].f||1; var fake = myF>3?1:6;
    this.guards.forEach(function(gd){ if (gd.flee>0) return; gd.decoy=30; gd.mode='alert'; gd.goalF=fake; gd.path=[]; gd.searchList=null; });
    this.alert=Math.min(this.alert,1); this.alertT=20;
    this.toast('假消息：“'+fake+'楼有人闹事！” 保安往'+fake+'楼去了');
  };

  // ---------- 更新 ----------
  P.update = function(dt){
    if (this.over) return;
    this.t += dt;
    var self=this;
    if (this.lastToast){ this.lastToast.t-=dt; if (this.lastToast.t<=0) this.lastToast=null; }
    for (var i=this.fx.length-1;i>=0;i--){ this.fx[i].t+=dt; if (this.fx[i].t>1.8) this.fx.splice(i,1); }
    // 户：香、拜神、宵夜
    for (var k in this.units){ var U=this.units[k];
      if (U.incense>0) U.incense=Math.max(0,U.incense-dt);
      if (U.praying>0) U.praying=Math.max(0,U.praying-dt);
      if (U.flicker>0) U.flicker=Math.max(0,U.flicker-dt);
      if (U.supper && !U.supper.eaten && this.t>=U.supper.eatAt){
        var here=U.residents.filter(function(r){return r.state!=='flee' && r.state!=='hide' && r.state!=='shower';});
        if (here.length){ U.supper.eaten=true; U.supper.byHuman=true; }
      }
      for (var p=0;p<U.prayAt.length;p++){ if (U.prayAt[p]!==null && this.t>=U.prayAt[p]){ U.prayAt[p]=null;
        var pr=U.residents.filter(function(r){return r.state==='tv'||r.state==='sleep'||r.state==='night';})[0];
        if (pr){ pr.state='pray'; pr.busy=4; pr.path=this.pathOrNull(pr,'L'+U.id); pr.scheduled=true; } } }
      U.light.L = U.residents.some(function(r){return r.node==='L'+U.id && (r.state==='tv'||r.state==='pray'||r.state==='night'||r.state==='eat'||r.state==='check'||r.state==='salt');})?1:0;
      U.light.B = U.residents.some(function(r){return r.node==='B'+U.id && (r.state==='check'||r.state==='hide');})?1:0;
    }
    this.residents.forEach(function(r){ self.updResident(r,dt); });
    this.guards.forEach(function(g){ self.updGuard(g,dt); });
    this.updDatuk(dt);
    this.ghosts.forEach(function(g,i){ self.updGhost(g,i,dt); });
    // 掉落物过期
    for (var j=this.items.length-1;j>=0;j--){ var it=this.items[j]; if (it.type==='drop'){ it.ttl-=dt; if (it.ttl<=0){ this.items.splice(j,1); this.toast('掉在'+it.where+'的东西被保安收走了'); } } }
    // 警戒衰减
    if (this.alert>0){ this.alertT-=dt; if (this.alertT<=0){ this.alert--; this.alertT=this.alert?60:0; if(this.alert===0) this.guards.forEach(function(g){ if(g.mode!=='flee'){ g.mode='patrol'; g.route=self.patrolRoute(); g.ri=0; g.path=[]; }}); else this.guards.forEach(function(g){ if(g.mode==='hunt') g.mode='alert'; }); } }
    if (this.t>=NIGHT-1/60){ this.endNight(); }
  };

  P.moveAlong = function(who, dt, speed, kind){
    if (!who.edge){
      if (!who.path || !who.path.length) return false;
      var nxt=who.path[0]; var e=this.findEdge(who.node,nxt);
      if (!e){ who.path=[]; return false; }
      if (kind && kind!=='human' && kind!=='guard' && !this.edgeOpen(e,kind,GR.idx[who.node])){ who.path=[]; this.float(who.x,who.y-70,'路被挡住了','#ff9a9a'); return false; }
      who.edge={e:e, from:GR.idx[who.node], to:GR.idx[nxt]}; who.et=0;
    }
    var E=who.edge, len=E.e.len||1;
    who.et += speed*dt/len;
    if (who.et>=1){ who.node=E.to.id; who.x=E.to.x; who.y=E.to.y; who.edge=null; who.path.shift(); return true; }
    who.x = E.from.x+(E.to.x-E.from.x)*who.et; who.y = E.from.y+(E.to.y-E.from.y)*who.et;
    if (Math.abs(E.to.x-E.from.x)>2) who.dir = E.to.x>E.from.x?1:-1;
    return true;
  };

  P.updResident = function(r, dt){
    var U=this.units[r.unit];
    if (r.lineT>0) r.lineT-=dt;
    r.fear=Math.max(0,r.fear-0.35*dt); r.sus=Math.max(0,r.sus-0.3*dt);
    if (r.fear<25 && r.tier>0 && r.state!=='flee' && r.state!=='hide') r.tier=0;
    if (r.path && r.path.length){ this.moveAlong(r,dt,62,'human'); return; }
    // 在目的地
    if (r.state==='pray'){ r.busy-=dt; if (U.praying<=0 && U.incense<=0){ U.praying=3; U.incense=15; } if (r.busy<=0){ r.state='tv'; r.scheduled=false; this.resumeSched(r); } return; }
    if (r.state==='salt'){ r.busy-=dt; if (r.busy<=0){ U.salt=true; this.float(GR.idx['Cd'+U.id].x, GR.idx['Cd'+U.id].y-60,'门口撒了盐','#fff'); r.state='tv'; this.resumeSched(r); } return; }
    if (r.state==='hide'||r.state==='check'){ r.busy-=dt; if (r.busy<=0){ r.state='tv'; this.resumeSched(r); } return; }
    if (r.state==='flee'){ r.busy-=dt; if (r.busy<=0){ r.state='back'; r.path=this.pathOrNull(r,'L'+U.id); } return; }
    if (r.state==='back'){ r.state='tv'; this.resumeSched(r); return; }
    // 按作息
    var cur=null; for (var i=0;i<r.sched.length;i++) if (r.sched[i].t<=this.t) cur=r.sched[i];
    if (cur && cur!==r.cur){ r.cur=cur; this.applyAct(r,cur.act); }
    if (r.state==='shower'){ /* 不在场 */ }
  };
  P.resumeSched = function(r){ r.cur=null; };
  P.applyAct = function(r, act){
    var U=this.units[r.unit];
    if (act==='tv'){ r.state='tv'; r.path=this.pathOrNull(r,'L'+U.id); }
    else if (act==='shower'){ r.state='shower'; r.path=this.pathOrNull(r,'B'+U.id); }
    else if (act==='sleep'){ r.state='sleep'; r.path=this.pathOrNull(r,'B'+U.id); }
    else if (act==='night'){ r.state='night'; r.path=this.pathOrNull(r,'L'+U.id); }
  };

  // 保安
  P.updGuard = function(g, dt){
    if (g.lineT>0) g.lineT-=dt;
    if (g.decoy>0) g.decoy-=dt;
    g.fear=Math.max(0,g.fear-0.5*dt);
    var speed = g.mode==='hunt'?78:(g.mode==='alert'?66:48);
    if (g.flee>0){ g.flee-=dt; if (g.path.length) this.moveAlong(g,dt,95,'guard'); if (g.flee<=0){ g.mode='patrol'; g.route=this.patrolRoute(); g.ri=0; g.path=[]; g.hasRadio=true; } return; }
    if (g.mode==='doze') return;
    if (g.wait>0){ g.wait-=dt; this.guardSee(g,dt); return; }
    if (g.path && g.path.length){ this.moveAlong(g,dt,speed,'guard'); this.guardSee(g,dt); return; }
    // 选下一个目标
    if (g.mode==='patrol'){
      g.ri=(g.ri+1)%g.route.length; g.path=this.pathOrNull(g,g.route[g.ri]);
      if (this.R()<0.25){ g.wait=1.5; }
      if (this.R()<0.05) this.say(g,'guardPatrol');
    } else if (g.mode==='alert' || g.mode==='hunt'){
      var f=g.goalF||1;
      if (!g.searchList){
        g.searchList=['S'+f,'Cd'+f+'_0','Cv'+f+'_2','Cd'+f+'_1'];
        if (g.mode==='hunt'){ var R0=this.R; var us=[0,1,2].sort(function(){return R0()-0.5;}); var self=this;
          g.searchList=['S'+f]; us.forEach(function(u){ g.searchList.push('L'+f+'_'+u); g.searchList.push('B'+f+'_'+u); });
        }
      }
      if (!g.searchList.length){ g.searchList=null; g.goalF = Math.max(1,Math.min(6,f+(this.R()<0.5?1:-1))); return; }
      var nx=g.searchList.shift(); g.path=this.pathOrNull(g,nx);
      if (nx.charAt(0)==='B'){ g.openWardrobe=nx; }
      g.wait = g.mode==='hunt'?1.2:0.6;
    }
    // 拉开衣柜
    if (g.openWardrobe && g.node===g.openWardrobe){
      var self2=this, uid=g.node.slice(1);
      this.ghosts.forEach(function(gh){ if (gh.hide==='wardrobe' && gh.node===g.node){ self2.float(gh.x,gh.y-90,'衣柜被拉开了！','#ff5d5d'); self2.catchGhost(gh,'被保安拉开衣柜抓到'); } });
      g.openWardrobe=null; g.wait=1.5;
    }
  };
  P.guardCone = function(g){
    if (g.flee>0 || g.mode==='doze') return null;
    var n=GR.idx[g.node]; var lane = n.lane;
    if (g.edge){ lane = (g.edge.from.lane==='room'&&g.edge.to.lane==='room')?'room':(g.edge.from.lane==='room'||g.edge.to.lane==='room'?'door':g.edge.from.lane); }
    if (lane==='door') return null;
    var vertical = g.edge && Math.abs(g.edge.to.x-g.edge.from.x)<2;
    return {x:g.x, y:g.y-34, dir:g.dir||1, len: vertical?60:130, warn: vertical?80:170, ang:0.42, wang:0.7, lane:lane, f:n.f, vertical:vertical};
  };
  P.inCone = function(c, gh, warn){
    var dx=gh.x-c.x, dy=(gh.y-34)-c.y;
    var gn=GR.idx[gh.node]; var gl=gn.lane; if (gh.edge) gl = gh.edge.to.lane===gh.edge.from.lane?gh.edge.to.lane:'mix';
    var cf = c.lane, sameBand = false;
    var gband = (gl==='room')?'room':((gl==='corr'||gl==='stair'||gl==='lobby'||gl==='roof')?'corr':gl);
    var cband = (cf==='room')?'room':((cf==='corr'||cf==='stair'||cf==='lobby'||cf==='roof')?'corr':cf);
    if (gband!==cband) return false;
    if (Math.abs(dy)>60) return false;
    var L = warn?c.warn:c.len, A = warn?c.wang:c.ang;
    if (c.vertical) return Math.hypot(dx,dy)<L;
    if (dx*c.dir<0) return false;
    var d=Math.hypot(dx,dy); if (d>L) return false;
    if (cband==='room'){ var gu=Math.floor((gh.x-100)/113), cu=Math.floor((c.x-100)/113); if (gu!==cu) return false; }
    return Math.abs(Math.atan2(dy, Math.abs(dx)))<A || d<26;
  };
  P.ghostVisible = function(gh){
    if (gh.hide) return false;
    var n=GR.idx[gh.node];
    if (!gh.edge && (n.lane==='ceil'||n.lane==='shaft') && !gh.hang) return false;
    if (gh.edge && (gh.edge.e.type==='ceil'||gh.edge.e.type==='shaft'||gh.edge.e.type==='climb')) return false;
    return true;
  };
  P.guardSee = function(g, dt){
    var c=this.guardCone(g); if(!c) return;
    var self=this;
    this.ghosts.forEach(function(gh){
      if (!self.ghostVisible(gh) || gh.respawn>0) return;
      if (self.inCone(c,gh,false)){
        gh.exposure+=dt; gh.lit=true; gh.reveal=Math.max(gh.reveal,0.5);
        if (!gh.warned){ gh.warned=true; self.float(gh.x,gh.y-90,'被手电照到！','#ffd54a'); var f=GR.idx[gh.node].f||1; self.raiseAlert(2,f,g.name+'的手电照到了'+gh.name+'！搜捕开始'); }
        if (gh.exposure>=2) self.catchGhost(gh, '被'+g.name+'抓到');
      }
    });
  };
  P.updDatuk = function(dt){
    var self=this;
    this.datuk.forEach(function(d){
      if (d.done) return;
      if (!d.warned && self.t>=d.at-15){ d.warned=true; self.toast(d.f+'楼走廊传来铃声和檀香——拿督公要巡视了'); }
      if (self.t>=d.at){
        if (d.sweep<0) d.sweep=0;
        d.sweep += dt/8;
        d.x = W - d.sweep*(W+60);
        self.ghosts.forEach(function(gh){
          var n=GR.idx[gh.node]; if (gh.stun>0||gh.respawn>0) return;
          var lane = gh.edge? (gh.edge.to.lane===gh.edge.from.lane?gh.edge.to.lane:'mix') : n.lane;
          var f = gh.edge? (gh.edge.to.f) : n.f;
          if ((lane==='corr'||lane==='stair') && f===d.f && !gh.hide && Math.abs(gh.x-d.x)<34){
            gh.stun=3; gh.reveal=4; gh.path=[]; self.stats.datukHits++; self.float(gh.x,gh.y-95,'拿督公巡视：定身 3 秒','#ffd54a');
            self.raiseAlert(1,f,gh.name+'在'+f+'楼被拿督公照出原形');
          }
        });
        if (d.sweep>=1) d.done=true;
      }
    });
  };
  P.catchGhost = function(gh, why){
    this.stats.caught++;
    var c=gh.carry, drop={supper:[], money:0, stash:0};
    var ns=Math.floor(c.supper.length/2); drop.supper=c.supper.splice(c.supper.length-ns, ns);
    drop.money=Math.floor(c.money/2); c.money-=drop.money;
    if (c.stash){ drop.stash=c.stash; c.stash=0; }
    var n=GR.idx[gh.node];
    if (drop.supper.length||drop.money||drop.stash){
      this.items.push({type:'drop', owner:gh.id, x:gh.x, y:gh.y, f:n.f, node:gh.node, supper:drop.supper, money:drop.money, stash:drop.stash, ttl:75, where:(n.f?n.f+'楼':'楼下')});
      this.float(gh.x,gh.y-60,'东西掉了一半','#ff9a9a');
    }
    this.toast(gh.name+why+'，打回水箱，魂力减半');
    var t=GR.idx['TANK']; gh.node='TANK'; gh.edge=null; gh.path=[]; gh.x=t.x; gh.y=t.y; gh.hide=null; gh.ring=null; gh.hang=0;
    gh.soul=Math.max(10,Math.floor(gh.soul/2)); gh.exposure=0; gh.respawn=2; gh.stun=0; gh.warned=false;
  };
  P.updGhost = function(g, gi, dt){
    if (g.respawn>0) g.respawn-=dt;
    if (g.reveal>0) g.reveal-=dt;
    if (g.hang>0 && !g.ring) g.hang=Math.max(0,g.hang-dt);
    g.lit=false;
    if (g.channel){
      var ch=g.channel; ch.t+=dt;
      var still = this.takeable(g, GR.idx[g.node], g.channel.tk.unit.id, ch.room);
      if (g.edge || g.stun>0 || !still || still.kind!==ch.tk.kind || this.watchers(ch.tk.unit.id, ch.room).length){ g.channel=null; this.float(g.x,g.y-84,'被打断','#ff9a9a'); }
      else if (ch.t>=ch.dur){ g.channel=null; this.finishTake(g, still, ch.room); }
    }
    if (g.ring){ g.ring.t+=dt; if (g.ring.t>g.ring.dur+0.35){ var tg=g.ring.target; g.ring=null; g.hang=0; this.float(tg.x,tg.y-100,'错过时机','#ffb27a'); if(!tg.mode){ tg.sus=Math.min(100,tg.sus+10);} } }
    if (g.stun>0){ g.stun-=dt; g.soul=Math.max(0,g.soul-5*dt); if (g.stun<=0 && g.pushBack){ var pb=GR.idx[g.pushBack]; g.node=pb.id; g.x=pb.x; g.y=pb.y; g.edge=null; g.pushBack=null; } }
    else {
      var spd = DATA.ghosts[g.id].speed;
      if (g.id==='toyol') spd *= (1 - Math.min(0.5, (g.carry.money)/110));
      if (g.id==='eking') spd *= (1 - Math.min(0.25, g.carry.supper.length*0.07));
      var onGround=false;
      if (g.id==='tianhua'){
        var ln = g.edge ? g.edge.e.type : GR.idx[g.node].lane;
        onGround = !(ln==='ceil'||ln==='climb'||ln==='shaft'||ln==='roof'||ln==='drop');
        if (onGround) spd=55;
      }
      g.onGround=onGround;
      var prevNode=g.node;
      if (g.path.length && !g.hide) this.moveAlong(g,dt,spd,g.id);
      // 神光
      var n=GR.idx[g.node]; var lane = g.edge ? ((g.edge.from.lane==='room'||g.edge.to.lane==='room')?'room':'x') : n.lane;
      if (g.edge && g.edge.e.type==='drop') lane = g.et>0.6?'room':'x';
      var f = g.edge? (g.edge.to.f||g.edge.from.f) : n.f;
      var U = this.litAt(g.x, g.y, f, lane);
      if (!U && g.hang && n.lane==='ceil' && n.room){ U=this.litAt(GR.idx[n.room+n.f+'_'+n.u].x, GR.idx[n.room+n.f+'_'+n.u].y, n.f, 'room'); }
      if (U && g.respawn<=0 && !g.hide){
        g.stun=2; g.soul=Math.max(0,g.soul-10); this.stats.stunned++;
        var back = g.edge ? g.edge.from.id : prevNode;
        if (this.litNode(GR.idx[back])) back = g.edge? g.edge.from.id : (n.lane==='ceil'?n.id:'Cd'+U.id);
        if (n.lane==='ceil') back=n.id;
        g.pushBack = back; g.path=[]; g.ring=null; g.hang=0;
        this.float(g.x,g.y-90,'神光镇住！定身 2 秒','#ffe08a');
      }
      if (onGround) g.soul=Math.max(0,g.soul-4*dt);
    }
    if (g.node==='TANK' && !g.edge){
      g.soul=Math.min(100,g.soul+8*dt);
      var c=g.carry, any=false;
      if (c.supper.length){ g.done.supper=g.done.supper.concat(c.supper); c.supper=[]; any=true; }
      if (c.money){ g.done.money+=c.money; c.money=0; any=true; }
      if (c.stash){ g.done.stash+=c.stash; c.stash=0; any=true; }
      if (any){ this.float(g.x,g.y-80,'带回水箱，存好了','#9affc8'); if (this.commDone(g.id)) this.toast(g.name+'的委托完成！'); }
    }
    if (g.soul<=0 && g.respawn<=0){ this.catchGhost(g,'魂力耗尽'); }
  };
  P.commDone = function(id){
    var g=this.ghosts.filter(function(x){return x.id===id;})[0];
    if (id==='eking'){ var s={}; g.done.supper.forEach(function(u){s[u]=1;}); return Object.keys(s).length>=3; }
    if (id==='toyol') return g.done.money>=50;
    if (id==='tianhua') return g.done.stash>0;
  };
  P.commProgress = function(id){
    var g=this.ghosts.filter(function(x){return x.id===id;})[0];
    if (id==='eking'){ var s={}; g.done.supper.forEach(function(u){s[u]=1;}); return {done:Object.keys(s).length, carry:g.carry.supper.length, need:3}; }
    if (id==='toyol') return {done:g.done.money, carry:g.carry.money, need:50};
    return {done:g.done.stash?1:0, carry:g.carry.stash?1:0, need:1};
  };
  P.endNight = function(){
    if (this.over) return;
    this.over=true; var self=this;
    var res = this.ghosts.map(function(g){ return {id:g.id, name:g.name, text:self.comm[g.id].text, ok:self.commDone(g.id)}; });
    var n = res.filter(function(r){return r.ok;}).length;
    var stars = n;
    var xianghuo = n*100 + this.scares*10;
    this.result = {comms:res, done:n, scares:this.scares, guardScares:this.guardScares, stars:stars, xianghuo:xianghuo, caught:this.stats.caught};
  };

  return {Game:Game, GEO:GEO, GR:GR, NIGHT:NIGHT, rng:rng};
})();
if (typeof module !== 'undefined') module.exports = LYG_SIM;
