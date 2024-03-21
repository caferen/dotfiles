append_path '/home/eren/.nix_profile/bin'
append_path '/home/eren/.local/bin'
systemctl --user import-environment PATH
export PATH
