-- ==========================================================================
-- 1. BASE16 PALETTE INITIALIZATION
-- ==========================================================================
require('base16-colorscheme').setup({
    base00 = "#1a1111",
    base01 = "#140c0c",
    base02 = "#231919",
    base03 = "#534342",
    base04 = "#d8c2c0",
    base05 = "#f1dedd",
    base06 = "#382e2d",
    base07 = "#423736",

    base08 = "#ddb778",
    base09 = "#e2c28c",
    base0A = "#e7bdba",
    base0B = "#ffb3af",
    base0C = "#594319",
    base0D = "#733331",
    base0E = "#5d3f3d",
    base0F = "#da9994",
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
    bg = '#733331',
    fg = '#ffdad7',
})

-- Strings (Boosted brightness slightly)
set_hl_multiple({ 'String', 'TSString' }, {
    fg = '#ecd8b5',
})

-- Comments (Using on_surface_variant instead of outline for better legibility)
set_hl_multiple({ 'TSComment', 'Comment' }, {
    fg = '#d8c2c0',
    italic = true,
})

-- Methods & Functions
set_hl_multiple({ 'TSMethod', 'Method' }, { fg = '#e2c28c' })
set_hl_multiple({ 'TSFunction', 'Function' }, { fg = '#e7bdba' })

-- KEYWORD FIX: Swapped from inverse_primary to primary + lighten
-- This gives keywords a vivid, high-contrast pop against dark terminals
set_hl_multiple({ 'Keyword', 'TSKeyword', 'TSKeywordFunction', 'TSRepeat' }, {
    fg = '#fffcfc',
    bold = true, -- Added bold to make control flow stand out
})
