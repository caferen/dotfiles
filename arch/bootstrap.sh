#!/bin/sh

nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add \
    https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
home-manager switch

flatpak remote-add --user --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user flathub bottles

rustup default stable

sudo passwd --lock root
sudo pacman -Rdd geoclue
pacman -Qtdq | sudo pacman -Rns -
