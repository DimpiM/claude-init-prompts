# Projekt

<!--
  Wartungsnotiz (wird nicht in Claudes Kontext geladen):
  Diese Datei bewusst klein halten (< ~200 Zeilen). Sie enthält NUR das Bootstrap
  für das Projekt-Gehirn – niemals Projektwissen selbst. Das Wissen lebt im Gehirn
  unter _brain/vault/ und wird ausschließlich bei Bedarf nachgeladen.
  Bewusst KEIN @-Import des Protokolls, da @-Importe beim Start in den Kontext geladen
  würden und damit das Lazy-Loading aushebeln.
-->

## Projekt-Gehirn (Brain)

Dieses Projekt besitzt ein persistentes Wissensgedächtnis ("Gehirn") unter `_brain/vault/`.
Es ist die Quelle der Wahrheit für **Entscheidungen, Architektur-Zusammenhänge, Learnings,
Konventionen und Domänenbegriffe**.

Das Gehirn ist für **dich (Claude)**, nicht für den Menschen. Aber wenn der Mensch eine Frage
stellt, die Projektwissen erfordert, **schau zuerst im Gehirn nach**, bevor du antwortest.

### Kontext nicht aufblähen
- Lade beim Start **nichts** aus dem Gehirn. Diese Datei importiert das Protokoll absichtlich nicht.
- Konsultiere das Gehirn erst, wenn du es brauchst – und hole dann **nur die relevanten Notizen**,
  nie den ganzen Vault.

### Ablauf
1. **Einmal pro Session**, sobald du das erste Mal mit dem Gehirn arbeitest (lesen *oder* schreiben):
   lies `_brain/vault/_protocol.md` und befolge es für den Rest der Session.
2. **Lesen** – bevor du eine projektbezogene Frage beantwortest oder eine nicht-triviale Aufgabe
   beginnst: durchsuche das Gehirn. Bevorzugt über die `brain`-MCP-Tools (Suche, Tags).
   Fallback, falls der MCP nicht verbunden ist: Dateien unter `_brain/vault/` direkt lesen/greppen.
3. **Schreiben** – halte neue Entscheidungen, Learnings, Architektur-Erkenntnisse, Konventionen
   und Begriffe nach den Regeln in `_protocol.md` fest.

### Setup-Hinweis (einmalig pro Maschine)
Der `brain`-MCP-Server ist projekt-skopiert in `.mcp.json` definiert. Beim ersten Start fragt
Claude Code einmal nach Bestätigung ("trust") – danach läuft er automatisch. Voraussetzung:
Node.js (>= 20) ist im Pfad verfügbar.
