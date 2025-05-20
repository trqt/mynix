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
        
        if test -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1 
            niri-session
        end

    '';
    shellAbbrs = {
      ns = "nix shell";
      nd = "nix develop";
      nr = "nix run nixpkgs#";
    };
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
  programs.nix-your-shell.enable = true;
  programs.nushell.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.command-not-found.enable = false;

  # editors battle royale
  programs.vim.enable = true;

  programs.helix = {
    enable = true;
    settings = {
      theme = "ayu_dark";
      editor.color-modes = true;
    };
    languages = {
      language = [
        {
          name = "nix";
          language-servers = [
            "nixd"
            "nil"
          ];
          formatter.command = "nixfmt";
        }

        {
          name = "python";
          language-servers = [
            "ruff"
            "basedpyright"
          ];
        }

        {
          name = "typst";
          language-servers = [
            "tinymist"
          ];
        }
      ];
    };
  };

  programs.git.enable = true;
  programs.go = {
    enable = true;
    goPath = ".local/share/go";
    goBin = ".local/bin.go";
  };

  programs.eza = {
    enable = true;
    icons = "auto";
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

  programs.bash.historyFile = "$XDG_STATE_HOME/bash/history";
  programs.sagemath.dataDir = "$XDG_CONFIG_HOME/sage";
}
