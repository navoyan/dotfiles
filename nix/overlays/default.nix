{
  inputs,
  pkgsQt610,
  ...
}: {
  nixpkgs.overlays = [
    (import ./mpv.nix)
    (import ./qutebrowser.nix pkgsQt610)
    inputs.apple-emoji-nix.overlays.default
  ];
}
