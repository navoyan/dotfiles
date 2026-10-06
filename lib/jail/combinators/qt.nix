{
  pkgs,
  combinators,
  ...
}:
with combinators; {
  qt = compose [
    gui

    (add-pkg-deps [pkgs.kdePackages.breeze-icons])

    (add-pkg-deps [pkgs.qt6Packages.qt6ct pkgs.klassy])
    (fwd-env "QT_QPA_PLATFORM")
    (fwd-env "QT_QPA_PLATFORMTHEME")
    (readonly (noescape "~/.config/qt6ct"))
    (readonly (noescape "~/.config/klassy"))
    (readonly (noescape "~/.local/share/color-schemes"))
  ];
}
