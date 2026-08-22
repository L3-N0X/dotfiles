local monitors = {
    {
        output = "desc:AOC 2475W MDMHAJA004705",
        width = 1920,
        height = 1080,
        hz = 60,
        -- transform = 1,
    },
    { output = "eDP-1",                                width = 1920, height = 1080, hz = 144, scale = 1.25 },
    { output = "HDMI-A-1",                             width = 1920, height = 1080, hz = 60,  scale = 1 },
    { output = "desc:Synaptics Inc Non-PnP 0x00BC614", width = 1920, height = 1080, hz = 60,  scale = 1.5 },
    -- desc:Ancor Communications Inc ASUS VS247 F8LMTF10236
}

local offset_x = 0

for _, m in ipairs(monitors) do
    local transform = m.transform or 0
    local layout_scale = m.scale or 1 -- Lua-only fallback; not sent to Hyprland

    local rule = {
        output = m.output,
        mode = m.width .. "x" .. m.height .. "@" .. m.hz,
        position = math.floor(offset_x) .. "x0",
        transform = transform,
    }

    -- Add `scale` only when the monitor defines one.
    if m.scale ~= nil then
        rule.scale = m.scale
    end

    hl.monitor(rule)

    local rotated = transform == 1 or transform == 3
    local logical_width = (rotated and m.height or m.width) / layout_scale
    offset_x = offset_x + logical_width
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
