{
  config,
  pkgs,
  lib,
  ...
}:
let
  swayexitify = pkgs.writeShellScriptBin "swayexitify" ''
    lock() {
      ${pkgs.swaylock}/bin/swaylock
    }

    case "$1" in
        lock)
            lock &
            ;;
        logout)
            ${pkgs.sway}/bin/swaymsg exit
            ;;
        suspend)
            ${pkgs.systemd}/bin/systemctl suspend
            ;;
        hibernate)
            ${pkgs.systemd}/bin/systemctl hibernate
            ;;
        reboot)
            ${pkgs.systemd}/bin/systemctl reboot
            ;;
        shutdown)
            ${pkgs.systemd}/bin/systemctl poweroff
            ;;
        *)
            echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
            exit 2
    esac

    exit 0
  '';
  niriswitch = pkgs.writeShellScriptBin "niriswitch" ''
    windows=$(${pkgs.niri}/bin/niri msg -j windows)
    ${pkgs.niri}/bin/niri msg action focus-window --id \
      $(echo "$windows" | 
        ${pkgs.jq}/bin/jq ".[$(echo "$windows" | ${pkgs.jq}/bin/jq -r 'map("\(.title // .app_id)\u0000icon\u001f\(.app_id)") | .[]' | ${pkgs.fuzzel}/bin/fuzzel -d --index)].id"
      )
  '';
in
{
  home.packages = with pkgs; [ wl-mirror ];
  wayland.windowManager.niri = {
    enable = true;
    configFile = pkgs.replaceVars ./niri.kdl {
      swaync = "${pkgs.swaynotificationcenter}";
      cursorTheme = "${config.gtk.cursorTheme.name}";
      foot = "${pkgs.foot}";
      fuzzel = "${pkgs.fuzzel}";
      wireplumber = "${pkgs.wireplumber}";
      playerctl = "${pkgs.playerctl}";
      brightnessctl = "${pkgs.brightnessctl}";
      bemoji = "${pkgs.bemoji}";
      swayexitify = "${swayexitify}";
      niriswitch = "${niriswitch}";
      copyq = "${pkgs.copyq}";
      DEFAULT_AUDIO_SINK = null;
      DEFAULT_AUDIO_SOURCE = null;
    };
  };

  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    extraArgs = [ "-w" ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 305;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      ignore-empty-password = true;
      show-failed-attempts = true;
    };
  };

  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland Background";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    Service = {
      Type = "exec";
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${./bg.jpg} -m fill";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "XWayland Satellite";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    Service = {
      Type = "exec";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  services.copyq = {
    enable = true;
    forceXWayland = false;
  };

  services.mako.enable = true;
}
