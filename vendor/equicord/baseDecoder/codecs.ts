import { decodeEe, encodeEe } from "./ee";

export type Format = "auto" | "ee" | "base64" | "hex" | "url";
export const formats: { value: Format; label: string; }[] = [
    { value: "auto", label: "Auto detect" },
    { value: "ee", label: "Ee!? (deadlyblock.com)" },
    { value: "base64", label: "Base64 / Base64URL" },
    { value: "hex", label: "Hex (UTF-8)" },
    { value: "url", label: "URL encoding" }
];
const te = new TextEncoder();
const td = new TextDecoder("utf-8", { fatal: true });
const cache = new Map<string, Promise<string>>();
const unfence = (s: string) => s.trim().replace(/^```(?:[\w-]+\n)?([\s\S]*?)```$/, "$1").trim();
const EE_CHARS = new Set(`Ee!?"#$%&'()*+,-./:;<=>@[]^_{|}~`);
const EE_OLD = new Set("Ee!?");

function normalizeEeCandidate(text: string) {
    return text
        .replace(/\\([~_])/g, "$1")
        .replace(/[\s`\u00ad\u200b-\u200d\u2060\ufeff]+/g, "")
        .replace(/[\u201c-\u201f\u2033]/g, '"')
        .replace(/[\u2018-\u201b\u2032]/g, "'")
        .replace(/\u2026/g, "...");
}

/** Conservative check so normal chat is not auto-decoded. Manual Decode still uses auto-detect. */
export function looksLikeEe(text: string) {
    const n = normalizeEeCandidate(unfence(text));
    if (n.length < 16) return false;
    let onlyOldAlphabet = true;
    for (const c of n) {
        if (!EE_CHARS.has(c)) return false;
        if (!EE_OLD.has(c)) onlyOldAlphabet = false;
    }
    return !onlyOldAlphabet;
}

export async function encodeText(text: string, format: Format): Promise<string> {
    if (text.length > 200_000) throw new Error("Use text under 200,000 characters.");
    if (format === "ee" || format === "auto") return encodeEe(text);
    if (format === "url") return encodeURIComponent(text);
    const bytes = te.encode(text);
    if (format === "hex") return Array.from(bytes, b => b.toString(16).padStart(2, "0")).join("");
    let binary = "";
    for (const b of bytes) binary += String.fromCharCode(b);
    return btoa(binary);
}

async function decodeOne(text: string, format: Format): Promise<string> {
    const s = unfence(text);
    if (!s) throw new Error("Paste some encoded text first.");
    if (format === "ee") return decodeEe(s);
    if (format === "url") {
        if (!/%[0-9a-f]{2}/i.test(s)) throw new Error("No URL escape sequences found.");
        return decodeURIComponent(s);
    }
    if (format === "hex") {
        const hex = s.replace(/\s/g, "");
        if (!/^(?:[0-9a-f]{2})+$/i.test(hex)) throw new Error("Invalid hex text.");
        return td.decode(Uint8Array.from(hex.match(/../g)!, x => parseInt(x, 16)));
    }
    const b64 = s.replace(/\s/g, "").replace(/-/g, "+").replace(/_/g, "/");
    if (!/^[A-Za-z0-9+/]+={0,2}$/.test(b64) || b64.length % 4 === 1) throw new Error("Invalid Base64 text.");
    const bytes = Uint8Array.from(atob(b64), c => c.charCodeAt(0));
    const result = td.decode(bytes);
    if (/[\u0000-\u0008\u000b\u000c\u000e-\u001f\u007f]/.test(result)) throw new Error("Decoded data is not readable text.");
    return result;
}

async function decodeAuto(text: string): Promise<string> {
    const candidates = [text, ...Array.from(text.matchAll(/```(?:[\w-]+\n)?([\s\S]*?)```/g), m => m[1])];
    for (const s of candidates) {
        for (const f of ["ee", "hex", "base64", "url"] as Format[]) {
            try { return await decodeOne(s, f); } catch { /* Try the next format. */ }
        }
    }
    // Retain the original plugin's ability to find Base64 inside a message.
    const results: string[] = [];
    for (const match of text.matchAll(/[A-Za-z0-9+/_-]{8,}={0,2}/g)) {
        try { results.push(await decodeOne(match[0], "base64")); } catch { /* Not Base64 text. */ }
    }
    if (results.length) return results.join("\n\n");
    throw new Error("Could not decode this message. Select its format manually; Ee!? needs the complete, unchanged code.");
}

export function decodeText(text: string, format: Format): Promise<string> {
    if (text.length > 200_000) return Promise.reject(new Error("Use text under 200,000 characters."));
    const key = format + ":" + text;
    const existing = cache.get(key);
    if (existing) return existing;
    const result = format === "auto" ? decodeAuto(text) : decodeOne(text, format);
    if (cache.size >= 128) cache.delete(cache.keys().next().value!);
    cache.set(key, result);
    result.catch(() => cache.delete(key));
    return result;
}
export function clearDecodeCache() { cache.clear(); }
