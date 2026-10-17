# output-styles – Antwortstil von Claude

Modul für [claude-init-prompts](../). Bringt fertige **Output-Styles** für Claude Code mit. Ein
Output-Style ändert, *wie* Claude antwortet (Ton, Länge, Sprache), nicht, *was* es tut.
**Kein MCP, kein `_brain/`-Ordner** und keine Änderung an `CLAUDE.md` oder `.mcp.json`.

## Enthaltene Styles

| Datei | Name | Wofür |
| --- | --- | --- |
| [`short-explain.md`](./short-explain.md) | `short-explain` | Sehr kurze, einfache Antworten auf Deutsch, erklärt wie einem klugen Kind. Abkürzungen werden erklärt, Vergleiche aus dem Alltag statt Definitionen. Für müde Köpfe. |

## Wohin installieren?

- **Global** `~/.claude/output-styles/<name>.md`: gilt in allen Projekten, nur für dich.
- **Pro Projekt** `.claude/output-styles/<name>.md`: liegt im Repo und gilt fürs ganze Team.

## Einzeln installieren

**Per Setup-Prompt.** In einer beliebigen Claude-Code-Session den Style beim Namen nennen. Ohne
Namen installiert das Setup alle Styles. Den Ort (global oder Projekt) kannst du gleich mit angeben,
sonst fragt Claude nach.

> Installiere den Output-Style `short-explain` global – hol dir die `setup.md` und führe sie aus:
> https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/output-styles/setup.md

**Per Hand.** Die eine Datei herunterladen, fertig:

```bash
# global
mkdir -p ~/.claude/output-styles
curl -fsSL -o ~/.claude/output-styles/short-explain.md \
  https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/output-styles/short-explain.md

# nur im aktuellen Projekt
mkdir -p .claude/output-styles
curl -fsSL -o .claude/output-styles/short-explain.md \
  https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/output-styles/short-explain.md
```

## Einschalten

- In der Session: `/output-style short-explain` (oder `/output-style` für die Auswahl).
- Dauerhaft: `"outputStyle": "short-explain"` in `.claude/settings.local.json` (nur für dich) oder
  `.claude/settings.json` (fürs Team).
- Taucht der Style nicht in der Auswahl auf: Claude Code einmal neu starten.

## Eigenen Style ergänzen

Neue Datei `<name>.md` mit Frontmatter (`name`, `description`) hier ablegen, sie zusätzlich als
`=== DATEI: <name>.md ===`-Block in die `setup.md` einbetten (beide Kopien identisch halten) und in
die Liste „Verfügbare Styles" der `setup.md` sowie in die Tabelle oben eintragen.
