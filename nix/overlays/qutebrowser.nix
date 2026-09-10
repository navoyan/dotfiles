pkgsQt610: final: prev: {
  # use qutebrowser with qt-6.10.2 dependencies:
  # ISSUE: https://github.com/qutebrowser/qutebrowser/issues/8925
  qutebrowser = pkgsQt610.qutebrowser.overrideAttrs (old: {
    qtWrapperArgs =
      (old.qtWrapperArgs or [])
      ++ [
        "--suffix"
        "QT_PLUGIN_PATH"
        ":"
        "${pkgsQt610.qt6Packages.qt6ct}/lib/qt-6/plugins"
      ];
  });
}
