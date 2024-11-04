{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./gtk
    ./sway
    ./foot
    ./xdg
    ./cli
    ./mpv
    ./password-managers
    ./zathura
    ./emacs
  ];

  nixpkgs = {
    overlays = [
      inputs.emacs-overlay.overlays.default
      inputs.nix-your-shell.overlays.default
    ];
    config = {
      #allowUnfree = true;
      #allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = lib.mkDefault "trqt";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;

  programs.newsboat.enable = true;

  programs.imv.enable = true;

  programs.librewolf.enable = true;
  
  programs.qutebrowser.enable = true;

  home.packages = with pkgs; [
    brave
    vesktop
    palemoon-bin
    qbittorrent # -enhanced
    calibre
    anki
    tor-browser
    ghidra

    libqalculate

    grim
    slurp
    wl-clipboard-rs
    xdg-utils
    pwvucontrol
    p7zip
    file

    yt-dlp
    #distrobox
    ledger

    hunspellDicts.pt_BR 
    hunspellDicts.en_GB-ise
    enchant
    nuspell
    typst

    doggo
    tealdeer
    aria2

    wl-screenrec
    ffmpeg

  ];
  home.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = 1;
    #WLR_RENDERER = "vulkan";
    GOPROXY = "direct";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = 14;
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
    _JAVA_AWT_WM_NONREPARENTING=1;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
