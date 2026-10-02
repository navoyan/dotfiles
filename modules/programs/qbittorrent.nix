{
  my.jail.qbittorrent = {
    enable = true;
    bootstrapService.enable = true;
    permissions = combinators:
      with combinators; [
        network
        qt
        gpu
        notifications
        xdg-desktop-portal
        tray

        (readwrite (noescape "~/.config/qBittorrent"))
        (readwrite (noescape "~/.local/share/qBittorrent"))

        (readwrite (noescape "~/Downloads"))
        (readwrite (noescape "~/Data/Videos"))
        (readwrite (noescape "~/Data/Games"))
        (readwrite (noescape "~/Games"))
      ];
  };
}
