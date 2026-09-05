{
  inputs,
  pkgs,
  ...
}: let
  pkgsQt610 = import inputs.nixpkgs-qt6-10 {
    system = pkgs.stdenv.hostPlatform.system;
  };
in {
  nixpkgs.overlays = [
    (import ./mpv.nix)
    (import ./qutebrowser.nix pkgsQt610)
    inputs.apple-emoji-nix.overlays.default
  ];
}
