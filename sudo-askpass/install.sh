#!/usr/bin/env bash
# Installiert claude-askpass und trägt SUDO_ASKPASS in ~/.claude/settings.json ein.
#
# Lokal:  ./install.sh
# Remote: curl -fsSL https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/sudo-askpass/install.sh | bash
#
# Mehrfach ausführen ist unschädlich.
set -euo pipefail

RAW_URL="https://raw.githubusercontent.com/DimpiM/claude-init-prompts/main/sudo-askpass/claude-askpass"
TARGET="${CLAUDE_ASKPASS_TARGET:-$HOME/.local/bin/claude-askpass}"
SETTINGS="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json"

# 1) Skript ablegen: aus dem Repo-Ordner, wenn vorhanden, sonst herunterladen.
src_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
mkdir -p "$(dirname "$TARGET")"
if [ -n "$src_dir" ] && [ -f "$src_dir/claude-askpass" ]; then
    install -m 755 "$src_dir/claude-askpass" "$TARGET"
else
    tmp=$(mktemp)
    curl -fsSL -o "$tmp" "$RAW_URL"
    install -m 755 "$tmp" "$TARGET"
    rm -f "$tmp"
fi
echo "Skript installiert: $TARGET"

# 2) Dialog-Tool prüfen (nur Warnung).
if ! command -v yad >/dev/null && ! command -v zenity >/dev/null \
   && ! command -v kdialog >/dev/null && ! command -v ksshaskpass >/dev/null \
   && [ ! -x /usr/lib/ssh/ssh-askpass ]; then
    echo "WARNUNG: kein Dialog-Tool gefunden. Installiere eins, z. B. 'sudo pacman -S zenity'." >&2
fi

# 3) SUDO_ASKPASS in settings.json eintragen (vorhandene Einträge bleiben erhalten).
mkdir -p "$(dirname "$SETTINGS")"
[ -s "$SETTINGS" ] || echo '{}' > "$SETTINGS"

current=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("env",{}).get("SUDO_ASKPASS",""))' "$SETTINGS")
if [ "$current" = "$TARGET" ]; then
    echo "settings.json: SUDO_ASKPASS ist schon gesetzt."
elif [ -n "$current" ] && [ "${FORCE:-0}" != "1" ]; then
    echo "settings.json: SUDO_ASKPASS zeigt schon auf '$current'. Nichts geändert." >&2
    echo "Zum Überschreiben: FORCE=1 $0" >&2
    exit 1
else
    cp "$SETTINGS" "$SETTINGS.bak"
    python3 - "$SETTINGS" "$TARGET" <<'EOF'
import json, sys
path, target = sys.argv[1], sys.argv[2]
with open(path) as f:
    data = json.load(f)
data.setdefault("env", {})["SUDO_ASKPASS"] = target
with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
EOF
    echo "settings.json: SUDO_ASKPASS gesetzt (Backup: $SETTINGS.bak)."
fi

echo "Fertig. Claude Code neu starten, damit die Einstellung greift."
