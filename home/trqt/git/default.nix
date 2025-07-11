{
  config,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    difftastic.enable = true;
    lfs.enable = true;

    extraConfig = {
      branch = {
        sort = "-committerdate";
      };
      tag = {
        sort = "version:refname";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        rename = true;
      };
      push = {
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      init.defaultBranch = "master";
      help.autocorrect = "prompt";
    };
  };

  home.packages = with pkgs; [
    git-absorb

    jujutsu
    pijul
  ];
}
