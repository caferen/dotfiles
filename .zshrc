export ZSH=$HOME/.oh-my-zsh
export VISUAL=nvim
export EDITOR="$VISUAL"
export CARGO_HOME="$HOME/.cargo"
export FZF_DEFAULT_COMMAND="rg --files --no-ignore-parent --hidden"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$CARGO_HOME/bin:$PATH"

alias vi="nvim -n"
alias grep="rg --no-ignore-parent --hidden"
alias cat="bat -p"

if which codium > /dev/null; then
    if [[ "$(echo $XDG_SESSION_TYPE)" == 'x11' ]]; then
        alias code="codium"
    else
        alias code="codium --enable-features=UseOzonePlatform,WaylandWindowDecorations \
            --ozone-platform=wayland"
    fi
fi

ff() {
    IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0 \
                --info=hidden --preview 'bat --color=always -p {}' --preview-window=up,90%,border \
        --bind 'ctrl-/:change-preview-window(90%|30%)'))
    [[ -n "$files" ]] && ${EDITOR} -n "${files[@]}"
}
gitcom() { git -C "$2" add -A && git -C "$2" commit -m "$1" --no-verify && git -C "$2" push }

test -f $HOME/.secrets && source $_
test -f $ZSH/oh-my-zsh.sh && source $_

eval "$(starship init zsh)"
