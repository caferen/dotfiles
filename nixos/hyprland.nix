{ config, pkgs, lib, ... }:

{
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.startx.enable = true;

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    plasma-browser-integration
    konsole
    oxygen
    ark
    okular
    elisa
    kate
  ];

  xdg.portal.wlr.enable = true;
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    grim
    slurp
    swaylock
    xorg.xrandr
    waybar
    envsubst
    swww
  ];

  security.pam.services.swaylock = { };
}
