{ config, pkgs, ... }:

let
  juno = pkgs.callPackage ./juno-theme.nix { };

in

{
  home.username = "eren";
  home.homeDirectory = "/home/eren";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    brave
    avizo
    candy-icons
    freetube
    nwg-dock-hyprland
    oh-my-posh
    wlogout
    coolercontrol.coolercontrold
    (colloid-gtk-theme.override {
      themeVariants = [ "default" ];
      colorVariants = [ "dark" ];
      sizeVariants = [ "standard" ];
      tweaks = [ "black" "rimless" ];
    })
    (graphite-gtk-theme.override {
      themeVariants = [ "default" ];
      colorVariants = [ "dark" ];
      sizeVariants = [ "standard" ];
      tweaks = [ "black" ];
      grubScreens = [ ];
    })
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        asvetliakov.vscode-neovim
        eamodio.gitlens
        ms-python.python
        rust-lang.rust-analyzer
        vadimcn.vscode-lldb
        github.github-vscode-theme
        gitlab.gitlab-workflow
      ];
    })
  ] ++ [ juno ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.11"; # Don't change
}

