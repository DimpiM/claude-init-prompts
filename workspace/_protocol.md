---
title: Workspace-Protokoll
type: meta
status: active
---

# Workspace – Protokoll

Regeln dafür, wohin Claude **selbst erzeugte, nicht zum Projekt gehörende** Dateien schreibt.
Standardort ist `_brain/workspace/`. Lies diese Datei einmal pro Session, sobald du das erste Mal
eine solche Datei erzeugst.

## Grundprinzip

Alles, was du erzeugst, *um* eine Aufgabe zu erledigen, aber das **nicht selbst Teil des Projekts/
der Aufgabe** ist, gehört strukturiert in `_brain/workspace/` – nicht in den Projektbaum und nicht
außerhalb des Repos. So bleibt der Projektbaum sauber.

## Was hierher gehört (nach Kategorie)

- `scripts/`  – Hilfs-/Wegwerf-Skripte, die du zum Prüfen, Reproduzieren oder Erkunden schreibst
- `analysis/` – Analyse-Ausgaben, Daten-Dumps, Logs, Messungen
- `reports/`  – generierte Reports/Zusammenfassungen, die nicht zum Codebestand gehören
- `notes/`    – task-bezogene Pläne, Zwischenstände, Arbeitsnotizen
- `tmp/`      – echtes Wegwerfzeug, jederzeit löschbar

Bei Bedarf pro Aufgabe ein Unterordner darunter (z. B. `analysis/<task-slug>/`).

## Was NICHT hierher gehört

- die eigentlichen Quellcode-Änderungen, die die Aufgabe sind → Projektbaum
- Dateien, die der Mensch ausdrücklich an einem bestimmten Ort haben will → dieser Ort
- Tests, Config, Doku, die bewusst Teil des Repos sein sollen → Projektbaum

## Vorrang des Vault

Existiert `_brain/vault/`, gehört **durables Projektwissen** (Entscheidungen, Learnings,
Architektur-Zusammenhänge, Konventionen, Begriffe) dorthin nach dessen Protokoll – **nicht** in den
Workspace. Der Workspace ist für Arbeits- und Ausgabe-Artefakte, nicht für Wissen. `notes/` ist nur
für flüchtige, task-bezogene Notizen; sobald etwas eine durable Erkenntnis ist, gehört es ins Vault.
Existiert kein Vault, erfasst dieses Modul kein Wissen – es kümmert sich nur um generierte Dateien.

## Grenzfälle

- Eine explizite Pfadangabe des Menschen („erstelle X unter Y") gewinnt immer.
- Ist unklar, ob etwas Deliverable oder Arbeitsausgabe ist: in den Workspace legen und den Menschen
  kurz darauf hinweisen, statt zu raten.

## Git

Standardmäßig werden die **Inhalte** des Workspace per `_brain/workspace/.gitignore` lokal gehalten;
eingecheckt bleiben nur die Struktur (`.gitkeep`), dieses Protokoll und die `.gitignore`. Sollen die
Ausgaben stattdessen mit dem Team geteilt werden, entferne in der `.gitignore` die Zeile `*`.

## Initialisierung

Fehlen Kategorieordner, lege sie mit je einer `.gitkeep` an: `scripts/`, `analysis/`, `reports/`,
`notes/`, `tmp/`.
