# Setup: Code-Doku-Cache (Context7) anlegen

Du richtest in diesem Repository einen lokalen Cache für externe Library-Dokumentation
(Context7) unter `_brain/code-docs/` ein. Dieses Modul ist **eigenständig** – es funktioniert
unabhängig davon, ob bereits ein Projekt-Gehirn (`_brain/vault/`) existiert.

## A) Dateien anlegen (wortwörtlich)

Lege die unten zwischen `=== DATEI: ... ===` und `=== ENDE DATEI ===` stehenden Dateien an –
**exakt** mit dem gezeigten Inhalt, nicht umformulieren, nicht kürzen, nicht ergänzen.
Lege `_brain/` an, falls es noch nicht existiert.

## B) .mcp.json zusammenführen (NICHT überschreiben)

- Existiert `.mcp.json` im Repo-Root bereits: füge unter `mcpServers` den Eintrag `context7`
  (siehe unten) hinzu, ohne vorhandene Server (z. B. `brain`) zu entfernen.
- Existiert sie nicht: erstelle sie mit genau diesem `context7`-Eintrag.
- Ist `context7` bereits vorhanden: unverändert lassen.
- Ergebnis muss gültiges JSON sein.

Einzufügender Server-Eintrag:
```json
"context7": {
  "command": "npx",
  "args": ["-y", "@upstash/context7-mcp"]
}
```

## C) CLAUDE.md zusammenführen (NICHT überschreiben)

- Existiert `CLAUDE.md` im Repo-Root bereits: hänge den unten stehenden Abschnitt unten an,
  ohne bestehende Inhalte zu verändern.
- Existiert sie nicht: erstelle sie mit der Überschrift `# Projekt` und darunter dem Abschnitt.
- Ist der Abschnitt „Code-Doku-Cache (Context7)" bereits vorhanden: unverändert lassen.

Einzufügender Abschnitt:
```markdown
## Code-Doku-Cache (Context7)

Bevor du Code schreibst oder änderst, der eine externe Library oder ein Framework nutzt:
konsultiere zuerst den lokalen Doku-Cache unter `_brain/code-docs/` nach den Regeln in
`_brain/code-docs/_protocol.md`. Lies diese Protokolldatei einmal pro Session beim ersten
solchen Anlass. Bei Cache-Miss oder veraltetem Eintrag hole die Doku über den `context7`-MCP,
gepinnt auf die installierte Library-Version, lege sie im Cache ab und aktualisiere
`_brain/code-docs/manifest.json`. Mache **keine** wiederholten API-Calls für bereits gecachte,
gültige Einträge.
```

## D) Abschluss

1. Gib den entstandenen/veränderten Verzeichnisbaum aus.
2. Weise mich auf folgende Punkte hin: (a) Node.js >= 20 muss im Pfad sein; (b) nach dem Anlegen
   der `.mcp.json` ist ein Neustart von Claude Code nötig, damit der `context7`-Server geladen wird
   und einmal per Trust-Dialog bestätigt werden kann; (c) keyless funktioniert mit niedrigeren
   Limits – für höhere Limits `CONTEXT7_API_KEY` als Umgebungsvariable setzen (und optional in der
   `.mcp.json` als Argument `"--api-key", "${CONTEXT7_API_KEY}"` ergänzen); (d) `refresh.mjs`
   benötigt `CONTEXT7_API_KEY`.

---

=== DATEI: _brain/code-docs/_protocol.md ===
---
title: Code-Doku-Cache – Protokoll
type: meta
status: active
---

# Code-Doku-Cache (Context7) – Protokoll

Regeln für den lokalen Cache externer Library-Dokumentation unter `_brain/code-docs/`.
Hier wird **fremdes** Wissen (Context7) gespiegelt – eigenes Projektwissen gehört ins Gehirn
(`_brain/vault/`). Lies diese Datei einmal pro Session, sobald du das erste Mal Code schreibst
oder änderst, der eine externe Library/ein Framework nutzt.

## Grundprinzipien

- Vor dem Schreiben/Ändern von Code mit externer Library: **zuerst hier nachschauen**, nicht blind die API rufen.
- „Aktuell" hat zwei Achsen: die **Library-Version** (hart an die installierte Version gekoppelt)
  und die **Frische der indexierten Doku** (TTL/Refresh). Siehe Policy.
- Lazy: nur die tatsächlich gebrauchten Libraries/Topics holen, nie „alles".
- **Versionierung macht Git** (der Cache liegt im Repo, ist geteilt und hat Historie).
  `manifest.json` macht Cache-Treffer/-Miss entscheidbar, ohne alle Dateien zu scannen.
- Keine Secrets in den Cache. Keine wiederholten API-Calls für bereits gültige Einträge.

## Speicherort & Schlüssel

Schlüssel = **Library-ID + Version + Topic**.
Pfad: `_brain/code-docs/<library-id-pfad>/<version>/<topic>.md`

- Library-ID-Pfad = Context7-ID ohne führenden Slash, z. B. `/vercel/next.js` → `vercel/next.js`.
- Version = installierte Version mit `v`-Präfix, z. B. `v15.1.8`.
- Topic = Slug (Kleinbuchstaben, Bindestriche), z. B. `app-router.md`. Ohne Topic: `_general.md`.

Beispiel: `_brain/code-docs/vercel/next.js/v15.1.8/app-router.md`

## manifest.json (Versions-Register)

```json
{
  "schemaVersion": 1,
  "policy": { "invalidateOnVersionChange": true, "maxAgeDays": 30 },
  "libraries": {
    "/vercel/next.js": {
      "installedVersion": "15.1.8",
      "context7Id": "/vercel/next.js/v15.1.8",
      "topics": {
        "app-router": {
          "file": "vercel/next.js/v15.1.8/app-router.md",
          "query": "app router",
          "tokens": 5000,
          "fetchedAt": "2026-05-31T10:00:00Z",
          "sourceHash": "sha256:..."
        }
      }
    }
  }
}
```

- `policy.maxAgeDays`: TTL für Achse 2. Auf `null` oder `0` setzen, um die TTL abzuschalten
  (voll offline-stabil, Refresh nur noch manuell).
- `policy.invalidateOnVersionChange`: bei `true` neu holen, sobald die installierte Version von
  `installedVersion` abweicht.

## Ablauf vor dem Coden

1. Relevante Libraries der Aufgabe **und ihre installierte Version** aus dem Lockfile/Manifest des
   Projekts ermitteln (`package-lock.json` / `pnpm-lock.yaml` / `poetry.lock` / `go.mod` / …).
2. Pro Library + Topic im `manifest.json` prüfen:
   - **Treffer** (`installedVersion` passt, Eintrag jünger als `maxAgeDays`, Datei vorhanden) →
     gecachte `.md` lesen. **Kein API-Call.**
   - **Miss/veraltet** → über den `context7`-MCP holen: bei unbekannter Library zuerst
     `resolve-library-id`, dann `get-library-docs` mit der **auf die installierte Version gepinnten**
     ID + `topic` (+ Token-Budget). Ergebnis in die Cache-Datei schreiben, Manifest-Eintrag setzen
     (`file`/`query`/`tokens`/`fetchedAt`/`sourceHash`), ggf. `installedVersion`/`context7Id`
     aktualisieren.
3. Code auf Basis der gecachten Doku schreiben. Legst du dabei eine Gehirn-Notiz an, verlinke die
   genutzte Cache-Datei im `source`-Feld.

## Fetch-Wege

- **Primär (on-demand):** der `context7`-MCP. Funktioniert keyless mit niedrigeren Limits; für höhere
  Limits `CONTEXT7_API_KEY` setzen (siehe Secrets).
- **Batch-Refresh (optional):** `refresh.mjs` zieht alle Manifest-Einträge über die HTTP-API neu
  (versions-gepinnt), mit Backoff bei 429. Braucht `CONTEXT7_API_KEY`.
  Aufruf: `node _brain/code-docs/refresh.mjs` (optional `--lib /vercel/next.js`).

## Invalidierung

- **Versionswechsel** (primär): installierte Version ≠ `installedVersion` → neu holen, alten
  Versionsordner prunen (optional genau eine Vorgängerversion behalten).
- **TTL** (sekundär): Eintrag älter als `maxAgeDays` → bei nächster Nutzung neu holen.
- **Manuell:** `refresh.mjs`, ganz oder per `--lib`.

## Repo-Größe

- Nur gebrauchte Topics cachen, Token-Budget moderat halten (Default 5000).
- Beim Versionssprung alte Versionsordner entfernen – die Historie übernimmt Git.

## Secrets

`CONTEXT7_API_KEY` **niemals einchecken**. In `.mcp.json` als Umgebungsvariable referenzieren bzw.
lokal in der Shell setzen; `refresh.mjs` liest ihn aus `process.env`.

## Offline

Einmal befüllt funktioniert der Cache offline. Bei einem Miss ohne Netz: mit dem vorhandenen Stand
weiterarbeiten und im Output klar vermerken, dass die Doku nicht aufgefrischt werden konnte.

## Initialisierung

Fehlt `_brain/code-docs/` oder `manifest.json`, anlegen (Manifest mit leerem `libraries`-Objekt und
der Default-Policy oben).

=== ENDE DATEI ===

=== DATEI: _brain/code-docs/manifest.json ===
{
  "schemaVersion": 1,
  "policy": {
    "invalidateOnVersionChange": true,
    "maxAgeDays": 30
  },
  "libraries": {}
}

=== ENDE DATEI ===

=== DATEI: _brain/code-docs/refresh.mjs ===
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

=== ENDE DATEI ===

