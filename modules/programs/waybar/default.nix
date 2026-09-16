{
  programs.waybar.enable = true;
  systemd.user.services.waybar.path = ["/run/current-system/sw"];

  my.xdgDirectSymlinks.config.waybar = "programs/waybar";
}
