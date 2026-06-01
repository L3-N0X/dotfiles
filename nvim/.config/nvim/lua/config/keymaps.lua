-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- =========================================
-- Terminal and Explorer Integrations
-- =========================================

-- Toggle floating terminal with Alt + Enter
-- The default LazyVim terminal uses Snacks.terminal or toggleterm
map("n", "<M-CR>", function() Snacks.terminal() end, { desc = "Toggle Terminal" })
map("t", "<M-CR>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- Toggle Neotree (File Explorer) with <leader>e instead of focusing it
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer" })

-- =========================================
-- Code Navigation and Diagnostics
-- =========================================

-- Fast line diagnostics floating window
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- =========================================
-- Search and Telescope
-- =========================================

-- Telescope fast filters
map("n", "<M-i>", "<cmd>Telescope git_files<cr>", { desc = "Find Git Files" })
map("n", "<M-h>", function()
    require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find All Files (incl. hidden)" })

-- Project-wide Search and Replace (Using built-in spectro/greplace or quickfix)
-- Maps to LazyVim's default search, but immediately populates the quickfix list for replacing
map("n", "<leader>sr", function()
    require("telescope.builtin").live_grep()
end, { desc = "Search Project" })
