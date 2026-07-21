-- ==========================================================================
-- 1. BASE16 PALETTE INITIALIZATION
-- ==========================================================================
require('base16-colorscheme').setup({
    base00 = "#11140f",
    base01 = "#0b0f0a",
    base02 = "#191d17",
    base03 = "#43483f",
    base04 = "#c3c8bc",
    base05 = "#e1e4da",
    base06 = "#2e322b",
    base07 = "#363a34",

    base08 = "#8fc6ca",
    base09 = "#a0cfd2",
    base0A = "#bbcbb2",
    base0B = "#a4d396",
    base0C = "#1e4d51",
    base0D = "#285021",
    base0E = "#3c4b37",
    base0F = "#a0b694",
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
    bg = '#285021',
    fg = '#c0efb0',
})

-- Strings (Boosted brightness slightly)
set_hl_multiple({ 'String', 'TSString' }, {
    fg = '#c3e0e2',
})

-- Comments (Using on_surface_variant instead of outline for better legibility)
set_hl_multiple({ 'TSComment', 'Comment' }, {
    fg = '#c3c8bc',
    italic = true,
})

-- Methods & Functions
set_hl_multiple({ 'TSMethod', 'Method' }, { fg = '#a0cfd2' })
set_hl_multiple({ 'TSFunction', 'Function' }, { fg = '#bbcbb2' })

-- KEYWORD FIX: Swapped from inverse_primary to primary + lighten
-- This gives keywords a vivid, high-contrast pop against dark terminals
set_hl_multiple({ 'Keyword', 'TSKeyword', 'TSKeywordFunction', 'TSRepeat' }, {
    fg = '#d3eacc',
    bold = true, -- Added bold to make control flow stand out
})
