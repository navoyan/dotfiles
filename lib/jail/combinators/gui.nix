{
  config,
  pkgs,
  builtinCombinators,
  combinators,
  ...
}:
with combinators; {
  gui = compose [
    builtinCombinators.gui

    (add-pkg-deps [pkgs.adwaita-icon-theme])
    (readonly "/run/current-system/sw/share/icons")

    (add-pkg-deps [config.hj.xdg.data.files."icons/default/index.theme".source])
    (readonly (noescape "~/.local/share/icons/default"))
  ];
}
