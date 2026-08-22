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

# Shell enhancements & syntax highlighting
zinit light zsh-users/zsh-completions
zinit cdreplay -q
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting


# ---- ENVIRONMENT VARIABLES & PATHS --------------------------
export EDITOR=helix
export VISUAL=helix
export PATH=$PATH:/home/lenox/.spicetify

export PATH=$HOME/bin:$PATH

export JAVA_HOME=/usr/lib/jvm/default

# Android SDK Paths for Arch Linux
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# ---- ZSH OPTIONS --------------------------------------------
unsetopt CORRECT_ALL

# ---- ZOXIDE -------------------------------------------------
# Strip the 'zi' alias created by Zinit so it doesn't break Zoxide
(( ${+aliases[zi]} )) && unalias zi

eval "$(zoxide init zsh)"

# ---- YAZI --------------------------------------------------
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
    command rm -f -- "$tmp"
}

# ---- FZF CONFIGURATION --------------------------------------
# Catppuccin Macchiato Theme & Layout
source ~/.config/fzf/fzf-matugen.sh
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

function prepend-tldr() {
    if [[ $BUFFER != "tldr "* ]]; then
        BUFFER="tldr $BUFFER"
        CURSOR=$(( CURSOR + 5 ))
    else
        BUFFER="${BUFFER#tldr }"
        CURSOR=$(( CURSOR - 5 ))
    fi
}
zle -N prepend-tldr
bindkey '^T' prepend-tldr

# git commit with Ctrl + X -> C
make-git-commit-stub() {
    LBUFFER+="git commit -m \""
    RBUFFER="\""
    zle redisplay
}
zle -N make-git-commit-stub
bindkey '^Xc' make-git-commit-stub

# git acp with Ctrl + X -> A
make-git-acp-stub() {
    LBUFFER+="git acp \""
    RBUFFER="\""
    zle redisplay
}
zle -N make-git-acp-stub
bindkey '^Xa' make-git-acp-stub

bindkey '^Z' undo

WORDCHARS="${WORDCHARS//[\/.-_]/}"
bindkey '^[^?' backward-kill-word
bindkey '^H' backward-kill-word

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

# helix
alias hx="helix"

# bat cat
alias cat="bat --paging=never --style=plain"
alias bat="bat --paging=never"

# Docker & Docker Compose Aliases

# Docker Compose
alias dco='docker compose'
alias dcb='docker compose build'
alias dce='docker compose exec'
alias dcps='docker compose ps'
alias dcrestart='docker compose restart'
alias dcrm='docker compose rm'
alias dcr='docker compose run'
alias dcstop='docker compose stop'
alias dcup='docker compose up'
alias dcupb='docker compose up --build'
alias dcupd='docker compose up -d'
alias dcupdb='docker compose up -d --build'
alias dcdn='docker compose down'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'
alias dcpull='docker compose pull'
alias dcstart='docker compose start'
alias dck='docker compose kill'

# Docker
alias dbl='docker build'
alias dcin='docker container inspect'
alias dcls='docker container ls'
alias dclsa='docker container ls -a'
alias dlo='docker container logs'
alias dr='docker container run'
alias drit='docker container run -it'
alias drm='docker container rm'
alias dst='docker container start'
alias drs='docker container restart'
alias dstp='docker container stop'
alias dtop='docker top'
alias dxc='docker container exec'
alias dxcit='docker container exec -it'

# Docker image commands
alias dib='docker image build'
alias dii='docker image inspect'
alias dils='docker image ls'
alias dipu='docker image push'
alias dirm='docker image rm'
alias dit='docker image tag'
alias dpu='docker pull'

# Docker network commands
alias dni='docker network inspect'
alias dnls='docker network ls'
alias dnrm='docker network rm'
alias dvi='docker volume inspect'
alias dvls='docker volume ls'
alias dvprune='docker volume prune'

alias dps='docker ps'
alias dsa='docker ps -q | xargs -r docker stop'
alias dxa='docker ps -aq | xargs -r docker rm'
alias dsp='docker system prune'

# Git Aliases

# Basic workflow
alias ga='git add'
alias gaa='git add --all'
alias gcmsg='git commit -m'
alias gcam='git commit -a -m'
alias gca!='git commit -v -a --amend'
alias gst='git status'
alias gd='git diff'

# Branching and Checkout
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcd='git checkout $(git config --get init.defaultBranch || echo main)' # checkout main/master
alias gcm='git checkout $(git config --get init.defaultBranch || echo master)'

# Fetching, Pulling, and Pushing
alias gf='git fetch'
alias gl='git pull'
alias gup='git pull --rebase'
alias gp='git push'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'
alias gpf!='git push --force'

# Logging
alias glg='git log --stat'
alias glgg='git log --graph'
alias glo='git log --oneline --decorate'

# Stashing
alias gsta='git stash push'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gstd='git stash drop'

# Rebasing
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'

# Core Utilities & Safety
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -Iv"
alias e='$EDITOR'
alias ee="sudoedit"
alias cd='z'

alias sshk='kitty +kitten ssh'

# Zed EDITOR
alias zed="zeditor"

# Expo Tailscale
alias expo-tailscale='REACT_NATIVE_PACKAGER_HOSTNAME=$(tailscale ip -4) npx expo'

# Config Upkeep & Dotfiles
alias reload="source ~/.zshrc && echo 'Zsh config reloaded successfully!'"
alias valac="nvim ~/.config/alacritty/alacritty.toml"
alias vthem="nvim ~/.tmux.conf"
alias stow="/usr/bin/stow --dir /home/lenox/dotfiles --target /home/lenox"

alias clock="tty-clock -D -c"

alias setjava="sudo archlinux-java set"

eval "$(fnm env --use-on-cd --shell zsh)"

# Added by Antigravity CLI installer
export PATH="/home/lenox/.local/bin:$PATH"
export PATH="$HOME/.local/share/pnpm:$PATH"

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<

# ESP Rust toolchain (espup)
[ -f "$HOME/export-esp.sh" ] && source "$HOME/export-esp.sh"
