{
  description = "NixOS config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-qt6-10.url = "github:nixos/nixpkgs/490a861fd99d76cfb6f86076c40a04bd07783628";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";
    jail-nix.url = "sourcehut:~alexdavid/jail.nix";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sls-steam = {
      url = "github:AceSLS/SLSsteam";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-emoji-nix = {
      url = "github:oxcl/nix-flake-apple-emoji/ad1260acba5c30ab04ed9d3710d98d57a296d939";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-qt6-10,
    jail-nix,
    import-tree,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgsQt610 = import inputs.nixpkgs-qt6-10 {
      inherit system;
      overlays = [
        inputs.nur.repos.ilya-fedin.overlays.qt6ct
      ];
    };

    localLib = import ./lib {
      inherit jail-nix import-tree;
      inherit (nixosSystem) pkgs lib config;
    };

    nixosSystem = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit system inputs pkgsQt610 localLib;
        user = "narek";
      };
      modules = [
        (import-tree ./modules)
        (import-tree ./hosts/desktop)
      ];
    };
  in {
    nixosConfigurations.nixos-desktop = nixosSystem;
  };
}
