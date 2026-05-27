local monitors = {
    { output = "eDP-1",                        width = 1920, height = 1080, hz = 144, scale = 1.25 },
    { output = "desc:AOC 2475W MDMHAJA004705", width = 1920, height = 1080, hz = 60,  scale = 1 },
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
