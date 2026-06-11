-- ==========================================================================
-- 1. BASE16 PALETTE INITIALIZATION
-- ==========================================================================
require('base16-colorscheme').setup({
    base00 = "{{colors.background.default.hex}}",
    base01 = "{{colors.surface_container_lowest.default.hex}}",
    base02 = "{{colors.surface_container_low.default.hex}}",
    base03 = "{{colors.outline_variant.default.hex}}",
    base04 = "{{colors.on_surface_variant.default.hex}}",
    base05 = "{{colors.on_surface.default.hex}}",
    base06 = "{{colors.inverse_on_surface.default.hex}}",
    base07 = "{{colors.surface_bright.default.hex}}",

    base08 = "{{colors.tertiary.default.hex | lighten: -5}}",
    base09 = "{{colors.tertiary.default.hex}}",
    base0A = "{{colors.secondary.default.hex}}",
    base0B = "{{colors.primary.default.hex}}",
    base0C = "{{colors.tertiary_container.default.hex}}",
    base0D = "{{colors.primary_container.default.hex}}",
    base0E = "{{colors.secondary_container.default.hex}}",
    base0F = "{{colors.secondary.default.hex | lighten: -10}}",
})

-- ==========================================================================
-- 2. TRANSPARENCY CONFIGURATION
-- ==========================================================================
-- We loop through the main UI groups and strip their backgrounds
local transparent_groups = {
    'Normal',       -- Main editor window background
    'NormalNC',     -- Non-current (inactive) windows
    'SignColumn',   -- Column where gitsigns/errors appear
    'FoldColumn',   -- Column for code folding
    'LineNr',       -- Line numbers
    'CursorLineNr', -- Current line number
    'EndOfBuffer',  -- The '~' tildes at the bottom of empty files
    'MsgArea',      -- Lower command/message area
}

for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = 'NONE', ctermbg = 'NONE' })
end

-- ==========================================================================
-- 3. SYNTAX CONTRAST FIXES
-- ==========================================================================
local function set_hl_multiple(groups, value)
    for _, v in pairs(groups) do
        vim.api.nvim_set_hl(0, v, value)
    end
end

-- Visual selection (Kept dark rust so highlighted text is readable)
vim.api.nvim_set_hl(0, 'Visual', {
    bg = '{{colors.primary_container.default.hex}}',
    fg = '{{colors.on_primary_container.default.hex}}',
})

-- Strings (Boosted brightness slightly)
set_hl_multiple({ 'String', 'TSString' }, {
    fg = '{{colors.tertiary.default.hex | lighten: 10.0 }}',
})

-- Comments (Using on_surface_variant instead of outline for better legibility)
set_hl_multiple({ 'TSComment', 'Comment' }, {
    fg = '{{colors.on_surface_variant.default.hex}}',
    italic = true,
})

-- Methods & Functions
set_hl_multiple({ 'TSMethod', 'Method' }, { fg = '{{colors.tertiary.default.hex}}' })
set_hl_multiple({ 'TSFunction', 'Function' }, { fg = '{{colors.secondary.default.hex}}' })

-- KEYWORD FIX: Swapped from inverse_primary to primary + lighten
-- This gives keywords a vivid, high-contrast pop against dark terminals
set_hl_multiple({ 'Keyword', 'TSKeyword', 'TSKeywordFunction', 'TSRepeat' }, {
    fg = '{{colors.primary.default.hex | lighten: 15.0 }}',
    bold = true, -- Added bold to make control flow stand out
})
