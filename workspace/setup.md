# Setup: Workspace für generierte Dateien anlegen

Du richtest in diesem Repository einen festen Ablageort für **von Claude Code erzeugte, nicht zum
Projekt gehörende Dateien** unter `_brain/workspace/` ein. Dieses Modul ist **eigenständig**,
braucht **keine Installation und keinen MCP-Server** und **überschreibt eine vorhandene `CLAUDE.md`
nicht**.

> Hinweis: Führe das Setup **nicht** im Plan-Modus aus – dort werden keine Dateien geschrieben.

## A) Dateien & Ordner anlegen (wortwörtlich)

Lege die unten zwischen `=== DATEI: ... ===` und `=== ENDE DATEI ===` stehenden Dateien an –
**exakt** mit dem gezeigten Inhalt, nicht umformulieren, nicht kürzen, nicht ergänzen.

Lege außerdem die fünf Kategorieordner unter `_brain/workspace/` an, jeweils mit einer leeren
`.gitkeep`: `scripts/`, `analysis/`, `reports/`, `notes/`, `tmp/`.

## B) CLAUDE.md zusammenführen (NICHT überschreiben)

- Existiert `CLAUDE.md` bereits: hänge den unten stehenden Abschnitt unten an, ohne bestehende
  Inhalte zu verändern.
- Existiert sie nicht: erstelle sie mit dem Kopf (Überschrift + Wartungsnotiz) und darunter dem Abschnitt.
- Ist der Abschnitt „Arbeitsausgabe / generierte Dateien" bereits vorhanden: unverändert lassen.

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
## Arbeitsausgabe / generierte Dateien

Schreibe alle Dateien, die du erzeugst und die **nicht** Teil des Projekts/der Aufgabe sind
(Hilfsskripte, Analysen, Logs, generierte Reports, Pläne, Wegwerf-Dateien), nicht in den
Projektbaum, sondern strukturiert nach Kategorie unter `_brain/workspace/`. Regeln und
Ordnerstruktur stehen in `_brain/workspace/_protocol.md` (lies sie einmal pro Session beim ersten
solchen Anlass).

Ausnahme: Existiert `_brain/vault/`, gehört durables Projektwissen (Entscheidungen, Learnings,
Architektur, Konventionen, Begriffe) weiterhin dorthin nach dessen Protokoll – nicht in den
Workspace. Dateien, die der Mensch ausdrücklich an einem bestimmten Ort haben will, bleiben dort.
```

## C) Abschluss

1. Gib den entstandenen/veränderten Verzeichnisbaum aus.
2. Weise mich darauf hin, dass die generierten **Inhalte** des Workspace standardmäßig per
   `_brain/workspace/.gitignore` lokal gehalten werden (nur Struktur, Protokoll und `.gitignore`
   werden eingecheckt). Sollen die Ausgaben mit dem Team geteilt werden, ist in der `.gitignore`
   die Zeile `*` zu entfernen.

---

=== DATEI: _brain/workspace/_protocol.md ===
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

=== ENDE DATEI ===

=== DATEI: _brain/workspace/.gitignore ===
# Generierte Inhalte lokal halten; Struktur + Protokoll bleiben eingecheckt.
# Sollen die Ausgaben mit dem Team geteilt werden: die Zeile "*" entfernen.
*
!*/
!.gitignore
!_protocol.md
!.gitkeep

=== ENDE DATEI ===

---

Lege außerdem an (leere Dateien): `_brain/workspace/scripts/.gitkeep`,
`_brain/workspace/analysis/.gitkeep`, `_brain/workspace/reports/.gitkeep`,
`_brain/workspace/notes/.gitkeep`, `_brain/workspace/tmp/.gitkeep`.
