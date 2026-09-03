{
  pkgs,
  inputs,
  ...
}:
let
  pkgsQt610 = import inputs.nixpkgs-qt6-10 {
    system = pkgs.stdenv.hostPlatform.system;
  };
in
{
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  programs.steam.enable = true;

  programs.spicetify = {
    enable = true;
    theme = {
      name = "Sleek";
      src = ../../config/spicetify/Themes/Sleek;
      injectCss = true;
      injectThemeJs = true;
      replaceColors = true;
      homeConfig = true;
      overwriteAssets = false;
    };
  };

  environment.systemPackages =
    let
      qutebrowserPinned = pkgsQt610.qutebrowser.overrideAttrs (old: {
        qtWrapperArgs = (old.qtWrapperArgs or [ ]) ++ [
          "--suffix"
          "QT_PLUGIN_PATH"
          ":"
          "${pkgsQt610.qtengine}/lib/qt-6/plugins"
        ];
      });
      mpvGit = pkgs.mpv.override {
        mpv-unwrapped = pkgs.mpv-unwrapped.overrideAttrs (old: {
          version = "unstable-2026-08-23";
          src = pkgs.fetchFromGitHub {
            owner = "mpv-player";
            repo = "mpv";
            rev = "654e9382c0bbccb09ccac348f792e9d378e9c7a9";
            hash = "sha256-2oPLH6ewbMp8Y/HK+Kpm5qVcvK2BO7C+XUmqI/wnRaI=";
          };
          doInstallCheck = false;
          postPatch = pkgs.lib.concatStringsSep "\n" [
            # Don't reference compile time dependencies or create a build outputs cycle between out and dev
            ''
              substituteInPlace meson.build \
                --replace-fail "conf_data.set_quoted('CONFIGURATION', meson.build_options().strip().replace('\\\\', '\\\\\\\\'))" \
                               "conf_data.set_quoted('CONFIGURATION', '<omitted>')"
            ''
            # A trick to patchShebang everything except mpv_identify.sh
            ''
              pushd TOOLS
              mv mpv_identify.sh mpv_identify
              patchShebangs *.py *.sh
              mv mpv_identify mpv_identify.sh
              popd
            ''
          ];
        });
      };
    in
    with pkgs;
    [
      qutebrowserPinned
      ungoogled-chromium

      mpvGit
      mpv-handler
      imv
      telegram-desktop
      qbittorrent
      obs-studio
      drawy
      (zathura.override {
        useMupdf = true;
      })
      (discord.override {
        withVencord = true;
      })
    ];
}
