{
  description = "NixOS config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-qt6-10.url = "github:nixos/nixpkgs/490a861fd99d76cfb6f86076c40a04bd07783628";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    apple-emoji-nix = {
      url = "github:oxcl/nix-flake-apple-emoji/ad1260acba5c30ab04ed9d3710d98d57a296d939";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.overlays = [ inputs.apple-emoji-nix.overlays.default ]; }
          ./configuration.nix
        ];
      };
    };
}
