source_if_exists() { [[ -f "$1" ]] && source "$1" }

export ZSH=$HOME/.oh-my-zsh
export VISUAL=nvim
export EDITOR="$VISUAL"
export HELIX_RUNTIME="$HOME/helix/runtime"
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$HOME/.local/bin:/opt/cuda/bin:$PATH"

alias vi="nvim -n"
alias python="python3"
alias pip="pip3"

gitcom() { git -C "$2" add -A && git -C "$2" commit -m "$1" --no-verify && git -C "$2" push }
xdual() {
    xrandr --output DP-4 --mode 2560x1440 --rotate normal --rate 165 --primary \
        --output HDMI-0 --mode 1920x1080 --left-of DP-4 --rate 75 --rotate right
}
xsingle() {
    xrandr --output DP-4 --mode 2560x1440 --rotate normal --rate 165 --primary \
        --output HDMI-0 --off
}

source_if_exists $HOME/.secrets
source_if_exists $ZSH/oh-my-zsh.sh
source_if_exists /usr/share/nvm/init-nvm.sh

eval "$(starship init zsh)"
