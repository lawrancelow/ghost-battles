// 由 n30_daily.js 生成 game/battle/bt_n30daily.gd（新鬼平日小動作，原生版）
// 用法：node gen_n30d.js <n30_daily.js> <out.gd>
// 只處理 n30_daily.js 用到嘅細子集（箭咀函式、物件／陣列字面、for 迴圈、三元、模板字串、ctx 方法）
const fs = require('fs');
const acorn = require(require.resolve('acorn', { paths: [__dirname, '/home/claude/gbgd/jsgd'] }));
const src = fs.readFileSync(process.argv[2], 'utf8');
const ast = acorn.parse(src, { ecmaVersion: 2022 });

const HELPERS = new Set(['sw', 'env', 'bump', 'T', 'note', 'zz', 'sweat', 'flake', 'coin', 'card', 'at']);
const RENAME = new Set(['str', 'len', 'range', 'max', 'min', 'abs', 'sign', 'int', 'float', 'char', 'print', 'seed', 'var', 'func', 'in', 'is', 'as', 'not', 'and', 'or', 'pass', 'match', 'class', 'signal', 'self', 'tan', 'cos', 'sin', 'floor']);
const KIT = { seg: 'BtN30.seg', cl: 'BtN30.cl', lerp: 'BtN30.lerp_', puff: 'BtN30.puff', drops: 'BtN30.drops', ring: 'BtN30.ring', burst: 'BtN30.burst', stars: 'BtN30.stars', rnd: 'BtN30.rnd', txt: 'BtN30.txt', crayon: 'h_crayon', at: 'h_at2' };
const MATH = { sin: 'sin', cos: 'cos', abs: 'absf', floor: 'floor', max: 'maxf', min: 'minf', sign: 'signf', sqrt: 'sqrt', round: 'round', pow: 'pow' };

function id(n) { return HELPERS.has(n) ? 'h_' + n : RENAME.has(n) ? n + '_' : n; }
function num(v, asFloat) {
  if (Number.isInteger(v) && !asFloat) return String(v);
  let s = String(v); if (!/[.e]/.test(s)) s += '.0'; return s;
}
function q(s) { return JSON.stringify(s); }
const PREC = { '||': 1, '&&': 2, '==': 4, '!=': 4, '===': 4, '!==': 4, '<': 5, '>': 5, '<=': 5, '>=': 5, '+': 6, '-': 6, '*': 7, '/': 7, '%': 7 };

function ex(n, ctxBool) {
  switch (n.type) {
    case 'Literal':
      if (typeof n.value === 'number') return num(n.value);
      if (typeof n.value === 'string') return q(n.value);
      if (n.value === null) return 'null';
      if (typeof n.value === 'boolean') return n.value ? 'true' : 'false';
      throw new Error('lit ' + n.raw);
    case 'Identifier':
      if (n.name === 'undefined') return 'null';
      return id(n.name);
    case 'TemplateLiteral': {
      const parts = [];
      n.quasis.forEach((qq, i) => { if (qq.value.cooked) parts.push(q(qq.value.cooked)); if (i < n.expressions.length) parts.push('h_s(' + ex(n.expressions[i]) + ')'); });
      return '(' + parts.join(' + ') + ')';
    }
    case 'ArrayExpression': return '[' + n.elements.map((e) => ex(e)).join(', ') + ']';
    case 'ObjectExpression':
      return '{' + n.properties.map((p) => q(p.key.name || p.key.value) + ': ' + ex(p.value)).join(', ') + '}';
    case 'UnaryExpression':
      if (n.operator === '-') return '-' + wrap(n.argument, 8);
      if (n.operator === '!') return '(not ' + wrap(n.argument, 8) + ')';
      if (n.operator === '+') return 'float(' + ex(n.argument) + ')';
      throw new Error('unary ' + n.operator);
    case 'BinaryExpression': {
      const op = n.operator;
      if (op === '%') return 'fmod(' + ex(n.left) + ', ' + ex(n.right) + ')';
      const gop = op === '===' ? '==' : op === '!==' ? '!=' : op;
      let R;
      if (op === '/') R = (n.right.type === 'Literal' && typeof n.right.value === 'number') ? num(n.right.value, true) : 'float(' + ex(n.right) + ')';
      else R = wrap(n.right, PREC[op] + 0.5);
      return wrap(n.left, PREC[op]) + ' ' + gop + ' ' + R;
    }
    case 'LogicalExpression':
      if (n.operator === '&&') return wrap(n.left, 2) + ' and ' + wrap(n.right, 2.5);
      if (ctxBool) return wrap(n.left, 1) + ' or ' + wrap(n.right, 1.5);
      return 'h_or(' + ex(n.left) + ', ' + ex(n.right) + ')';
    case 'ConditionalExpression':
      return '(' + ex(n.consequent) + ' if ' + ex(n.test, true) + ' else ' + ex(n.alternate) + ')';
    case 'MemberExpression': {
      if (n.computed) {
        const pr = n.property.type === 'Literal' && typeof n.property.value === 'number' ? String(n.property.value) : 'int(' + ex(n.property) + ')';
        return wrap(n.object, 9) + '[' + pr + ']';
      }
      const on = n.object.type === 'Identifier' ? n.object.name : null, pn = n.property.name;
      if (on === 'Math') { if (pn === 'PI') return 'PI'; throw new Error('Math.' + pn); }
      if (on === 'N' && pn in KIT) return KIT[pn];
      if (on === 'f') return 'h_g(f, ' + q(pn) + ')';
      return wrap(n.object, 9) + '.' + pn;
    }
    case 'CallExpression': {
      const c = n.callee, args = n.arguments.map((a) => ex(a));
      if (c.type === 'MemberExpression' && !c.computed) {
        const on = c.object.type === 'Identifier' ? c.object.name : null, pn = c.property.name;
        if (on === 'Math') return MATH[pn] + '(' + args.join(', ') + ')';
        if (on === 'N' && c.object.type === 'Identifier') { if (!(pn in KIT)) throw new Error('N.' + pn); return KIT[pn] + '(' + args.join(', ') + ')'; }
        if (c.object.type === 'MemberExpression' && c.object.object.name === 'N' && c.object.property.name === 'E' && pn === 'io') return 'BtMoves.eio(' + args.join(', ') + ')';
        if (on === 'N30M' && pn === 'bolt') return 'h_bolt(' + args.join(', ') + ')';
        if (pn === 'push') return ex(c.object) + '.append(' + args.join(', ') + ')';
        return ex(c) + '(' + args.join(', ') + ')';
      }
      if (c.type === 'Identifier') return id(c.name) + '(' + args.join(', ') + ')';
      throw new Error('call ' + c.type);
    }
    case 'AssignmentExpression': return ex(n.left) + ' ' + n.operator + ' ' + ex(n.right);
    case 'UpdateExpression': return ex(n.argument) + (n.operator === '++' ? ' += 1' : ' -= 1');
    case 'SequenceExpression': throw new Error('seq');
  }
  throw new Error('expr ' + n.type + ' @' + n.start);
}
function prec(n) {
  if (n.type === 'BinaryExpression') return n.operator === '%' ? 10 : PREC[n.operator];
  if (n.type === 'LogicalExpression') return PREC[n.operator];
  if (n.type === 'ConditionalExpression' || n.type === 'AssignmentExpression') return 0;
  if (n.type === 'UnaryExpression') return 8;
  return 10;
}
function wrap(n, p) { const s = ex(n); return prec(n) < p ? '(' + s + ')' : s; }

function st(n, ind, out) {
  const I = '\t'.repeat(ind);
  switch (n.type) {
    case 'BlockStatement': if (!n.body.length) out.push(I + 'pass'); n.body.forEach((s) => st(s, ind, out)); return;
    case 'ExpressionStatement': out.push(I + ex(n.expression)); return;
    case 'VariableDeclaration': n.declarations.forEach((d) => out.push(I + 'var ' + id(d.id.name) + (d.init ? ' = ' + ex(d.init) : ''))); return;
    case 'ReturnStatement': out.push(I + 'return' + (n.argument ? ' ' + ex(n.argument) : '')); return;
    case 'IfStatement':
      out.push(I + 'if ' + ex(n.test, true) + ':'); st(n.consequent, ind + 1, out);
      if (n.alternate) { out.push(I + 'else:'); st(n.alternate, ind + 1, out); }
      return;
    case 'ForStatement': {
      const d = n.init.declarations[0], v = id(d.id.name), a = ex(d.init), t = n.test;
      if (t.left.name !== d.id.name || !(n.update.type === 'UpdateExpression' && n.update.operator === '++')) throw new Error('for');
      const lim = t.operator === '<' ? ex(t.right) : t.operator === '<=' ? ex(t.right) + ' + 1' : null;
      if (!lim) throw new Error('for op');
      out.push(I + 'for ' + v + ' in range(' + a + ', ' + lim + '):'); st(n.body, ind + 1, out); return;
    }
  }
  throw new Error('stmt ' + n.type + ' @' + n.start);
}
function fnBody(fn, ind) {
  const out = [];
  if (fn.body.type === 'BlockStatement') st(fn.body, ind, out);
  else out.push('\t'.repeat(ind) + 'return ' + ex(fn.body));
  return out;
}
function params(fn, all) { return fn.params.map((p) => p.type === 'Identifier' ? id(p.name) + (all ? ' = null' : '') : (() => { throw new Error('param'); })()).join(', '); }

// ---- 搵 IIFE 入面嘅嘢 ----
const decl = ast.body.find((b) => b.type === 'VariableDeclaration' && b.declarations[0].id.name === 'N30D');
const iife = decl.declarations[0].init.callee.body.body;
const out = [];
out.push('# 自動生成自 n30_daily.js（tools/jsgd/gen_n30d.js）——新鬼 40 隻平日小動作，原生版（用 BtN30 原生招式工具）');
out.push('# 改原 JS 再生成：node tools/jsgd/gen_n30d.js <src>/n30_daily.js game/battle/bt_n30daily.gd');
out.push('extends RefCounted');
out.push('');
out.push('static func h_or(a, b): return a if a else b');
out.push('static func h_g(f, n: String): return f.get(n)');
out.push('static func h_at2(S: Dictionary, m: Transform2D, u: float, v: float) -> Array:\n\tvar p = BtN30.at(S, m, u, v); return [p.x, p.y]');
out.push('static func h_s(v) -> String: return J.str(v)');
out.push('static func h_crayon(ctx: Ctx, pts: Array, col, w: float, seed_: float, _al = null) -> void:');
out.push('\tvar P = []');
out.push('\tfor p in pts: P.append(Vector2(p[0], p[1]))');
out.push('\tBtN30.crayon(ctx, P, col, w, seed_)');
out.push('static func h_bolt(ctx: Ctx, a: Array, b: Array, w: float, seed_: float, col = null, al = null) -> void: BtN30d.bolt(ctx, Vector2(a[0], a[1]), Vector2(b[0], b[1]), w, seed_, col, al)');
const acts = [];
let n = 0;
for (const s of iife) {
  if (s.type === 'VariableDeclaration') {
    for (const d of s.declarations) {
      const nm = d.id.name;
      if (HELPERS.has(nm)) {
        const fn = d.init;
        out.push('static func ' + id(nm) + '(' + params(fn, true) + '):');
        const b = fnBody(fn, 1), val = ['sw', 'env', 'bump', 'at'].includes(nm);
        out.push(...b.map((l, i) => (!val && fn.body.type !== 'BlockStatement' && i === 0) ? l.replace(/^\treturn /, '\t') : l));
      }
    }
    continue;
  }
  if (s.type === 'ExpressionStatement' && s.expression.type === 'CallExpression' && s.expression.callee.name === 'A') {
    const a = s.expression.arguments; n++;
    const [idv, act, zh, dur, desc] = a.slice(0, 5).map((x) => x.value);
    const key = 'n30_' + idv + '_' + act, nm = idv + '_' + act;
    const fr = a[5], fx = a[6], idleK = a[7];
    const fp = fr.params.map((p) => p.name);
    out.push('static func fr_' + nm + '(g: float, H: float, S: Dictionary) -> Dictionary:');
    if (fp.length > 3) throw new Error('fr params');
    out.push(...fnBody(fr, 1));
    let pre = 'null', post = 'null';
    const emitFx = (fn, tag) => {
      const ps = ['ctx', 'S', 'g', 'm', 'f', 'H'];
      fn.params.forEach((p, i) => { if (p.name !== ps[i]) throw new Error('fx param ' + p.name); });
      out.push('static func ' + tag + '_' + nm + '(ctx: Ctx, S: Dictionary, g: float, m: Transform2D, f: Dictionary, H: float) -> void:');
      const b = fnBody(fn, 1);
      // 箭咀 expression body 嘅 return 去掉（void）
      out.push(...b.map((l, i) => (fn.body.type !== 'BlockStatement' && i === 0) ? l.replace(/^\treturn /, '\t') : l));
      return tag + '_' + nm;
    };
    if (fx) {
      if (fx.type === 'ObjectExpression') {
        for (const p of fx.properties) { if (p.key.name === 'pre') pre = emitFx(p.value, 'pre'); else if (p.key.name === 'post') post = emitFx(p.value, 'post'); else throw new Error('fx key'); }
      } else post = emitFx(fx, 'fx');
    }
    acts.push([idv, key, zh, dur, desc, 'fr_' + nm, pre, post, idleK ? ex(idleK) : 'null']);
    continue;
  }
  if (s.type === 'ReturnStatement') continue;
  if (s.type === 'FunctionDeclaration' && s.id.name === 'A') continue;
  throw new Error('top ' + s.type + ' @' + s.start);
}
out.push('');
out.push('# [鬼 id, key, 中文名, 一輪秒數, 說明, 姿勢, 身後特效, 身前特效, idleK]');
out.push('static func list() -> Array:');
out.push('\treturn [');
for (const r of acts) out.push('\t\t[' + [q(r[0]), q(r[1]), q(r[2]), num(r[3], true), q(r[4]), r[5], r[6] === 'null' ? 'null' : r[6], r[7] === 'null' ? 'null' : r[7], r[8]].join(', ') + '],');
out.push('\t]');
fs.writeFileSync(process.argv[3], out.join('\n') + '\n');
console.log('acts', n);
