{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.wayland.windowManager.niri;
in
rec {
  meta.maintainers = [ lib.hm.maintainers."9p4" ];

  options.wayland.windowManager.niri = {
    enable = mkEnableOption "the niri";

    configFile = mkOption {
      type = types.path;
      default = null;
      description = ''
        Path to config file. If set, this will override settings and extraConfig
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.niri;
      defaultText = literalExpression "pkgs.niri";
      description = "niri package to use.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [ cfg.package ];

      # Creating an empty file on empty configuration is desirable, otherwise swayrd will create the file on startup.
      xdg.configFile."niri/config.kdl" = {
        source = cfg.configFile;
      };
    }
  ]);
}
