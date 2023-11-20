source_if_exists() { [[ -f "$1" ]] && source "$1" }

export ZSH=$HOME/.oh-my-zsh
export VISUAL=nvim
export EDITOR="$VISUAL"
export HELIX_RUNTIME="$HOME/helix/runtime"
export CARGO_HOME="$HOME/.cargo"
export FZF_DEFAULT_COMMAND="rg --files --no-ignore-parent --hidden"
export PATH="$CARGO_HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/cuda/bin:$PATH"
export PATH="$HOME/bin:$PATH"

alias vi="nvim -n"
alias python="python3"
alias pip="pip3"
alias ripgrep="rg --no-ignore-parent --hidden"

if which helix > /dev/null; then
    alias hx="helix"
fi

if which codium > /dev/null; then
    if [[ "$(echo $XDG_SESSION_TYPE)" == 'x11' ]]; then
        alias code="codium"
    else
        alias code="codium --enable-features=UseOzonePlatform,WaylandWindowDecorations \
            --ozone-platform=wayland"
    fi
fi

f() {
    IFS=$'\n' files=($(fzf  --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR} -n "${files[@]}"
}
gitcom() { git -C "$2" add -A && git -C "$2" commit -m "$1" --no-verify && git -C "$2" push }

source_if_exists $HOME/.secrets
source_if_exists $ZSH/oh-my-zsh.sh
source_if_exists /usr/share/nvm/init-nvm.sh

eval "$(starship init zsh)"
