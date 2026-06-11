return {
    {
        "RRethy/nvim-base16",
        lazy = false,    -- Load this immediately on startup
        priority = 1000, -- Make sure it loads before other plugins
        config = function()
            -- Helper function to safely read and run the Matugen file
            local function source_matugen()
                local matugen_path = os.getenv("HOME") .. "/.config/nvim/matugen.lua"
                local file, err = io.open(matugen_path, "r")

                if err ~= nil then
                    -- Fallback theme if Matugen hasn't generated the file yet
                    vim.cmd("colorscheme base16-default-dark")
                else
                    io.close(file)
                    dofile(matugen_path) -- This runs your require('base16-colorscheme').setup({...})
                end
            end

            -- Run it immediately on startup
            source_matugen()

            -- Listen for Matugen's signal (pkill -SIGUSR1 nvim) to reload on the fly
            vim.api.nvim_create_autocmd("Signal", {
                pattern = "SIGUSR1",
                callback = function()
                    source_matugen()
                    package.loaded["lualine"] = nil -- Clear cache so it fully reloads
                    require("lualine").setup({ options = { theme = "base16" } })

                    -- Re-apply any custom tweaks you like
                    vim.api.nvim_set_hl(0, "Comment", { italic = true })
                end,
            })
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            -- FIX HERE: We use a function so LazyVim yields control completely to your file
            colorscheme = function()
                local matugen_path = os.getenv("HOME") .. "/.config/nvim/matugen.lua"
                dofile(matugen_path)
            end,
        },
    },
}
