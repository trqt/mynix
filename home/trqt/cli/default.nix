{
  config,
  pkgs,
  ...
}:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      set -g fish_key_bindings fish_vi_key_bindings
    '';
    shellAliases = {
      zt = "zathura";
      gdb = "gdb -q -n -x $XDG_CONFIG_HOME/gdb/init";
      pgdb = "gdb -q -n -x $XDG_CONFIG_HOME/gdb/pwninit";
      yt264 = "yt-dlp -S 'codec:h264,res:720'";

      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -iv";
    };
  };

  # Add stuff for your user as you see fit:
  programs.neovim = {
    enable = true;
    #defaultEditor = true;
    plugins = [
            #pkgs.vimPlugins.nvim-treesitter
            #pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
    viAlias = true;
  };

  programs.git.enable = true;
  programs.go = {
    enable = true;
    goPath = ".local/share/go";
    goBin = ".local/bin.go";
  };

  programs.eza = {
    enable = true;
    icons = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      rounded_corners = true;
    };
  };

  programs.fd.enable = true;
  programs.ripgrep.enable = true;
}
