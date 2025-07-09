{
  config,
  pkgs,
  ...
}:
{
  programs.emacs = {
    enable = true;
    package = (
      pkgs.emacsWithPackagesFromUsePackage {
        package = pkgs.emacs-git-pgtk; # replace with pkgs.emacsPgtk, or another version if desired.
        config = ./init.el;
        defaultInitFile = true;
        alwaysEnsure = true;

        # Optionally provide extra packages not in the configuration file.
        extraEmacsPackages = epkgs: [
          epkgs.treesit-grammars.with-all-grammars
          epkgs.melpaPackages.telega
        ];
        #
        # Optionally override derivations.
        # override = epkgs: epkgs // {
        #   somePackage = epkgs.melpaPackages.somePackage.overrideAttrs(old: {
        #      # Apply fixes here
        #   });
        # };
      }
    );

  };

  services.emacs = {
    enable = true;
    startWithUserSession = "graphical";
    package = config.programs.emacs.package;
    client.enable = true;
    socketActivation.enable = false;
  };

  # LSP Servers and whanot
  home.packages = with pkgs; [
    # c
    clang-tools

    # Go
    gopls

    # python
    ruff
    basedpyright
    python313Packages.python-lsp-ruff

    # Typst
    tinymist
  ];
}
