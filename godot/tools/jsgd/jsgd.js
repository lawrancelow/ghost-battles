// JS → GDScript 轉譯器（過勞鬼大作戰 Godot 移植用）
// 用法：node jsgd.js <in.js> <out.gd> <模塊名>
// 設計：
//  - 每個 JS 函數 → GDScript 方法 _fN(this_, a: Array, env)；函數值 = Callable(self,"_fN").bind(env)
//  - 被內層函數捕獲的變數 → 裝入作用域字典（_sN），鏈住 "__p"；冇被捕獲嘅 → 普通局部變數
//  - 頂層（Program）宣告 → 全局字典 J.G（瀏覽器入面所有 script 共用頂層）
//  - 表達式降級：有副作用／短路需要嘅部分拆成前置語句
'use strict';
const acorn = require('acorn');
const fs = require('fs');

const [, , IN, OUT, MOD] = process.argv;
const SRC = fs.readFileSync(IN, 'utf8');
const AST = acorn.parse(SRC, { ecmaVersion: 2022, locations: true });

// ---------------------------------------------------------------- 作用域分析
let SID = 0, BID = 0;
class Scope {
  constructor(kind, parent, fn) { this.id = ++SID; this.kind = kind; this.parent = parent; this.fn = fn; this.vars = new Map(); this.dict = false; this.dvar = null; }
  lookup(n) { for (let s = this; s; s = s.parent) if (s.vars.has(n)) return s.vars.get(n); return null; }
}
function declare(scope, name, kind) {
  if (scope.vars.has(name)) return scope.vars.get(name);
  const b = { name, scope, kind, captured: false, uid: ++BID, global: scope.kind === 'global' };
  scope.vars.set(name, b); return b;
}
function patNames(p, out = []) {
  if (!p) return out;
  switch (p.type) {
    case 'Identifier': out.push(p.name); break;
    case 'ArrayPattern': p.elements.forEach(e => patNames(e, out)); break;
    case 'ObjectPattern': p.properties.forEach(pr => patNames(pr.type === 'RestElement' ? pr.argument : pr.value, out)); break;
    case 'AssignmentPattern': patNames(p.left, out); break;
    case 'RestElement': patNames(p.argument, out); break;
  }
  return out;
}
const isFn = n => n && (n.type === 'FunctionDeclaration' || n.type === 'FunctionExpression' || n.type === 'ArrowFunctionExpression');
// 收集函數體內 var／function 宣告（唔入內層函數）
function hoistVars(node, fnScope) {
  const visit = (n) => {
    if (!n || typeof n.type !== 'string') return;
    if (n.type === 'VariableDeclaration' && n.kind === 'var') n.declarations.forEach(d => patNames(d.id).forEach(x => declare(fnScope, x, 'var')));
    if (isFn(n) || n.type === 'ClassDeclaration' || n.type === 'ClassExpression') return;
    for (const k in n) { if (k === 'loc' || k === '_s') continue; const v = n[k]; if (Array.isArray(v)) v.forEach(visit); else if (v && typeof v.type === 'string') visit(v); }
  };
  visit(node);
}
function blockDecls(stmts, scope) {
  for (const s of stmts) {
    if (s.type === 'VariableDeclaration' && s.kind !== 'var') s.declarations.forEach(d => patNames(d.id).forEach(x => declare(scope, x, s.kind)));
    if (s.type === 'FunctionDeclaration') declare(scope, s.id.name, 'function');
    if (s.type === 'ClassDeclaration') declare(scope, s.id.name, 'class');
  }
}
const FNS = []; // 所有函數節點
function analyze(node, scope) {
  const rec = (n, sc) => analyze(n, sc);
  if (!node || typeof node.type !== 'string') return;
  switch (node.type) {
    case 'Program': {
      const g = new Scope('global', null, node); node._s = g;
      hoistVars(node, g); blockDecls(node.body, g);
      node.body.forEach(s => rec(s, g)); return;
    }
    case 'FunctionDeclaration': case 'FunctionExpression': case 'ArrowFunctionExpression': {
      const fs_ = new Scope('func', scope, node); node._s = fs_; FNS.push(node); node._fid = FNS.length;
      if (node.type !== 'ArrowFunctionExpression') { declare(fs_, 'this', 'this'); declare(fs_, 'arguments', 'arguments'); }
      if (node.type === 'FunctionExpression' && node.id) declare(fs_, node.id.name, 'fname');
      node.params.forEach(p => patNames(p).forEach(x => declare(fs_, x, 'param')));
      if (node.body.type === 'BlockStatement') { hoistVars(node.body, fs_); blockDecls(node.body.body, fs_); node.body._s = fs_; node.body.body.forEach(s => rec(s, fs_)); }
      else rec(node.body, fs_);
      node.params.forEach(p => walkPat(p, fs_));
      return;
    }
    case 'BlockStatement': { const b = new Scope('block', scope, scope.fn); node._s = b; blockDecls(node.body, b); node.body.forEach(s => rec(s, b)); return; }
    case 'ForStatement': case 'ForInStatement': case 'ForOfStatement': {
      const b = new Scope('block', scope, scope.fn); node._s = b;
      const init = node.init || node.left;
      if (init && init.type === 'VariableDeclaration' && init.kind !== 'var') init.declarations.forEach(d => patNames(d.id).forEach(x => declare(b, x, init.kind)));
      for (const k of ['init', 'test', 'update', 'left', 'right', 'body']) if (node[k]) { if (k === 'left' && node[k].type !== 'VariableDeclaration') { walkPat(node[k], b); continue; } rec(node[k], b); }
      return;
    }
    case 'CatchClause': { const b = new Scope('block', scope, scope.fn); node._s = b; if (node.param) patNames(node.param).forEach(x => declare(b, x, 'let')); if (node.param) walkPat(node.param, b); rec(node.body, b); return; }
    case 'SwitchStatement': { rec(node.discriminant, scope); const b = new Scope('block', scope, scope.fn); node._s = b; node.cases.forEach(c => blockDecls(c.consequent, b)); node.cases.forEach(c => { if (c.test) rec(c.test, b); c.consequent.forEach(s => rec(s, b)); }); return; }
    case 'ClassDeclaration': case 'ClassExpression': {
      if (node.superClass) rec(node.superClass, scope);
      node.body.body.forEach(m => { if (m.computed) rec(m.key, scope); rec(m.value, scope); }); return;
    }
    case 'VariableDeclarator': walkPat(node.id, scope); if (node.init) rec(node.init, scope); return;
    case 'Identifier': ref(node, scope); return;
    case 'ThisExpression': { node._b = scope.lookup('this'); markCap(node._b, scope); return; }
    case 'MemberExpression': rec(node.object, scope); if (node.computed) rec(node.property, scope); return;
    case 'Property': if (node.computed) rec(node.key, scope); rec(node.value, scope); return;
    case 'MethodDefinition': rec(node.value, scope); return;
    case 'LabeledStatement': rec(node.body, scope); return;
    case 'BreakStatement': case 'ContinueStatement': return;
    case 'AssignmentExpression': walkPat(node.left, scope); rec(node.right, scope); return;
  }
  for (const k in node) { if (k === 'loc' || k === '_s' || k === '_b') continue; const v = node[k]; if (Array.isArray(v)) v.forEach(x => rec(x, scope)); else if (v && typeof v.type === 'string') rec(v, scope); }
}
function walkPat(p, scope) {
  if (!p) return;
  switch (p.type) {
    case 'Identifier': ref(p, scope); break;
    case 'ArrayPattern': p.elements.forEach(e => walkPat(e, scope)); break;
    case 'ObjectPattern': p.properties.forEach(pr => { if (pr.type === 'RestElement') walkPat(pr.argument, scope); else { if (pr.computed) analyze(pr.key, scope); walkPat(pr.value, scope); } }); break;
    case 'AssignmentPattern': walkPat(p.left, scope); analyze(p.right, scope); break;
    case 'RestElement': walkPat(p.argument, scope); break;
    case 'MemberExpression': analyze(p, scope); break;
    default: analyze(p, scope);
  }
}
function ref(id, scope) { const b = scope.lookup(id.name); id._b = b; markCap(b, scope); }
function markCap(b, scope) { if (b && !b.global && b.scope.fn !== scope.fn) b.captured = true; }
analyze(AST, null);
// 決定邊啲作用域要字典
(function markDicts(n) {
  if (!n || typeof n.type !== 'string') return;
  if (n._s && !n._s.dictChecked) { const s = n._s; s.dictChecked = true; for (const b of s.vars.values()) if (b.captured) s.dict = true; }
  for (const k in n) { if (k === 'loc' || k === '_s' || k === '_b') continue; const v = n[k]; if (Array.isArray(v)) v.forEach(markDicts); else if (v && typeof v.type === 'string') markDicts(v); }
})(AST);

// ---------------------------------------------------------------- 輸出工具
class Em {
  constructor(ind) { this.lines = []; this.ind = ind || 1; }
  w(s) { this.lines.push('\t'.repeat(this.ind) + s); }
  sub() { return new Em(this.ind); }
  append(e) { this.lines.push(...e.lines); }
}
let TMP = 0; const tmp = () => '_t' + (++TMP);
const GD_KW = new Set('if elif else for while match break continue pass return class class_name extends is in as self signal func static const enum var breakpoint preload await yield assert void PI TAU INF NAN not and or true false null super tool export onready setget remote master puppet sync'.split(' '));
const lname = (b) => 'v_' + b.name.replace(/\$/g, '_S') + '_' + b.uid;
const num = (v) => { if (!isFinite(v)) return Number.isNaN(v) ? 'NAN' : (v > 0 ? 'INF' : '-INF'); let s = String(v); if (/e/.test(s)) s = v.toExponential(); if (!/[.eE]/.test(s)) s += '.0'; return s; };
const str = (s) => JSON.stringify(s).replace(/[\u2028]/g, '\\u2028').replace(/[\u2029]/g, '\\u2029');

// ---------------------------------------------------------------- 代碼生成上下文
let CUR = null; // { fn, scope }
const METHODS = [];
function dictChainFrom(scope) { // 由 scope 向外所有有字典嘅作用域（唔包 global）
  const out = []; for (let s = scope; s && s.kind !== 'global'; s = s.parent) if (s.dict) out.push(s); return out;
}
function startExpr(scope) { // 由當前位置，最入面可用嘅字典表達式
  for (let s = scope; s && s.kind !== 'global'; s = s.parent) {
    if (s.fn !== CUR.fn) return 'env';
    if (s.dict && s.dvar && s.live) return s.dvar;
  }
  return 'env';
}
function bindingRef(b, scope) {
  if (!b || b.global) return null;
  if (!b.captured) return b.kind === 'this' ? 'this_' : b.kind === 'arguments' ? 'a' : lname(b);
  // 由 scope 開始數 hop
  const chain = []; let start = null; let startIdx = 0;
  for (let s = scope; s && s.kind !== 'global'; s = s.parent) {
    if (!s.dict) continue;
    if (s.fn === CUR.fn && !(s.dvar && s.live)) continue; // 未建立
    chain.push(s);
  }
  // chain[0] 係最入面；喺當前函數入面嘅用佢嘅 dvar，否則由 env 開始
  let expr, i = 0;
  if (chain.length && chain[0].fn === CUR.fn) { expr = chain[0].dvar; }
  else expr = 'env';
  for (const s of chain) { if (s === b.scope) return `${expr}[${str(b.name)}]`; expr += '["__p"]'; }
  return `J.G[${str('__lost_' + b.name)}]`; // 理論上唔會發生
}
function readVar(id, scope) {
  const b = id._b;
  if (!b || b.global) {
    if (id.name === 'undefined') return 'null';
    if (id.name === 'NaN') return 'NAN';
    if (id.name === 'Infinity') return 'INF';
    return `J.G.get(${str(id.name)})`;
  }
  return bindingRef(b, scope);
}
function writeVar(id, scope, val, em) {
  const b = id._b;
  if (!b || b.global) { em.w(`J.G[${str(id.name)}] = ${val}`); return; }
  em.w(`${bindingRef(b, scope)} = ${val}`);
}

// ---------------------------------------------------------------- 表達式
// 回傳 { c, k }：k = 'num'|'str'|'bool'|'any'；pure = 冇副作用而且重複求值安全
const PURE = new Set(['Identifier', 'Literal', 'ThisExpression']);
function isSimple(n) { return n.type === 'Literal' || n.type === 'Identifier' || n.type === 'ThisExpression'; }
function isPure(n) { // 冇副作用、唔會出錯
  if (!n) return true;
  switch (n.type) {
    case 'Literal': case 'Identifier': case 'ThisExpression': return true;
    case 'MemberExpression': return isPure(n.object) && (!n.computed || isPure(n.property));
    case 'ChainExpression': return isPure(n.expression);
    case 'UnaryExpression': return n.operator !== 'delete' && isPure(n.argument);
    case 'TemplateLiteral': return n.expressions.every(isPure);
    case 'ArrowFunctionExpression': case 'FunctionExpression': return true;
    default: return false;
  }
}
function T(e) { return e.k === 'bool' ? e.c : `J.t(${e.c})`; }
function spillIfNeeded(e, em) { if (/^(_t\d+|v_[\w]+|-?[\d.]+|null|true|false|"[^"]*")$/.test(e.c)) return e; const t = tmp(); em.w(`var ${t} = ${e.c}`); return { c: t, k: e.k }; }
// 依次編譯多個子表達式，保證求值次序
function exprList(nodes, em, scope) {
  const out = [];
  for (const n of nodes) {
    const sub = em.sub(); const e = expr(n, sub, scope);
    if (sub.lines.length) { for (let i = 0; i < out.length; i++) out[i] = spillIfNeeded(out[i], em); em.append(sub); }
    out.push(e);
  }
  return out;
}
const MATH1 = { floor: 'floor', ceil: 'ceil', abs: 'absf', sqrt: 'sqrt', sin: 'sin', cos: 'cos', tan: 'tan', atan: 'atan', asin: 'asin', acos: 'acos', exp: 'exp', log: 'log', sign: 'signf', trunc: 'J.trunc', round: 'J.round', cbrt: 'J.cbrt', log2: 'J.log2', log10: 'J.log10' };
function argsArray(nodes, em, scope) {
  if (nodes.some(n => n.type === 'SpreadElement')) {
    const parts = exprList(nodes.map(n => n.type === 'SpreadElement' ? n.argument : n), em, scope);
    return 'J.spread([' + parts.map((p, i) => nodes[i].type === 'SpreadElement' ? `J.SP(${p.c})` : p.c).join(', ') + '])';
  }
  return '[' + exprList(nodes, em, scope).map(p => p.c).join(', ') + ']';
}
function globalName(n) { return n.type === 'Identifier' && (!n._b || n._b.global) ? n.name : null; }
function expr(n, em, scope) {
  switch (n.type) {
    case 'Literal':
      if (n.regex) return { c: `J.re(${str(n.regex.pattern)}, ${str(n.regex.flags)})`, k: 'any' };
      if (n.value === null) return { c: 'null', k: 'any' };
      if (typeof n.value === 'number') return { c: num(n.value), k: 'num' };
      if (typeof n.value === 'string') return { c: str(n.value), k: 'str' };
      if (typeof n.value === 'boolean') return { c: String(n.value), k: 'bool' };
      return { c: 'null', k: 'any' };
    case 'Identifier': return { c: readVar(n, scope), k: 'any' };
    case 'ThisExpression': return { c: n._b ? bindingRef(n._b, scope) : 'null', k: 'any' };
    case 'TemplateLiteral': {
      const ex = exprList(n.expressions, em, scope); const parts = [];
      n.quasis.forEach((q, i) => { if (q.value.cooked) parts.push(str(q.value.cooked)); if (i < ex.length) parts.push(ex[i].k === 'str' ? ex[i].c : `J.str(${ex[i].c})`); });
      return { c: parts.length ? '(' + parts.join(' + ') + ')' : '""', k: 'str' };
    }
    case 'ArrayExpression': {
      if (n.elements.some(e => e && e.type === 'SpreadElement')) return { c: argsArray(n.elements, em, scope), k: 'any' };
      return { c: '[' + exprList(n.elements.map(e => e || { type: 'Identifier', name: 'undefined' }), em, scope).map(e => e.c).join(', ') + ']', k: 'any' };
    }
    case 'ObjectExpression': {
      const props = n.properties; const parts = []; const getters = [];
      const hasSpread = props.some(p => p.type === 'SpreadElement');
      const vals = exprList(props.map(p => p.type === 'SpreadElement' ? p.argument : p.value), em, scope);
      const keys = props.map(p => p.type === 'SpreadElement' ? null : p.computed ? `J.key(${expr(p.key, em, scope).c})` : str(p.key.type === 'Identifier' ? p.key.name : String(p.key.value)));
      if (!hasSpread) {
        props.forEach((p, i) => { if (p.kind === 'get') getters.push(`${keys[i]}: ${vals[i].c}`); else if (p.kind === 'set') {} else parts.push(`${keys[i]}: ${vals[i].c}`); });
        if (getters.length) parts.push(`"__getters": {${getters.join(', ')}}`);
        return { c: '{' + parts.join(', ') + '}', k: 'any' };
      }
      const t = tmp(); em.w(`var ${t} = {}`);
      props.forEach((p, i) => { if (p.type === 'SpreadElement') em.w(`J.assign(${t}, [${vals[i].c}])`); else em.w(`${t}[${keys[i]}] = ${vals[i].c}`); });
      return { c: t, k: 'any' };
    }
    case 'FunctionExpression': case 'ArrowFunctionExpression': return { c: closure(n, scope), k: 'any' };
    case 'ClassExpression': return { c: classExpr(n, em, scope), k: 'any' };
    case 'ChainExpression': return expr(n.expression, em, scope);
    case 'ParenthesizedExpression': return expr(n.expression, em, scope);
    case 'SequenceExpression': { let last; n.expressions.forEach((x, i) => { if (i < n.expressions.length - 1) stmtExpr(x, em, scope); else last = expr(x, em, scope); }); return last; }
    case 'MemberExpression': {
      if (!n.computed && n.property.name === 'length') { const o = expr(n.object, em, scope); return { c: `J.len(${o.c})`, k: 'num' }; }
      const gn = globalName(n.object);
      if (gn === 'Math' && !n.computed) { const m = { PI: 'PI', E: '2.718281828459045', SQRT2: '1.4142135623730951', LN2: '0.6931471805599453', LN10: '2.302585092994046' }[n.property.name]; if (m) return { c: m, k: 'num' }; }
      if (gn === 'Number' && !n.computed) { const m = { MAX_VALUE: '1.7976931348623157e308', MIN_VALUE: '5e-324', EPSILON: '2.220446049250313e-16', MAX_SAFE_INTEGER: '9007199254740991.0', POSITIVE_INFINITY: 'INF', NEGATIVE_INFINITY: '-INF' }[n.property.name]; if (m) return { c: m, k: 'num' }; }
      const [o, k] = n.computed ? exprList([n.object, n.property], em, scope) : [expr(n.object, em, scope), { c: str(n.property.name), k: 'str' }];
      return { c: `J.gp(${o.c}, ${k.c})`, k: 'any' };
    }
    case 'UnaryExpression': {
      const op = n.operator;
      if (op === 'typeof') { if (n.argument.type === 'Identifier' && (!n.argument._b || n.argument._b.global)) return { c: `J.typeof_(J.G.get(${str(n.argument.name)}))`, k: 'str' }; return { c: `J.typeof_(${expr(n.argument, em, scope).c})`, k: 'str' }; }
      if (op === 'delete') { const m = n.argument; if (m.type === 'MemberExpression') { const [o, k] = m.computed ? exprList([m.object, m.property], em, scope) : [expr(m.object, em, scope), { c: str(m.property.name) }]; em.w(`J.del(${o.c}, ${k.c})`); } return { c: 'true', k: 'bool' }; }
      if (op === 'void') { stmtExpr(n.argument, em, scope); return { c: 'null', k: 'any' }; }
      const a = expr(n.argument, em, scope);
      if (op === '!') return { c: `(not ${T(a)})`, k: 'bool' };
      if (op === '-') return { c: a.k === 'num' ? `(-${a.c})` : `(-J.num(${a.c}))`, k: 'num' };
      if (op === '+') return { c: a.k === 'num' ? a.c : `J.num(${a.c})`, k: 'num' };
      if (op === '~') return { c: `J.bnot(${a.c})`, k: 'num' };
      throw new Error('unary ' + op);
    }
    case 'BinaryExpression': {
      const [a, b] = exprList([n.left, n.right], em, scope); const op = n.operator; const nn = a.k === 'num' && b.k === 'num';
      switch (op) {
        case '+': if (nn) return { c: `(${a.c} + ${b.c})`, k: 'num' }; if (a.k === 'str' && b.k === 'str') return { c: `(${a.c} + ${b.c})`, k: 'str' }; return { c: `J.add(${a.c}, ${b.c})`, k: a.k === 'str' || b.k === 'str' ? 'str' : 'any' };
        case '-': return { c: nn ? `(${a.c} - ${b.c})` : `J.sub(${a.c}, ${b.c})`, k: 'num' };
        case '*': return { c: nn ? `(${a.c} * ${b.c})` : `J.mul(${a.c}, ${b.c})`, k: 'num' };
        case '/': return { c: `J.div(${a.c}, ${b.c})`, k: 'num' };
        case '%': return { c: `J.mod(${a.c}, ${b.c})`, k: 'num' };
        case '**': return { c: `pow(J.num(${a.c}), J.num(${b.c}))`, k: 'num' };
        case '<': case '>': case '<=': case '>=': return { c: nn ? `(${a.c} ${op} ${b.c})` : `J.cmp(${a.c}, ${b.c}, ${str(op)})`, k: 'bool' };
        case '===': return { c: `J.seq(${a.c}, ${b.c})`, k: 'bool' };
        case '!==': return { c: `(not J.seq(${a.c}, ${b.c}))`, k: 'bool' };
        case '==': return { c: `J.leq(${a.c}, ${b.c})`, k: 'bool' };
        case '!=': return { c: `(not J.leq(${a.c}, ${b.c}))`, k: 'bool' };
        case '|': return { c: `J.bor(${a.c}, ${b.c})`, k: 'num' };
        case '&': return { c: `J.band(${a.c}, ${b.c})`, k: 'num' };
        case '^': return { c: `J.bxor(${a.c}, ${b.c})`, k: 'num' };
        case '<<': return { c: `J.shl(${a.c}, ${b.c})`, k: 'num' };
        case '>>': return { c: `J.shr(${a.c}, ${b.c})`, k: 'num' };
        case '>>>': return { c: `J.ushr(${a.c}, ${b.c})`, k: 'num' };
        case 'in': return { c: `J.has(${b.c}, ${a.c})`, k: 'bool' };
        case 'instanceof': return { c: `J.inst(${a.c}, ${b.c})`, k: 'bool' };
      }
      throw new Error('binop ' + op);
    }
    case 'LogicalExpression': {
      const op = n.operator;
      const sub = em.sub(); const a = expr(n.left, sub, scope); em.append(sub);
      const bsub = em.sub(); const b = expr(n.right, bsub, scope);
      const k = a.k === b.k ? a.k : 'any';
      if (!bsub.lines.length && (isPure(n.right) || n.right.type === 'CallExpression' || true)) {
        // 用三元（GDScript 嘅 x if c else y 係惰性）；a 唔簡單就先放 temp
        const A = isSimple(n.left) || /^_t\d+$/.test(a.c) ? a : spillIfNeeded(a, em);
        if (op === '||') return { c: `(${A.c} if ${T(A)} else ${b.c})`, k };
        if (op === '&&') return { c: `(${b.c} if ${T(A)} else ${A.c})`, k };
        return { c: `(${A.c} if ${A.c} != null else ${b.c})`, k }; // ??
      }
      const t = tmp(); em.w(`var ${t} = ${a.c}`);
      const cond = op === '||' ? `not J.t(${t})` : op === '&&' ? `J.t(${t})` : `${t} == null`;
      em.w(`if ${cond}:`); const inner = new Em(em.ind + 1); inner.lines = bsub.lines.map(l => '\t' + l); inner.w(`${t} = ${b.c}`); em.append(inner);
      return { c: t, k };
    }
    case 'ConditionalExpression': {
      const t0 = expr(n.test, em, scope);
      const s1 = em.sub(), s2 = em.sub(); const a = expr(n.consequent, s1, scope), b = expr(n.alternate, s2, scope);
      const k = a.k === b.k ? a.k : 'any';
      if (!s1.lines.length && !s2.lines.length) return { c: `(${a.c} if ${T(t0)} else ${b.c})`, k };
      const t = tmp(); em.w(`var ${t} = null`); em.w(`if ${T(t0)}:`);
      const i1 = new Em(em.ind + 1); i1.lines = s1.lines.map(l => '\t' + l); i1.w(`${t} = ${a.c}`); em.append(i1);
      em.w('else:'); const i2 = new Em(em.ind + 1); i2.lines = s2.lines.map(l => '\t' + l); i2.w(`${t} = ${b.c}`); em.append(i2);
      return { c: t, k };
    }
    case 'AssignmentExpression': { const v = assign(n, em, scope); return v; }
    case 'UpdateExpression': {
      const delta = n.operator === '++' ? '1.0' : '-1.0';
      if (n.argument.type === 'Identifier') {
        const cur = readVar(n.argument, scope);
        if (n.prefix) { writeVar(n.argument, scope, `J.num(${cur}) + ${delta}`, em); return { c: readVar(n.argument, scope), k: 'num' }; }
        const t = tmp(); em.w(`var ${t} = J.num(${cur})`); writeVar(n.argument, scope, `${t} + ${delta}`, em); return { c: t, k: 'num' };
      }
      const m = n.argument; const [o, k] = m.computed ? exprList([m.object, m.property], em, scope).map(e => spillIfNeeded(e, em)) : [spillIfNeeded(expr(m.object, em, scope), em), { c: str(m.property.name) }];
      const t = tmp(); em.w(`var ${t} = J.num(J.gp(${o.c}, ${k.c}))`); em.w(`J.sp(${o.c}, ${k.c}, ${t} + ${delta})`);
      return { c: n.prefix ? `(${t} + ${delta})` : t, k: 'num' };
    }
    case 'CallExpression': return call(n, em, scope);
    case 'NewExpression': {
      const gn = globalName(n.callee); const args = argsArray(n.arguments, em, scope);
      if (gn && ['Map', 'Set', 'Array', 'Image', 'Float32Array', 'Float64Array', 'Uint8Array', 'Uint16Array', 'Int16Array', 'Int32Array', 'Uint32Array', 'Uint8ClampedArray', 'RegExp', 'Date', 'Error', 'Promise', 'AbortController', 'WeakMap', 'WeakSet', 'Path2D', 'TextEncoder', 'TextDecoder', 'MutationObserver', 'AudioContext', 'OffscreenCanvas', 'CustomEvent', 'Event'].includes(gn)) return { c: `J.new_(${str(gn)}, ${args})`, k: 'any' };
      const c = expr(n.callee, em, scope); return { c: `J.construct(${c.c}, ${args})`, k: 'any' };
    }
    case 'AwaitExpression': return expr(n.argument, em, scope);
    case 'TaggedTemplateExpression': return expr(n.quasi, em, scope);
  }
  throw new Error('expr ' + n.type + ' @' + (n.loc && n.loc.start.line));
}
function call(n, em, scope) {
  const cal = n.callee;
  if (cal.type === 'MemberExpression' && !cal.computed) {
    const gn = globalName(cal.object), m = cal.property.name;
    if (gn === 'Math') {
      const as = exprList(n.arguments.filter(x => x.type !== 'SpreadElement'), em, scope);
      const spread = n.arguments.some(x => x.type === 'SpreadElement');
      if (m === 'random') return { c: 'randf()', k: 'num' };
      if (m === 'max' || m === 'min' || m === 'hypot') return { c: `J.${m}_(${argsArray(n.arguments, em, scope)})`, k: 'num' };
      if (spread) return { c: `J.math(${str(m)}, ${argsArray(n.arguments, em, scope)})`, k: 'num' };
      if (MATH1[m]) return { c: `${MATH1[m]}(J.num(${as[0].c}))`, k: 'num' };
      if (m === 'atan2') return { c: `atan2(J.num(${as[0].c}), J.num(${as[1].c}))`, k: 'num' };
      if (m === 'pow') return { c: `pow(J.num(${as[0].c}), J.num(${as[1].c}))`, k: 'num' };
      return { c: `J.math(${str(m)}, [${as.map(a => a.c).join(', ')}])`, k: 'num' };
    }
    if (gn && ['JSON', 'Object', 'Array', 'Number', 'String', 'Date', 'console', 'performance', 'document', 'window', 'localStorage', 'navigator', 'history', 'location', 'Promise', 'sessionStorage', 'Reflect', 'speechSynthesis', 'URL', 'Intl'].includes(gn))
      return { c: `J.S_${gn}_(${str(m)}, ${argsArray(n.arguments, em, scope)})`, k: 'any' };
    const o = expr(cal.object, em, scope); const oo = n.arguments.length && !isSimple(cal.object) ? spillIfNeeded(o, em) : o;
    return { c: `J.mc(${oo.c}, ${str(m)}, ${argsArray(n.arguments, em, scope)})`, k: 'any' };
  }
  if (cal.type === 'MemberExpression' && cal.computed) {
    const [o, k] = exprList([cal.object, cal.property], em, scope).map(e => spillIfNeeded(e, em));
    return { c: `J.mc(${o.c}, ${k.c}, ${argsArray(n.arguments, em, scope)})`, k: 'any' };
  }
  const gn = globalName(cal);
  if (gn && ['parseInt', 'parseFloat', 'isNaN', 'isFinite', 'Number', 'String', 'Boolean', 'setTimeout', 'setInterval', 'clearTimeout', 'clearInterval', 'requestAnimationFrame', 'cancelAnimationFrame', 'encodeURIComponent', 'decodeURIComponent', 'btoa', 'atob', 'getComputedStyle', 'fetch', 'alert', 'confirm', 'queueMicrotask', 'structuredClone', 'Array', 'Object'].includes(gn) && !(cal._b && !cal._b.global))
    return { c: `J.F_${gn}(${argsArray(n.arguments, em, scope)})`, k: ['parseInt', 'parseFloat', 'Number'].includes(gn) ? 'num' : gn === 'String' ? 'str' : 'any' };
  const f = expr(cal, em, scope); const ff = n.arguments.length ? spillIfNeeded(f, em) : f;
  return { c: `J.cl(${ff.c}, null, ${argsArray(n.arguments, em, scope)})`, k: 'any' };
}
function assign(n, em, scope) {
  const op = n.operator; const L = n.left;
  if (L.type === 'ArrayPattern' || L.type === 'ObjectPattern') { const r = spillIfNeeded(expr(n.right, em, scope), em); destructure(L, r.c, em, scope, false); return r; }
  if (L.type === 'Identifier') {
    let v;
    if (op === '=') v = expr(n.right, em, scope);
    else if (op === '||=' || op === '&&=' || op === '??=') {
      const cur = readVar(L, scope); const cond = op === '||=' ? `not J.t(${cur})` : op === '&&=' ? `J.t(${cur})` : `${cur} == null`;
      em.w(`if ${cond}:`); const s = new Em(em.ind + 1); const r = expr(n.right, s, scope); writeVar(L, scope, r.c, s); em.append(s); return { c: readVar(L, scope), k: 'any' };
    } else v = binop(op.slice(0, -1), { c: readVar(L, scope), k: 'any' }, expr(n.right, em, scope));
    const vv = isPure(n.right) && op === '=' ? v : spillIfNeeded(v, em);
    writeVar(L, scope, vv.c, em); return { c: readVar(L, scope), k: vv.k };
  }
  if (L.type === 'MemberExpression') {
    const [o, k] = L.computed ? exprList([L.object, L.property], em, scope).map(e => spillIfNeeded(e, em)) : [spillIfNeeded(expr(L.object, em, scope), em), { c: str(L.property.name), k: 'str' }];
    if (op === '||=' || op === '&&=' || op === '??=') {
      const cur = `J.gp(${o.c}, ${k.c})`; const cond = op === '||=' ? `not J.t(${cur})` : op === '&&=' ? `J.t(${cur})` : `${cur} == null`;
      em.w(`if ${cond}:`); const s = new Em(em.ind + 1); const r = expr(n.right, s, scope); s.w(`J.sp(${o.c}, ${k.c}, ${r.c})`); em.append(s); return { c: cur, k: 'any' };
    }
    let v = expr(n.right, em, scope);
    if (op !== '=') v = binop(op.slice(0, -1), { c: `J.gp(${o.c}, ${k.c})`, k: 'any' }, v);
    const vv = spillIfNeeded(v, em);
    em.w(`J.sp(${o.c}, ${k.c}, ${vv.c})`); return vv;
  }
  throw new Error('assign target ' + L.type);
}
function binop(op, a, b) {
  const nn = a.k === 'num' && b.k === 'num';
  switch (op) {
    case '+': return nn ? { c: `(${a.c} + ${b.c})`, k: 'num' } : { c: `J.add(${a.c}, ${b.c})`, k: 'any' };
    case '-': return { c: `J.sub(${a.c}, ${b.c})`, k: 'num' };
    case '*': return { c: `J.mul(${a.c}, ${b.c})`, k: 'num' };
    case '/': return { c: `J.div(${a.c}, ${b.c})`, k: 'num' };
    case '%': return { c: `J.mod(${a.c}, ${b.c})`, k: 'num' };
    case '|': return { c: `J.bor(${a.c}, ${b.c})`, k: 'num' };
    case '&': return { c: `J.band(${a.c}, ${b.c})`, k: 'num' };
    case '^': return { c: `J.bxor(${a.c}, ${b.c})`, k: 'num' };
    case '<<': return { c: `J.shl(${a.c}, ${b.c})`, k: 'num' };
    case '>>': return { c: `J.shr(${a.c}, ${b.c})`, k: 'num' };
    case '**': return { c: `pow(J.num(${a.c}), J.num(${b.c}))`, k: 'num' };
  }
  throw new Error('compound ' + op);
}
// 解構：pat ← 值表達式 v（已係 temp／簡單）
function destructure(p, v, em, scope, isDecl) {
  switch (p.type) {
    case 'Identifier': writeVar(p, scope, v, em); return;
    case 'MemberExpression': { const [o, k] = p.computed ? exprList([p.object, p.property], em, scope) : [expr(p.object, em, scope), { c: str(p.property.name) }]; em.w(`J.sp(${o.c}, ${k.c}, ${v})`); return; }
    case 'AssignmentPattern': { const t = tmp(); em.w(`var ${t} = ${v}`); em.w(`if ${t} == null:`); const s = new Em(em.ind + 1); const d = expr(p.right, s, scope); s.w(`${t} = ${d.c}`); em.append(s); destructure(p.left, t, em, scope, isDecl); return; }
    case 'ArrayPattern': p.elements.forEach((e, i) => { if (!e) return; if (e.type === 'RestElement') { const t = tmp(); em.w(`var ${t} = J.mc(${v}, "slice", [${num(i)}])`); destructure(e.argument, t, em, scope, isDecl); return; } const t = tmp(); em.w(`var ${t} = J.gp(${v}, ${num(i)})`); destructure(e, t, em, scope, isDecl); }); return;
    case 'ObjectPattern': {
      const used = [];
      p.properties.forEach(pr => {
        if (pr.type === 'RestElement') { const t = tmp(); em.w(`var ${t} = J.omit(${v}, [${used.join(', ')}])`); destructure(pr.argument, t, em, scope, isDecl); return; }
        const k = pr.computed ? expr(pr.key, em, scope).c : str(pr.key.type === 'Identifier' ? pr.key.name : String(pr.key.value)); used.push(k);
        const t = tmp(); em.w(`var ${t} = J.gp(${v}, ${k})`); destructure(pr.value, t, em, scope, isDecl);
      }); return;
    }
  }
  throw new Error('pattern ' + p.type);
}

// ---------------------------------------------------------------- 函數
function closure(fnNode, scope) {
  // env = 定義位置最入面嘅字典
  const env = startExpr(scope);
  emitFunction(fnNode);
  return `Callable(self, "_f${fnNode._fid}").bind(${env})`;
}
function classExpr(n, em, scope) {
  // class → 構造函數（Callable），J.construct 會識別 {"__class": ...}
  const ctor = n.body.body.find(m => m.kind === 'constructor');
  const meths = n.body.body.filter(m => m.kind === 'method' && !m.static);
  const parts = meths.map(m => `${str(m.key.name)}: ${closure(m.value, scope)}`);
  return `{"__class": true, "ctor": ${ctor ? closure(ctor.value, scope) : 'null'}, "proto": {${parts.join(', ')}}${n.superClass ? `, "super": ${expr(n.superClass, em, scope).c}` : ''}}`;
}
function emitFunction(fnNode) {
  if (fnNode._emitted) return; fnNode._emitted = true;
  const saved = CUR; const fs_ = fnNode._s; CUR = { fn: fnNode, scope: fs_ };
  const em = new Em(1);
  // 局部變數預先宣告
  const locals = [];
  const collect = (s) => { for (const b of s.vars.values()) if (!b.captured && b.kind !== 'this' && b.kind !== 'arguments') locals.push(lname(b)); };
  // 本函數所有（非字典）作用域
  const scopesOf = []; (function walkS(n) { if (!n || typeof n.type !== 'string') return; if (n !== fnNode && isFn(n)) return; if (n._s && n._s.fn === fnNode && !scopesOf.includes(n._s)) scopesOf.push(n._s); for (const k in n) { if (k === 'loc' || k === '_s' || k === '_b') continue; const v = n[k]; if (Array.isArray(v)) v.forEach(walkS); else if (v && typeof v.type === 'string') walkS(v); } })(fnNode);
  scopesOf.forEach(collect);
  const lines = [];
  const L = (s) => lines.push(s);
  L(`func _f${fnNode._fid}(this_, a: Array, env):`);
  if (locals.length) L('\tvar ' + [...new Set(locals)].join(' = null; var ') + ' = null');
  // 函數作用域字典
  if (fs_.dict) { fs_.dvar = '_s' + fs_.id; fs_.live = true; em.w(`var ${fs_.dvar} = {"__p": env${dictInit(fs_)}}`); }
  const thisB = fs_.vars.get('this'); if (thisB && thisB.captured) em.w(`${bindingRef(thisB, fs_)} = this_`);
  const argB = fs_.vars.get('arguments'); if (argB && argB.captured) em.w(`${bindingRef(argB, fs_)} = a`);
  // 具名函數表達式自己個名
  const fnb = fnNode.type === 'FunctionExpression' && fnNode.id ? fs_.vars.get(fnNode.id.name) : null;
  if (fnb) em.w(`${bindingRef(fnb, fs_)} = Callable(self, "_f${fnNode._fid}").bind(env)`);
  // 參數
  fnNode.params.forEach((p, i) => {
    if (p.type === 'Identifier') writeVar(p, fs_, `J.arg(a, ${i})`, em);
    else if (p.type === 'RestElement') destructure(p.argument, `a.slice(${i})`, em, fs_, true);
    else destructure(p, `J.arg(a, ${i})`, em, fs_, true);
  });
  if (fnNode.body.type === 'BlockStatement') { hoistFns(fnNode.body.body, em, fs_); fnNode.body.body.forEach(s => stmt(s, em, fs_)); }
  else { const r = expr(fnNode.body, em, fs_); em.w(`return ${r.c}`); }
  if (!em.lines.length) em.w('pass');
  // 預先宣告用 a.slice → J.slice
  lines.push(...em.lines.map(l => l.replace(/\ba\.slice\((\d+)\)/g, 'a.slice($1)')));
  METHODS.push(lines.join('\n'));
  CUR = saved;
}
function hoistFns(stmts, em, scope) {
  for (const s of stmts) if (s.type === 'FunctionDeclaration') { const b = scope.vars.get(s.id.name) || s.id._b; writeVarB(b, scope, closure(s, scope), em); }
}
function writeVarB(b, scope, val, em) { if (!b || b.global) { em.w(`J.G[${str(b ? b.name : '?')}] = ${val}`); return; } em.w(`${bindingRef(b, scope)} = ${val}`); }

// ---------------------------------------------------------------- 語句
const LOOPS = []; // { kind:'loop'|'switch', update:Em lines, contFlag }
function blockEnter(node, em, scope) {
  const s = node._s;
  if (s && s !== scope && s.dict && s.kind === 'block') { s.dvar = '_s' + s.id; const parent = startExpr(scope); em.w(`var ${s.dvar} = {"__p": ${parent}${dictInit(s)}}`); s.live = true; return s; }
  return s && s.kind === 'block' ? s : scope;
}
function dictInit(s) { const ks = [...s.vars.values()].filter(b => b.captured).map(b => `, ${str(b.name)}: null`); return ks.join(''); }
function body(stmts, em, scope) { const n0 = em.lines.length; hoistFns(stmts, em, scope); stmts.forEach(s => stmt(s, em, scope)); if (em.lines.length === n0) em.w('pass'); }
function stmtExpr(n, em, scope) {
  switch (n.type) {
    case 'AssignmentExpression': assign(n, em, scope); return;
    case 'UpdateExpression': {
      const d = n.operator === '++' ? '1.0' : '-1.0';
      if (n.argument.type === 'Identifier') { writeVar(n.argument, scope, `J.num(${readVar(n.argument, scope)}) + ${d}`, em); return; }
      const m = n.argument; const [o, k] = m.computed ? exprList([m.object, m.property], em, scope).map(e => spillIfNeeded(e, em)) : [spillIfNeeded(expr(m.object, em, scope), em), { c: str(m.property.name) }];
      em.w(`J.sp(${o.c}, ${k.c}, J.num(J.gp(${o.c}, ${k.c})) + ${d})`); return;
    }
    case 'LogicalExpression': {
      const a = expr(n.left, em, scope); const cond = n.operator === '||' ? `not ${T(a)}` : n.operator === '&&' ? T(a) : `${a.c} == null`;
      em.w(`if ${cond}:`); const s = new Em(em.ind + 1); stmtExpr(n.right, s, scope); if (!s.lines.length) s.w('pass'); em.append(s); return;
    }
    case 'ConditionalExpression': {
      const t = expr(n.test, em, scope); em.w(`if ${T(t)}:`); const s = new Em(em.ind + 1); stmtExpr(n.consequent, s, scope); if (!s.lines.length) s.w('pass'); em.append(s);
      em.w('else:'); const s2 = new Em(em.ind + 1); stmtExpr(n.alternate, s2, scope); if (!s2.lines.length) s2.w('pass'); em.append(s2); return;
    }
    case 'SequenceExpression': n.expressions.forEach(x => stmtExpr(x, em, scope)); return;
    case 'Literal': case 'Identifier': return;
    case 'UnaryExpression': if (n.operator === 'delete' || n.operator === 'void') { expr(n, em, scope); return; } break;
  }
  const r = expr(n, em, scope);
  if (/^(J\.(mc|cl|S_|F_|new_|construct|del|assign)|Callable|_t\d+$)/.test(r.c) || /^J\.(mc|cl)/.test(r.c)) { if (!/^_t\d+$/.test(r.c)) em.w(r.c); }
  else if (r.c !== 'null') em.w(`J.nop(${r.c})`);
}
function stmt(n, em, scope) {
  switch (n.type) {
    case 'EmptyStatement': return;
    case 'ExpressionStatement': stmtExpr(n.expression, em, scope); return;
    case 'VariableDeclaration':
      for (const d of n.declarations) {
        if (d.id.type === 'Identifier') { if (d.init) { const v = expr(d.init, em, scope); writeVar(d.id, scope, v.c, em); } else if (n.kind !== 'var') writeVar(d.id, scope, 'null', em); }
        else { const v = spillIfNeeded(expr(d.init, em, scope), em); destructure(d.id, v.c, em, scope, true); }
      }
      return;
    case 'FunctionDeclaration': return; // 已 hoist
    case 'ClassDeclaration': { const c = classExpr(n, em, scope); writeVar(n.id, scope, c, em); return; }
    case 'ReturnStatement': { if (!n.argument) { em.w('return null'); return; } const r = expr(n.argument, em, scope); em.w(`return ${r.c}`); return; }
    case 'BlockStatement': { const sc = blockEnter(n, em, scope); body(n.body, em, sc); return; }
    case 'IfStatement': {
      const t = expr(n.test, em, scope); em.w(`if ${T(t)}:`);
      const s = new Em(em.ind + 1); stmtBody(n.consequent, s, scope); em.append(s);
      if (n.alternate) { em.w('else:'); const s2 = new Em(em.ind + 1); stmtBody(n.alternate, s2, scope); em.append(s2); }
      return;
    }
    case 'ThrowStatement': { const r = expr(n.argument, em, scope); em.w(`J.throw_(${r.c})`); em.w('return null'); return; }
    case 'TryStatement': { const s = blockEnter(n.block, em, scope); body(n.block.body, em, s); if (n.finalizer) { const f = blockEnter(n.finalizer, em, scope); body(n.finalizer.body, em, f); } return; }
    case 'BreakStatement': {
      if (n.label) { em.w(`break # label ${n.label.name}`); return; }
      em.w('break'); return;
    }
    case 'ContinueStatement': {
      let sw = null; for (let i = LOOPS.length - 1; i >= 0; i--) { const L = LOOPS[i]; if (L.kind === 'switch') { if (!sw) sw = L; L.cont = true; continue; } if (sw) { em.w(`${sw.flag} = true`); em.w('break'); return; } if (L.update) L.update(em); em.w('continue'); return; }
      em.w('continue'); return;
    }
    case 'WhileStatement': {
      em.w('while true:'); const s = new Em(em.ind + 1);
      const t = expr(n.test, s, scope); s.w(`if not ${T(t)}: break`);
      LOOPS.push({ kind: 'loop', update: null }); stmtBody(n.body, s, scope); LOOPS.pop(); em.append(s); return;
    }
    case 'DoWhileStatement': {
      const flag = tmp(); em.w(`var ${flag} = true`); em.w('while true:'); const s = new Em(em.ind + 1);
      const upd = (e) => { const t = expr(n.test, e, scope); e.w(`if not ${T(t)}: break`); };
      // 第一次唔睇條件
      s.w(`if not ${flag}:`); const c = new Em(s.ind + 1); const tt = expr(n.test, c, scope); c.w(`if not ${T(tt)}: break`); s.append(c); s.w(`${flag} = false`);
      LOOPS.push({ kind: 'loop', update: null }); stmtBody(n.body, s, scope); LOOPS.pop(); em.append(s); return;
    }
    case 'ForStatement': {
      const sc = n._s; if (sc.dict) { sc.dvar = '_s' + sc.id; em.w(`var ${sc.dvar} = {"__p": ${startExpr(scope)}${dictInit(sc)}}`); sc.live = true; }
      if (n.init) { if (n.init.type === 'VariableDeclaration') stmt(n.init, em, sc); else stmtExpr(n.init, em, sc); }
      em.w('while true:'); const s = new Em(em.ind + 1);
      if (sc.dict) s.w(`${sc.dvar} = ${sc.dvar}.duplicate()`);
      if (n.test) { const t = expr(n.test, s, sc); s.w(`if not ${T(t)}: break`); }
      const upd = (e) => { if (n.update) stmtExpr(n.update, e, sc); };
      LOOPS.push({ kind: 'loop', update: upd }); stmtBody(n.body, s, sc); LOOPS.pop();
      upd(s); em.append(s); return;
    }
    case 'ForOfStatement': case 'ForInStatement': {
      const sc = n._s; const it = tmp();
      const right = expr(n.right, em, scope);
      em.w(`for ${it} in ${n.type === 'ForOfStatement' ? 'J.iter' : 'J.keys'}(${right.c}):`);
      const s = new Em(em.ind + 1);
      if (sc.dict) { sc.dvar = '_s' + sc.id; s.w(`var ${sc.dvar} = {"__p": ${startExpr(scope)}${dictInit(sc)}}`); sc.live = true; }
      const left = n.left.type === 'VariableDeclaration' ? n.left.declarations[0].id : n.left;
      destructure(left, it, s, sc, true);
      LOOPS.push({ kind: 'loop', update: null }); stmtBody(n.body, s, sc); LOOPS.pop();
      em.append(s); return;
    }
    case 'SwitchStatement': {
      const d = spillIfNeeded(expr(n.discriminant, em, scope), em); const sc = n._s;
      if (sc.dict) { sc.dvar = '_s' + sc.id; em.w(`var ${sc.dvar} = {"__p": ${startExpr(scope)}${dictInit(sc)}}`); sc.live = true; }
      const ci = tmp(); const flag = tmp(); em.w(`var ${ci} = -1`); em.w(`var ${flag} = false`);
      let first = true; let defIdx = -1;
      n.cases.forEach((c, i) => {
        if (!c.test) { defIdx = i; return; }
        const sub = em.sub(); const t = expr(c.test, sub, sc);
        if (sub.lines.length) { em.w(`if ${ci} == -1:`); const s = new Em(em.ind + 1); s.lines = sub.lines.map(l => '\t' + l); s.w(`if J.seq(${d.c}, ${t.c}): ${ci} = ${i}`); em.append(s); }
        else em.w(`if ${ci} == -1 and J.seq(${d.c}, ${t.c}): ${ci} = ${i}`);
      });
      if (defIdx >= 0) em.w(`if ${ci} == -1: ${ci} = ${defIdx}`);
      em.w('while true:'); const s = new Em(em.ind + 1);
      const L = { kind: 'switch', flag, cont: false }; LOOPS.push(L);
      n.cases.forEach((c, i) => { s.w(`if ${ci} <= ${i} and ${ci} >= 0:`); const b = new Em(s.ind + 1); hoistFns(c.consequent, b, sc); c.consequent.forEach(x => stmt(x, b, sc)); if (!b.lines.length) b.w('pass'); s.append(b); });
      s.w('break'); LOOPS.pop(); em.append(s);
      if (L.cont) { em.w(`if ${flag}:`); const c = new Em(em.ind + 1); let lp = null; for (let i = LOOPS.length - 1; i >= 0; i--) if (LOOPS[i].kind === 'loop') { lp = LOOPS[i]; break; } let swo = null; for (let i = LOOPS.length - 1; i >= 0; i--) { if (LOOPS[i].kind === 'loop') break; if (LOOPS[i].kind === 'switch') { swo = LOOPS[i]; break; } } if (swo) { swo.cont = true; c.w(`${swo.flag} = true`); c.w('break'); } else { if (lp && lp.update) lp.update(c); c.w('continue'); } em.append(c); }
      return;
    }
    case 'LabeledStatement': stmt(n.body, em, scope); return;
    case 'DebuggerStatement': return;
  }
  throw new Error('stmt ' + n.type + ' @' + (n.loc && n.loc.start.line));
}
function stmtBody(n, em, scope) { const n0 = em.lines.length; if (n.type === 'BlockStatement') { const sc = blockEnter(n, em, scope); body(n.body, em, sc); } else stmt(n, em, scope); if (em.lines.length === n0) em.w('pass'); }

// ---------------------------------------------------------------- 主程序
CUR = { fn: AST, scope: AST._s };
const top = new Em(1);
try {
  hoistFns(AST.body, top, AST._s);
  AST.body.forEach(s => stmt(s, top, AST._s));
} catch (e) { console.error(MOD, e.message); process.exit(1); }
const topLocals = []; (function walkS(n) { if (!n || typeof n.type !== 'string') return; if (isFn(n)) return; if (n._s && n._s.fn === AST && n._s.kind !== 'global') for (const b of n._s.vars.values()) if (!b.captured) topLocals.push(lname(b)); for (const k in n) { if (k === 'loc' || k === '_s' || k === '_b') continue; const v = n[k]; if (Array.isArray(v)) v.forEach(walkS); else if (v && typeof v.type === 'string') walkS(v); } })(AST);
if (topLocals.length) top.lines.unshift('\tvar ' + [...new Set(topLocals)].join(' = null; var ') + ' = null');
const out = [`# 自動轉譯自 ${MOD}.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉`, 'extends RefCounted', '', 'func run(env):', '\tvar this_ = null; var a = []', ...(top.lines.length ? top.lines : ['\tpass']), '', ...METHODS.map(m => m + '\n')];
fs.writeFileSync(OUT, out.join('\n'));
console.log(MOD, 'ok', METHODS.length, 'funcs', out.join('\n').length, 'bytes');
