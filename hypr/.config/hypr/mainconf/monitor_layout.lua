-- Position, zoom and rotation for every display, kept apart from the hardware
-- catalogue in `monitors.lua` so it can be rewritten by a script.
--
-- Managed by `~/.config/hypr/scripts/monitorctl` and the Vicinae "Monitor
-- Control" extension. Hand edits are fine -- monitorctl re-reads this file
-- before every write, so nothing here is clobbered.
--
-- Keys are Hyprland output selectors: either a connector name ("eDP-1") or a
-- `desc:` match. Prefer `desc:` for anything external -- it survives being
-- plugged into a different port.

return {
    -- The display everything else is placed around. It always sits at 0x0.
    anchor = "eDP-1",

    -- Where each display sits relative to the anchor.
    -- One of "left", "right", "up", "down".
    side = {
        ["desc:AOC 2475W MDMHAJA004705"]         = "left",
        ["desc:Synaptics Inc Non-PnP 0x00BC614"] = "right",
    },

    -- Zoom, i.e. Hyprland's `scale`. Higher means a bigger, less dense UI.
    -- Must divide the resolution into whole pixels: 1920 / 1.25 = 1536 is fine,
    -- 1920 / 1.3 is not. `monitorctl zoom` snaps to the nearest valid value.
    zoom = {
        ["desc:AOC 2475W MDMHAJA004705"]         = 1,
        ["desc:Synaptics Inc Non-PnP 0x00BC614"] = 1.5,
        ["eDP-1"]                                = 1,
    },

    -- Rotation: 0 = normal, 1 = 90deg, 2 = 180deg, 3 = 270deg.
    transform = {
        ["desc:AOC 2475W MDMHAJA004705"] = 0,
    },
}
