{
  pkgs,
  localLib,
  ...
}: let
  discord = pkgs.discord.override {
    withVencord = true;
  };

  permissions = combinators:
    with combinators; [
      network
      gui
      gpu
      xdg-open
      xdg-desktop-portal
      notifications
      tray

      # otherwise refuses to start despite running natively on wayland:
      xwayland

      (readwrite (noescape "~/.config/discord"))
      (readwrite (noescape "~/.config/Vencord"))

      (readonly (noescape "~/Downloads"))
      (readonly (noescape "~/Pictures"))
    ];

  discordJailed = localLib.jail.pkg "Discord" discord permissions;
in {
  environment.systemPackages = [discordJailed];

  my.xdgDirectSymlinks.config.Vencord = localLib.path.join "programs/discord" [
    "./themes"
  ];
}
