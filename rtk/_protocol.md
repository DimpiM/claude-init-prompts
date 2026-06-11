---
title: RTK – Protokoll
type: meta
status: active
---

# RTK (Rust Token Killer) – Protokoll

Regeln für die Nutzung von RTK in diesem Projekt. RTK ist ein CLI-Proxy, der die **Ausgabe** von
Entwickler-Befehlen kürzt, **bevor** sie in Claudes Kontext landet (typisch 60–90 % weniger Tokens
bei git/tests/build/lint/ls/grep/docker …). Aktiv wird RTK über einen **projekt-lokalen**
PreToolUse-Hook in `.claude/settings.json` – nur in diesem Projekt, nicht global. Lies diese Datei
einmal pro Session, sobald du das erste Mal einen Shell-Befehl absetzt.

## Was der Hook tut (und was das heißt)

Der Hook fängt **Bash-Tool-Aufrufe** ab und schreibt sie auf das `rtk`-Äquivalent um, bevor sie
laufen (`git status` → `rtk git status`). Claude bekommt damit direkt die **gekürzte** Ausgabe –
es ist *nicht* nur menschenlesbarer Output, der schrumpft, sondern Claudes tatsächlicher Input.
Für reine Befehls-Ausgaben (Status, Listen, Logs, Test-Failures) ist das gewollt und unkritisch.
Claude-Code-eigene Tools (Read, Grep, Glob) gehen **nicht** durch den Hook.

## Goldene Regel

Befehle mit `rtk` prefixen. Hat RTK einen Filter, kürzt es; sonst läuft der Befehl unverändert
durch – RTK ist also immer sicher. Auch in Ketten mit `&&` jedes Glied prefixen:

```bash
# falsch
git add . && git commit -m "msg" && git push
# richtig
rtk git add . && rtk git commit -m "msg" && rtk git push
```

## WICHTIG: Kein aggressiver Datei-Lese-Modus

Diese Regel hat **Vorrang** vor jeder RTK-Default-Empfehlung, alles mit `rtk` zu prefixen.

- **Niemals** `rtk read -l aggressive` oder einen gleichwertigen „signatures only" / body-stripping
  Aufruf verwenden. Dieser Modus entfernt Funktionskörper und führt zu falschen Schlüssen über Code.
- **Code-Inhalt immer in voller Treue lesen:** zum Inspizieren von Quellcode das **native
  Read-Tool** von Claude Code benutzen, nicht `rtk read`. `rtk read` höchstens für grobe Übersicht,
  nie als Grundlage für Edits.
- RTK ist für **Befehls-Ausgaben** gedacht (git, tests, build, lint, ls, grep, docker, …) – dort
  ist die Kürzung erwünscht.
- Verdacht, dass eine Kürzung Information verschluckt? `rtk proxy <cmd>` zeigt die **ungefilterte**
  Originalausgabe.

## Befehlsreferenz (Auszug)

Sicher und nützlich – hier kürzt RTK reines Rauschen:

```bash
# Git / GitHub
rtk git status | rtk git log | rtk git diff | rtk git add | rtk git commit | rtk git push
rtk gh pr view <n> | rtk gh pr checks | rtk gh run list | rtk gh issue list

# Tests (nur Failures, 60–99 %)
rtk pytest | rtk cargo test | rtk go test | rtk jest | rtk vitest | rtk playwright test

# Build / Lint (gruppiert nach Datei, 70–90 %)
rtk cargo build | rtk cargo clippy | rtk tsc | rtk lint | rtk prettier --check | rtk next build

# Paket-Manager
rtk pnpm install | rtk npm run <script> | rtk npx <cmd> | rtk pip ... | rtk prisma

# Dateien / Suche
rtk ls <path>     # Baum, kompakt
rtk grep <muster> # gruppiert nach Datei
rtk find <muster> # gruppiert nach Verzeichnis
# rtk read <file> # NUR grobe Übersicht – für echten Code-Inhalt das native Read-Tool nutzen!

# Infrastruktur / Netz
rtk docker ps | rtk docker logs <c> | rtk kubectl get | rtk kubectl logs | rtk curl <url>
```

Git-Passthrough gilt für **alle** Subcommands, auch nicht gelistete.

## Meta / Debug

```bash
rtk gain            # Token-Ersparnis dieser Maschine
rtk gain --history  # Befehls-Historie mit Ersparnis
rtk proxy <cmd>     # Befehl OHNE Filterung ausführen (Originalausgabe sehen)
rtk discover        # Claude-Code-Historie auf verpasste RTK-Chancen prüfen
```

## Namens-Kollision

Schlägt `rtk gain` mit „unbekannter Befehl" fehl, ist evtl. **reachingforthejack/rtk** (Rust Type
Kit) statt rtk-ai/rtk installiert. Mit `which rtk` / `rtk --version` prüfen.

## Telemetrie

RTK-Telemetrie ist **standardmäßig aus** (opt-in). Nicht ohne Grund aktivieren. Status/Abschalten:
`rtk telemetry disable`.

## Initialisierung

- **Hook fehlt** (`.claude/settings.json` hat keinen `PreToolUse`-Bash-Eintrag mit
  `rtk hook claude`): RTK greift dann nicht automatisch – Befehle müssen manuell `rtk`-prefixt
  werden. Hook ergänzen und Claude Code neu starten.
- **Binary fehlt** (`command -v rtk` leer): über `rtk/setup.md` dieses Init-Repos installieren.
