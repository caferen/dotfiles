. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

declare -A env_vars 

env_vars[FLATPAK_USER_DIR]="/home/data/flatpak"
env_vars[BIN]="$HOME/.local/bin"
env_vars[XDG_DATA_DIRS]="$XDG_DATA_DIRS:$env_vars[FLATPAK_USER_DIR]/exports/share"
env_vars[XDG_DATA_HOME]="$HOME/.local/share"
env_vars[PATH]="$PATH:$env_vars[BIN]:$HOME/.nix-profile/bin"
env_vars[EDITOR]="nvim"
env_vars[GTK_THEME]="Colloid-Dark"
env_vars[PRIMARY_MONITOR]="DP-3"
env_vars[SECONDARY_MONITOR]="HDMI-A-1"
env_vars[FZF_DEFAULT_COMMAND]="rg --files"
env_vars[RIPGREP_CONFIG_PATH]="$HOME/.ripgreprc"

for var value in ${(kv)env_vars}; do
	export "$var"="$value"
	systemctl --user import-environment "$var"
done

if [[ $(tty) == "/dev/tty1" ]]; then
	exec Hyprland
fi
