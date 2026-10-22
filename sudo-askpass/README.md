# sudo-askpass – sudo-Passwort per Fenster

Modul für [claude-init-prompts](../). Claude Code hat kein Terminal, in das du ein Passwort
tippen könntest. Deshalb scheitert dort jeder `sudo`-Befehl. Dieses Modul sorgt dafür, dass
stattdessen ein **kleines Fenster** aufgeht, in das du dein Passwort eingibst.

**Kein Skill, kein Plugin, kein MCP.** Es nutzt eine eingebaute Funktion von `sudo`: Ist
`SUDO_ASKPASS` gesetzt und gibt es kein Terminal, fragt `sudo` das Passwort über das dort genannte
Programm ab. Das Passwort geht direkt vom Fenster an `sudo`. Claude sieht es nie.

Das Fenster zeigt auch den Befehl, den Claude mit `sudo` ausführen will. Mit „Abbrechen" lehnst du ab.

## Was installiert wird

| Was | Wo | Zweck |
| --- | --- | --- |
| [`claude-askpass`](./claude-askpass) | `~/.local/bin/claude-askpass` | Zeigt das Passwortfenster. Nimmt das erste vorhandene Tool: `yad`, `zenity`, `kdialog`, `ksshaskpass`, `ssh-askpass`. |
| `env.SUDO_ASKPASS` | `~/.claude/settings.json` | Sagt `sudo` in jeder Claude-Code-Sitzung, welches Programm es nutzen soll. Andere Einstellungen bleiben unberührt. |

Die Variable gilt **nur in Claude Code**, nicht in deinem normalen Terminal. Dort fragt `sudo`
wie gewohnt im Terminal.

## Voraussetzungen

- Linux mit grafischer Sitzung (X11 oder Wayland mit XWayland, `DISPLAY` muss gesetzt sein).
- Eines der Dialog-Tools oben. Unter Arch z. B. `sudo pacman -S zenity` oder `yad`.
- `python3` (nur für `install.sh`, zum Bearbeiten der `settings.json`).

## Installieren

**Per Setup-Prompt** in einer beliebigen Claude-Code-Session:

> Hol dir diese `setup.md` und führe ihre Anweisungen aus:
> https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/sudo-askpass/setup.md

**Per Skript** (ohne Claude):

```bash
# aus einem Klon dieses Repos
./sudo-askpass/install.sh

# oder direkt
curl -fsSL https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/sudo-askpass/install.sh | bash
```

`install.sh` legt vor jeder Änderung ein Backup `settings.json.bak` an und kann gefahrlos mehrfach
laufen. Zeigt `SUDO_ASKPASS` schon auf ein anderes Programm, bricht es ab (überschreiben mit
`FORCE=1`).

Danach **Claude Code neu starten**.

## Testen

```bash
SUDO_ASKPASS=$HOME/.local/bin/claude-askpass sudo -k
SUDO_ASKPASS=$HOME/.local/bin/claude-askpass sudo whoami   # Fenster geht auf, Ausgabe: root
```

## Entfernen

```bash
rm ~/.local/bin/claude-askpass
```

Dann in `~/.claude/settings.json` den Eintrag `SUDO_ASKPASS` unter `env` löschen.

## Hinweise

- `sudo` merkt sich dein Passwort eine Weile (Standard: 5 Minuten). In der Zeit kommt kein Fenster.
- Das Fenster gibt Claude keine Sonderrechte. Du entscheidest bei jeder Abfrage selbst.
- Ändert sich `claude-askpass`, den eingebetteten Block in der `setup.md` mit ändern (beide Kopien
  identisch halten).
