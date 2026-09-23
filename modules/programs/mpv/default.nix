{
  pkgs,
  localLib,
  ...
}: let
  overlay = self: super: {
    # use unreleased git version:
    mpv-unwrapped = super.mpv-unwrapped.overrideAttrs (old: {
      version = "v0.41.0-UNKNOWN";
      src = self.fetchFromGitHub {
        owner = "mpv-player";
        repo = "mpv";
        rev = "654e9382c0bbccb09ccac348f792e9d378e9c7a9";
        hash = "sha256-2oPLH6ewbMp8Y/HK+Kpm5qVcvK2BO7C+XUmqI/wnRaI=";
      };
      postPatch = self.lib.concatStringsSep "\n" [
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

  thirdPartyScripts = import ./_3rd-party-scripts.nix {inherit pkgs;};

  mpv = pkgs.mpv.override {
    scripts = [
      thirdPartyScripts.mfpbar
      thirdPartyScripts.thumbfast
      thirdPartyScripts.thumbyt
      pkgs.mpvScripts.sponsorblock-minimal
    ];
  };

  mpvHandler = pkgs.mpv-handler.override {
    inherit mpv;
  };

  permissions = combinators:
    with combinators; [
      gui
      gpu

      (add-pkg-deps [
        # for thumbyt:
        pkgs.curl
        pkgs.ffmpeg
      ])

      # rust-script:
      (add-pkg-deps [
        pkgs.rustup
        pkgs.gcc
        pkgs.rust-script
      ])
      (fwd-env "RUSTUP_HOME")
      (fwd-env "CARGO_HOME")
      (readwrite (noescape "~/.local/share/rustup"))
      (readwrite (noescape "~/.local/share/cargo"))
      (readwrite (noescape "~/.cache/rust-script"))

      # mpv dirs:
      (readonly (noescape "~/.config/mpv"))
      (readwrite (noescape "~/.cache/mpv"))
      (readwrite (noescape "~/.local/state/mpv"))

      # media dirs:
      (readwrite (noescape "~/Downloads"))
      (readwrite (noescape "~/Data/Videos"))
      (readwrite (noescape "~/Games"))
    ];

  permissionsWithNetwork = combinators: (permissions combinators) ++ [combinators.network];

  mpvJailed = localLib.jail.pkg "mpv" mpv permissions;
  mpvDlJailed = localLib.jail.bin "mpv-dl" mpv permissionsWithNetwork;
  mpvHandlerJailed = localLib.jail.pkg "mpv-handler" mpvHandler permissionsWithNetwork;
in {
  nixpkgs.overlays = [overlay];

  environment.systemPackages = [
    mpvJailed
    mpvDlJailed
    mpvHandlerJailed
  ];

  my.xdgDirectSymlinks.config.mpv = "programs/mpv";
}
