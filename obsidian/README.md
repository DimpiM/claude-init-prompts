# Projekt-Gehirn für Claude Code

Ein persistentes Wissensgedächtnis ("Gehirn") für Claude Code, das **im Repo** liegt und über
Git mit dem Team geteilt wird. Es ersetzt das lokale Memory: Entscheidungen, Architektur-
Zusammenhänge, Learnings, Konventionen und Domänenbegriffe werden in einem Obsidian-kompatiblen
Vault unter `_brain/vault/` dokumentiert. Wer das Repo klont, hat automatisch den aktuellen Stand.

## Was der Setup-Prompt macht

Die Datei `brain-setup-prompt.md` ist ein **einmaliger** Prompt für Claude Code. Eingefügt in
Claude Code legt er das komplette Gerüst an:

- `CLAUDE.md` (Repo-Root) – schlanker Einstieg, der Claude Code anweist, das Gehirn bei Bedarf zu
  nutzen. Lädt das Wissen bewusst **nicht** beim Start, damit der Kontext klein bleibt.
- `.mcp.json` (Repo-Root) – projekt-skopierter MCP-Server `brain` für Suche und Tags im Vault
  (dateisystem-nativ, kein laufendes Obsidian nötig). Der Vault-Pfad ist maschinenunabhängig.
- `_brain/vault/_protocol.md` – die Betriebsregeln: wann gelesen/geschrieben wird, Notiztypen,
  Frontmatter-Schema, Tags, Verifikation, Veraltung, Konfliktvermeidung im Team.
- `_brain/vault/index.md` – generierte Übersicht (Map of Content).
- `_brain/vault/{decisions,learnings,architecture,conventions,glossary}/` – die Ablageordner.

Der Prompt trägt die exakten Dateiinhalte in sich und weist Claude Code an, sie wortwörtlich zu
schreiben – das Ergebnis ist also deterministisch.

## Verwendung

1. **Einmalig:** Inhalt von `brain-setup-prompt.md` kopieren und in Claude Code einfügen.
   Claude Code erzeugt alle Dateien und Ordner.
2. Auf GitHub committen und pushen.
3. **Ab dann:** einfach sagen, was du möchtest ("ich möchte xy"). Claude Code schaut bei
   Projektwissen von selbst ins Gehirn und dokumentiert Neues nach dem Protokoll mit – ohne dass
   du das Gehirn erwähnen musst.

## Einmalige Schritte pro Maschine

- **Node.js >= 20** muss im Pfad verfügbar sein (für den npx-basierten MCP-Server).
- Beim ersten Start fragt Claude Code **einmal** nach Bestätigung für den `brain`-MCP
  (Trust-Dialog). Nach dem Anlegen der `.mcp.json` ist ein **Neustart** von Claude Code nötig,
  damit der Server geladen wird.

## Gut zu wissen

- **Kein Geheimnis** (Tokens, Passwörter) ins Gehirn schreiben – es wird mit dem Code eingecheckt.
- Das Gehirn ist für Claude gedacht, nicht zur Pflege durch Menschen. Reviewt wird es bequem über
  den PR-Diff, da es im Repo liegt.
- Fällt der MCP aus, funktioniert das Gehirn weiterhin: das Protokoll hat einen Datei-Fallback,
  bei dem Claude Code direkt in `_brain/vault/` liest und sucht.
