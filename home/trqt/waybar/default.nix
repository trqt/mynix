{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
    };
    settings = {
      bottomBar = {
        layer = "top";
        position = "bottom";
        height = 24;
        modules-left = [
          "sway/workspaces"
          "niri/workspaces"
          "sway/mode"
          "sway/window"
          "niri/window"
        ];
        modules-right = [
          "custom/uptime"
          "backlight"
          "pulseaudio"
          "battery"
          "clock"
          "tray"
        ];
        "sway/workspaces" = {
          all-outputs = false;
          format = "{index}";
          disable-scroll = false;
          disable-click = false;
          enable-bar-scroll = false;
          numeric-first = true;
        };
        "niri/workspaces" = {
          format = "{value}";
        };
        "sway/mode" = {
          format = "{}";
          tooltip = false;
          on-click = "";
        };
        "sway/window" = {
          format = "{}";
          max-length = 64;
          on-click = "";
        };
        "niri/window" = {
          format = "{}";
        };
        "custom/uptime" = {
          format = "{}";
          return-type = "";
          interval = 10;
          exec = "${pkgs.coreutils}/bin/uptime | ${pkgs.gnused}/bin/sed 's/^.* up \\+\\(.\\+\\), \\+[0-9] user.*$/\\1/' | ${pkgs.gnused}/bin/sed 's/  / /g'";
          on-click = "";
        };
        backlight = {
          device = "intel_backlight";
          format = "{percent}%";
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          on-click = "";
        };
        pulseaudio = {
          format = "{volume}%";
          format-muted = "muted";
          scroll-step = 5;
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        battery = {
          format = "{capacity}% {time}h";
          format-time = "{H:02}:{M:02}";
          on-click = "";
          states = {
            warning = 30;
            critical = 15;
          };
        };
        clock = {
          interval = 1;
          format = "{:%F %H:%M:%S}";
          on-click = "";
        };
        tray = {
          icon-size = 30;
          spacing = 8;
        };
      };
      topBar = {
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [
          "custom/notifs"
          "idle_inhibitor"
          "privacy"
          "custom/load"
          "cpu"
          "memory"
        ];
        modules-right = [
          "power-profiles-daemon"
          "temperature"
          "disk#root"
          "disk#home"
          "network#wlp59s0"
          "network#wl0"
          "network#enp58s0u1u4"
        ];
        "sway/workspaces" = {
          all-outputs = false;
          format = "{index}";
          disable-scroll = false;
          disable-click = false;
          enable-bar-scroll = false;
          numeric-first = true;
        };
        "custom/load" = {
          format = "{}";
          exec = "${pkgs.coreutils}/bin/echo -n \"Load \"; ${pkgs.coreutils}/bin/cat /proc/loadavg | ${pkgs.coreutils}/bin/cut -f1-3 -d' '";
          interval = 5;
          on-click = "";
        };
        cpu = {
          interval = 1;
          format = "CPU {usage}%";
          max-length = 10;
          on-click = "";
        };
        memory = {
          interval = 30;
          format = "RAM: {used:0.1f}G/{total:0.1f}G";
          on-click = "";
        };
        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon5/temp1_input";
          critical-threshold = 90;
          format-critical = "HOT {temperatureC}°C";
          format = "{temperatureC}°C";
          on-click = "";
        };
        "disk#root" = {
          interval = 30;
          format = "{path}: {percentage_used}%";
          path = "/";
          on-click = "";
        };
        "disk#home" = {
          interval = 30;
          format = "{path}: {percentage_used}%";
          path = "/home";
          on-click = "";
        };
        "network#wl0" = {
          interface = "w*";
          format = "{ifname}: {ipaddr}";
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "{ifname}";
          format-disconnected = "";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          on-click = "";
        };
        "network#wlp59s0" = {
          interface = "wlp59s0";
          format = "{ifname}: {ipaddr}";
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "{ifname}";
          format-disconnected = "";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          on-click = "";
        };
        "network#enp58s0u1u4" = {
          interface = "enp58s0u1u4";
          format = "{ifname}: {ipaddr} {bandwidthUpBits} up, {bandwidthDownBits} down";
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "{ifname}: {ipaddr}";
          format-disconnected = "{ifname}: disconnected";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          on-click = "";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰛐";
            deactivated = "󰛑";
          };
          on-click = "";
        };
        "custom/notifs" = {
          format = "{icon}";
          format-icons = {
            notification = "󰅸";
            none = "󰂜";
            dnd-none = "󱏪";
            dnd-notification = "󱏨";
          };
          tooltip = false;
          return-type = "json";
          exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
          on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          on-click-middle = "${pkgs.swaynotificationcenter}/bin/swaync-client -C";
          escape = true;
        };
        power-profiles-daemon = {
          format = "{profile}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
        };
        privacy = {
          icon-spacing = 4;
          icon-size = 10;
          transition-duration = 100;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-in";
              tooltip = true;
              tooltip-icon-size = 24;
            }
          ];
        };
      };
    };

    style = pkgs.replaceVars ./waybar.css {
      font = config.gtk.font.name;
    };
  };
}
