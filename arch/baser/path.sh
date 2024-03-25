append_path ~/.nix_profile/bin ~/.local/bin
systemctl --user import-environment PATH
export PATH
