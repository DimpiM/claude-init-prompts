# rtk – Token-optimierte Befehlsausgaben

Modul für [claude-init-prompts](../). Richtet im Zielprojekt **RTK** (Rust Token Killer) ein – einen
CLI-Proxy, der die **Ausgabe** von Entwickler-Befehlen kürzt, **bevor** sie in Claudes Kontext
landet. Typisch 60–90 % weniger Tokens bei `git`, Tests, Build/Lint, `ls`/`grep`, Docker u. a.
Aktiviert über einen **projekt-lokalen** Hook – wirkt nur in diesem Repo, nicht global.

## Was es bewirkt

Ein `PreToolUse`-Hook fängt Bash-Tool-Aufrufe ab und schreibt sie auf ihr `rtk`-Äquivalent um
(`git status` → `rtk git status`). Claude erhält damit direkt die **gekürzte** Ausgabe – das ist
*nicht* nur menschenlesbarer Output, sondern Claudes tatsächlicher Input. Für reine Befehls-Ausgaben
(Status, Listen, Logs, Test-Failures) ist das gewollt und unkritisch; weniger Rauschen im Kontext =
günstiger und längere Sessions.

## Bewusste Entscheidung: aggressiver Datei-Lese-Modus AUS

RTKs aggressiver Modus (`rtk read -l aggressive`) strippt Funktionskörper aus Quellcode – das kann
Claudes Arbeitsqualität spürbar verschlechtern. Er ist ohnehin **kein Default** (nur per Flag), und
dieses Modul schreibt zusätzlich eine **Vorrang-Regel** in `CLAUDE.md` / `_protocol.md`: Code-Inhalt
immer in voller Treue mit dem **nativen Read-Tool** lesen, RTK nur für **Befehls-Ausgaben**. So
bleibt der nützliche Teil (Output-Kürzung) erhalten, ohne die Lese-Treue zu opfern.

## Struktur

```
<dein-projekt>/
├── .claude/settings.json   # projekt-lokaler PreToolUse-Hook (zusammengeführt)
├── CLAUDE.md               # kurzer Routing-Abschnitt + Vorrang-Regel (zusammengeführt)
└── _brain/rtk/
    └── _protocol.md        # Regeln & Befehlsreferenz (lazy gelesen, beim ersten Anlass)
```

Das **Binary** `rtk` wird auf der Maschine installiert (Standard: `~/.local/bin/rtk`) – kein
MCP/Node nötig.

## Einrichten

Im Zielprojekt die `setup.md` dieses Ordners ausführen lassen (siehe [Root-README](../#verwendung)).
Sie installiert das Binary (falls nötig), führt den Hook in `.claude/settings.json` sowie den
Abschnitt in `CLAUDE.md` **zusammen, nicht überschreibend**, und legt `_brain/rtk/_protocol.md` an.
Nach dem Einrichten **Claude Code neu starten**, damit der Hook geladen wird (ggf. Trust-Dialog).

## Idempotenz („schon vorhanden → überspringen")

Jeder Schritt prüft den Ist-Zustand und macht nichts doppelt:

- **Binary:** `command -v rtk` + `rtk gain` (Letzteres disambiguiert die Namens-Kollision mit
  *reachingforthejack/rtk*, das `gain` nicht kennt). Vorhanden → Installation übersprungen.
- **Hook:** ist in `.claude/settings.json` schon ein `Bash`-`PreToolUse`-Eintrag mit
  `rtk hook claude` → unverändert. Sonst ergänzen, ohne andere Hooks zu entfernen.
- **CLAUDE.md / `_protocol.md`:** vorhandener Abschnitt bzw. vorhandene Datei → unverändert.

## Per-Projekt vs. global

Bewusst **per Projekt**: der Hook liegt in der `.claude/settings.json` des Repos und wirkt nur hier.
`rtk init -g` würde stattdessen global (`~/.claude/`) einrichten und u. a. `@RTK.md` an deine globale
`~/.claude/CLAUDE.md` hängen – das vermeidet dieses Modul. Wer den Hook team-weit will, committet
`.claude/settings.json`, `CLAUDE.md` und `_brain/rtk/` einfach mit.

## Voraussetzungen

- Eine POSIX-Shell mit `curl` für den Installer (oder manuell ein Release-Binary von
  <https://github.com/rtk-ai/rtk/releases>). Kein Node/MCP nötig.
- `~/.local/bin` muss im `PATH` sein (sonst `rtk: command not found`).
- Nach dem Anlegen des Hooks **Claude Code neu starten**.

## Abgrenzung

Dieses Modul reduziert **Token im Befehls-Output** – orthogonal zu den anderen Modulen: das Gehirn
(`_brain/vault/`) hält Projektwissen, der Doku-Cache (`_brain/code-docs/`) Library-Doku, der
Workspace (`_brain/workspace/`) generierte Dateien. RTK fasst keines davon an, sondern macht nur die
Ausgaben der Shell-Befehle schlanker, die Claude ohnehin absetzt.
