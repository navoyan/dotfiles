{
  pkgs,
  localLib,
  ...
}: let
  qbittorrentJailed = localLib.jail.pkg "qbittorrent" pkgs.qbittorrent (combinators:
    with combinators; [
      network
      qt
      gpu
      notifications
      xdg-desktop-portal
      tray
      (cleanup-lockfile (noescape "~/.config/qBittorrent/lockfile"))

      (readwrite (noescape "~/.config/qBittorrent"))
      (readwrite (noescape "~/.local/share/qBittorrent"))

      (readwrite (noescape "~/Downloads"))
      (readwrite (noescape "~/Data/Videos"))
      (readwrite (noescape "~/Data/Games"))
      (readwrite (noescape "~/Games"))
    ]);
in {
  environment.systemPackages = [qbittorrentJailed];
}
