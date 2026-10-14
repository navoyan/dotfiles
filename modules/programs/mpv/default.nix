{
  config,
  pkgs,
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
        # bash
        ''
          substituteInPlace meson.build \
            --replace-fail "conf_data.set_quoted('CONFIGURATION', meson.build_options().strip().replace('\\\\', '\\\\\\\\'))" \
                           "conf_data.set_quoted('CONFIGURATION', '<omitted>')"
        ''
        # A trick to patchShebang everything except mpv_identify.sh
        # bash
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

  thirdPartyScripts = import ./_3rd-party-scripts.nix pkgs;

  mpv = pkgs.mpv.override {
    scripts = [
      thirdPartyScripts.mfpbar
      thirdPartyScripts.thumbfast
      thirdPartyScripts.thumbyt
      pkgs.mpvScripts.sponsorblock-minimal
    ];
  };

  detectLang = pkgs.writeShellApplication {
    name = "detect-lang";
    inheritPath = false;
    runtimeInputs = with pkgs; [
      cargo
      gcc
      rust-script
    ];
    text = ''
      exec "${config.programs.nh.flake}/modules/programs/mpv/detect_lang.rs" "$@"
    '';
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

      # detect-lang script:
      (add-pkg-deps [detectLang])
      (fwd-env "CARGO_HOME")
      (readwrite (noescape "~/.local/share/cargo"))
      (readwrite (noescape "~/.cache/rust-script"))

      # mpv dirs:
      (readonly (noescape "~/.config/mpv"))
      (readwrite (noescape "~/.cache/mpv"))
      (readwrite (noescape "~/.local/state/mpv"))

      # yt-dlp dirs:
      (readonly (noescape "~/.config/yt-dlp"))
      (readwrite (noescape "~/.cache/yt-dlp"))
      # browser cookies:
      (readwrite (noescape "~/.local/share/qutebrowser"))

      # media dirs:
      (readonly (noescape "~/Downloads"))
      (readonly (noescape "~/Data/Videos"))
      (readonly (noescape "~/Games"))

      # screenshots:
      (readwrite (noescape "~/Pictures/'MPV Screenshots'"))
    ];

  permissionsWithNetwork = combinators: (permissions combinators) ++ [combinators.network];
in {
  nixpkgs.overlays = [overlay];

  my.jail.mpv = {
    enable = true;
    bootstrapService.enable = true;
    package = mpv;
    inherit permissions;
  };

  my.jail.mpv-dl = {
    enable = true;
    bootstrapService.enable = false;
    package = mpv;
    permissions = permissionsWithNetwork;
  };

  my.jail.mpv-handler = {
    enable = true;
    bootstrapService.enable = false;
    package = pkgs.mpv-handler.override {
      inherit mpv;
    };
    permissions = permissionsWithNetwork;
  };

  my.xdgDirectSymlinks.config.mpv = "programs/mpv";
}
