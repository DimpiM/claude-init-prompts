<!--
  Für Repo-Pfleger: Die Modulliste unten (Abschnitt B) ist die EINZIGE Stelle, die beim Hinzufügen
  eines neuen Moduls ergänzt werden muss. Neues Modul → dort in die passende Gruppe eintragen
  (Ordnername + eine Zeile Beschreibung). Mehr als 4 Module in einer Gruppe → die Gruppe gleichmäßig
  auf mehrere Fragen aufteilen (AskUserQuestion verlangt 2 bis 4 Optionen pro Frage, also z. B.
  3 + 2, nie 4 + 1).
-->

# Setup: Module auswählen und installieren

Du bietest dem Menschen die Module aus diesem Repo zur Auswahl an und richtest **nur die
angehakten** ein. Jedes Modul hat eine eigene `setup.md`; die holst du und führst sie aus.

> Hinweis: Führe dieses Setup **nicht** im Plan-Modus aus – dort werden keine Dateien geschrieben.

## A) Auswahl anbieten

Frag den Menschen mit dem Werkzeug **AskUserQuestion**, und zwar mit `multiSelect: true`
(Ankreuz-Liste). Stelle die Fragen aus Abschnitt B in **einem** Aufruf. Jede Option bekommt den
Modulnamen als Label und die eine Zeile Beschreibung aus der Liste.

- Das Werkzeug verlangt **2 bis 4 Optionen pro Frage** und erlaubt höchstens **4 Fragen pro
  Aufruf**. Hat eine Gruppe mehr als 4 Module, teile sie **gleichmäßig** auf mehrere Fragen auf
  (z. B. 3 + 2, nie 4 + 1; Titel z. B. „Module für dieses Projekt (2)").
- Ist AskUserQuestion nicht verfügbar: gib die Module als **nummerierte Liste** aus (gruppiert wie
  unten), bitte um die Nummern der gewünschten Module und **warte auf die Antwort**.

## B) Modulliste

Basis-URL jeder Modul-`setup.md`:
`https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/<modul>/setup.md`

**Frage 1 – „Module für dieses Projekt"**, header `Projekt` (landen im Repo des Zielprojekts):
- `obsidian` – Projekt-Gehirn unter `_brain/vault/`: Entscheidungen, Architektur, Learnings bleiben im Repo.
- `context7` – Doku-Cache unter `_brain/code-docs/`: Library-Doku passend zur installierten Version.
- `workspace` – Ablage unter `_brain/workspace/` für Hilfsskripte, Analysen und Wegwerf-Dateien.
- `clean-code` – Clean-Code-Regeln unter `.claude/rules/` plus Prüf-Skill `clean-code-check`.

**Frage 2 – „Globale Module für diesen Rechner"**, header `Global` (gelten für alle Projekte):
- `output-styles` – Antwortstile für Claude Code, z. B. `short-explain` (kurz, einfach, Deutsch).
- `sudo-askpass` – `sudo` öffnet in Claude Code ein Passwortfenster statt zu scheitern (nur Linux).

## C) Ausgewählte Module installieren

1. **Nichts angehakt:** nichts tun und dem Menschen genau das sagen. Hier aufhören.
   - Freitext („Other") nur als **Modulnamen** deuten; unbekannte Namen nachfragen.
   - Frage ohne Antwort abgelaufen oder geschlossen: **nichts installieren** und neu fragen.
2. Für jedes angehakte Modul, **eines nach dem anderen** in der Reihenfolge der Liste:
   - die `setup.md` über die Raw-URL holen (Basis-URL oben, `<modul>` = Ordnername),
   - ihre Anweisungen **vollständig ausführen** (nicht nur lesen),
   - Rückfragen, die das Modul-Setup selbst vorsieht (z. B. global oder Projekt bei
     `output-styles`, unklarer Projekttyp bei `clean-code`), stellst du wie dort beschrieben.
3. **Nichts installieren, was nicht angehakt wurde** – auch nicht „passend dazu".
4. Schlägt ein Modul fehl (z. B. URL nicht erreichbar, Voraussetzung fehlt): melde es kurz und
   mach mit dem nächsten Modul weiter.

Die einzelnen Abschlussausgaben der Module (Verzeichnisbäume, Hinweise) musst du nicht jeweils
voll wiederholen – sammle sie für Abschnitt D.

## D) Abschluss

Gib dem Menschen eine kurze Übersicht:

1. **Eingerichtet:** welche Module installiert wurden (und welche fehlgeschlagen sind, mit Grund).
2. **Gesammelte Hinweise** aus den Modul-Setups, ohne Doppelungen, z. B.:
   - **Claude Code einmal neu starten** (nötig bei `.mcp.json`, Output-Styles, `SUDO_ASKPASS`).
   - Neue MCP-Server beim nächsten Start per **Trust-Dialog** bestätigen; Node.js >= 20 muss im Pfad sein.
   - Projektmodule im Zielprojekt **committen und pushen**, damit das Team denselben Stand hat.
   - Modulspezifisches (z. B. `CONTEXT7_API_KEY`, Workspace-`.gitignore`, wie man einen Style einschaltet).
