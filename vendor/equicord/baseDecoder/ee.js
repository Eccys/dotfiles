// Ee!? codec from https://deadlyblock.com/e/ (2026-10-06).
// Original wire format and public page key retained for interoperability.

const KEY = 'mbUdJ+25AFtzRz6GvtslBc2g6uMpk5IhrxYl0sjad6Q=';
const A = 'Ee!?"#$%&\'()*+,-./:;<=>@[]^_{|}~';
const AC = Uint8Array.from(A, c => c.charCodeAt(0));
const LUT = new Int8Array(256).fill(-1);
AC.forEach((c, i) => LUT[c] = i);
[9, 10, 11, 12, 13, 96].forEach(c => LUT[c] = -2);

const HS = [...' etaoinshrdlucmwfgypb.,vIk\0\'\n’T?A!SWHM-01jxOBC2DNLYPEq35)GFR":49zJ678K“”(U/…V;*—@XQZ&#_%$+=<>–~[]\t|^{}\\`'];
const HN = [0, 0, 2, 6, 4, 10, 5, 3, 7, 16, 20, 8, 13, 4, 2, 4], ESC = HS.indexOf('\0');
const HC = [], HL = [], HM = new Map();
for (let L = 1, c = 0, i = 0; L <= 16; L++, c <<= 1) {
  for (let k = 0; k < HN[L - 1]; k++, i++) {
    HC[i] = c++;
    HL[i] = L;
    if (i !== ESC) HM.set(HS[i], i);
  }
}

const TE = new TextEncoder(), TA = new TextDecoder(), TD = new TextDecoder('utf-8', { fatal: true, ignoreBOM: true });
const MODE = {
  0: ['text mode', 'Each character has its own bit code: 3 bits for space and e, more for rarer ones.'],
  4: ['compressed', 'Deflate-compressed before encoding, which wins on long text.'],
  5: ['raw bytes', 'Plain UTF-8 bytes, used when that comes out shortest.'],
  6: ['file', 'The file’s bytes with its name stored inside.'],
  7: ['compressed file', 'The file deflate-compressed, with its name stored inside.']
};
const Z = (() => { try { new CompressionStream('deflate-raw'); new DecompressionStream('deflate-raw'); return true; } catch { return false; } })();
const flow = (b, S) => new Response(new Blob([b]).stream().pipeThrough(new S('deflate-raw'))).arrayBuffer().then(x => new Uint8Array(x));

const K = (async () => {
  if (!crypto.subtle) throw 5;
  const base = await crypto.subtle.importKey('raw', TE.encode(KEY), 'PBKDF2', false, ['deriveBits']);
  const bits = new Uint8Array(await crypto.subtle.deriveBits({ name: 'PBKDF2', hash: 'SHA-256', salt: TE.encode('Ee!?'), iterations: 100000 }, base, 512));
  return {
    enc: await crypto.subtle.importKey('raw', bits.slice(0, 32), 'AES-CTR', false, ['encrypt']),
    mac: await crypto.subtle.importKey('raw', bits.slice(32), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign'])
  };
})();
K.catch(() => {});

const mac = async (k, s) => new Uint8Array(await crypto.subtle.sign('HMAC', k.mac, s));
const stream = async (k, iv, n) => {
  const c = new Uint8Array(16);
  c.set(iv);
  return new Uint8Array(await crypto.subtle.encrypt({ name: 'AES-CTR', counter: c, length: 48 }, k.enc, new Uint8Array(n)));
};

const seal = async s => {
  const k = await K, t = await mac(k, s), o = new Uint8Array(10 + s.length);
  for (let i = 0; i < 10; i++) o[i] = t[i] & 31;
  const x = await stream(k, o.subarray(0, 10), s.length);
  for (let i = 0; i < s.length; i++) o[10 + i] = s[i] ^ x[i] & 31;
  return o;
};

const open = async c => {
  if (c.length < 11) throw 1;
  const k = await K, x = await stream(k, c.subarray(0, 10), c.length - 10), s = new Uint8Array(c.length - 10);
  for (let i = 0; i < s.length; i++) s[i] = c[10 + i] ^ x[i] & 31;
  const t = await mac(k, s);
  for (let i = 0; i < 10; i++) if ((t[i] & 31) !== c[i]) throw 4;
  return s;
};

const ascii = v => {
  for (let i = 0; i < v.length; i++) v[i] = AC[v[i]];
  return v;
};

const pack = (b, m) => {
  const o = new Uint8Array(Math.ceil((3 + b.length * 8) / 5));
  let a = m, k = 3, j = 0;
  for (let i = 0; i < b.length; i++) {
    a = a << 8 | b[i];
    k += 8;
    while (k >= 5) o[j++] = a >>> (k -= 5) & 31;
    a &= (1 << k) - 1;
  }
  if (k) o[j] = (a << 5 - k | 31 >> k) & 31;
  return o;
};

const unpack = s => {
  const bits = s.length * 5 - 3, r = bits & 7;
  if (r > 4) throw 1;
  const o = new Uint8Array(bits >> 3);
  let a = s[0] & 3, k = 2, j = 0;
  for (let i = 1; i < s.length; i++) {
    a = a << 5 | s[i];
    if ((k += 5) >= 8) {
      o[j++] = a >>> (k -= 8);
      a &= (1 << k) - 1;
    }
  }
  if (a !== (1 << k) - 1) throw 1;
  return o;
};

const henc = t => {
  const o = new Uint8Array(Math.ceil((1 + t.length * 37) / 5));
  let a = 0, k = 1, j = 0, prev = 128;
  const put = (v, b) => {
    a = a << b | v;
    k += b;
    while (k >= 5) o[j++] = a >>> (k -= 5) & 31;
    a &= (1 << k) - 1;
  };
  for (const c of t) {
    const i = HM.get(c);
    if (i !== undefined) { put(HC[i], HL[i]); continue; }
    const p = c.codePointAt(0);
    let z = p < prev ? (prev - p) * 2 - 1 : (p - prev) * 2;
    prev = p;
    put(HC[ESC], HL[ESC]);
    do { put(z > 15 ? z & 15 | 16 : z, 5); z >>>= 4; } while (z);
  }
  if (k) put(31 >> k, 5 - k);
  return o.subarray(0, j);
};

const hdec = s => {
  const n = s.length * 5;
  let pos = 1, r = '', prev = 128;
  const bit = () => s[pos / 5 | 0] >> 4 - pos++ % 5 & 1;
  while (pos < n) {
    let code = 0, first = 0, idx = 0, sym = -1;
    for (let L = 0; L < 16; L++) {
      if (pos >= n) {
        if (L > 4 || code !== (2 << L) - 2) throw 1;
        return r;
      }
      code |= bit();
      if (code - first < HN[L]) { sym = idx + code - first; break; }
      idx += HN[L];
      first = first + HN[L] << 1;
      code <<= 1;
    }
    if (sym < 0) throw 1;
    if (sym !== ESC) { r += HS[sym]; continue; }
    let z = 0, sh = 0, g;
    do {
      if (pos + 5 > n || sh > 20) throw 1;
      g = 0;
      for (let b = 0; b < 5; b++) g = g << 1 | bit();
      z |= (g & 15) << sh;
      sh += 4;
    } while (g & 16);
    prev += z & 1 ? -(z + 1) / 2 : z / 2;
    if (prev < 0 || prev > 1114111) throw 1;
    r += String.fromCodePoint(prev);
  }
  return r;
};

const encText = async t => {
  const u = TE.encode(t), sz = n => Math.ceil((3 + n * 8) / 5);
  let o = henc(t), m = 0;
  if (sz(u.length) < o.length) { o = pack(u, 5); m = 5; }
  if (Z && u.length > 40) {
    try {
      const c = await flow(u, CompressionStream);
      if (sz(c.length) < o.length) { o = pack(c, 4); m = 4; }
    } catch {}
  }
  return { o, m };
};

const encFile = async (name, d) => {
  const nm = TE.encode(name), h = [];
  for (let l = nm.length; ; l >>>= 7) {
    if (l < 128) { h.push(l); break; }
    h.push(l & 127 | 128);
  }
  const p = new Uint8Array(h.length + nm.length + d.length);
  p.set(h);
  p.set(nm, h.length);
  p.set(d, h.length + nm.length);
  if (Z && p.length > 64) {
    try {
      const mid = p.length >> 1, s = p.length > 262144 ? p.subarray(mid - 32768, mid + 32768) : null;
      if (!s || (await flow(s, CompressionStream)).length < s.length * .96) {
        const c = await flow(p, CompressionStream);
        if (c.length < p.length) return { o: pack(c, 7), m: 7 };
      }
    } catch {}
  }
  return { o: pack(p, 6), m: 6 };
};

const clean = t => t.replace(/[\s`\u00ad\u200b-\u200d\u2060\ufeff]+/g, '').replace(/[\u201c-\u201f\u2033]/g, '"').replace(/[\u2018-\u201b\u2032]/g, "'").replace(/\u2026/g, '...');
const F = '```', fence = s => F + s + F;

const symsText = t => {
  t = t.trim();
  if (t.includes(' ') && /^[Ee!? ]+$/.test(t)) throw 3;
  t = clean(t);
  const s = new Uint8Array(t.length);
  for (let i = 0; i < t.length; i++) {
    const c = t.charCodeAt(i), v = c < 128 ? LUT[c] : -1;
    if (v < 0) throw { ch: String.fromCodePoint(t.codePointAt(i)) };
    s[i] = v;
  }
  return s;
};

const symsBytes = u => {
  const s = new Uint8Array(u.length);
  let n = 0;
  for (let i = 0; i < u.length; i++) {
    const v = LUT[u[i]];
    if (v >= 0) s[n++] = v;
    else if (v === -1) return symsText(TA.decode(u));
  }
  return s.subarray(0, n);
};

const decode = async s => {
  if (s[0] < 16) return { t: hdec(s), m: 0 };
  const m = s[0] >> 2;
  let b = unpack(s);
  if (m === 4 || m === 7) {
    if (!Z) throw 2;
    b = await flow(b, DecompressionStream);
  }
  if (m < 6) return { t: TD.decode(b), m };
  let l = 0, k = 0, i = 0, c;
  do {
    if (i >= b.length || k > 14) throw 1;
    c = b[i++];
    l |= (c & 127) << k;
    k += 7;
  } while (c & 128);
  if (i + l > b.length) throw 1;
  return { f: TD.decode(b.subarray(i, i + l)) || 'file', d: b.subarray(i + l), m };
};

const why = e => e?.ch ? `It contains “${e.ch}”, which isn’t one of the 32 symbols.` : e === 2 ? 'This browser can’t decompress it. Try a recent Chrome, Firefox or Safari.' : e === 3 ? 'This looks like a code from the old five-symbol version, which this one can’t read.' : e === 4 ? 'This code wasn’t made with this page’s key, or part of it was changed.' : e === 5 ? 'Open this page over https or as a local file to lock and unlock codes.' : 'Part of the code is missing or was changed.';

export async function encodeEe(text) {
    const { o } = await encText(text);
    return fence(TA.decode(ascii(await seal(o))));
}
export async function decodeEe(text) {
    try {
        // Accept markdown-escaped punctuation pasted from chat.
        const r = await decode(await open(symsText(text.replace(/\\([~_])/g, '$1'))));
        if (r.d) throw new Error('This Ee!? code contains a file; use deadlyblock.com/e/ to download it.');
        return r.t;
    } catch (e) {
        throw e instanceof Error ? e : new Error(why(e));
    }
}
