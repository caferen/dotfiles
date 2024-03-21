{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware.nix
      ./network.nix
      ./system.nix
      ./user-services.nix
      ./secrets.nix
      ./gnome.nix
    ];

  environment.sessionVariables = rec {
    BIN = "$HOME/.local/bin";
    RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
    FLATPAK_USER_DIR = "$HOME/ssd/flatpak";
    NIXOS_OZONE_WL = "1";
    PRIMARY_MONITOR = "DP-3";
    SECONDARY_MONITOR = "HDMI-A-1";
    PATH = [
      "${BIN}"
      "/run/current-system/sw/bin"
    ];
  };

  environment.variables = {
    FZF_DEFAULT_COMMAND = "rg --files";
  };

  programs.direnv.enable = true;

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  programs.zsh =
    {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
      promptInit = "source ''${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      histSize = 1000000;
      setOptions = [
        "HIST_IGNORE_ALL_DUPS"
        "INC_APPEND_HISTORY"
      ];
      ohMyZsh = {
        enable = true;
        plugins = [ ];
      };
    };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    # package =
    #   pkgs.steam.override {
    #     extraPkgs = pkgs: with pkgs; [
    #       mangohud
    #     ];
    #     extraEnv = {
    #       MANGOHUD = true;
    #     };
    #   };
  };

  programs.coolercontrol.enable = true;

  environment.systemPackages = with pkgs; [
    git
    stow
    alacritty
    tmux
    brave
    firefox
    fzf
    ripgrep
    coreutils-full
    usbutils
    wally-cli
    mullvad-vpn
    flatpak
    spotify
    bat
    jq
    btop
    wl-clipboard
    gocryptfs
    gamemode
    rsync
    syncthing
    libusb1
    gh
    glab
    python3
    zsh-syntax-highlighting
    bluez
    neofetch
    signal-desktop
    cura
    vlc
    git-crypt
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

  fonts.packages = with pkgs; [
    meslo-lgs-nf
    cozette
  ];

  services.mullvad-vpn.enable = true;
  services.fwupd.enable = true;
  services.udev.extraRules = ''
        KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
        KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"

    	KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"
  '';

  system.stateVersion = "23.11";
}
