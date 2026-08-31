-- Hardware catalogue: one entry per display I own, giving only the things that
-- are properties of the panel itself (resolution, refresh rate).
--
-- Where a display sits, how far it is zoomed and how it is rotated all live in
-- `monitor_layout.lua`, which `monitorctl` rewrites. Nothing in this file is
-- script-managed, so it stays hand-editable.
--
-- Note the AOC is the display that hangs off HDMI-A-1. It is matched by `desc:`
-- rather than by connector so that plugging the projector into the same port
-- does not inherit the AOC's settings.

local layout = require("mainconf.monitor_layout")

local monitors = {
    { output = "eDP-1",                                width = 1920, height = 1080, hz = 144 },
    { output = "desc:AOC 2475W MDMHAJA004705",         width = 1920, height = 1080, hz = 60 },
    { output = "desc:Synaptics Inc Non-PnP 0x00BC614", width = 1920, height = 1080, hz = 60 },
    -- desc:Ancor Communications Inc ASUS VS247 F8LMTF10236
}

local auto_position = {
    left  = "auto-left",
    right = "auto-right",
    up    = "auto-up",
    down  = "auto-down",
}

-- Build the set of outputs to emit a rule for: everything in the catalogue,
-- plus anything the layout file knows about that the catalogue does not. That
-- lets monitorctl register a newly seen display without editing this file.
local outputs, seen = {}, {}
local function add_output(output, mode)
    if output == nil or seen[output] then return end
    seen[output] = true
    table.insert(outputs, { output = output, mode = mode or "preferred" })
end

for _, m in ipairs(monitors) do
    add_output(m.output, m.width .. "x" .. m.height .. "@" .. m.hz)
end
add_output(layout.anchor)
for output in pairs(layout.side) do add_output(output) end
for output in pairs(layout.zoom) do add_output(output) end

for _, m in ipairs(outputs) do
    -- The anchor is pinned at the origin; Hyprland then resolves `auto-*` for
    -- everything else against whatever is actually connected. That keeps the
    -- layout gap-free no matter which subset of these displays is plugged in.
    local position = "0x0"
    if m.output ~= layout.anchor then
        position = auto_position[layout.side[m.output]] or "auto-right"
    end

    hl.monitor({
        output    = m.output,
        mode      = m.mode,
        position  = position,
        scale     = layout.zoom[m.output] or 1,
        transform = layout.transform[m.output] or 0,
    })
end

-- Fallback for any other monitor plugged in
hl.monitor({
    output = "",             -- Leaving this blank acts as the wildcard (*) fallback
    mode = "preferred",      -- Queries the projector for its preferred resolution
    position = "auto-right", -- Automatically places it to the right
    scale = 1
})

-- Force Laptop (eDP-1) to be Group 0 (Workspaces 1-10)
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
for i = 2, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end

-- Force HDMI to be Group 1 (Workspaces 11-20)
hl.workspace_rule({ workspace = "11", monitor = "HDMI-A-1", default = true })
for i = 12, 20 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end
