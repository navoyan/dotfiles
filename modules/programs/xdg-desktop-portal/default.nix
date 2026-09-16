{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-termfilechooser
    ];
  };

  my.xdgDirectSymlinks.config.xdg-desktop-portal = "programs/xdg-desktop-portal";
}
