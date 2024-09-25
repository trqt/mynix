{
  config,
  pkgs,
  ...
}:
{
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 13;
  };

  gtk = {
    enable = true;
    cursorTheme.name = config.home.pointerCursor.name;
    cursorTheme.package = config.home.pointerCursor.package;
    theme = {
      name = "Orchis-Compact";
      package = pkgs.orchis-theme;
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-size = config.home.pointerCursor.size;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "slight";
      gtk-xft-antialias = 1; # => font-antialiasing="grayscale"
      gtk-xft-rgba = "rgb"; # => font-rgb-order="rgb"
    };
  };
}
