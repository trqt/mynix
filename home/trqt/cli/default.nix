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
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = ''
      vim.o.undofile      = true
      vim.o.clipboard     = "unnamedplus"
      vim.o.laststatus    = 0
      vim.opt.expandtab   = true
      vim.opt.shiftwidth  = 4
      vim.opt.softtabstop = -1
      vim.cmd("syntax off | colorscheme retrobox")
      vim.keymap.set('n', '<space>y', function() vim.fn.setreg('+', vim.fn.expand('%:p')) end)
      vim.keymap.set("n", "<space>c", function() vim.ui.input({}, function(c) if c and c~="" then 
      vim.cmd("noswapfile vnew") vim.bo.buftype = "nofile" vim.bo.bufhidden = "wipe"
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.systemlist(c)) end end) end)
    '';
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "ayu_dark";
      editor = {
        color-modes = true;
        soft-wrap.enable = true;
      };
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

  programs.git = {
    enable = true;
    difftastic.enable = true;
    lfs.enable = true;

    extraConfig = {
      push = {
        autoSetupRemote = true;
        followTags = true;
      };
      init.defaultBranch = "master";
    };
  };

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
