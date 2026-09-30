{
  pkgs,
  localLib,
  ...
}: let
  permissions = combinators:
    with combinators; [
      network
      qt
      gpu
      xdg-open
      xdg-desktop-portal
      tray

      (readwrite (noescape "~/.local/share/TelegramDesktop"))

      (readonly (noescape "~/Downloads"))
      (readonly (noescape "~/Pictures"))
    ];

  telegramJailed = localLib.jail.pkg "Telegram" pkgs.telegram-desktop permissions;
in {
  environment.systemPackages = [telegramJailed];
}
