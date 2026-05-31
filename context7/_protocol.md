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
