local monitors = {
    { output = "eDP-1",    width = 1920, height = 1080, hz = 144, scale = 1.25 },
    { output = "HDMI-A-1", width = 1920, height = 1080, hz = 60,  scale = 1 },
    -- desc:AOC 2475W MDMHAJA004705
    -- desc:Ancor Communications Inc ASUS VS247 F8LMTF10236
}

local offset_x = 0

for _, m in ipairs(monitors) do
    hl.monitor({
        output   = m.output,
        mode     = m.width .. "x" .. m.height .. "@" .. m.hz,
        position = math.floor(offset_x) .. "x0",
        scale    = m.scale,
    })
    offset_x = offset_x + (m.width / m.scale) -- logical width
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
