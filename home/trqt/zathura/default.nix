{
  config,
  pkgs,
  ...
}:
{
  programs.zathura = {
    enable = true;
    options = {
      database = "sqlite";
      zoom-center = "true";
    };
  };
}
