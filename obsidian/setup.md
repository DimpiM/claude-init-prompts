# Setup: Projekt-Gehirn anlegen

Du richtest in diesem Repository ein persistentes Wissensgedächtnis ("Gehirn") für Claude Code
unter `_brain/vault/` ein. Dieses Modul ist **eigenständig** – es funktioniert unabhängig davon,
ob bereits andere `_brain`-Subsysteme (z. B. der Code-Doku-Cache) eingerichtet sind, und
**überschreibt vorhandene `CLAUDE.md`/`.mcp.json` nicht**.

## A) Dateien anlegen (wortwörtlich)

Lege die unten zwischen `=== DATEI: ... ===` und `=== ENDE DATEI ===` stehenden Dateien an –
**exakt** mit dem gezeigten Inhalt, nicht umformulieren, nicht kürzen, nicht ergänzen.
Lege außerdem die fünf Unterordner `decisions/`, `learnings/`, `architecture/`, `conventions/`,
`glossary/` unter `_brain/vault/` an und packe in jeden eine leere Datei `.gitkeep`.

## B) .mcp.json zusammenführen (NICHT überschreiben)

- Existiert `.mcp.json` im Repo-Root bereits: füge unter `mcpServers` den Eintrag `brain` hinzu,
  ohne vorhandene Server (z. B. `context7`) zu entfernen.
- Existiert sie nicht: erstelle sie mit genau diesem `brain`-Eintrag.
- Ist `brain` bereits vorhanden: unverändert lassen. Ergebnis muss gültiges JSON sein.

Einzufügender Server-Eintrag:
```json
"brain": {
  "command": "npx",
  "args": ["-y", "obsidian-mcp", "${CLAUDE_PROJECT_DIR:-.}/_brain/vault"]
}
```

## C) CLAUDE.md zusammenführen (NICHT überschreiben)

- Existiert `CLAUDE.md` bereits: hänge den unten stehenden Abschnitt unten an, ohne bestehende
  Inhalte zu verändern.
- Existiert sie nicht: erstelle sie mit dem Kopf (Überschrift + Wartungsnotiz) und darunter dem Abschnitt.
- Ist der Abschnitt „Projekt-Gehirn (Brain)" bereits vorhanden: unverändert lassen.

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
## Projekt-Gehirn (Brain)

Dieses Projekt besitzt ein persistentes Wissensgedächtnis ("Gehirn") unter `_brain/vault/`.
Es ist die Quelle der Wahrheit für **Entscheidungen, Architektur-Zusammenhänge, Learnings,
Konventionen und Domänenbegriffe**.

Das Gehirn ist für **dich (Claude)**, nicht für den Menschen. Aber wenn der Mensch eine Frage
stellt, die Projektwissen erfordert, **schau zuerst im Gehirn nach**, bevor du antwortest.

### Kontext nicht aufblähen
- Lade beim Start **nichts** aus dem Gehirn. Importiere das Protokoll absichtlich nicht (kein @-Import).
- Konsultiere das Gehirn erst, wenn du es brauchst – und hole dann **nur die relevanten Notizen**,
  nie den ganzen Vault.

### Ablauf
1. **Einmal pro Session**, sobald du das erste Mal mit dem Gehirn arbeitest (lesen *oder* schreiben):
   lies `_brain/vault/_protocol.md` und befolge es für den Rest der Session.
2. **Lesen** – bevor du eine projektbezogene Frage beantwortest oder eine nicht-triviale Aufgabe
   beginnst: durchsuche das Gehirn. Bevorzugt über die `brain`-MCP-Tools (Suche, Tags).
   Fallback, falls der MCP nicht verbunden ist: Dateien unter `_brain/vault/` direkt lesen/greppen.
3. **Schreiben** – halte neue Entscheidungen, Learnings, Architektur-Erkenntnisse, Konventionen
   und Begriffe nach den Regeln in `_brain/vault/_protocol.md` fest.

### Setup-Hinweis (einmalig pro Maschine)
Der `brain`-MCP-Server ist projekt-skopiert in `.mcp.json` definiert. Beim ersten Start fragt
Claude Code einmal nach Bestätigung ("trust") – danach läuft er automatisch. Voraussetzung:
Node.js (>= 20) ist im Pfad verfügbar.
```

## D) Abschluss

1. Gib den entstandenen/veränderten Verzeichnisbaum aus.
2. Weise mich auf zwei einmalige Schritte hin: (a) den `brain`-MCP beim nächsten Start einmal
   per Trust-Dialog bestätigen (ein Neustart von Claude Code ist nötig, damit die neue/geänderte
   `.mcp.json` geladen wird), und (b) sicherstellen, dass Node.js >= 20 im Pfad verfügbar ist.

---

=== DATEI: _brain/vault/_protocol.md ===
---
title: Brain-Protokoll
type: meta
status: active
---

# Brain-Protokoll

Betriebsanleitung für das Projekt-Gehirn (`_brain/vault/`). Du (Claude) liest diese Datei
einmal pro Session, sobald du das erste Mal mit dem Gehirn arbeitest, und befolgst sie danach.
Diese Datei selbst ist Meta – kein Projektwissen.

## Grundprinzipien

- **Lazy by default.** Nichts beim Start laden. Wissen wird bei Bedarf geholt, gezielt, nie als Block.
- **Quelle der Wahrheit.** Für Projektwissen (Entscheidungen, Architektur, Learnings, Konventionen,
  Begriffe) ist das Gehirn maßgeblich. Bei Widerspruch zwischen Code und Notiz gewinnt der Code –
  und du aktualisierst die Notiz.
- **Atomar.** Eine Notiz = ein Konzept. Das hält Notizen klein, verlinkbar und konfliktarm im Team.
- **Belegt statt geraten.** Jede Aussage wird an konkrete Quellen verankert und als Beobachtung
  oder Ableitung gekennzeichnet (siehe Frontmatter `source` / `confidence`).

## Werkzeuge: wie du auf das Gehirn zugreifst

1. **Bevorzugt:** die `brain`-MCP-Tools (Suche im Volltext, Tag-basierte Suche, Lesen/Schreiben).
2. **Backlinks:** dieser MCP hat kein eigenes Backlink-Tool. Löse Rückverweise auf, indem du nach
   `[[Notiztitel]]` suchst. Ausgehende Links stehen im Notiz-Body und im Frontmatter-Feld `related`.
3. **Fallback** (MCP nicht verbunden / nicht bestätigt): Dateien unter `_brain/vault/` direkt lesen
   und mit Grep durchsuchen. Das Gehirn funktioniert auch ohne MCP, nur weniger komfortabel.
4. **Landkarte:** `index.md` ist eine generierte Übersicht (Map of Content) als Einstieg – nicht
   vorab laden, sondern nur konsultieren, wenn du orientierungslos bist.

## Wann LESEN

Konsultiere das Gehirn, bevor du:
- eine projektbezogene Frage des Menschen beantwortest,
- eine nicht-triviale Aufgabe beginnst (Feature, Refactor, Bugfix),
- mit einer dir unbekannten Komponente/Domäne arbeitest.

Vorgehen: zuerst per Tag/Suche die **relevanten** Notizen finden, nur diese lesen. Nicht den Vault
durchblättern.

## Wann SCHREIBEN

Lege eine Notiz an oder aktualisiere eine bestehende, wenn:
- eine **Architektur-/Technologie-Entscheidung** getroffen wurde → `decisions/`
- ein **nicht-offensichtliches Verhalten oder Constraint** entdeckt wurde → `learnings/`
- ein **Bug auf seine Ursache** zurückgeführt wurde → `learnings/`
- eine **Konvention** etabliert wurde (Naming, Struktur, Workflow) → `conventions/`
- ein **Zusammenhang/Abhängigkeit** zwischen Komponenten klar wurde → `architecture/`
- eine **Eigenheit einer externen Abhängigkeit** gelernt wurde → `learnings/`
- ein **Domänenbegriff** geklärt wurde → `glossary/`

**Nicht** schreiben bei: trivialen Edits, Dingen die direkt aus dem Code ersichtlich sind,
flüchtigem Zustand (TODO-Liste der aktuellen Aufgabe), Vermutungen ohne Beleg.

Nach dem Schreiben: passende Notizen über `related` / `[[Wikilinks]]` verknüpfen und `index.md`
aktualisieren (siehe unten).

## Frontmatter-Schema (für alle Notiztypen)

```yaml
---
title: <kurzer, prägnanter Titel>
type: decision        # decision | learning | architecture | convention | glossary
status: active        # active | deprecated | superseded
created: 2026-05-31
last-verified: 2026-05-31
tags: [decision, domain/auth]
source:               # konkrete Belege; leer lassen statt erfinden
  - src/auth/session.ts
  - "commit a1b2c3d"
confidence: fact      # fact = im Code/Verhalten beobachtet | inference = abgeleitet
related:
  - "[[token-rotation]]"
superseded-by: ""     # nur bei status: superseded → "[[neue-notiz]]"
---
```

## Tags (kleines, kontrolliertes Vokabular)

- Typ-Tag, identisch zu `type`: `decision`, `learning`, `architecture`, `convention`, `glossary`
- Bereichs-Tag: `domain/<bereich>`, z. B. `domain/auth`, `domain/billing`, `domain/ui`
- Sparsam halten. Keine Synonyme erfinden. Neue Bereiche nur, wenn es wiederkehrend gebraucht wird.

## Dateinamen

- `decisions/JJJJ-MM-TT-slug.md`  (z. B. `2026-05-31-postgres-statt-mongo.md`)
- `learnings/JJJJ-MM-TT-slug.md`
- `architecture/<komponente-oder-bereich>.md`  (z. B. `auth-flow.md`)
- `conventions/<thema>.md`  (z. B. `error-handling.md`)
- `glossary/<begriff>.md`  (z. B. `mandant.md`)

## Vorlagen pro Typ

### decisions/ (ADR-leicht)
```markdown
## Kontext
Warum stand die Entscheidung an? Welches Problem, welche Kräfte?

## Entscheidung
Was wurde entschieden (aktiv formuliert)?

## Konsequenzen
Was folgt daraus – positiv wie negativ? Was wird dadurch erschwert?

## Verworfene Alternativen
Was wurde nicht gewählt und warum (kurz).
```

### learnings/
```markdown
## Erkenntnis
Die nicht-offensichtliche Sache in 1–2 Sätzen.

## Auslöser / Kontext
Wobei tauchte es auf (Bug, Recherche, Experiment)?

## Konsequenz
Was heißt das konkret fürs künftige Coden/Design?
```

### architecture/
```markdown
## Zweck
Wofür ist diese Komponente / dieser Bereich da?

## Zusammenhänge
- Hängt ab von: [[...]]
- Wird genutzt von: [[...]]
- Kommuniziert mit: ... (wie? worüber?)

## Einstiegspunkte / wichtige Dateien
- `pfad/...`

## Nicht-offensichtliche Constraints
...
```

### conventions/
```markdown
## Regel
Was gilt?

## Begründung
Warum so?

## Beispiel
Kurz: gut vs. schlecht.
```

### glossary/
```markdown
**<Begriff>**: Definition in 1–3 Sätzen, in der Sprache des Projekts.

Siehe auch: [[...]]
```

## Verifikation & Vertrauen

- Belege jede sachliche Aussage in `source` mit Dateipfaden (und optional Commit-Ref).
- Trenne `confidence: fact` (beobachtet) von `inference` (abgeleitet). Im Zweifel `inference`.
- **Kopplung an Code-Änderungen:** Wenn du Code anfasst, den eine Notiz referenziert, prüfe die
  Notiz mit, aktualisiere sie und setze `last-verified` auf das heutige Datum.
- Der Mensch reviewt das Gehirn über den PR-Diff (der Vault liegt im Repo). Schreibe so, dass eine
  Änderung im Diff verständlich ist.

## Veraltung & Wartung

- `status`-Lebenszyklus: `active` → `deprecated` (überholt, aber lehrreich) → `superseded` (ersetzt).
- **Nicht löschen, ablösen.** Bei einer neuen Entscheidung, die eine alte ersetzt: alte Notiz auf
  `status: superseded` setzen, `superseded-by: "[[neue-notiz]]"` eintragen, neue Notiz verlinkt
  zurück über `related`. Historie ist Teil des Werts.
- **Brain-Audit** (auf Zuruf): durchlaufe Notizen, gleiche sie gegen den aktuellen Code ab,
  markiere veraltete und liste sie dem Menschen auf, statt still zu löschen.

## index.md (Map of Content)

- `index.md` ist **generiert**, nicht von Hand gepflegt – das vermeidet eine zentrale Konfliktdatei.
- Regeneriere sie aus dem Frontmatter aller Notizen: gruppiert nach `type`, je Eintrag Titel als
  `[[Wikilink]]` plus `status`-Hinweis bei nicht-`active`. Tu das, wenn du Notizen hinzufügst/änderst.

## Team / Konfliktvermeidung

- Atomare Notizen + datierte Dateinamen → zwei Personen treffen selten dieselbe Datei.
- Fremde Notizen nur ändern, wenn inhaltlich nötig (z. B. Ablösung), nicht aus Stilgründen.
- Keine Geheimnisse/Tokens ins Gehirn. Es wird mit dem Code eingecheckt.

## Initialisierung (Erststart)

Falls beim ersten Schreiben Unterordner oder `index.md` fehlen, lege sie an:
`decisions/`, `learnings/`, `architecture/`, `conventions/`, `glossary/` und eine leere `index.md`,
dann regeneriere `index.md` wie oben beschrieben.

=== ENDE DATEI ===

=== DATEI: _brain/vault/index.md ===
---
title: Gehirn – Index
type: meta
status: active
---

# Index (Map of Content)

Generierte Übersicht. Wird von Claude aus dem Frontmatter der Notizen aktualisiert
(siehe `_protocol.md` → "index.md"). Noch keine Notizen vorhanden.

## Decisions
## Learnings
## Architecture
## Conventions
## Glossary

=== ENDE DATEI ===

---

Lege außerdem an (leere Dateien): `_brain/vault/decisions/.gitkeep`, `_brain/vault/learnings/.gitkeep`, `_brain/vault/architecture/.gitkeep`, `_brain/vault/conventions/.gitkeep`, `_brain/vault/glossary/.gitkeep`.
