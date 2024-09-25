{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.mako.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    checkConfig = false; # breaks background ;(
    config = rec {
      terminal = "${pkgs.foot}/bin/footclient";
      modifier = "Mod4";
      menu = "${pkgs.fuzzel}/bin/fuzzel";
      output = {
        "*" = {
          bg = "${config.home.homeDirectory}/media/pics/bg.jpg fill";
        };
      };
      gaps = {
        inner = 5;
        smartBorders = "on";
        smartGaps = true;
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "br";
          xkb_variant = "thinkpad";
          xkb_options = "caps:ctrl_modifier";

          repeat_delay = "200";
          repeat_rate = "30";
        };
      };
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+Shift+c" = "kill";
          "${modifier}+Mod1+c" = "reload";
          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86MonBrightnessUp" = "exec light -A 10";
          "XF86AudioRaiseVolume" = "exec 'wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+'";
          "XF86AudioLowerVolume" = "exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'";
          "XF86AudioMute" = "exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";
          "XF86AudioMicMute" = "exec 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'";
          "Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard-rs}/bin/wl-copy -t image/png";
          "Shift+Print" = "exec ${pkgs.grim}/bin/grim  - | ${pkgs.wl-clipboard-rs}/bin/wl-copy -t image/png";
        };
      keycodebindings =
        let
          swaylock = "${config.programs.swaylock.package}/bin/swaylock";
        in
        {
          "160" = "exec ${swaylock}";
        };
    };
    extraConfig = ''
      default_border pixel 2
       hide_edge_borders --i3 none
    '';
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      ignore-empty-password = true;
      show-failed-attempts = true;
    };
  };

  services.swayidle =
    let
      swaylock = "${config.programs.swaylock.package}/bin/swaylock -f";
    in
    {
      enable = true;
      systemdTarget = "sway-session.target";
      timeouts =
        let
          dpmsCommand = "${config.wayland.windowManager.sway.package}/bin/swaymsg 'output * power";
        in
        [
          {
            timeout = 300;
            #timeout = 5;
            command = swaylock;
          }
          {
            timeout = 600;
            #timeout = 10;
            command = "${dpmsCommand} off'";
            resumeCommand = "${dpmsCommand} on'";
          }
        ];
      events = [
        {
          event = "before-sleep";
          command = swaylock;
        }
        {
          event = "lock";
          command = swaylock;
        }
      ];
    };
}
