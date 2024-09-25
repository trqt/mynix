{
  config,
  pkgs,
  ...
}:
{
  programs.password-store = {
    enable = true;
    package = pkgs.gopass;
  };
  home.packages = with pkgs; [
    keepassxc
    age
  ];
}
