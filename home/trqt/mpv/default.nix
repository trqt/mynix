{
  config,
  pkgs,
  ...
}:
{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      ytdl-format = "bestvideo[height<=?720]+bestaudio/best";
    };
  };
}
