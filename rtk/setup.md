# Setup: RTK (Token-optimierte Befehlsausgaben) einrichten

Du richtest in diesem Repository **RTK** ein – einen CLI-Proxy, der die Ausgabe von
Entwickler-Befehlen kürzt, bevor sie in Claudes Kontext landet (60–90 % weniger Tokens). Aktiviert
wird RTK über einen **projekt-lokalen** Hook in `.claude/settings.json` – er greift nur in diesem
Projekt, nicht global. Dieses Modul ist **eigenständig**.

Dieses Modul braucht eine **Binary-Installation** (kein Node/MCP) und einen **Hook**. Jeder Schritt
ist **idempotent**: Ist etwas bereits installiert/konfiguriert, **überspringe es unverändert** und
melde es nur. Mache keinen Schritt doppelt.

> Hinweis: Führe das Setup **nicht** im Plan-Modus aus – dort werden keine Dateien geschrieben.

## A) RTK-Binary installieren (überspringen, wenn vorhanden)

Prüfe zuerst, ob bereits ein funktionierendes rtk-ai/rtk auf dem PATH ist. Nur wenn **nicht**,
installiere es. Führe aus:

```bash
if command -v rtk >/dev/null 2>&1 && rtk gain >/dev/null 2>&1; then
  echo "[skip] rtk bereits installiert: $(rtk --version) ($(command -v rtk))"
else
  echo "[install] rtk nicht gefunden – installiere via offiziellem Installer nach ~/.local/bin"
  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh | sh
  command -v rtk >/dev/null 2>&1 || echo "[hinweis] ~/.local/bin ggf. zum PATH hinzufügen, dann neue Shell."
  rtk --version
fi
```

- `rtk gain >/dev/null` dient zugleich als **Disambiguierung** gegen die Namens-Kollision mit
  *reachingforthejack/rtk* (Rust Type Kit): nur das echte rtk-ai/rtk kennt `gain`.
- **Fallback ohne `curl | sh`** (wenn unerwünscht oder offline): das passende Release-Binary von
  <https://github.com/rtk-ai/rtk/releases/latest> laden (Linux x86_64 statisch:
  `rtk-x86_64-unknown-linux-musl.tar.gz`; Linux ARM: `…-aarch64-unknown-linux-gnu.tar.gz`; macOS:
  `…-apple-darwin.tar.gz`), entpacken und das Binary `rtk` nach `~/.local/bin/` legen
  (`chmod +x`). Alternativ `brew install rtk` oder `cargo install --git https://github.com/rtk-ai/rtk`.
- Installiere **nicht** den globalen Hook via `rtk init -g` – das schriebe in deine globale
  `~/.claude/`-Config und hängt `@RTK.md` an die **globale** `~/.claude/CLAUDE.md` an. Dieses Modul
  bleibt bewusst projekt-lokal (Schritt B).

## B) Projekt-Hook in `.claude/settings.json` zusammenführen (NICHT überschreiben)

Ziel: ein `PreToolUse`-Hook mit Matcher `Bash`, der den Befehl `rtk hook claude` aufruft – **nur in
diesem Projekt**.

- Existiert `.claude/settings.json` bereits und enthält unter `hooks.PreToolUse` schon einen
  `Bash`-Matcher mit dem Command `rtk hook claude`: **unverändert lassen** (`[skip]` melden).
- Existiert die Datei mit anderen `hooks.PreToolUse`-Einträgen: den unten stehenden `Bash`-Eintrag
  **ergänzen**, vorhandene Hooks/Matcher nicht entfernen.
- Existiert die Datei ohne `hooks`-Block: den `hooks`-Block ergänzen, andere Keys (z. B.
  `permissions`) unangetastet lassen.
- Existiert die Datei nicht: `.claude/` anlegen und die Datei mit genau diesem Inhalt erstellen.
- Ergebnis muss gültiges JSON sein.

Einzufügender Hook (bzw. vollständige Datei, falls neu):
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "rtk hook claude" }
        ]
      }
    ]
  }
}
```

## C) Protokoll-Datei anlegen (wortwörtlich, überspringen wenn vorhanden)

Existiert `_brain/rtk/_protocol.md` bereits: **unverändert lassen**. Sonst lege `_brain/` an (falls
nötig) und erstelle die Datei zwischen `=== DATEI: ... ===` und `=== ENDE DATEI ===` **exakt** mit
dem gezeigten Inhalt – nicht umformulieren, nicht kürzen, nicht ergänzen.

## D) CLAUDE.md zusammenführen (NICHT überschreiben)

- Existiert `CLAUDE.md` im Repo-Root bereits: hänge den unten stehenden Abschnitt unten an, ohne
  bestehende Inhalte zu verändern.
- Existiert sie nicht: erstelle sie mit der Überschrift `# Projekt` und darunter dem Abschnitt.
- Ist der Abschnitt „RTK – Token-optimierte Befehlsausgaben" bereits vorhanden: **unverändert lassen**.

Einzufügender Abschnitt:
```markdown
## RTK – Token-optimierte Befehlsausgaben

In diesem Projekt ist **RTK** aktiv (projekt-lokaler `PreToolUse`-Hook in `.claude/settings.json`):
Bash-Befehle werden automatisch auf ihr `rtk`-Äquivalent umgeschrieben und liefern gekürzte
Ausgaben. Regeln in `_brain/rtk/_protocol.md` (lies sie einmal pro Session beim ersten Shell-Befehl).

**Vorrang-Regel:** **Niemals** den aggressiven Datei-Lese-Modus verwenden (`rtk read -l aggressive`
o. ä.) – er strippt Funktionskörper. Quellcode immer in voller Treue mit dem **nativen Read-Tool**
lesen. RTK ist für **Befehls-Ausgaben** (git/tests/build/lint/ls/grep/docker), nicht zum Lesen von
Code. Im Zweifel `rtk proxy <cmd>` für die ungefilterte Originalausgabe.
```

## E) Abschluss

1. Gib den entstandenen/veränderten Verzeichnisbaum sowie eine kurze Schritt-Übersicht aus (welche
   Schritte `[install]`/`[merge]` waren und welche `[skip]`).
2. Weise mich auf folgende Punkte hin: (a) der Hook greift erst nach **Neustart von Claude Code**;
   beim ersten Lauf ggf. **Trust-Dialog** für den projekt-lokalen Hook bestätigen; danach mit
   `git status` testen (wird transparent zu `rtk git status`). (b) Liegt `~/.local/bin` nicht im
   PATH, `rtk` ist sonst „command not found". (c) RTK wirkt **nur in diesem Projekt** (Hook liegt in
   `.claude/settings.json` des Repos); committe `.claude/settings.json`, `CLAUDE.md` und
   `_brain/rtk/` mit, dann gilt es team-weit. (d) RTK-Telemetrie ist standardmäßig **aus**.

---

=== DATEI: _brain/rtk/_protocol.md ===
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

=== ENDE DATEI ===
