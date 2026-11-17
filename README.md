# claude-init-prompts

Eine Sammlung modularer **Setup-Prompts für Claude Code**. Jeder Prompt wird in der Claude-Code-
Session eines *Zielprojekts* eingefügt und richtet dort ein eigenständiges Subsystem ein – meist
unter `_brain/`. Alles liegt im Projekt-Repo – damit über Git geteilt, versioniert und im Team auf
demselben Stand. Wenige Module (`output-styles`, `sudo-askpass`) wirken global auf deinem Rechner.

## Idee

- **Im Repo statt im lokalen Memory.** Wer das Zielprojekt klont, hat automatisch den aktuellen Stand.
- **Lazy.** Beim Start wird nichts geladen; Claude konsultiert ein Subsystem erst, wenn es gebraucht wird.
- **Komponierbar & reihenfolgeunabhängig.** Module berühren höchstens zwei geteilte Dateien –
  `CLAUDE.md` und `.mcp.json` – und **führen dort zusammen, statt zu überschreiben**. Du kannst sie
  einzeln und in beliebiger Reihenfolge einrichten.

## Was die Module bringen

Jedes Modul löst ein konkretes, wiederkehrendes Problem im Arbeiten mit Claude Code:

- **Projekt-Gehirn (`obsidian/`) – Wissen geht nicht verloren.** Sonst vergisst Claude zwischen
  Sessions, *warum* etwas so gebaut wurde. Das Gehirn hält Entscheidungen, Architektur-Zusammenhänge
  und Learnings im Repo fest – versioniert, team-geteilt und beim nächsten Klon sofort da. Es ersetzt
  das flüchtige, lokale Memory.
- **Code-Doku-Cache (`context7/`) – richtige API, richtige Version.** Statt gegen veraltetes
  Trainingswissen zu coden, holt Claude die Doku der **tatsächlich installierten** Library-Version,
  cached sie lokal und spart wiederholte API-Calls. Nach dem ersten Befüllen offline-fähig.
- **Arbeitsausgabe (`workspace/`) – sauberer Projektbaum.** Hilfsskripte, Analysen, Reports und
  Wegwerf-Dateien, die Claude *um* eine Aufgabe herum erzeugt, landen gebündelt unter
  `_brain/workspace/` statt verstreut im Projekt. Ohne MCP, ohne Installation.
- **Output-Styles (`output-styles/`) – Antworten, wie du sie brauchst.** Fertige Antwortstile für
  Claude Code, z. B. `short-explain` für kurze, einfache Antworten auf Deutsch. Global oder pro
  Projekt installierbar, jeder Style einzeln. Kein `_brain/`, kein MCP.
- **sudo-Passwort per Fenster (`sudo-askpass/`) – sudo klappt auch in Claude Code.** Claude Code
  hat kein Terminal für Passworteingaben, deshalb scheitert dort jedes `sudo`. Das Modul setzt
  `SUDO_ASKPASS`, und `sudo` öffnet ein kleines Passwortfenster. Claude sieht das Passwort nie.
  Global, kein `_brain/`, kein MCP.
- **Clean Code (`clean-code/`) – sauberer Code nach festen Regeln.** Kurze, prüfbare Regeln für
  jeden Code (u. a.: Code ist auf Englisch), dazu passend für Web-Apps, native Apps, Bash und Embedded. Claude lädt sie automatisch beim
  Schreiben. Der Skill `clean-code-check` prüft vorhandenen Code, ändert nichts und legt einen
  Bericht mit neuen, offenen und behobenen Funden unter `_doku/clean-code-check/` ab.

Der Hebel liegt im Zusammenspiel: Weil die `_brain`-Module demselben Muster folgen und nur zusammenführen statt
zu überschreiben, kombinierst du genau die, die du brauchst – und Claude arbeitet mit projekteigenem
Gedächtnis, aktueller Library-Doku und aufgeräumtem Projektbaum zugleich.

## Module

| Ordner | Subsystem | Zweck |
| --- | --- | --- |
| [`obsidian/`](./obsidian) | Projekt-Gehirn (`_brain/vault/`) | Persistentes Wissensgedächtnis: Entscheidungen, Architektur-Zusammenhänge, Learnings, Konventionen und Domänenbegriffe als verlinkte Markdown-Notizen, angebunden über den dateisystem-nativen `obsidian-mcp` (Suche/Tags). |
| [`clean-code/`](./clean-code) | Clean-Code-Regeln (`.claude/rules/clean-code/`, `.claude/skills/clean-code-check/`, `_doku/clean-code-check/`) | Kurze, prüfbare Regeln mit festen IDs (allgemein, Web, nativ/MVVM, Bash, Embedded), je nach erkanntem Projekttyp installiert und von Claude Code automatisch geladen. Dazu ein Skill, der vorhandenen Code prüft, nichts ändert und eingecheckte Berichte mit Verlauf (neu/offen/behoben) schreibt. Kein MCP, kein `_brain/`. |
| [`context7/`](./context7) | Code-Doku-Cache (`_brain/code-docs/`) | Holt vor dem Coden versions-spezifische Library-Doku über Context7 und legt sie lokal als Cache ab, um wiederholte API-Calls zu vermeiden. Versionierung über Git + Manifest. |
| [`output-styles/`](./output-styles) | Output-Styles (`~/.claude/output-styles/` oder `.claude/output-styles/`) | Fertige Antwortstile für Claude Code (aktuell: `short-explain`). Jeder Style einzeln installierbar, global oder pro Projekt. Berührt weder `CLAUDE.md` noch `.mcp.json`. |
| [`sudo-askpass/`](./sudo-askpass) | sudo-Passwortfenster (`~/.local/bin/claude-askpass`, `~/.claude/settings.json`) | Lässt `sudo` in Claude Code ein grafisches Passwortfenster öffnen (über `SUDO_ASKPASS`), statt mangels Terminal zu scheitern. Global, mit `install.sh` auch ohne Claude installierbar. Berührt weder `CLAUDE.md` noch `.mcp.json`. |
| [`workspace/`](./workspace) | Arbeitsausgabe (`_brain/workspace/`) | Sammelt von Claude erzeugte, nicht zum Projekt gehörende Dateien (Skripte, Analysen, Reports, Notizen, Temp) strukturiert unter `_brain/workspace/`, damit der Projektbaum sauber bleibt. Ohne MCP/Installation, nur eine `CLAUDE.md`-Regel. |

Einstiegspunkt je Modul ist die Datei `setup.md` im jeweiligen Ordner – das ist der
auszuführende Setup-Prompt. [`install.md`](./install.md) im Repo-Root bietet alle Module zur
Auswahl an und führt die gewählten `setup.md` nacheinander aus.

## Verwendung

### Empfohlen: Auswahl-Installer

In der Claude-Code-Session des **Zielprojekts** (nicht im Plan-Modus) sagst du:

> Hol dir https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/install.md und führe sie aus.

Claude zeigt dir alle Module als Ankreuz-Liste – getrennt nach Projektmodulen und globalen Modulen
für deinen Rechner. Es richtet nur die angehakten ein, führt `CLAUDE.md` / `.mcp.json` zusammen und
sammelt am Ende die Hinweise (Neustart, Trust-Dialog). Anschließend im Zielprojekt **committen und
pushen** – ab dann arbeitest du einfach normal („ich möchte xy"), und die `CLAUDE.md` leitet Claude
automatisch ins Gehirn, an den Doku-Cache usw., ohne dass du die Subsysteme erwähnen musst.

### Module einzeln installieren

Jedes Modul funktioniert allein. Du nennst Claude die Raw-URL seiner `setup.md` und lässt sie
**ausführen** (nicht nur lesen):

> Hol dir diese `setup.md` und führe ihre Anweisungen in diesem Projekt aus: `<Raw-URL>`

- `obsidian`: https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/obsidian/setup.md
- `context7`: https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/context7/setup.md
- `workspace`: https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/workspace/setup.md
- `clean-code`: https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/clean-code/setup.md
- `output-styles`: https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/output-styles/setup.md
- `sudo-askpass`: https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/sudo-askpass/setup.md

Mehrere URLs in einer Nachricht gehen auch. Weitere Module kannst du später jederzeit nachziehen;
die Reihenfolge ist egal. Nimm die **Raw-URL**, nicht die `tree/...`-Ordneransicht – die muss Claude
erst auflösen, und das scheitert gelegentlich an GitHubs Zugriffsschutz.

**Output-Styles** gehen auch einzeln, Style für Style. Nenne den Namen und den Ort (global oder
nur dieses Projekt):

> Installiere den Output-Style `short-explain` global – hol dir die `setup.md` und führe sie aus:
> https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/output-styles/setup.md

Ohne Claude geht es auch per Hand: die Style-Datei nach `~/.claude/output-styles/` (global) oder
`.claude/output-styles/` (Projekt) legen, dann `/output-style short-explain`. Details im
[Modul-README](./output-styles).

## Was im Zielprojekt entsteht

```
<dein-projekt>/
├── CLAUDE.md              # schlankes Bootstrap/Routing (zusammengeführt)
├── .mcp.json             # projekt-skopierte MCP-Server (zusammengeführt)
├── .claude/
│   ├── rules/clean-code/        # clean-code-Modul: die Regeln (automatisch geladen)
│   ├── skills/clean-code-check/ # clean-code-Modul: der Prüf-Skill
│   └── output-styles/           # output-styles-Modul, nur bei Installation pro Projekt
├── _doku/
│   └── clean-code-check/ # clean-code-Modul: Prüfberichte je Lauf (eingecheckt)
└── _brain/
    ├── vault/            # obsidian-Modul: das Gehirn
    ├── code-docs/        # context7-Modul: der Doku-Cache
    └── workspace/        # workspace-Modul: generierte Dateien
```

Das `clean-code`-Modul nutzt kein `_brain/`: Regeln und Skill liegen dort, wo Claude Code sie von
selbst findet (`.claude/`), die Berichte unter `_doku/clean-code-check/` (entsteht beim ersten
Prüflauf). Das `output-styles`-Modul schreibt nur `<name>.md` nach `~/.claude/output-styles/` oder,
pro Projekt, nach `.claude/output-styles/`. Das `sudo-askpass`-Modul fasst das Zielprojekt gar
nicht an: Es legt `~/.local/bin/claude-askpass` an und setzt `env.SUDO_ASKPASS` in
`~/.claude/settings.json`.

## Voraussetzungen

- **Node.js >= 20** (die MCP-Server laufen über `npx`).
- Nach dem Anlegen/Ändern der `.mcp.json` einmal **Claude Code neu starten** und den neuen
  MCP-Server per **Trust-Dialog** bestätigen.
- **`context7`** funktioniert keyless mit niedrigeren Rate-Limits. Für höhere Limits und den
  optionalen Batch-Refresh einen `CONTEXT7_API_KEY` als Umgebungsvariable setzen.
- **Keine Secrets einchecken** – API-Keys nur als Umgebungsvariablen.

## Prinzipien (für eigene Module)

Ein neues Modul folgt demselben Muster: ein eigener Ordner hier im Repo mit genau einer `setup.md`
als Einstiegs-Prompt. Diese legt im Zielprojekt ein eigenes `_brain/<name>/`-Subsystem samt Protokoll
an und **mergt** sich über die beiden geteilten Dateien (`CLAUDE.md`, `.mcp.json`) **statt zu
überschreiben**. So bleiben alle Module unabhängig und beliebig kombinierbar.

Module ohne `_brain/` (wie `clean-code`, `output-styles`, `sudo-askpass`) legen ihre Dateien dort ab,
wo Claude Code sie von selbst findet, und sagen im README klar, ob sie pro Projekt oder global wirken.

Jedes neue Modul gehört außerdem in die Modulliste von [`install.md`](./install.md) (in die passende
Gruppe: Projekt oder global) – sonst taucht es im Auswahl-Installer nicht auf. Dazu hier oben in
die Tabelle, „Was die Module bringen" und „Module einzeln installieren".
