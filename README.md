# claude-init-prompts

Eine Sammlung modularer **Setup-Prompts für Claude Code**. Jeder Prompt wird in der Claude-Code-
Session eines *Zielprojekts* eingefügt und richtet dort ein eigenständiges Wissens-Subsystem unter
`_brain/` ein. Alles liegt im Projekt-Repo – damit über Git geteilt, versioniert und im Team auf
demselben Stand.

## Idee

- **Im Repo statt im lokalen Memory.** Wer das Zielprojekt klont, hat automatisch den aktuellen Stand.
- **Lazy.** Beim Start wird nichts geladen; Claude konsultiert ein Subsystem erst, wenn es gebraucht wird.
- **Komponierbar & reihenfolgeunabhängig.** Die Module berühren zwei geteilte Dateien – `CLAUDE.md`
  und `.mcp.json` – und **führen dort zusammen, statt zu überschreiben**. Du kannst sie einzeln und
  in beliebiger Reihenfolge einrichten.

## Module

| Ordner | Subsystem | Zweck |
| --- | --- | --- |
| [`obsidian/`](./obsidian) | Projekt-Gehirn (`_brain/vault/`) | Persistentes Wissensgedächtnis: Entscheidungen, Architektur-Zusammenhänge, Learnings, Konventionen und Domänenbegriffe als verlinkte Markdown-Notizen, angebunden über den dateisystem-nativen `obsidian-mcp` (Suche/Tags). |
| [`context7/`](./context7) | Code-Doku-Cache (`_brain/code-docs/`) | Holt vor dem Coden versions-spezifische Library-Doku über Context7 und legt sie lokal als Cache ab, um wiederholte API-Calls zu vermeiden. Versionierung über Git + Manifest. |

## Verwendung

1. Im **Zielprojekt** eine Claude-Code-Session starten.
2. Den Inhalt des gewünschten Setup-Prompts aus dem passenden Ordner (z. B. `obsidian/` oder
   `context7/`) einfügen.
3. Claude Code legt die Modul-Dateien an und führt `CLAUDE.md` / `.mcp.json` zusammen.
4. Im Zielprojekt **committen und pushen**.
5. Ab dann einfach arbeiten („ich möchte xy"): Die `CLAUDE.md` leitet Claude automatisch ins Gehirn
   bzw. an den Doku-Cache – ohne dass du die Subsysteme erwähnen musst.

## Was im Zielprojekt entsteht

```
<dein-projekt>/
├── CLAUDE.md              # schlankes Bootstrap/Routing (zusammengeführt)
├── .mcp.json             # projekt-skopierte MCP-Server (zusammengeführt)
└── _brain/
    ├── vault/            # obsidian-Modul: das Gehirn
    └── code-docs/        # context7-Modul: der Doku-Cache
```

## Voraussetzungen

- **Node.js >= 20** (die MCP-Server laufen über `npx`).
- Nach dem Anlegen/Ändern der `.mcp.json` einmal **Claude Code neu starten** und den neuen
  MCP-Server per **Trust-Dialog** bestätigen.
- **`context7`** funktioniert keyless mit niedrigeren Rate-Limits. Für höhere Limits und den
  optionalen Batch-Refresh einen `CONTEXT7_API_KEY` als Umgebungsvariable setzen.
- **Keine Secrets einchecken** – API-Keys nur als Umgebungsvariablen.

## Prinzipien (für eigene Module)

Ein neues Modul folgt demselben Muster: eigener Ordner hier im Repo mit einem Setup-Prompt, der im
Zielprojekt ein eigenes `_brain/<name>/`-Subsystem samt Protokoll anlegt und sich über die beiden
geteilten Dateien (`CLAUDE.md`, `.mcp.json`) **mergt statt überschreibt**. So bleiben alle Module
unabhängig und beliebig kombinierbar.
