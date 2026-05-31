#!/usr/bin/env node
// Batch-Refresh des Code-Doku-Caches über die Context7 HTTP-API.
// Aufruf:  node _brain/code-docs/refresh.mjs [--lib /vercel/next.js]
// Voraussetzung: Umgebungsvariable CONTEXT7_API_KEY.

import { readFile, writeFile, mkdir } from "node:fs/promises";
import { createHash } from "node:crypto";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const MANIFEST = join(HERE, "manifest.json");
const API = "https://context7.com/api/v2/context";

const apiKey = process.env.CONTEXT7_API_KEY;
if (!apiKey) {
  console.error("Fehlt: Umgebungsvariable CONTEXT7_API_KEY. Abbruch.");
  process.exit(1);
}

const libFilter = (() => {
  const i = process.argv.indexOf("--lib");
  return i !== -1 ? process.argv[i + 1] : null;
})();

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function fetchDocs(context7Id, query, attempt = 0) {
  const url =
    `${API}?libraryId=${encodeURIComponent(context7Id)}` +
    `&query=${encodeURIComponent(query || "")}`;
  const res = await fetch(url, { headers: { Authorization: `Bearer ${apiKey}` } });
  if (res.status === 429 && attempt < 3) {
    const retry = Number(res.headers.get("retry-after")) || 2 ** attempt;
    console.warn(`429 für ${context7Id} – warte ${retry}s`);
    await sleep(retry * 1000);
    return fetchDocs(context7Id, query, attempt + 1);
  }
  if (!res.ok) throw new Error(`${res.status} für ${context7Id}: ${await res.text()}`);
  return res.text();
}

const manifest = JSON.parse(await readFile(MANIFEST, "utf8"));
let updated = 0;

for (const [libId, lib] of Object.entries(manifest.libraries || {})) {
  if (libFilter && libFilter !== libId) continue;
  for (const [topic, entry] of Object.entries(lib.topics || {})) {
    try {
      const text = await fetchDocs(lib.context7Id, entry.query);
      const outPath = join(HERE, entry.file);
      await mkdir(dirname(outPath), { recursive: true });
      await writeFile(outPath, text, "utf8");
      entry.fetchedAt = new Date().toISOString();
      entry.sourceHash = "sha256:" + createHash("sha256").update(text).digest("hex");
      updated++;
      console.log(`aktualisiert: ${libId} / ${topic}`);
    } catch (e) {
      console.error(`Fehler bei ${libId} / ${topic}: ${e.message}`);
    }
  }
}

await writeFile(MANIFEST, JSON.stringify(manifest, null, 2) + "\n", "utf8");
console.log(`Fertig. ${updated} Eintrag/Einträge aktualisiert.`);
