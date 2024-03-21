{ config, pkgs, lib, ... }:

{
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    fwupd
  ];

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
    ark
    okular
    elisa
    kate
  ];
}
