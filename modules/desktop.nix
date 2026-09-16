{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.apple-emoji-nix.overlays.default
  ];

  services.displayManager.ly.enable = true;

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
    wl-clipboard
    handlr-regex
    (lib.hiPrio (
      writeShellScriptBin "xdg-open" ''
        exec ${handlr-regex}/bin/handlr open "$@"
      ''
    ))

    hyprpicker
    xwininfo

    awww
    cliphist
    swayidle
  ];
}
