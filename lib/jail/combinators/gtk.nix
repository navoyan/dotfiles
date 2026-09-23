pkgs: builtinCombinators:
with builtinCombinators; {
  gtk = compose [
    gui

    (fwd-env "GTK_THEME")
    (readonly (noescape "~/.local/share/themes"))

    (add-pkg-deps [pkgs.adwaita-icon-theme])
    (readonly "/run/current-system/sw/share/icons")
  ];
}
