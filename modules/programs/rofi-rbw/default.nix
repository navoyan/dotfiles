{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.rbw
    pkgs.rofi-rbw-wayland
  ];

  my.xdgDirectSymlinks.config."rofi-rbw.rc" = "programs/rofi-rbw/rofi-rbw.rc";
}
