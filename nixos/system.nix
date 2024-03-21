{ config, pkgs, ... }:

{
  users.groups = {
    eren = { };
    plugdev = { };
    gamemode = { };
  };
  users.users.eren = {
    isNormalUser = true;
    description = "eren";
    extraGroups = [
      "eren"
      "networkmanager"
      "wheel"
      "plugdev"
      "gamemode"
    ];
    shell = pkgs.zsh;
  };

  time.timeZone = "Europe/London";

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];

  nixpkgs.config.allowUnfree = true;
}
