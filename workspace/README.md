# workspace – generierte Dateien sammeln

Modul für [claude-init-prompts](../). Richtet im Zielprojekt einen festen Ablageort für **von Claude
Code erzeugte, nicht zum Projekt gehörende Dateien** unter `_brain/workspace/` ein. **Kein MCP, keine
Installation** – nur eine Regel in der `CLAUDE.md` plus ein kleines Protokoll.

## Was es bewirkt

Claude schreibt alles, was es *um* eine Aufgabe herum erzeugt, aber das nicht selbst Teil des Projekts
ist (Hilfsskripte, Analysen, Logs, generierte Reports, Pläne, Wegwerf-Dateien), strukturiert nach
Kategorie in `_brain/workspace/` – statt in den Projektbaum. So bleibt der Projektbaum sauber.

## Struktur

```
_brain/workspace/
├── _protocol.md   # Regeln (lazy gelesen, beim ersten Anlass)
├── .gitignore     # hält generierte Inhalte lokal
├── scripts/       # Hilfs-/Wegwerf-Skripte
├── analysis/      # Analyse-Ausgaben, Daten-Dumps, Logs
├── reports/       # generierte Reports/Zusammenfassungen
├── notes/         # task-bezogene Arbeitsnotizen
└── tmp/           # Wegwerfzeug
```

## Einrichten

Im Zielprojekt die `setup.md` dieses Ordners ausführen lassen (siehe [Root-README](../#verwendung)).
Sie legt die Struktur an und ergänzt die `CLAUDE.md`; eine vorhandene `CLAUDE.md` wird
**zusammengeführt, nicht überschrieben**.

## Defaults (leicht umstellbar)

- **Ordnername** `workspace`.
- Die generierten **Inhalte** werden per `.gitignore` lokal gehalten; eingecheckt bleiben nur
  Struktur (`.gitkeep`), das Protokoll und die `.gitignore`. Sollen die Ausgaben mit dem Team geteilt
  werden, entferne in `_brain/workspace/.gitignore` die Zeile `*`.

## Vorrang des Vault

Existiert das Gehirn-Modul (`_brain/vault/`), bleibt **durables Projektwissen** (Entscheidungen,
Learnings, Architektur, Konventionen, Begriffe) dort – der Workspace nimmt nur Arbeits- und
Ausgabe-Artefakte. `notes/` ist nur für flüchtige, task-bezogene Notizen. Ohne Vault kümmert sich das
Modul allein um generierte Dateien und erfasst kein Wissen.

## Abgrenzung

**Hierher:** alles, was Claude erzeugt, um die Aufgabe zu erledigen, aber das nicht selbst die Aufgabe
ist. **In den Projektbaum:** die eigentlichen Quellcode-Änderungen, vom Menschen ausdrücklich verortete
Dateien, sowie Tests/Config/Doku, die bewusst Teil des Repos sein sollen. Eine explizite Pfadangabe des
Menschen gewinnt immer.
