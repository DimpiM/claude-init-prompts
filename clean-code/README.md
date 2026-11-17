# clean-code – Regeln für sauberen Code und ein Prüf-Skill

Modul für [claude-init-prompts](../). Bringt dem Zielprojekt kurze, prüfbare **Clean-Code-Regeln**
bei und einen **Skill**, der vorhandenen Code dagegen prüft. **Kein MCP, kein `_brain/`.**

## Was es bewirkt

- **Beim Schreiben:** Claude Code lädt die Regeln aus `.claude/rules/clean-code/` automatisch und hält
  sich beim Schreiben und Ändern von Code daran.
- **Beim Prüfen:** Der Skill `clean-code-check` geht vorhandenen Code durch und schreibt einen Bericht.
  Er **ändert keinen Code**. Jeder Lauf vergleicht mit dem letzten: jeder Fund ist `neu`, `offen` oder
  `behoben`. So sieht man, ob es besser wird. `Edit` ist für den Skill gesperrt; `Write` ist ohne
  Nachfrage erlaubt, aber laut Skill-Anweisung nur für den Bericht unter `_doku/clean-code-check/`.

## Struktur im Zielprojekt

```
.claude/
├── rules/clean-code/
│   ├── allgemein.md     # gilt immer (A1–A10)
│   ├── web.md           # nur bei Web-Apps (W1–W5)
│   ├── native.md        # nur bei nativen Apps, MVVM (N1–N4)
│   ├── bash.md          # nur bei Bash-Skripten (B1–B5)
│   └── embedded.md      # nur bei Embedded (E1–E5)
└── skills/clean-code-check/
    └── SKILL.md         # der Prüf-Skill
_doku/clean-code-check/
└── run-001/            # ein Ordner pro Lauf: run-001, run-002, … (entsteht beim ersten Lauf)
    ├── report.md        # lesbar, nach Schwere sortiert
    └── findings.json    # maschinenlesbar, Grundlage für den Vergleich
```

Dazu kommt ein kurzer Abschnitt „Clean Code" in der `CLAUDE.md`, der nur auf Regeln und Skill zeigt.

## Die Regeln

Jede Regel hat eine feste ID, eine Schwere (hoch / mittel / niedrig) und einen Satz „warum".

- **Allgemein:** eine Sache pro Funktion, sprechende Namen, Kommentare nur fürs Warum, kein doppelter
  Code, kein toter Code, Fehler nie verschlucken, keine Secrets, keine magischen Zahlen, testbare Logik.
- **Web:** Frontend zeigt nur an. Regeln, Berechnungen und Rechte liegen im Backend. Frontend-Prüfung
  nur als Komfort. Backend liefert fertige Daten. Backend in Schichten (Controller → Service → Repository).
- **Native (MVVM):** View zeigt nur an, ViewModel hält den Anzeige-Zustand, Fachlogik in einem Kern
  ohne Oberfläche, lange Arbeiten im Hintergrund.
- **Bash:** `set -euo pipefail` (reines POSIX-sh: `set -eu`), Variablen quoten, `shellcheck` ohne
  Warnungen, Logik in Funktionen mit `main`, über ca. 200 Zeilen in eine richtige Sprache umziehen.
- **Embedded:** Hardware-Zugriff hinter einer Schicht (HAL), Ressourcen räumen sich selbst auf, kein
  Speicher-Anfordern in zeitkritischen Pfaden, geteilte Daten geschützt, auf Ereignisse warten statt
  in Schleifen. Embedded mit Oberfläche (z. B. Qt/QML) bekommt zusätzlich die Native-Regeln.

Der genaue Wortlaut steht in der [`setup.md`](./setup.md).

## Einrichten und aktualisieren

Im Zielprojekt die `setup.md` dieses Ordners ausführen lassen (siehe [Root-README](../#verwendung)):

> Hol dir diese `setup.md` und führe ihre Anweisungen in diesem Projekt aus:
> https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/clean-code/setup.md

Das Setup erkennt den Projekttyp selbst und fragt nur bei Unklarheit einmal nach. Eine vorhandene
`CLAUDE.md` wird **zusammengeführt, nicht überschrieben**.

**Update:** Einfach die `setup.md` erneut ausführen lassen. Fehlende Dateien kommen dazu, identische
bleiben, bei abweichenden wird gefragt. Neue Projekttypen (z. B. jetzt gibt es Bash-Skripte) bekommen
ihre Regeldatei nachträglich.

## Prüfen

- `/clean-code-check` – prüft das ganze Repository.
- `/clean-code-check src/api` – prüft nur diesen Teilpfad.
- Oder per Satz: „prüf den Code auf Clean Code", „wie ist die Code-Qualität?".

Die Fund-IDs hängen nicht an Zeilennummern, sondern an Regel, Datei und Funktion
(z. B. `A6:src/api/user.ts:UserService.load`). Verschobene Zeilen machen also keinen neuen Fund.

Die Berichte unter `_doku/clean-code-check/` werden **mit eingecheckt**. So sieht das Team den Verlauf.

## Eigene Regeln ergänzen

Weitere `.md`-Dateien unter `.claude/rules/clean-code/` sind erlaubt und werden vom Skill mitgeprüft.
Jede Regel braucht eine eindeutige ID (eigenes Präfix, z. B. `P1…`) und eine Schwere in Klammern.
Das Setup lässt solche Dateien beim Update in Ruhe.
