$env.VISUAL = nvim
$env.EDITOR = $env.VISUAL
$env.HELIX_RUNTIME = $"($env.HOME)/helix/runtime"
$env.CARGO_HOME = $"($env.HOME)/.cargo"
$env.PATH = ($env.PATH | append $"($env.CARGO_HOME)/bin")

$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

alias vi = nvim
alias python = python3
alias pip = pip3

def gitcom [message: string = "autosave", dir: string = ""] {
    git -C $dir add -A
    git -C $dir commit -m $message
    git -C $dir push | null
}
