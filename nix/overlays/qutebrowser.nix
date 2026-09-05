pkgsQt610: final: prev: {
  # use qutebrowser with qt-6.10.2 dependencies:
  qutebrowser = pkgsQt610.qutebrowser.overrideAttrs (old: {
    qtWrapperArgs =
      (old.qtWrapperArgs or [])
      ++ [
        "--suffix"
        "QT_PLUGIN_PATH"
        ":"
        "${pkgsQt610.qtengine}/lib/qt-6/plugins"
      ];
  });
}
