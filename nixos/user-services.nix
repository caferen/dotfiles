{ config, lib, ... }:

{
  systemd.user.services.wallpaper = {
    description = "Change the wallpaper periodically";
    environment = lib.mkForce {
      inherit (config.environment.sessionVariables) PATH;
    };
    script = "exec ${/home/eren/.local/bin/wallpaper}";
  };

  systemd.user.timers.wallpaper = {
    enable = true;
    description = "Wallpaper timer";
    timerConfig = {
      Unit = "wallpaper.service";
      OnCalendar = "*-*-* *:00/3:00";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.user.services.dotfiles = {
    description = "Backup configurations";
    serviceConfig = {
      WorkingDirectory = "/home/eren/.dotfiles";
    };
    environment = lib.mkForce {
      inherit (config.environment.sessionVariables) PATH;
    };
    script = ''
		dconf dump / > $HOME/.config/dconf/dconf-settings.ini && \
        git add -A && \
        git commit -m autosave && \
      	git push
    '';
  };

  systemd.user.timers.dotfiles = {
    enable = true;
    description = "Dotfiles timer";
    timerConfig = {
      Unit = "dotfiles.service";
      OnCalendar = "hourly";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.user.services.backup = {
    description = "Backup configuration and files";
    environment = lib.mkForce {
      inherit (config.environment.sessionVariables) PATH;
    };
    script = ''
        rsync -av --delete /home/eren/ssd/drive-cipher /home/eren/backup
      	rsync -av --delete /home/eren/ssd/media-cipher /home/eren/backup
      	rsync -av --delete /home/eren/ssd/images /home/eren/backup
    '';
  };

  systemd.user.timers.backup = {
    enable = true;
    description = "Backup timer";
    timerConfig = {
      Unit = "backup.service";
      OnCalendar = "*-*-* *:00/5:00";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.user.services.launcher = {
    description = "Rebuild launcher app cache";
    environment = lib.mkForce {
      inherit (config.environment.sessionVariables) PATH;
    };
    script = "exec ${/home/eren/.local/bin/launcher} --cache";
  };

  systemd.user.paths.launcher = {
    enable = true;
    description = "Monitor application directories";
    pathConfig = {
      Unit = "launcher.service";
      PathChanged = [
        "/run/booted-system/sw/share/applications"
        "/home/eren/.local/share/applications"
        "/home/eren/.local/bin/launcher"
      ];
    };
    wantedBy = [ "default.target" ];
  };

  security.rtkit.enable = true;
  services = {
    syncthing = {
      enable = true;
      user = "eren";
      configDir = "/home/eren/.local/state/syncthing";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
hardware.pulseaudio.enable = false;
}
