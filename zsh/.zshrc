# ---- POWERLEVEL10K INSTANT PROMPT ---------------------------
# Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---- SYSTEM & THEME CONFIG ----------------------------------
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---- PLUGIN MANAGER (ZINIT) ---------------------------------
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ---- ENVIRONMENT VARIABLES & PATHS --------------------------
export EDITOR=nvim
export VISUAL=nvim
export PATH=$PATH:/home/lenox/.spicetify

# ---- ZSH OPTIONS --------------------------------------------
unsetopt CORRECT_ALL

# ---- ZOXIDE -------------------------------------------------
# Strip the 'zi' alias created by Zinit so it doesn't break Zoxide
(( ${+aliases[zi]} )) && unalias zi

eval "$(zoxide init zsh)"

# ---- FZF CONFIGURATION --------------------------------------
# Catppuccin Macchiato Theme & Layout
local fzf_bg="#24273a"
local fzf_fg="#cad3f5"
local fzf_border="#7dc4e4"
local fzf_hl="#ed8796"
local fzf_fg_plus="#cad3f5"
local fzf_bg_plus="#363a4f"
local fzf_hl_plus="#ed8796"
local fzf_info="#c6a0f6"
local fzf_prompt="#8aadf4"
local fzf_pointer="#f4dbd6"
local fzf_marker="#b7bdf8"
local fzf_header="#ed8796"

export FZF_DEFAULT_OPTS="
  --layout=reverse
  --border=rounded
  --margin=1
  --padding=1
  --height=60%
  --prompt='󰭎 '
  --pointer='➔'
  --marker='➔'
  --color=bg+:$fzf_bg_plus,bg:$fzf_bg,spinner:$fzf_pointer,hl:$fzf_hl
  --color=fg:$fzf_fg,header:$fzf_header,info:$fzf_info,pointer:$fzf_pointer
  --color=marker:$fzf_marker,fg+:$fzf_fg_plus,prompt:$fzf_prompt,hl+:$fzf_hl_plus
  --color=border:$fzf_border"
  
# Force fzf to use 'fd'
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --strip-cwd-prefix --hidden --follow --exclude .git"

# ---- KEYBINDINGS & MACROS -----------------------------------
# Edit current command line in $EDITOR (Ctrl + E)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

# Sudo with Ctrl + S
function prepend-sudo() {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"
    CURSOR=$(( CURSOR + 5 ))
  else
    BUFFER="${BUFFER#sudo }"
    CURSOR=$(( CURSOR - 5 ))
  fi
}
zle -N prepend-sudo
bindkey '^S' prepend-sudo

# git commit with Ctrl + X -> G
make-git-commit-stub() {
    LBUFFER+="git commit -m \""
    RBUFFER="\""
    zle redisplay
}
zle -N make-git-commit-stub
bindkey '^Xg' make-git-commit-stub

# git acp with Ctrl + X -> A
make-git-acp-stub() {
    LBUFFER+="git acp \""
    RBUFFER="\""
    zle redisplay
}
zle -N make-git-acp-stub
bindkey '^Xa' make-git-acp-stub

# ---- ALIASES ------------------------------------------------
# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Eza (Modern replacement for ls)
if (( $+commands[eza] )); then
    alias ls="eza --icons=always --color=always --group-directories-first"
    alias la="eza --icons=always --color=always --group-directories-first -a"
    alias ll="eza --icons=always --color=always --group-directories-first -la --git --header"
    alias lt="eza --icons=always --color=always --group-directories-first --tree --level=2"
else
    alias ls="ls --color=auto"
    alias la="ls -A"
    alias ll="ls -la"
fi

# Core Utilities & Safety
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"
alias e='nvim'

# Config Upkeep & Dotfiles
alias reload="source ~/.zshrc && echo 'Zsh config reloaded successfully!'"
alias valac="nvim ~/.config/alacritty/alacritty.toml"
alias vthem="nvim ~/.tmux.conf"
alias stow="/usr/bin/stow --dir /home/lenox/dotfiles --target /home/lenox"
