{
  inputs,
  config,
  pkgs,
  lib,
  system,
  ...
}: let
  linuwuxVersion = "26.09.28.4";
  linuwuxSo = pkgs.fetchurl {
    url = "https://github.com/brcly/linuwux-runtime/releases/download/v${linuwuxVersion}/LinUwUx.so";
    hash = "sha256-KvPM4ng4KHJoi4UkA/lrf6+Hdr1B2qLXW9RenYO5mtk=";
  };
  linuwux = pkgs.writeShellScriptBin "linuwux" ''
    export PROTON_DISABLE_LSTEAMCLIENT=0
    export LD_PRELOAD="${linuwuxSo}''${LD_PRELOAD:+:$LD_PRELOAD}"
    exec "$@"
  '';
in {
  environment.systemPackages = with pkgs; [
    goverlay
    protonplus
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    package = pkgs.steam.override (let
      slsSteam = inputs.sls-steam.packages.${system}.sls-steam;
    in {
      extraEnv = {
        LD_AUDIT = "${slsSteam}/library-inject.so:${slsSteam}/SLSsteam.so";
        PROTON_USE_NTSYNC = "1";
      };
    });
    extraPackages = with pkgs; [
      adwaita-icon-theme
      (lib.hiPrio (
        pkgs.writeShellScriptBin "xdg-open" ''
          exec xdgopenchannel "$1"
        ''
      ))

      gamescope
      mangohud
      linuwux
    ];
  };

  services.sunshine = {
    enable = true;
    openFirewall = true;
    autoStart = false;
  };

  my.jail.steam = {
    enable = true;
    bootstrapService.enable = false;
    package = config.programs.steam.package;
    permissions = combinators:
      with combinators; [
        (persist-home "steam")

        network
        gui
        xwayland
        xdg-open
        xdg-desktop-portal
        notifications
        tray

        (wrap-entry (entry: ''
          exec ${entry} --pipewire-dmabuf
        ''))

        (dbus {
          own = ["com.steampowered.*"];
          talk = ["org.freedesktop.ScreenSaver"];
        })

        # `/dev` directory with limited devices, managed by custom udev rules.
        # See: ./gaming-dev-tmpfs.nix
        (unsafe-dev-bind "/run/jail/gaming/dev" "/dev")
        (tmpfs "/dev/shm")

        # gpu userspace stack:
        (runtime-deep-ro-bind (noescape "/run/opengl-driver"))
        (runtime-deep-ro-bind (noescape "/run/opengl-driver-32"))

        # hardware information for GPU discovery and MangoHud (flatpak defaults):
        (readonly "/sys/block")
        (readonly "/sys/bus")
        (readonly "/sys/dev")
        (readonly "/sys/devices")
        (readonly "/sys/class")

        (readonly "/run/udev")

        # some (only native?) games require this:
        fake-machine-id
        # for hardware survey:
        (readonly "/etc/os-release")

        (readwrite (noescape "~/.local/share/Steam"))
        (readwrite (noescape "~/Data/Steam"))
        (readwrite (noescape "~/Games"))
        (readwrite (noescape "~/Data/Games"))

        # SLSsteam:
        (readwrite (noescape "~/.config/SLSsteam"))

        # mangohud:
        (readonly (noescape "~/.config/MangoHud/MangoHud.conf"))
      ];
  };

  hj.files = {
    "Steam".source = "${config.hj.directory}/.local/share/Steam";
  };
}
