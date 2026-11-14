# Setup: Clean-Code-Regeln und Prüf-Skill einrichten

Du richtest in diesem Repository **Clean-Code-Regeln** für Claude Code ein, plus einen Skill, der
vorhandenen Code gegen diese Regeln prüft. Dieses Modul ist **eigenständig**, braucht **keinen
MCP-Server**, legt **kein `_brain/`** an und **überschreibt eine vorhandene `CLAUDE.md` nicht**.

Es legt an:
- Regeln unter `.claude/rules/clean-code/` (Claude Code lädt sie automatisch),
- den Skill `.claude/skills/clean-code-check/SKILL.md`,
- einen kurzen Abschnitt in der `CLAUDE.md`.

Die Prüfberichte des Skills landen später unter `_doku/clean-code-check/` und werden mit eingecheckt.

> Hinweis: Führe das Setup **nicht** im Plan-Modus aus – dort werden keine Dateien geschrieben.

Das Setup funktioniert beim **ersten Einrichten** und beim **erneuten Ausführen** (Update). Gehe
deshalb immer gleich vor: erkennen, vergleichen, nur Fehlendes oder Geändertes anfassen.

## A) Projekttyp erkennen

Sieh dir das Projekt an (Dateien, Build-Konfiguration, Abhängigkeiten). Ignoriere dabei
`node_modules/`, `vendor/`, `dist/`, `build/`, `.git/` und ähnliche erzeugte Ordner. Entscheide für
jede der drei Fragen **ja** oder **nein**:

1. **Web-App?** Ja, wenn es ein Web-Frontend und/oder ein Web-Backend gibt. Anzeichen: Frontend-Frameworks
   (React, Vue, Angular, Svelte, Next, Nuxt, …), HTML-Templates, Web-Server-Frameworks (Express, Fastify,
   NestJS, Django, Flask, FastAPI, Rails, Laravel, Spring Web, ASP.NET, …).
2. **Native App (Desktop/Mobile)?** Ja bei z. B. Qt/QML, SwiftUI/UIKit (Xcode-Projekt), Android
   (`AndroidManifest.xml`), Flutter, WPF/WinUI/MAUI/Avalonia, GTK, React Native.
3. **Bash-Skripte?** Ja, wenn es Dateien `*.sh` / `*.bash` gibt oder Dateien ohne Endung mit
   `#!/bin/bash` oder `#!/usr/bin/env bash` in der ersten Zeile. Ein reines `#!/bin/sh` zählt allein nicht.

Daraus ergeben sich die Regeldateien:
- `allgemein.md` – **immer**.
- `web.md` – nur bei Web-App.
- `native.md` – nur bei nativer App.
- `bash.md` – nur bei Bash-Skripten.

**Nur wenn etwas unklar ist** (z. B. Electron/Tauri, reine Library, leeres Projekt), frag den Menschen
**einmal**, mit allen unklaren Punkten in einer Frage. Ist alles klar, frag nicht.

Bei einem **Update**: Regeldateien, die schon unter `.claude/rules/clean-code/` liegen, gelten als
gewählt, auch wenn der Typ jetzt nicht mehr erkannt wird. Erkennst du einen Typ neu (z. B. es gibt
jetzt Bash-Skripte), kommt dessen Regeldatei dazu. Lösche nie eine Regeldatei von selbst – passt
eine nicht mehr, weise den Menschen darauf hin.

## B) Dateien anlegen oder aktualisieren (wortwörtlich)

Lege die gewählten Regeldateien und **immer** den Skill an – **exakt** mit dem Inhalt zwischen
`=== DATEI: <pfad> ===` und `=== ENDE DATEI ===`, nicht umformulieren, nicht kürzen, nicht ergänzen.
Die Pfade sind relativ zum Repo-Root.

Für jede Datei:
- **Fehlt sie:** anlegen.
- **Existiert sie mit identischem Inhalt:** unverändert lassen.
- **Existiert sie mit abweichendem Inhalt:** nicht überschreiben. Zeig dem Menschen die Unterschiede
  kurz und frag – für alle abweichenden Dateien zusammen in **einer** Frage –, ob sie durch die neue
  Fassung ersetzt werden sollen oder bleiben, wie sie sind.

Andere Dateien unter `.claude/rules/clean-code/` (eigene Ergänzungen des Teams) bleiben unberührt.

## C) CLAUDE.md zusammenführen (NICHT überschreiben)

Geh in dieser Reihenfolge vor:

1. **Zuerst prüfen:** Ist der Abschnitt „Clean Code" in der `CLAUDE.md` schon vorhanden?
   - Identisch: unverändert lassen. Fertig mit diesem Schritt.
   - Abweichend: frag, ob **nur dieser Abschnitt** durch die neue Fassung ersetzt werden soll.
     Fertig mit diesem Schritt.
2. **Nur wenn er fehlt:**
   - Existiert `CLAUDE.md` bereits: hänge den Abschnitt unten an, ohne bestehende Inhalte zu verändern.
   - Existiert sie nicht: erstelle sie mit dem Kopf (Überschrift + Wartungsnotiz) und darunter dem Abschnitt.

Kopf nur für eine **neu erstellte** CLAUDE.md:
```markdown
# Projekt

<!--
  Wartungsnotiz: Diese Datei klein halten (< ~200 Zeilen). Sie enthält nur Bootstrap/Routing
  für die _brain-Subsysteme – niemals Projektwissen selbst. Kein @-Import von Protokolldateien,
  da @-Importe beim Start in den Kontext geladen würden.
-->
```

Einzufügender Abschnitt:
```markdown
## Clean Code

Für den Code in diesem Projekt gelten die Clean-Code-Regeln unter `.claude/rules/clean-code/`.
Claude Code lädt sie automatisch; jede Regel hat eine feste ID (A1…, W1…, N1…, B1…). Halte sie
beim Schreiben und Ändern von Code ein. Die Regeln stehen nur dort – hier nicht wiederholen.

Vorhandenen Code prüft der Skill `clean-code-check` (`/clean-code-check [teilpfad]`). Er ändert
keinen Code, sondern schreibt einen Bericht nach `_doku/clean-code-check/run-<NNN>/`.
Diese Berichte werden mit eingecheckt.
```

## D) Git prüfen

Die Berichte unter `_doku/clean-code-check/` sollen eingecheckt werden. Prüfe mit
`git check-ignore -v _doku/clean-code-check/x/report.md`, ob der Pfad ignoriert wird. Falls ja:
nichts ändern, sondern den Menschen darauf hinweisen und die passende `.gitignore`-Zeile nennen.

## E) Abschluss

1. Nenne den erkannten Projekttyp und welche Regeldateien installiert sind.
2. Nenne die angelegten, aktualisierten und unveränderten Dateien.
3. Sag, dass die Regeln in **neuen** Sessions automatisch geladen werden (laufende Session ggf. neu
   starten) und dass der Skill mit `/clean-code-check` oder per Satz wie „prüf den Code auf Clean Code"
   startet.
4. Weise darauf hin, die neuen Dateien zu **committen**. Committe nicht selbst.

---

=== DATEI: .claude/rules/clean-code/allgemein.md ===
# Clean Code – Allgemein

Gilt für jeden Code in diesem Projekt. Jede Regel hat eine feste ID und eine Schwere
(hoch / mittel / niedrig). Der Skill `clean-code-check` prüft gegen genau diese Regeln.

- **A1 – Eine Sache pro Funktion** (mittel)
  Eine Funktion muss genau eine Aufgabe erledigen. Braucht ihre Beschreibung ein „und", muss sie geteilt werden.
  Warum: Kleine Funktionen sind leichter zu verstehen, zu testen und zu ändern.

- **A2 – Sprechende Namen** (mittel)
  Namen von Funktionen, Variablen und Klassen müssen sagen, was sie tun oder enthalten. Keine
  Abkürzungen ohne Not, keine Namen wie `data`, `tmp`, `doStuff`.
  Warum: Wer den Namen liest, soll den Code nicht erst lesen müssen.

- **A3 – Kommentare nur für das Warum** (niedrig)
  Kommentare dürfen nicht wiederholen, was der Code tut. Sie erklären nur, warum etwas so gelöst ist.
  Warum: Ein Was-Kommentar veraltet und lügt irgendwann; der Code sagt das Was selbst.

- **A4 – Kein doppelter Code** (mittel)
  Gleiche oder fast gleiche Logik darf nicht an zwei Stellen stehen. Was zweimal gebraucht wird, kommt an eine Stelle.
  Warum: Sonst wird eine Änderung an einer Stelle gemacht und an der anderen vergessen.

- **A5 – Kein toter Code** (niedrig)
  Kein ungenutzter Code und kein auskommentierter Code. Alte Fassungen stehen in Git.
  Warum: Toter Code verwirrt und muss trotzdem mitgelesen und mitgepflegt werden.

- **A6 – Fehler nie verschlucken** (hoch)
  Jeder Fehler muss behandelt oder weitergegeben werden. Ein leerer `catch`/`except` oder ein
  ignorierter Rückgabewert ist verboten.
  Warum: Ein verschluckter Fehler taucht später an ganz anderer Stelle auf und ist kaum zu finden.

- **A7 – Keine Secrets im Code** (hoch)
  Passwörter, Tokens und API-Keys dürfen nicht im Code oder in eingecheckten Dateien stehen.
  Sie kommen aus Umgebungsvariablen oder einem Secret-Speicher.
  Warum: Was einmal in Git ist, ist praktisch nicht mehr zu löschen.

- **A8 – Keine magischen Zahlen** (niedrig)
  Zahlen und Texte mit fachlicher Bedeutung müssen eine benannte Konstante sein (z. B. `MAX_RETRIES = 3`).
  Selbsterklärende Werte wie `0`, `1` oder `""` sind erlaubt.
  Warum: Eine nackte `86400` erklärt sich nicht, und bei einer Änderung findet man nicht alle Stellen.

- **A9 – Logik ist testbar** (mittel)
  Fachlogik muss von Ein-/Ausgabe (Dateien, Netz, Datenbank, Oberfläche) getrennt sein, damit sie
  ohne diese getestet werden kann.
  Warum: Gemischter Code lässt sich nur mit großem Aufwand oder gar nicht testen.

=== ENDE DATEI ===

=== DATEI: .claude/rules/clean-code/web.md ===
# Clean Code – Web-Apps

Gilt zusätzlich zu `allgemein.md` für Web-Frontend und Web-Backend. IDs und Schwere wie dort.

- **W1 – Frontend zeigt nur an** (hoch)
  Das Frontend zeigt Daten an und schickt Eingaben ans Backend. Es darf nichts fachlich berechnen
  oder entscheiden.
  Warum: Logik im Browser ist doppelt, manipulierbar und schwer zu testen.

- **W2 – Regeln, Berechnungen und Rechte im Backend** (hoch)
  Prüfregeln, Berechnungen und Rechteprüfungen müssen im Backend liegen.
  Warum: Nur das Backend ist vertrauenswürdig; der Browser gehört dem Nutzer.

- **W3 – Frontend-Prüfung nur als Komfort** (hoch)
  Das Frontend darf Eingaben nur zur Bequemlichkeit vorprüfen (z. B. leeres Pflichtfeld). Das
  Backend muss jede Eingabe trotzdem selbst vollständig prüfen.
  Warum: Jede Frontend-Prüfung lässt sich umgehen.

- **W4 – Backend liefert fertige Daten** (mittel)
  Das Backend liefert Daten so, wie sie angezeigt werden. Das Frontend darf sie nicht umbauen,
  zusammenrechnen oder filtern, außer für reine Darstellung (z. B. Datumsformat).
  Warum: Sonst wandert Fachlogik schleichend ins Frontend.

- **W5 – Backend in Schichten** (mittel)
  Das Backend ist geteilt in Controller → Service → Repository (oder MVC). Der Controller ist dünn
  (Anfrage annehmen, Antwort geben), die Logik steht im Service, Datenbankzugriff nur im Repository.
  Warum: Jede Schicht hat eine Aufgabe; Logik wird testbar und die Datenbank austauschbar.

=== ENDE DATEI ===

=== DATEI: .claude/rules/clean-code/native.md ===
# Clean Code – Native Apps (MVVM)

Gilt zusätzlich zu `allgemein.md` für Desktop- und Mobile-Apps. IDs und Schwere wie dort.

- **N1 – View zeigt nur an** (hoch)
  Die View zeigt den Zustand an und meldet Aktionen des Nutzers weiter. Sie darf keine Logik enthalten.
  Warum: Logik in der Oberfläche lässt sich nicht ohne Fenster testen und nicht wiederverwenden.

- **N2 – ViewModel hält den Anzeige-Zustand** (mittel)
  Das ViewModel hält den Zustand für die Anzeige und reicht Aktionen an den Kern weiter. Fachliche
  Entscheidungen gehören nicht hierher, sondern in den Kern.
  Warum: So bleibt das ViewModel dünn und der Kern die einzige Quelle für Fachlogik.

- **N3 – Fachlogik im Kern** (hoch)
  Fachlogik muss in einem Kern ohne Oberflächen-Code liegen und ohne Fenster testbar sein.
  Warum: Der Kern ist das Wertvolle; er soll unabhängig von der Oberfläche getestet und geändert werden können.

- **N4 – Oberfläche blockiert nie** (hoch)
  Lange Arbeiten (Netz, Dateien, große Berechnungen) dürfen nie im Oberflächen-Thread laufen,
  sondern im Hintergrund.
  Warum: Sonst friert die App ein und wirkt abgestürzt.

=== ENDE DATEI ===

=== DATEI: .claude/rules/clean-code/bash.md ===
# Clean Code – Bash

Gilt zusätzlich zu `allgemein.md` für Shell-Skripte: Dateien `*.sh` / `*.bash` und Dateien ohne
Endung mit Shell-Shebang. IDs und Schwere wie dort.

- **B1 – Strikter Modus** (hoch)
  Jedes ausführbare Skript muss direkt nach dem Shebang `set -euo pipefail` setzen.
  Ausnahmen: Dateien, die nur per `source` eingebunden werden. Reine POSIX-sh-Skripte (`#!/bin/sh`)
  setzen `set -eu`, weil `pipefail` dort nicht überall geht.
  Warum: Ohne strikten Modus läuft ein Skript nach einem Fehler einfach weiter und richtet Schaden an.

- **B2 – Variablen quoten** (hoch)
  Variablen müssen immer in Anführungszeichen stehen: `"$var"`, `"${arr[@]}"`.
  Warum: Ungequotete Variablen zerbrechen an Leerzeichen und Sonderzeichen.

- **B3 – shellcheck ohne Warnungen** (mittel)
  Jedes Skript muss `shellcheck` ohne Warnungen bestehen. Ausnahmen nur per
  `# shellcheck disable=SCxxxx` mit kurzer Begründung in derselben Zeile.
  Warum: shellcheck findet die typischen Bash-Fallen zuverlässiger als jedes Auge.

- **B4 – Funktionen und main** (niedrig)
  Die Logik steht in Funktionen. Unten im Skript steht eine kurze Funktion `main`, aufgerufen mit `main "$@"`.
  Warum: So ist das Skript von oben nach unten lesbar und Teile lassen sich einzeln testen.

- **B5 – Höchstens ca. 200 Zeilen** (mittel)
  Ein Skript über ca. 200 Zeilen muss in eine richtige Programmiersprache umziehen (z. B. Python).
  Warum: Größere Bash-Programme werden schnell unlesbar, fehleranfällig und schwer zu testen.

=== ENDE DATEI ===

=== DATEI: .claude/skills/clean-code-check/SKILL.md ===
---
name: clean-code-check
description: Prüft vorhandenen Code gegen die Clean-Code-Regeln des Projekts (.claude/rules/clean-code/) und schreibt einen Bericht mit neuen, offenen und behobenen Funden nach _doku/clean-code-check/. Ändert keinen Code. Verwenden bei "clean code prüfen", "Code-Qualität prüfen", "Code auf Regeln prüfen", "Clean-Code-Check", "wie sauber ist der Code", "Regelverstöße finden", optional für einen Teilpfad.
argument-hint: "[teilpfad]"
allowed-tools: Read Grep Glob Write Bash(shellcheck *) Bash(git ls-files *) Bash(git rev-parse *) Bash(git status *) Bash(date *) Bash(mkdir -p _doku/clean-code-check/run-*)
disallowed-tools: Edit NotebookEdit
---

# Clean-Code-Check

Du prüfst vorhandenen Code gegen die Clean-Code-Regeln dieses Projekts und schreibst einen Bericht.

**Grundsatz: Du behebst nichts und änderst keinen Code.** Auch auf Nachfrage im selben Lauf änderst du
nichts; Korrekturen sind eine eigene Aufgabe.

**Write nur für den Bericht.** `Write` ist für diesen Skill ohne Nachfrage freigegeben, damit der
Bericht ohne Rückfrage entsteht. Du benutzt es **ausschließlich** für die zwei Dateien im neuen
Lauf-Ordner `_doku/clean-code-check/run-<NNN>/` (`report.md`, `findings.json`) – nie für
eine andere Datei, auch nicht für alte Lauf-Ordner. `Edit` ist für diesen Skill gesperrt.

Argument (optional): `$ARGUMENTS` – ein Teilpfad. Ist er gesetzt, prüfst du nur diesen Ordner bzw.
diese Datei. Ist er leer, prüfst du das ganze Repository.

## 1. Regeln laden

- Lies **alle** `.md`-Dateien unter `.claude/rules/clean-code/` (auch eigene Ergänzungen des Teams).
  Das ist die einzige Quelle. Prüfe nur gegen Regeln, die dort stehen; erfinde keine eigenen.
- Merke dir je Regel: ID (z. B. `A6`), Kurztitel, Schwere (hoch / mittel / niedrig) und die Datei.
  Fehlt einer Regel die Schwere, nimm `mittel`.
- Hat eine Regeldatei ein `paths`-Frontmatter, gelten ihre Regeln nur für passende Dateien. Nennt
  eine Regeldatei in ihrem Text, wofür sie gilt (z. B. „für Shell-Skripte"), wende sie nur dort an.
- Fehlt der Ordner oder ist er leer: brich ab und sag, dass zuerst das Setup des Moduls `clean-code`
  laufen muss.

## 2. Umfang bestimmen

- Dateiliste: `git ls-files --cached --others --exclude-standard` (bei Teilpfad mit diesem Pfad).
  Prüfe vorher, dass der Teilpfad existiert.
- Lass weg: `_doku/`, `.claude/`, `_brain/`, Abhängigkeiten und Erzeugtes (`node_modules/`, `vendor/`,
  `dist/`, `build/`, Lock-Dateien, minifizierte Dateien), Binärdateien, reine Daten- und Doku-Dateien.
- Ist der Umfang sehr groß (mehrere hundert Code-Dateien), sag das kurz und schlag einen Teilpfad vor,
  bevor du weitermachst.

## 3. Letzten Lauf als Vergleich finden

- Die Lauf-Ordner unter `_doku/clean-code-check/` heißen `run-001`, `run-002`, … `run-010` usw.
  (fortlaufende Nummer, mindestens dreistellig mit führenden Nullen; ab 1000 vierstellig, z. B. `run-1000`).
  Sortiere sie nach der **Zahl**, nicht nach dem Namen: `run-1000` ist neuer als `run-999`.
- Vergleichsbasis ist der **neueste** Lauf, dessen `umfang` den jetzigen Umfang **enthält** (ein Lauf
  über das ganze Repo enthält jeden Teilpfad). So verfälscht ein Teil-Lauf nicht den nächsten Gesamt-Lauf.
- Lies dessen `findings.json`. Gibt es keinen passenden Lauf, ist jeder Fund `neu`.

## 4. Prüfen

- Geh jede Datei durch und prüfe jede Regel, die für sie gilt. Lies den Code wirklich; rate nicht aus
  Dateinamen.
- Für die Shell-Regel zu `shellcheck`: führe `shellcheck` aus, wenn es installiert ist. Fehlt es, prüf
  von Hand und vermerke im Bericht, dass shellcheck nicht verfügbar war.
- Melde nur echte Verstöße. Bist du unsicher, melde den Fund mit dem Zusatz „unsicher" in der
  Beschreibung, statt ihn zu verschweigen oder aufzubauschen.
- **Secrets nie in den Bericht schreiben.** Zeig bei einem Secret-Fund nur die Stelle und den Namen der
  Variable, den Wert maskiert (`***`).

### Stabile Fund-IDs

Jeder Fund bekommt eine ID, die **nicht** an Zeilennummern hängt:

```
<Regel-ID>:<Datei relativ zum Repo-Root>:<Symbol>
```

- `<Symbol>` ist der Name der umgebenden Funktion/Methode (mit Klasse, z. B. `UserService.save`) oder
  Klasse. Steht der Verstoß außerhalb jeder Funktion, nimm `_datei_`.
- Mehrere Verstöße gegen dieselbe Regel im selben Symbol sind **ein** Fund mit mehreren Stellen.
- Betrifft ein Fund mehrere Dateien (z. B. doppelter Code), lege ihn unter der ersten Datei
  (alphabetisch) an und nenne die anderen in den Stellen.

### Status bestimmen

- ID war im Vergleichslauf (Status `neu` oder `offen`) und ist wieder da → `offen`.
- ID ist neu → `neu`.
- ID war im Vergleichslauf (Status `neu` oder `offen`), liegt im jetzigen Umfang und ist nicht mehr
  da → `behoben` (übernimm die Angaben aus dem alten Lauf).
- Funde, die im alten Lauf schon `behoben` waren, nimmst du nicht wieder auf.

## 5. Ergebnis schreiben

Lege den Ordner `_doku/clean-code-check/run-<NNN>/` an. `<NNN>` ist die höchste vorhandene run-Nummer + 1
(nach der Zahl, nicht nach dem Namen), mindestens dreistellig mit führenden Nullen; gibt es noch keinen
Lauf, ist es `run-001`. Datum und Uhrzeit des Laufs holst du mit `date`; sie stehen im Kopf von
`report.md` und in `findings.json`. Schreib genau zwei Dateien hinein. Auch ohne Funde
schreibst du beide.

### findings.json

```json
{
  "schema": 1,
  "lauf": "run-003",
  "zeitpunkt": "2026-01-31T14:30:00+01:00",
  "umfang": ".",
  "commit": "a1b2c3d",
  "arbeitsbaum_sauber": true,
  "vergleich_mit": "run-002",
  "regeldateien": ["allgemein.md", "bash.md"],
  "hinweise": ["shellcheck nicht installiert"],
  "zusammenfassung": {
    "neu": 1, "offen": 0, "behoben": 0,
    "hoch": 1, "mittel": 0, "niedrig": 0
  },
  "funde": [
    {
      "id": "A6:src/api/user.ts:UserService.load",
      "regel": "A6",
      "titel": "Fehler nie verschlucken",
      "schwere": "hoch",
      "status": "neu",
      "datei": "src/api/user.ts",
      "symbol": "UserService.load",
      "stellen": [{ "datei": "src/api/user.ts", "zeile": 42, "auszug": "catch (e) {}" }],
      "beschreibung": "Leerer catch-Block verschluckt Ladefehler.",
      "hinweis": "Fehler loggen und weiterwerfen oder dem Aufrufer melden."
    }
  ]
}
```

- `umfang` ist `.` oder der Teilpfad. `commit` aus `git rev-parse --short HEAD`, `arbeitsbaum_sauber`
  aus `git status --porcelain`. `vergleich_mit` ist `null`, wenn es keinen Vergleichslauf gibt.
- `zusammenfassung` zählt Schwere nur über `neu` und `offen`. `auszug` höchstens drei Zeilen.
- Zeilennummern sind nur zur Orientierung; sie sind nie Teil der ID.

### report.md

Lesbar für Menschen, auf Deutsch, kurz:

1. Kopf: Datum/Zeit, Umfang, Commit, Vergleichslauf, geprüfte Regeldateien, Hinweise.
2. Zusammenfassung: Zahlen neu / offen / behoben und nach Schwere.
3. Funde, **nach Schwere sortiert** (hoch → mittel → niedrig), innerhalb davon erst `neu`, dann `offen`.
   Je Fund eine Überschrift `### [neu] A6 – Fehler nie verschlucken – src/api/user.ts › UserService.load`,
   darunter Stellen (Datei:Zeile), Beschreibung und ein Satz, wie man es beheben könnte.
4. Abschnitt „Behoben seit dem letzten Lauf" als kurze Liste.

## 6. Antwort an den Menschen

Kurz: Zahlen (neu / offen / behoben), die wichtigsten zwei bis drei Funde und der Pfad zu `report.md`.
Erinnere daran, dass der Lauf-Ordner mit eingecheckt werden soll. Committe nicht selbst und behebe
nichts.

=== ENDE DATEI ===
