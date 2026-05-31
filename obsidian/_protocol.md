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

## Vault-Konfiguration (.obsidian)

Der `brain`-MCP akzeptiert das Verzeichnis nur als Vault, wenn darin ein `.obsidian`-Ordner mit
minimaler Konfiguration liegt (`app.json`, `appearance.json`, `core-plugins.json`, jeweils `{}`).
Dieser Ordner wird beim Setup angelegt und **mit eingecheckt** – nicht löschen, nicht in
`.gitignore` aufnehmen. Ein laufendes Obsidian ist dafür nicht nötig.
