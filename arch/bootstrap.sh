#!/bin/sh

git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
(
	cd /tmp/yay-bin
	makepkg -si --asdeps
)

git clone https://github.com/caferen/dotfiles.git /tmp/dots

rsync -rlptH /tmp/dots/.** $HOME/
rsync -rlptH /tmp/dots/** $HOME/

find $HOME/.config/systemd/system -regextype egrep -regex \
    '.*(timer|path|service)' -exec bash -c \
    "realpath '{}' | xargs -L1 sudo systemctl enable" \;

sudo ln -s $HOME/.config/coolercontrol.toml /etc/coolercontrol/config.toml

nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add \
    https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
home-manager switch

pacman -Qqi baser | rg -v ':' -o | rg -v 'installed' | tr -d ' \t' | sudo pacman -S --asdeps -

rustup default stable

flatpak remote-add --user --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user cura

sudo passwd --lock root
sudo pacman -Rdd geoclue
pacman -Qtdq | sudo pacman -Rns -
