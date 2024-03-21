{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
    editor = false;
  };
  boot.loader.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = [ "coretemp" "nct6775" ];

  fileSystems."/home/eren/ssd" =
    {
      device = "/dev/disk/by-uuid/a2533b5b-ab99-4a22-a5ab-6e462b75e61d";
      fsType = "ext4";
      options = [ "nosuid" "nodev" "nofail" ];
    };

  fileSystems."/home/eren/backup" =
    {
      device = "/dev/disk/by-uuid/963da330-ae54-4d3f-b2fa-a055b98b9308";
      fsType = "ext4";
      options = [ "nosuid" "nodev" "noexec" "nofail" ];
    };

  fileSystems."/home/eren/.data" =
    {
      device = "/home/eren/ssd/data-cipher";
      fsType = "fuse./run/current-system/sw/bin/gocryptfs";
      options = [ "nosuid" "nodev" "nofail" "allow_other" "passfile=/home/eren/ssd/.password/data" ];
    };

  hardware.opengl.driSupport32Bit = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
