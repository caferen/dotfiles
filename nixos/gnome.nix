{ config, pkgs, lib, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-text-editor
    gnome-connections
  ]) ++ (with pkgs.gnome; [
    cheese
    epiphany
    geary
    evince
    totem
    tali
    iagno
    hitori
    atomix
    yelp
    simple-scan
    gnome-calendar
    gnome-calculator
    gnome-disk-utility
    gnome-music
    gnome-terminal
    gnome-characters
    gnome-contacts
    gnome-maps
  ]);

  environment.systemPackages = (with pkgs.gnomeExtensions; [
    appindicator
    pop-shell
    blur-my-shell
    burn-my-windows
    hot-edge
  ]) ++ (with pkgs; [
    gnome-feeds
    candy-icons
    pop-launcher
  ]);

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  nixpkgs.overlays = [
    (final: prev: {
      gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs (old: {
          src = pkgs.fetchgit {
            url = "https://gitlab.gnome.org/vanvugt/mutter.git";
            # GNOME 45: triple-buffering-v4-45
            rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
            sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
          };
        });
      });
    })
  ];

  nixpkgs.config.allowAliases = false;
}

