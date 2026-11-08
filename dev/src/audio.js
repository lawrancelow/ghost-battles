// ===================== 聲音：全部即時合成（離線、單檔）=====================
const Sound = (() => {
  let ac = null, master, music, sfx, verb, verbIn, noiseBuf, mode = null, want = null, nodes = [], timers = [];
  let on = true; try { on = localStorage.getItem('gb_sound') !== '0'; } catch (e) {}
  const SCALE = [146.83, 174.61, 196.0, 220.0, 261.63, 293.66, 349.23, 392.0, 440.0]; // D 小調五聲
  function init() {
    if (ac) return true;
    const AC = window.AudioContext || window.webkitAudioContext; if (!AC) return false;
    ac = new AC();
    master = ac.createGain(); master.gain.value = on ? 0.9 : 0; master.connect(ac.destination);
    const comp = ac.createDynamicsCompressor(); comp.threshold.value = -18; comp.ratio.value = 4; comp.connect(master);
    music = ac.createGain(); music.gain.value = 0.5; music.connect(comp);
    sfx = ac.createGain(); sfx.gain.value = 0.85; sfx.connect(comp);
    // 殘響
    verb = ac.createConvolver(); const len = ac.sampleRate * 3.2, ir = ac.createBuffer(2, len, ac.sampleRate);
    for (let c = 0; c < 2; c++) { const d = ir.getChannelData(c); for (let i = 0; i < len; i++) d[i] = (Math.random() * 2 - 1) * Math.pow(1 - i / len, 2.6); }
    verb.buffer = ir; verbIn = ac.createGain(); verbIn.gain.value = 0.6; verbIn.connect(verb); verb.connect(comp);
    noiseBuf = ac.createBuffer(1, ac.sampleRate * 2, ac.sampleRate); const nd = noiseBuf.getChannelData(0); for (let i = 0; i < nd.length; i++) nd[i] = Math.random() * 2 - 1;
    return true;
  }
  function unlock() { if (!init()) return; if (ac.state === 'suspended') ac.resume(); if (want && want !== mode) setMode(want, true); }
  ['pointerdown', 'keydown', 'touchstart'].forEach(ev => window.addEventListener(ev, unlock, { passive:true }));
  const now = () => ac.currentTime;
  // ---------- 基本音源 ----------
  function env(g, t, a, peak, d) { g.gain.setValueAtTime(0.0001, t); g.gain.exponentialRampToValueAtTime(peak, t + a); g.gain.exponentialRampToValueAtTime(0.0001, t + a + d); }
  function tone(o) { // {f,type,t,a,d,v,dest,wet,f2,detune,pan}
    const t = o.t || now(); const osc = ac.createOscillator(), g = ac.createGain();
    osc.type = o.type || 'sine'; osc.frequency.setValueAtTime(o.f, t); if (o.f2) osc.frequency.exponentialRampToValueAtTime(o.f2, t + (o.slide || o.d));
    if (o.detune) osc.detune.value = o.detune;
    env(g, t, o.a || 0.005, o.v || 0.2, o.d || 0.3);
    let last = g; if (o.pan) { const p = ac.createStereoPanner(); p.pan.value = o.pan; g.connect(p); last = p; }
    osc.connect(g); last.connect(o.dest || sfx); if (o.wet) { const w = ac.createGain(); w.gain.value = o.wet; last.connect(w); w.connect(verbIn); }
    osc.start(t); osc.stop(t + (o.a || 0.005) + (o.d || 0.3) + 0.05); return osc;
  }
  function noise(o) { // {t,d,type,f,f2,q,v,dest,wet,a}
    const t = o.t || now(); const src = ac.createBufferSource(); src.buffer = noiseBuf; src.loop = true;
    const fl = ac.createBiquadFilter(); fl.type = o.type || 'bandpass'; fl.frequency.setValueAtTime(o.f || 1000, t); if (o.f2) fl.frequency.exponentialRampToValueAtTime(o.f2, t + o.d); fl.Q.value = o.q || 1;
    const g = ac.createGain(); env(g, t, o.a || 0.003, o.v || 0.2, o.d || 0.2);
    src.connect(fl); fl.connect(g); g.connect(o.dest || sfx); if (o.wet) { const w = ac.createGain(); w.gain.value = o.wet; g.connect(w); w.connect(verbIn); }
    src.start(t, Math.random()); src.stop(t + (o.a || 0.003) + o.d + 0.05);
  }
  // ---------- 背景音樂 ----------
  function stopAll(fade) {
    const t = now(); nodes.forEach(n => { try { if (n.gain) { n.gain.cancelScheduledValues(t); n.gain.setValueAtTime(n.gain.value, t); n.gain.linearRampToValueAtTime(0, t + fade); } } catch (e) {} });
    const old = nodes; nodes = []; setTimeout(() => old.forEach(n => { try { n.stop && n.stop(); n.disconnect(); } catch (e) {} }), fade * 1000 + 100);
    timers.forEach(clearTimeout); timers = [];
  }
  function every(fn, min, max) { const go = () => { if (!ac) return; fn(); timers.push(setTimeout(go, (min + Math.random() * (max - min)) * 1000)); }; timers.push(setTimeout(go, min * 500)); }
  function drone(freqs, cutoff, vol) {
    const g = ac.createGain(); g.gain.setValueAtTime(0, now()); g.gain.linearRampToValueAtTime(vol, now() + 3); g.connect(music); nodes.push(g);
    const lp = ac.createBiquadFilter(); lp.type = 'lowpass'; lp.frequency.value = cutoff; lp.Q.value = 3; lp.connect(g);
    const lfo = ac.createOscillator(), lg = ac.createGain(); lfo.frequency.value = 0.06; lg.gain.value = cutoff * 0.45; lfo.connect(lg); lg.connect(lp.frequency); lfo.start(); nodes.push(lfo);
    freqs.forEach((f, i) => { const o = ac.createOscillator(); o.type = i === 0 ? 'sine' : 'sawtooth'; o.frequency.value = f; o.detune.value = (i % 2 ? 7 : -6); o.connect(lp); o.start(); nodes.push(o); });
    const w = ac.createGain(); w.gain.value = 0.35; g.connect(w); w.connect(verbIn); nodes.push(w);
  }
  function wind(vol) {
    const src = ac.createBufferSource(); src.buffer = noiseBuf; src.loop = true;
    const bp = ac.createBiquadFilter(); bp.type = 'bandpass'; bp.frequency.value = 500; bp.Q.value = 1.2;
    const lfo = ac.createOscillator(), lg = ac.createGain(); lfo.frequency.value = 0.045; lg.gain.value = 320; lfo.connect(lg); lg.connect(bp.frequency); lfo.start();
    const g = ac.createGain(); g.gain.setValueAtTime(0, now()); g.gain.linearRampToValueAtTime(vol, now() + 4);
    src.connect(bp); bp.connect(g); g.connect(music); src.start(); nodes.push(src, lfo, g);
  }
  const musicBox = (f, t, v) => { tone({ f, t, d:2.6, v:v || 0.07, dest:music, wet:0.9, detune:-18 }); tone({ f:f * 2, t, d:1.2, v:(v || 0.07) * 0.35, dest:music, wet:0.9, detune:-12 }); };
  function erhu(f1, f2, t, dur, v) {
    const o = ac.createOscillator(); o.type = 'sawtooth'; o.frequency.setValueAtTime(f1, t); o.frequency.exponentialRampToValueAtTime(f2, t + dur * 0.8);
    const vib = ac.createOscillator(), vg = ac.createGain(); vib.frequency.value = 5.2; vg.gain.setValueAtTime(0, t); vg.gain.linearRampToValueAtTime(f1 * 0.018, t + dur * 0.5); vib.connect(vg); vg.connect(o.frequency);
    const bp = ac.createBiquadFilter(); bp.type = 'bandpass'; bp.frequency.value = 1100; bp.Q.value = 2.2;
    const g = ac.createGain(); g.gain.setValueAtTime(0.0001, t); g.gain.exponentialRampToValueAtTime(v, t + 0.35); g.gain.setValueAtTime(v, t + dur - 0.5); g.gain.exponentialRampToValueAtTime(0.0001, t + dur);
    o.connect(bp); bp.connect(g); g.connect(music); const w = ac.createGain(); w.gain.value = 0.8; g.connect(w); w.connect(verbIn);
    o.start(t); vib.start(t); o.stop(t + dur + 0.1); vib.stop(t + dur + 0.1);
  }
  function bell(f, t, v) { [1, 2.76, 5.4, 8.93].forEach((m, i) => tone({ f:f * m, t, a:0.004, d:4.5 / (i + 1), v:v / (i + 1.2), dest:music, wet:1 })); }
  function taiko(t, v) { tone({ f:120, f2:48, slide:0.25, t, d:0.45, v:v || 0.5, dest:music }); noise({ t, d:0.06, type:'lowpass', f:900, v:(v || 0.5) * 0.4, dest:music }); }
  const MODES = {
    village() {
      drone([36.71, 73.42, 110.3], 320, 0.16); wind(0.05);
      every(() => { const t = now() + 0.05; const i = Math.floor(Math.random() * SCALE.length); musicBox(SCALE[i] * 2, t); if (Math.random() < 0.4) musicBox(SCALE[(i + 2) % SCALE.length] * 2, t + 0.45, 0.05); }, 2.4, 4.8);
      every(() => { const t = now() + 0.1; if (Math.random() < 0.5) bell(146.83, t, 0.09); else erhu(440, 349.23, t, 2.6, 0.05); }, 11, 19);
    },
    story() { drone([36.71, 73.42], 260, 0.12); wind(0.03); every(() => bell(110, now() + 0.1, 0.06), 9, 16); },
    office() { // 凌晨兩點的辦公室：日光燈嗡嗡聲 + 掛鐘
      const o = ac.createOscillator(); o.type = 'sawtooth'; o.frequency.value = 50; const lp = ac.createBiquadFilter(); lp.type = 'lowpass'; lp.frequency.value = 180;
      const g = ac.createGain(); g.gain.value = 0.025; o.connect(lp); lp.connect(g); g.connect(music); o.start(); nodes.push(o, g);
      let k = 0; every(() => { k++; tone({ f:k % 2 ? 2400 : 2100, t:now() + 0.02, d:0.03, v:0.035, dest:music, wet:0.3 }); }, 1, 1);
    },
    battle() {
      drone([36.71, 73.42], 420, 0.11);
      const bpm = 108, beat = 60 / bpm, bar = beat * 4; let t0 = now() + 0.15, n = 0;
      const pat = [[0, 0.55], [1.5, 0.35], [2, 0.5], [3.5, 0.3]];
      let note = 4;
      const schedule = () => {
        if (!ac) return; const t = t0 + n * bar;
        pat.forEach(([b, v]) => taiko(t + b * beat, v * (n % 4 === 3 && b === 3.5 ? 1.4 : 1)));
        for (let s = 0; s < 8; s++) if (Math.random() < 0.55) { note = Math.max(0, Math.min(SCALE.length - 1, note + [-2, -1, 1, 2][Math.floor(Math.random() * 4)])); tone({ f:SCALE[note] * 2, type:'triangle', t:t + s * beat / 2, d:0.35, v:0.06, dest:music, wet:0.4 }); }
        tone({ f:73.42, type:'triangle', t, d:beat * 1.6, v:0.12, dest:music }); tone({ f:n % 2 ? 87.31 : 65.41, type:'triangle', t:t + beat * 2, d:beat * 1.6, v:0.1, dest:music });
        if (n % 4 === 0) noise({ t:t, d:1.4, type:'highpass', f:6000, v:0.05, dest:music, wet:0.6, a:0.01 });
        n++; timers.push(setTimeout(schedule, Math.max(10, (t0 + n * bar - now() - 0.25) * 1000)));
      };
      schedule();
    },
    silent() {},
  };
  function setMode(m, force) {
    want = m; if (!ac || ac.state !== 'running') return; if (m === mode && !force) return;
    stopAll(1.2); mode = m; (MODES[m] || MODES.silent)();
  }
  // ---------- 音效 ----------
  const S = {
    chop() { const t = now(); noise({ t, d:0.09, f:1700, q:1.4, v:0.45 }); tone({ f:150, f2:55, t, d:0.16, v:0.5 }); tone({ f:420, f2:300, t, d:0.05, v:0.12, type:'triangle' }); },
    treeFall() { const t = now(); noise({ t, d:0.7, type:'lowpass', f:900, f2:200, v:0.35, a:0.05 }); tone({ f:90, f2:40, t:t + 0.5, d:0.4, v:0.5 }); },
    crow(pan) {
      const caw = (t) => { const o = ac.createOscillator(); o.type = 'sawtooth'; o.frequency.setValueAtTime(560, t); o.frequency.exponentialRampToValueAtTime(400, t + 0.24);
        const fm = ac.createOscillator(), fg = ac.createGain(); fm.frequency.value = 38; fg.gain.value = 140; fm.connect(fg); fg.connect(o.frequency);
        const bp = ac.createBiquadFilter(); bp.type = 'bandpass'; bp.frequency.value = 1500; bp.Q.value = 3; const g = ac.createGain(); env(g, t, 0.015, 0.16, 0.24);
        const p = ac.createStereoPanner(); p.pan.value = pan || 0; o.connect(bp); bp.connect(g); g.connect(p); p.connect(sfx); const w = ac.createGain(); w.gain.value = 0.5; p.connect(w); w.connect(verbIn);
        o.start(t); fm.start(t); o.stop(t + 0.32); fm.stop(t + 0.32); };
      const t = now() + Math.random() * 0.06; caw(t); if (Math.random() < 0.7) caw(t + 0.3);
      for (let i = 0; i < 5; i++) noise({ t:t + i * 0.07, d:0.05, type:'bandpass', f:900, q:0.8, v:0.06 }); // 拍翅
    },
    harvest() { noise({ d:0.32, f:3200, f2:700, q:0.9, v:0.32, a:0.02 }); },
    craft() { const t = now(); [0, 0.13].forEach(d => { tone({ f:330, f2:180, t:t + d, d:0.08, v:0.35, type:'triangle' }); noise({ t:t + d, d:0.03, f:2500, v:0.2 }); }); },
    coin() { const t = now(); tone({ f:1320, t, d:0.35, v:0.12, wet:0.3 }); tone({ f:1980, t:t + 0.06, d:0.4, v:0.1, wet:0.3 }); },
    build() { const t = now(); for (let i = 0; i < 3; i++) { tone({ f:220, f2:110, t:t + i * 0.16, d:0.09, v:0.4, type:'triangle' }); noise({ t:t + i * 0.16, d:0.04, f:1800, v:0.25 }); } },
    gong() { const t = now(); [1, 1.48, 2.02, 2.76, 3.9].forEach((m, i) => tone({ f:98 * m, f2:96 * m, t, a:0.01, d:3.2 / (i * 0.5 + 1), v:0.18 / (i + 1), wet:0.9 })); noise({ t, d:0.05, type:'lowpass', f:600, v:0.3 }); },
    levelUp() { this.gong(); const t = now(); [0, 2, 4, 7].forEach((k, i) => musicBox(SCALE[Math.min(8, k + 1)] * 2, t + 0.25 + i * 0.12, 0.09)); },
    click() { tone({ f:1700, d:0.025, v:0.06, type:'triangle' }); },
    paper() { noise({ d:0.12, type:'highpass', f:2500, v:0.12, a:0.01 }); },
    waIn() { const t = now(); tone({ f:880, t, d:0.09, v:0.13 }); tone({ f:1318, t:t + 0.09, d:0.16, v:0.13 }); },
    waOut() { noise({ d:0.14, type:'highpass', f:1500, f2:5000, v:0.12, a:0.01 }); tone({ f:1046, d:0.06, v:0.05 }); },
    key() { tone({ f:2600 + Math.random() * 600, d:0.015, v:0.03, type:'square' }); },
    praise() { const t = now(); tone({ f:1568, t, d:0.12, v:0.06, type:'square' }); tone({ f:2093, t:t + 0.08, d:0.16, v:0.06, type:'square' }); },
    hit() { const t = now(); noise({ t, d:0.07, type:'lowpass', f:1200, v:0.35 }); tone({ f:110, f2:55, t, d:0.1, v:0.35 }); },
    skill() { const t = now(); noise({ t, d:0.35, f:400, f2:3000, q:2, v:0.25, a:0.05 }); tone({ f:880, t:t + 0.25, d:0.8, v:0.08, wet:0.8 }); },
    combo(n) { const t = now(); for (let i = 0; i < 3; i++) tone({ f:SCALE[Math.min(8, 3 + i + (n || 0) % 3)] * 2, type:'triangle', t:t + i * 0.06, d:0.2, v:0.1 }); },
    win() { this.gong(); const t = now(); [4, 5, 6, 8].forEach((k, i) => musicBox(SCALE[k] * 2, t + 0.4 + i * 0.18, 0.1)); },
    lose() { erhu(392, 196, now() + 0.05, 2.4, 0.09); bell(73.42, now() + 0.1, 0.12); },
    chest() { const t = now(); tone({ f:180, f2:320, t, d:0.35, v:0.15, type:'sawtooth' }); this.coin(); },
    flatline() { const t = now(); tone({ f:988, t, a:0.01, d:3.2, v:0.09, type:'sine' }); },
    heartbeat() { const t = now(); tone({ f:60, f2:40, t, d:0.12, v:0.5 }); tone({ f:55, f2:38, t:t + 0.22, d:0.12, v:0.35 }); },
    whoosh() { noise({ d:0.5, f:300, f2:2500, q:1.5, v:0.2, a:0.15 }); },
  };
  function play(name, ...a) { if (!ac || !on || ac.state !== 'running') return; try { S[name] && S[name](...a); } catch (e) {} }
  function toggle() { on = !on; try { localStorage.setItem('gb_sound', on ? '1' : '0'); } catch (e) {} if (ac) master.gain.setTargetAtTime(on ? 0.9 : 0, now(), 0.05); return on; }
  return { play, setMode, toggle, isOn:() => on, unlock };
})();
