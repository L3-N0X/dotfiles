#!/usr/bin/env bash
# Regenerate the matugen colorscheme from the *current* wallpaper without
# changing it. Bound to CTRL+SUPER+SHIFT+R in custom/keybinds.lua.

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
qsConfig="${qsConfig:-ii}"
SWITCHWALL="$XDG_CONFIG_HOME/quickshell/$qsConfig/scripts/colors/switchwall.sh"
LOG="$XDG_STATE_HOME/quickshell/user/generated/reload-colors.log"

notify() { notify-send -a "Colorscheme" -h string:x-canonical-private-synchronous:matugen-reload "$@"; }

if [[ ! -x "$SWITCHWALL" ]]; then
    notify -c "im.error" "Reload failed" "switchwall.sh not found at $SWITCHWALL"
    exit 1
fi

notify "Reloading colors" "Regenerating palette from current wallpaper…"

# --noswitch reuses background.wallpaperPath from the shell config, so the
# wallpaper stays put and only the palette is rebuilt.
#
# switchwall.sh's exit code is not a usable success signal: its last statement
# restarts xdg-desktop-portal-kde, which isn't installed here, so it returns 1
# even on a fully successful run. What actually matters is whether matugen
# aborted partway - that's the failure that leaves the theme half-applied.
# Benign post_hook failures (tmux/cava/nvim not running) print "Failed executing
# command" and are deliberately not treated as errors.
mkdir -p "$(dirname "$LOG")"
"$SWITCHWALL" --noswitch >"$LOG" 2>&1

# "Error:" on its own line is matugen's abort marker; the useful detail is on the
# next line ("0: Permission denied (os error 13)").
clean=$(tr -d '\0' < "$LOG" | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g')
if grep -qaE '^Error:' <<<"$clean"; then
    detail=$(grep -aA3 '^Error:' <<<"$clean" | grep -m1 -oE '[0-9]+: .+')
    notify -c "im.error" "Colorscheme reload failed" "${detail:-matugen aborted} — see $LOG"
    exit 1
fi

notify "Colors reloaded" "matugen palette reapplied."
