{ config, pkgs, ... }:

{
  home.username = "eren";
  home.homeDirectory = "/home/eren";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.zsh =
    {
      enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      # autosuggestion.enable = true;
      history = {
        expireDuplicatesFirst = true;
        ignoreAllDups = true;
        ignoreSpace = false;
        save = 10000000;
        size = 10000000;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ ];
      };
      plugins = with pkgs; [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      initExtra = ''source ~/.zshconf'';
      initExtraFirst = ''
        	if [[ $(tty) == "/dev/tty1" ]]; then
        		exec Hyprland
        	fi

        	if [[ $(tty) == "/dev/tty2" ]]; then
        		exec startx /usr/bin/startplasma-x11
        	fi
      '';
    };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  home.packages = with pkgs; [
    meslo-lgs-nf
    cozette
    brave
    swww
    spotify
    wally-cli
    avizo
    wl-clip-persist
    swaynotificationcenter
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        asvetliakov.vscode-neovim
        eamodio.gitlens
        ms-python.python
        rust-lang.rust-analyzer
        github.github-vscode-theme
        vadimcn.vscode-lldb
        gitlab.gitlab-workflow
      ];
    })
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11"; # Don't change
}
