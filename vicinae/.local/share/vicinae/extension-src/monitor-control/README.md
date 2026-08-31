# Monitor Control

A Vicinae extension for rearranging Hyprland displays: which side of the laptop
an external monitor sits on, how far each one is zoomed, and how it is rotated.

It is a front-end only. Every change goes through `~/.config/hypr/scripts/monitorctl`,
which writes `~/.config/hypr/mainconf/monitor_layout.lua` and applies the result to
the running compositor, so changes made here and changes made from a shell cannot
disagree, and both survive a reload.

## Commands

- **Monitor Layout** — a list of the connected displays, with actions to move,
  zoom and rotate each one.
- **Swap Monitor Sides** — flips the single external display to the other side,
  with no UI. Worth binding to a key.

## Install

    ./install.sh

Then restart the launcher (`vicinae server`) so the new commands are indexed.

Rebuild with the same script after editing `src/`.
