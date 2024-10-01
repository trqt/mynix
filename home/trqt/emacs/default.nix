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
        package = pkgs.emacs-pgtk; # replace with pkgs.emacsPgtk, or another version if desired.
        config = ./init.el;
        defaultInitFile = pkgs.substituteAll {
          name = "default.el";
          src = ./init.el;
          inherit (config.xdg) configHome dataHome;
        };
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
    defaultEditor = true;
    socketActivation.enable = false;
  };

  # LSP Servers and whanot
  home.packages = with pkgs; [
    # c
    clang-tools
    # rust
    rust-analyzer
    # haskell
    haskell-language-server
    # Go
    gopls
    # python
    ruff
    python312Packages.python-lsp-server
    python312Packages.python-lsp-ruff
  ];
}
