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
    inputs.nur.repos.ilya-fedin.overlays.qt6ct
  ];
}
