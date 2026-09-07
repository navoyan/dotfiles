{pkgs, ...}: {
  services.displayManager.ly.enable = true;
  programs.niri.enable = true;

  programs.waybar.enable = true;
  systemd.user.services.waybar.path = ["/run/current-system/sw"];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-termfilechooser
    ];
  };

  xdg.terminal-exec = {
    enable = true;
    settings.default = ["kitty.desktop"];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      nerd-fonts.jetbrains-mono
      apple-emoji-nix
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans"];
        emoji = ["Apple Color Emoji"];
        monospace = ["JetBrainsMono Nerd Font"];
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

  environment.systemPackages = with pkgs; [
    libxkbcommon
    wl-clipboard
    xwayland-satellite
    handlr-regex
    (lib.hiPrio (
      writeShellScriptBin "xdg-open" ''
        exec ${handlr-regex}/bin/handlr open "$@"
      ''
    ))

    adwaita-icon-theme
    klassy
    qtengine

    (rofi.override {
      plugins = [rofi-calc];
    })
    rofi-rbw-wayland
    hyprpicker

    awww
    cliphist
    swayidle
    swaynotificationcenter
  ];
}
