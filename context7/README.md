# context7 – Code-Doku-Cache

Modul für [claude-init-prompts](../). Richtet im Zielprojekt einen lokalen Cache für externe
Library-Dokumentation ([Context7](https://context7.com)) unter `_brain/code-docs/` ein. So holt
Claude vor dem Coden die **versions-spezifische** Doku der genutzten Libraries, cached sie im Repo
und vermeidet wiederholte API-Calls.

## Was es bewirkt

Vor dem Schreiben/Ändern von Code, der eine externe Library nutzt, prüft Claude den lokalen Cache:
Treffer → die gecachte Doku lesen (kein API-Call). Miss oder veraltet → über den `context7`-MCP holen,
auf die **installierte** Version gepinnt, im Cache ablegen und das Manifest aktualisieren.

## Struktur

```
_brain/code-docs/
├── _protocol.md     # Regeln (lazy gelesen, beim ersten Anlass)
├── manifest.json    # Versions-Register: Policy + gecachte Einträge
├── refresh.mjs      # optionaler Batch-Refresh über die HTTP-API
└── <lib>/<version>/<topic>.md   # gecachte Doku-Chunks
```

Schlüssel je Eintrag = Library-ID + Version + Topic, z. B.
`_brain/code-docs/vercel/next.js/v15.1.8/app-router.md`.

## Einrichten

Im Zielprojekt die `setup.md` dieses Ordners ausführen lassen (siehe [Root-README](../#verwendung)).
Sie legt `_brain/code-docs/` an und führt `.mcp.json` (Server `context7`) sowie `CLAUDE.md`
**zusammen, nicht überschreibend**. Nach dem Anlegen der `.mcp.json` einmal Claude Code neu starten
(Trust-Dialog). Voraussetzung: Node.js >= 20.

## Zwei Achsen von „aktuell" & die Policy

In `manifest.json` steuern zwei Felder, wann neu geholt wird:

- `invalidateOnVersionChange` (Default `true`): neu holen, sobald die installierte Library-Version
  von der gecachten abweicht.
- `maxAgeDays` (Default `30`): Frische-TTL für gleichbleibende Versionen. Auf `null`/`0` setzen für
  reinen Offline-/Manuell-Modus.

Versioniert wird der Cache über **Git** (liegt im Repo, geteilt, mit Historie); das Manifest macht
Treffer/Miss entscheidbar.

## API-Key

Der `context7`-MCP funktioniert **keyless** mit niedrigeren Rate-Limits – der Cache reduziert die
Zahl der Calls ohnehin stark. Für höhere Limits **und** den Batch-Refresh `refresh.mjs` einen
`CONTEXT7_API_KEY` als Umgebungsvariable setzen (`refresh.mjs` bricht ohne Key ab). **Niemals den Key
einchecken.**

## Offline & Repo-Größe

Einmal befüllt funktioniert der Cache offline; bei einem Miss ohne Netz arbeitet Claude mit dem
vorhandenen Stand weiter und vermerkt das. Damit das Repo schlank bleibt: nur gebrauchte Topics mit
moderatem Token-Budget cachen und alte Versionsordner beim Versionssprung prunen.

## Abgrenzung

Dieses Modul spiegelt **fremdes** Wissen (Library-Doku). **Eigenes** Projektwissen (Entscheidungen,
Learnings, Architektur …) gehört in das Gehirn-Modul (`_brain/vault/`), falls eingerichtet – die
beiden überschneiden sich nicht.
