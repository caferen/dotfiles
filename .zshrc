ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d $ZINIT_HOME ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit blockf wait lucid light-mode for \
    zsh-users/zsh-completions \
    nix-community/nix-zsh-completions
zinit wait lucid atload'_zsh_autosuggest_start' light-mode for \
    zsh-users/zsh-autosuggestions
zinit wait lucid light-mode for \
    zsh-users/zsh-syntax-highlighting

autoload -U compinit && compinit

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="$HOME/.zsh_history"

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_BY_COPY
setopt HIST_LEX_WORDS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    eval "$(oh-my-posh init zsh --config $HOME/.config/omp.toml)"
fi

zstyle ':completion:*' use-cache on
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'

bindkey -e

zle -N hist
bindkey '^R' hist
bindkey '^[[B' history-beginning-search-forward
bindkey '^[[A' history-beginning-search-backward

autoload edit-command-line; zle -N edit-command-line
bindkey '^b' edit-command-line

alias cat="bat -p"
alias claer=clear
alias la="ls -lAh"
alias ls="ls --color"
alias vi="nvim -n"

if [[ $(uname) == "Linux" ]]; then
    alias code="codium --enable-features=UseOzonePlatform --ozone-platform=wayland"
    alias disku="du --max-depth=1 --block-size=MB --human-readable --all"
fi

if [[ $(uname) == "Darwin" ]]; then
    alias sed=gsed
	alias wl-copy=pbcopy
	alias wl-paste=pbpaste
    alias disku="du -h -c --si -d 1"
fi

start() { sudo systemctl start "$@"; }
stop() { sudo systemctl stop "$@"; }
restart() { sudo systemctl restart "$@"; }
status() { systemctl status "$@"; }

ustart() { systemctl --user start "$@"; }
ustop() { systemctl --user stop "$@"; }
urestart() { systemctl --user restart "$@"; }
ustatus() { systemctl --user status "$@"; }

ff() {
    IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0 --scheme=path \
                --preview 'bat --color=always -p {}' --preview-window=up,70%,border \
        --bind 'ctrl-/:change-preview-window(70%|30%)'))
    [[ -n "$files" ]] && ${EDITOR} -n "${files[@]}"
}

dc() {
    IFS=$'\n' dir=($(rg --files "${1-$HOME}" | \
        xargs dirname | sort -u | fzf --scheme=path))
    [[ -n "$dir" ]] && cd "$dir"
}

gith() {
    IFS=$'\n' commit=($(git log --format="%H %s %an %ah" \
        | fzf --query="$1" --select-1 --exit-0))
    grep -o '^\S*' <<< "$commit" | wl-copy
}

gitsr() {
    IFS=$'\n' commit=($(git log --format="%H %s %an %ah" \
        | fzf --query="$1" --select-1 --exit-0))
    hash=$(grep -o '^\S*' <<< "$commit")
    [[ -n "$hash" ]] && read "?Soft reset to "$commit"? [yN]"
    [[ "$REPLY" =~ ^[Yy]$ ]] && git reset --soft "$hash"
}

gitd() {
    IFS=$'\n' commit_hashes=($(git log --format="%H %s %an %ah" \
                | fzf --query="$1" --multi --select-1 --exit-0 \
        | grep -o '^\S*' ))
    [[ -n "$commit_hashes[2]" ]] || commit_hashes[2]=HEAD
    [[ -n "$commit_hashes[1]" ]] && git difftool "$commit_hashes[1]" "$commit_hashes[2]"
}

gitc() {
    git -C "$2" add -A \
        && [[ -n "$1" ]] || git -C "$2" commit \
        && git -C "$2" commit -m "$1" && \
        read "?Push? [y/N/force]"
    [[ "$REPLY" =~ ^[Yy]$ ]] && git -C "$2" push
    [[ "$REPLY" == "force" ]] && git -C "$2" push --force
}

hist() {
    cat $HISTFILE | fzf --tac --no-sort \
        --query="$BUFFER" --scheme=history | wl-copy
    LBUFFER="$(wl-paste)"
}
