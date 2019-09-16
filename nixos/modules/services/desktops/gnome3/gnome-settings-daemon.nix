# GNOME Settings Daemon

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.gnome3.gnome-settings-daemon;

in

{

  ###### interface

  options = {

    services.gnome3.gnome-settings-daemon = {

      enable = mkEnableOption "GNOME Settings Daemon";

      # There are many forks of gnome-settings-daemon
      package = mkOption {
        type = types.package;
        default = pkgs.gnome3.gnome-settings-daemon;
        description = "Which gnome-settings-daemon package to use.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.user.targets."gnome-session-initialized".wants = [
      "gsd-a11y-settings.target" "gsd-housekeeping.target" "gsd-power.target"
      "gsd-color.target" "gsd-keyboard.target" "gsd-print-notifications.target"
      "gsd-datetime.target" "gsd-media-keys.target" "gsd-rfkill.target"
      "gsd-screensaver-proxy.target" "gsd-sound.target" "gsd-smartcard.target"
      "gsd-sharing.target" "gsd-wacom.target" "gsd-wwan.target"
    ];

    systemd.user.targets."gnome-session-x11-services".wants = [
      "gsd-xsettings.target"
    ];

  };

}
