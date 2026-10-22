# Setup: sudo-Passwort per Fenster (SUDO_ASKPASS)

Du richtest ein, dass `sudo` in Claude Code ein **grafisches Passwortfenster** öffnet. Claude Code
hat kein Terminal, in das man ein Passwort tippen könnte. Ohne dieses Modul scheitert jeder
`sudo`-Befehl mit „a terminal is required to read the password".

So funktioniert es: Ist die Umgebungsvariable `SUDO_ASKPASS` gesetzt und gibt es kein Terminal,
ruft `sudo` dieses Programm auf und liest das Passwort von dessen Ausgabe. Das Passwort geht direkt
vom Fenster an `sudo`. Claude sieht es nicht.

Dieses Modul ist **global** (gilt für alle Projekte), braucht **keinen MCP-Server** und berührt
**weder `CLAUDE.md` noch `.mcp.json`**. Es schreibt nur zwei Dinge:

1. das Skript `~/.local/bin/claude-askpass`,
2. den Eintrag `env.SUDO_ASKPASS` in `~/.claude/settings.json`.

> Hinweis: Führe das Setup **nicht** im Plan-Modus aus – dort werden keine Dateien geschrieben.

## A) Voraussetzungen prüfen

- Nur Linux mit grafischer Sitzung (`DISPLAY` muss gesetzt sein; unter Wayland setzt XWayland es).
- Eines dieser Dialog-Tools muss installiert sein: `yad`, `zenity`, `kdialog`, `ksshaskpass`
  oder `/usr/lib/ssh/ssh-askpass`. Fehlt alles, schlag dem Menschen vor, eins zu installieren
  (z. B. `zenity`). Installiere es **nicht** selbst, denn dafür bräuchtest du ja schon `sudo`.

## B) Skript anlegen

Lege `~/.local/bin/claude-askpass` an – **exakt** mit dem Inhalt zwischen
`=== DATEI: claude-askpass ===` und `=== ENDE DATEI ===`, nicht umformulieren, nicht kürzen.
Danach `chmod 755 ~/.local/bin/claude-askpass`.

Existiert die Datei bereits mit identischem Inhalt: unverändert lassen. Weicht der Inhalt ab:
nicht überschreiben, sondern den Menschen fragen.

## C) settings.json zusammenführen

In `~/.claude/settings.json` (bzw. `$CLAUDE_CONFIG_DIR/settings.json`) unter `env` den Eintrag
`"SUDO_ASKPASS": "<absoluter Pfad zu ~/.local/bin/claude-askpass>"` setzen. Die Tilde muss
ausgeschrieben sein (z. B. `/home/<user>/.local/bin/claude-askpass`).

- **Zusammenführen, nicht überschreiben.** Alle anderen Schlüssel und alle anderen `env`-Einträge
  bleiben, wie sie sind.
- Vorher ein Backup nach `settings.json.bak` legen.
- Zeigt `SUDO_ASKPASS` schon auf etwas anderes: nicht ändern, den Menschen fragen.

## D) Test

Führe aus (mit `SUDO_ASKPASS` direkt gesetzt, weil die Einstellung erst nach einem Neustart greift):

```bash
SUDO_ASKPASS=$HOME/.local/bin/claude-askpass sudo -k; SUDO_ASKPASS=$HOME/.local/bin/claude-askpass sudo whoami
```

Sag dem Menschen **vorher**, dass gleich ein Passwortfenster aufgeht. Erwartete Ausgabe: `root`.
Klickt er auf „Abbrechen", schlägt der Befehl fehl. Das ist auch in Ordnung.

## E) Abschluss

1. Nenne die geänderten Dateien mit vollem Pfad.
2. Sag dem Menschen, dass er Claude Code **einmal neu starten** muss, damit `SUDO_ASKPASS` greift.
3. Weise darauf hin: Hat `sudo` das Passwort vor Kurzem schon bekommen, erscheint eine Weile
   (Standard: 5 Minuten) kein Fenster.

---

=== DATEI: claude-askpass ===
#!/usr/bin/env bash
# Grafische Passwortabfrage für sudo (SUDO_ASKPASS).
#
# sudo ruft dieses Skript auf, wenn kein Terminal vorhanden ist (so wie bei
# Claude Code) und SUDO_ASKPASS darauf zeigt. Das Passwort geht über stdout
# direkt an sudo. Abbrechen -> Exit-Code != 0 -> sudo bricht ab.
#
# Nutzt das erste vorhandene Dialog-Tool: yad, zenity, kdialog, ksshaskpass,
# ssh-askpass.

prompt="${1:-Passwort für sudo:}"
title="sudo – Claude Code"

# Der Elternprozess ist sudo selbst; seine Argumente zeigen den Befehl.
cmd=$(ps -o args= -p "$PPID" 2>/dev/null)
text_plain="Claude Code möchte mit sudo ausführen:
${cmd}

${prompt}"

# Für yad/zenity (Pango-Markup) Sonderzeichen maskieren.
esc=${cmd//&/&amp;}; esc=${esc//</&lt;}; esc=${esc//>/&gt;}
text_markup="<b>Claude Code möchte mit sudo ausführen:</b>\n<tt>${esc}</tt>\n\n${prompt}"

if command -v yad >/dev/null; then
    exec yad --entry --hide-text --title="$title" \
        --window-icon=dialog-password --image=dialog-password \
        --text="$text_markup" \
        --button="Abbrechen:1" --button="OK:0" \
        --center --on-top --fixed --width=450
elif command -v zenity >/dev/null; then
    exec zenity --password --title="$title" 2>/dev/null
elif command -v kdialog >/dev/null; then
    exec kdialog --title "$title" --password "$text_plain"
elif command -v ksshaskpass >/dev/null; then
    exec ksshaskpass "$text_plain"
elif [ -x /usr/lib/ssh/ssh-askpass ]; then
    exec /usr/lib/ssh/ssh-askpass "$text_plain"
fi

echo "claude-askpass: kein Dialog-Tool gefunden (yad, zenity, kdialog, ksshaskpass)." >&2
exit 1
=== ENDE DATEI ===
