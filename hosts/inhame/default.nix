{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes";

      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
      #use-xdg-base-directories = true;
    };
  };

  boot = {
    tmp.useTmpfs = true;
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    loader.systemd-boot = {
      enable = true;
    };
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "inhame";
    nameservers = [
      "::1"
      "127.0.0.1"
    ];
    firewall = {
      enable = true;
      allowPing = false;
    };
    dhcpcd.enable = false; # do not plays well with iwd
    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          EnableNetworkConfiguration = true;
          AddressRandomization = "network";
        };
        Network = {
          NameResolvingService="resolvconf";
        };
      };
    };
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = false;
      require_dnssec = true;
      max_clients = 500;
      ignore_system_dns = true;

      listen_addresses = [
        "127.0.0.1:53"
        "[::1]:53"
      ];

      bootstrap_resolvers = [
        "9.9.9.11:53"
        "45.90.30.232:53"
      ];

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  time.timeZone = "America/Sao_Paulo";

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];

  security.apparmor = {
    enable = true;
    enableCache = true;
    # add profiles and whatever
  };
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      mpv = {
        executable = "${lib.getBin pkgs.mpv}/bin/mpv";
        profile = "${pkgs.firejail}/etc/firejail/mpv.profile";
      };
      imv = {
        executable = "${lib.getBin pkgs.imv}/bin/imv";
        profile = "${pkgs.firejail}/etc/firejail/imv.profile";
      };
      zathura = {
        executable = "${lib.getBin pkgs.zathura}/bin/zathura";
        profile = "${pkgs.firejail}/etc/firejail/zathura.profile";
      };
      qutebrowser = {
        executable = "${lib.getBin pkgs.qutebrowser}/bin/qutebrowser";
        profile = "${pkgs.firejail}/etc/firejail/qutebrowser.profile";
      };
      palemoon-bin = {
        executable = "${lib.getBin pkgs.palemoon-bin}/bin/palemoon";
        profile = "${pkgs.firejail}/etc/firejail/palemoon.profile";
      };
    };
  };

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.udisks2.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware = {
    bluetooth.enable = false;
    pulseaudio.enable = false;
    graphics = {
      enable = true;
      # extraPackages = with pkgs; [
      #   vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      # ];
    };
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # wayland

  programs.fish.enable = true;
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
  users.users.trqt = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "networkmanager"
    ];
  };

  fonts = {
    packages = with pkgs; [
      twemoji-color-font
      ibm-plex
      noto-fonts-cjk
      noto-fonts-emoji
      libertinus
      material-symbols
      geist-font
      (nerdfonts.override {
        fonts = [
          "FantasqueSansMono"
          "JetBrainsMono"
        ];
      })
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [
          "FantasqueSansM Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "IBM Plex Sans"
          "Noto Color Emoji"
        ];
        serif = [
          "IBM Plex Serif"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  zramSwap.enable = true;

  programs.light.enable = true;
  programs.dconf.enable = true;

  system.stateVersion = "24.05";
}
