{
  inputs,
  #outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.self.homeManagerModules.niri

    ./gtk
    ./waybar
    ./niri
    ./foot
    ./xdg
    ./cli
    ./git
    ./mpv
    ./password-managers
    ./zathura
    ./sioyek
    ./emacs
  ];
  nixpkgs = {
    overlays = [
      inputs.emacs-overlay.overlays.default
    ];
    config = {
      allowUnfree = true;
      #allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = lib.mkDefault "trqt";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    brave
    vesktop
    qbittorrent # -enhanced
    calibre
    tor-browser
    ghidra
    gimp3
    libreoffice-qt6
    zotero
    librewolf-wayland
    qutebrowser

    libqalculate
    imv

    grim
    slurp
    wl-clipboard-rs
    xdg-utils
    pwvucontrol
    p7zip
    file
    appimage-run
    imagemagick

    yt-dlp
    #distrobox
    ledger

    hunspellDicts.pt_BR
    hunspellDicts.en_GB-ise
    enchant
    nuspell
    typst
    difftastic

    doggo
    tealdeer
    aria2
    libnotify
    newsraft
    tokei
    mprocs
    gdu

    wf-recorder
    ffmpeg

  ];
  home.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
    #SDL_VIDEODRIVER = "wayland,x11";
    MOZ_ENABLE_WAYLAND = 1;
    #WLR_RENDERER = "vulkan";
    GOPROXY = "direct";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = 14;
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
    _JAVA_AWT_WM_NONREPARENTING = 1;

    # xdg
    DOT_SAGE = "$XDG_CONFIG_HOME/sage";
    PYTHON_HISTORY = "$XDG_STATE_HOME/python/history";
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    SQLITE_HISTORY = "$XDG_CACHE_HOME/sqlite_history";
    GNUPGHOME = "$XDG_DATA_HOME/gnupg";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
