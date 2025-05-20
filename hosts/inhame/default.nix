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

  nixpkgs.config.allowUnfree = true;
  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
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
          NameResolvingService = "resolvconf";
        };
      };
    };
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
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
        "[2620:fe::fe]:53"
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

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware = {
    bluetooth.enable = false;
    graphics = {
      enable = true;
      enable32Bit = true;
      # extraPackages = with pkgs; [
      #   vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      # ];
    };
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # wayland
  environment.localBinInPath = true;

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
  programs.command-not-found.enable = false; # get rid of the annoying error

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

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
      noto-fonts-cjk-sans
      noto-fonts-emoji
      freefont_ttf
      libertinus
      geist-font
      ibm-plex
      dejavu_fonts
      noto-fonts
      unifont
      merriweather
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.jetbrains-mono
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
