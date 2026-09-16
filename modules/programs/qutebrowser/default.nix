{
  pkgs,
  pkgsQt610,
  localLib,
  ...
}: let
  overlay = self: super: {
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
  };
in {
  nixpkgs.overlays = [overlay];

  environment.systemPackages = [
    (pkgs.qutebrowser.override {
      withPdfReader = false;
    })
  ];

  hj.environment.sessionVariables = {
    BROWSER = "qutebrowser";
  };

  my.xdgDirectSymlinks.config.qutebrowser = localLib.path.join "programs/qutebrowser" [
    "./config.py"
    "./tokyonight.py"
    "./jseval"
    "./greasemonkey"
  ];

  hj.xdg.data.files = {
    "qutebrowser/greasemonkey/yt_ads_bypass.js".source = pkgs.fetchurl {
      url = "https://update.greasyfork.org/scripts/575941/1849507/YouTube%20Ads-Bypass.user.js";
      hash = "sha256-SdANPGG210MgZo6FZO0REUuzA6rBTHGbuQ7s8wEHUDA=";
    };
    "qutebrowser/greasemonkey/remove_yt_shorts.js".source = pkgs.fetchurl {
      url = "https://update.greasyfork.org/scripts/522057/1865541/Remove%20YouTube%20Shorts.user.js";
      hash = "sha256-HAOh7QQm4SXT9X+fJ1x4paa2+P0KXoznZMm8Dxmd6gs=";
    };
  };

  hj.xdg.mime-apps = {
    added-associations = {
      "x-scheme-handler/chrome" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/mailto" = "org.qutebrowser.qutebrowser.desktop";
    };
    default-applications = {
      "application/x-extension-html" = "org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-htm" = "org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-shtml" = "org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-xhtml" = "org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-xht" = "org.qutebrowser.qutebrowser.desktop";
      "application/xhtml+xml" = "org.qutebrowser.qutebrowser.desktop";
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/chrome" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/mailto" = "org.qutebrowser.qutebrowser.desktop";
    };
  };
}
