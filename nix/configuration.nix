# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
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
    ./hardware-configuration.nix
    ./user.nix
    inputs.spicetify-nix.nixosModules.default
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    it87
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu = {
      overdrive.enable = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  networking = {
    networkmanager.enable = true;
    wireless.enable = true;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];

    hostName = "nixos";
    hosts = {
      "192.168.49.2" = [
        "minikube.localhost"
        "minikube.info"
        "api.minikube.info"
        "grafana.minikube.info"
      ];
    };
  };
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "true";
      Domains = [ "~." ];
      DNSOverTLS = "true";
      FallbackDNS = [
        "1.1.1.1"
        "1.0.0.1"
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Yerevan";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  security.polkit = {
    enable = true;
    enablePkexecWrapper = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3; # options: pinentry-qt, pinentry-gtk2, pinentry-gnome3, pinentry-curses
    # enableSSHSupport = true;
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.snapper.configs = {
    home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = [ "narek" ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = 10;
      TIMELINE_LIMIT_DAILY = 7;
      TIMELINE_LIMIT_WEEKLY = 1;
      TIMELINE_LIMIT_MONTHLY = 0;
      TIMELINE_LIMIT_YEARLY = 0;
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "kitty.desktop" ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-termfilechooser
    ];
  };

  services.displayManager.ly.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
      polkit_gnome
      pinentry-gnome3

      snapper

      xwayland-satellite
      libxkbcommon
      wl-clipboard
      handlr-regex
      (lib.hiPrio (
        pkgs.writeShellScriptBin "xdg-open" ''
          exec ${pkgs.handlr-regex}/bin/handlr open "$@"
        ''
      ))
      xwininfo

      qtengine
      klassy
      adwaita-icon-theme

      kitty
      neovim
      neovim-remote
      page
      tree-sitter

      moreutils
      jq
      fd
      bat
      delta
      ripgrep
      gettext
      dust
      just
      stow
      fzf
      zoxide
      fishPlugins.tide
      rbw
      hydra-check
      cliphist
      libnotify
      tealdeer
      tokei
      rust-script
      bind
      inetutils

      lazygit
      fastfetch
      wiremix
      yazi
      libqalculate
      btop
      nvtopPackages.amd
      claude-code

      hyprpicker
      awww
      swayidle

      qutebrowserPinned
      ungoogled-chromium

      (rofi.override {
        plugins = [ rofi-calc ];
      })
      rofi-rbw-wayland
      swaynotificationcenter
      blueman
      mpvGit
      mpv-handler
      imv
      (zathura.override {
        useMupdf = true;
      })
      (discord.override {
        withVencord = true;
      })
      telegram-desktop
      qbittorrent
      gparted
      obs-studio
      drawy

      gcc
      gdb

      nixd
      lua-language-server
      bash-language-server
      ruff
      typescript-language-server
      vscode-json-languageserver
      yaml-language-server
      helm-ls
      tombi
      typos

      nixfmt-rs
      stylua
      biome

      prek
      shellcheck

      # work-specific:
      mongodb-compass
      (google-cloud-sdk.withExtraComponents [
        pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
      ])
      velero
      minikube
      (lib.hiPrio # otherwise minikube kubectl is used
        kubectl
      )
      kubectl-view-secret
      kubectx
      k9s
      kubernetes-helm
    ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      nerd-fonts.jetbrains-mono
      apple-emoji-nix
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        emoji = [ "Apple Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    silent = true;
  };

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      claude = {
        executable = "${pkgs.claude-code}/bin/claude";
      };
      Telegram = {
        executable = "${pkgs.telegram-desktop}/bin/Telegram";
      };
    };
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      }
    ];
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  };
  services.envfs.enable = true;

  programs.niri.enable = true;

  programs.waybar.enable = true;
  systemd.user.services.waybar.path = [ "/run/current-system/sw" ];

  programs.librepods.enable = true;
  services.blueman.enable = true;

  virtualisation.docker.enable = true;

  services.netbird.enable = true;

  programs.steam.enable = true;

  programs.coolercontrol.enable = true;

  programs.spicetify = {
    enable = true;
    theme = {
      name = "Sleek";
      src = ../.config/spicetify/Themes/Sleek;
      injectCss = true;
      injectThemeJs = true;
      replaceColors = true;
      homeConfig = true;
      overwriteAssets = false;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05";
}
