pkgs: builtinCombinators: let
  imports = [
    (import ./cleanup-lockfile.nix pkgs builtinCombinators)
    (import ./xdg-desktop-portal.nix pkgs builtinCombinators)
    (import ./gtk.nix pkgs builtinCombinators)
    (import ./open-urls-in-browser.nix pkgs builtinCombinators)
    (import ./qt.nix pkgs builtinCombinators)
    (import ./secrets.nix pkgs builtinCombinators)
    (import ./tray.nix pkgs builtinCombinators)
    (import ./xdg-runtime.nix pkgs builtinCombinators)
  ];
in
  builtins.foldl' (acc: x: acc // x) {} imports
