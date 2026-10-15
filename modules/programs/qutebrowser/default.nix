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

          # GL drivers (radeonsi_dri.so):
          "--set"
          "LIBGL_DRIVERS_PATH"
          "${pkgsQt610.mesa}/lib/dri"

          # VA-API video decode (radeonsi_drv_video.so):
          "--set"
          "LIBVA_DRIVERS_PATH"
          "${pkgsQt610.mesa}/lib/dri"

          # make libglvnd's EGL use the pinned Mesa, not /run/opengl-driver:
          "--set"
          "__EGL_VENDOR_LIBRARY_FILENAMES"
          "${pkgsQt610.mesa}/share/glvnd/egl_vendor.d/50_mesa.json"
        ];
    });
  };

  thirdPartyScripts = {
    ytAdsBypass = pkgs.fetchurl {
      url = "https://update.greasyfork.org/scripts/575941/1836031/YouTube%20Ads-Bypass.user.js";
      hash = "sha256-SdANPGG210MgZo6FZO0REUuzA6rBTHGbuQ7s8wEHUDA=";
    };
    removeYtShorts = pkgs.fetchurl {
      url = "https://update.greasyfork.org/scripts/522057/1865541/Remove%20YouTube%20Shorts.user.js";
      hash = "sha256-HAOh7QQm4SXT9X+fJ1x4paa2+P0KXoznZMm8Dxmd6gs=";
    };
  };
in {
  nixpkgs.overlays = [overlay];

  my.jail.qutebrowser = {
    enable = true;
    bootstrapService.enable = true;
    package = pkgs.qutebrowser.override {
      withPdfReader = false;
    };
    permissions = combinators:
      with combinators; [
        network
        qt
        gpu
        xdg-open
        xdg-desktop-portal
        notifications

        (add-pkg-deps [
          thirdPartyScripts.ytAdsBypass
          thirdPartyScripts.removeYtShorts
        ])

        (dbus {
          own = [
            "org.mpris.MediaPlayer2.chromium.*"
            "org.mpris.MediaPlayer2.qutebrowser.*"
          ];
        })

        (readwrite (noescape "~/.config/qutebrowser"))
        (readwrite (noescape "~/.cache/qutebrowser"))
        (readwrite (noescape "~/.local/share/qutebrowser"))

        (readwrite (noescape "~/Downloads"))
        (readwrite (noescape "~/Documents"))
        (readwrite (noescape "~/Pictures"))

        ## integrations:

        # mpv:
        (jail-to-host-channel "mpv"
          # bash
          ''
            mime=$(handlr mime "$1" --json | jq -r '.[0].mime')
            if [[ "$mime" =~ ^x-scheme-handler/http(s)?$ ]]; then
              mpv-dl "$1"
            fi
          '')

        # kitty:
        (add-pkg-deps [pkgs.kitty])
        (readonly (noescape "~/.config/kitty"))
        (readwrite (noescape "~/.cache/kitty"))

        # nvim:
        (add-pkg-deps [pkgs.neovim pkgs.git])
        (readonly (noescape "~/.config/nvim"))
        (readwrite (noescape "~/.cache/nvim"))
        (readonly (noescape "~/.local/share/nvim"))
        (readonly (noescape "~/vaults"))

        # yazi:
        (add-pkg-deps [pkgs.yazi])
        (readonly (noescape "~/.config/yazi"))
        (readwrite (noescape "~/.cache/yazi"))
      ];
  };

  my.xdgDirectSymlinks.config.qutebrowser = localLib.path.join "programs/qutebrowser" [
    "./config.py"
    "./tokyonight.py"
    "./jseval"
    "./content.css"
    "./greasemonkey"
  ];

  hj.xdg.data.files = {
    "qutebrowser/greasemonkey/yt_ads_bypass.js".source = thirdPartyScripts.ytAdsBypass;
    "qutebrowser/greasemonkey/remove_yt_shorts.js".source = thirdPartyScripts.removeYtShorts;
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
