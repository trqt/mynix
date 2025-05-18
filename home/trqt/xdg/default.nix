{
  config,
  pkgs,
  ...
}:
{
  xdg = {
    enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      configPackages = [ pkgs.niri ];
      config = {
        common = {
          default = [ "gnome" ];
           "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
        # sway = {
        #   default = [ "gtk" ];
        #   "org.freedesktop.impl.portal.Screencast" = [ "wlr" ];
        #   "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        # };
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      videos = "${config.home.homeDirectory}/media/vids";
      music = "${config.home.homeDirectory}/media/music";
      pictures = "${config.home.homeDirectory}/media/pics";

      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/downloads";

      #disabled
      templates = "${config.home.homeDirectory}";
      desktop = "${config.home.homeDirectory}";
      publicShare = "${config.home.homeDirectory}";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "librewolf.desktop" ];
        "text/xml" = [ "librewolf.desktop" ];
        "x-scheme-handler/http" = [ "librewolf.desktop" ];
        "x-scheme-handler/https" = [ "librewolf.desktop" ];
      };
    };
  };
}
