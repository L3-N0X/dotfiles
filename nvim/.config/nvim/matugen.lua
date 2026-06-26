-- ==========================================================================
-- 1. BASE16 PALETTE INITIALIZATION
-- ==========================================================================
require('base16-colorscheme').setup({
    base00 = "#1a110f",
    base01 = "#140c0a",
    base02 = "#231917",
    base03 = "#53433f",
    base04 = "#d8c2bc",
    base05 = "#f1dfda",
    base06 = "#392e2b",
    base07 = "#423734",

    base08 = "#d2bd7a",
    base09 = "#d8c68d",
    base0A = "#e7bdb1",
    base0B = "#ffb59e",
    base0C = "#52461a",
    base0D = "#723521",
    base0E = "#5d4037",
    base0F = "#db9c8a",
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
    bg = '#723521',
    fg = '#ffdbd0',
})

-- Strings (Boosted brightness slightly)
set_hl_multiple({ 'String', 'TSString' }, {
    fg = '#e5d9b3',
})

-- Comments (Using on_surface_variant instead of outline for better legibility)
set_hl_multiple({ 'TSComment', 'Comment' }, {
    fg = '#d8c2bc',
    italic = true,
})

-- Methods & Functions
set_hl_multiple({ 'TSMethod', 'Method' }, { fg = '#d8c68d' })
set_hl_multiple({ 'TSFunction', 'Function' }, { fg = '#e7bdb1' })

-- KEYWORD FIX: Swapped from inverse_primary to primary + lighten
-- This gives keywords a vivid, high-contrast pop against dark terminals
set_hl_multiple({ 'Keyword', 'TSKeyword', 'TSKeywordFunction', 'TSRepeat' }, {
    fg = '#ffefeb',
    bold = true, -- Added bold to make control flow stand out
})
