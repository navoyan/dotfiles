{pkgs, ...}: {
  my.jail.Telegram = {
    enable = true;
    bootstrapService.enable = true;
    package = pkgs.telegram-desktop;
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
  };
}
