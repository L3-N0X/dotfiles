-- This file will not be overwritten across dots-hyprland updates.
-- The file name is for the sake of organization and does not matter
-- See the corresponding files in ~/.config/hypr/hyprland for examples

--##! Colors
--# Regenerate the matugen palette from the current wallpaper (no wallpaper change)
hl.bind("CTRL + SUPER + SHIFT + R",
    hl.dsp.exec_cmd("$HOME/.config/hypr/custom/scripts/reload-colors.sh"),
    { description = "Shell: Reload colorscheme (matugen)" })
