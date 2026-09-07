{
  inputs,
  pkgsQt610,
  ...
}: {
  nixpkgs.overlays = [
    (import ./mpv.nix)
    (import ./pinentry-qt.nix)
    (import ./qutebrowser.nix pkgsQt610)
    inputs.apple-emoji-nix.overlays.default
  ];
}
