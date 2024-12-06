{
  description = "trqt nix config";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      hardware,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        inhame = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          }; # Pass flake inputs to our config
          modules = [
            ./hosts/inhame
            hardware.nixosModules.lenovo-thinkpad-x230
          ];
        };
      };

      homeConfigurations = {
        "trqt@inhame" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./home/trqt ];
        };
      };
    };
}
