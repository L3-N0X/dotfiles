-- ==========================================================================
-- 1. BASE16 PALETTE INITIALIZATION
-- ==========================================================================
require('base16-colorscheme').setup({
    base00 = "#1b110e",
    base01 = "#150c09",
    base02 = "#241916",
    base03 = "#57423c",
    base04 = "#dec0b8",
    base05 = "#f3ded8",
    base06 = "#3a2e2a",
    base07 = "#433633",

    base08 = "#3ad6d2",
    base09 = "#4fdad7",
    base0A = "#fdb6a0",
    base0B = "#ffb59e",
    base0C = "#00b3b1",
    base0D = "#f87d56",
    base0E = "#6b392a",
    base0F = "#fc906e",
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
    bg = '#f87d56',
    fg = '#2d0700',
})

-- Strings (Boosted brightness slightly)
set_hl_multiple({ 'String', 'TSString' }, {
    fg = '#79e3e1',
})

-- Comments (Using on_surface_variant instead of outline for better legibility)
set_hl_multiple({ 'TSComment', 'Comment' }, {
    fg = '#dec0b8',
    italic = true,
})

-- Methods & Functions
set_hl_multiple({ 'TSMethod', 'Method' }, { fg = '#4fdad7' })
set_hl_multiple({ 'TSFunction', 'Function' }, { fg = '#fdb6a0' })

-- KEYWORD FIX: Swapped from inverse_primary to primary + lighten
-- This gives keywords a vivid, high-contrast pop against dark terminals
set_hl_multiple({ 'Keyword', 'TSKeyword', 'TSKeywordFunction', 'TSRepeat' }, {
    fg = '#ffefeb',
    bold = true, -- Added bold to make control flow stand out
})
