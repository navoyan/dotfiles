{pkgs, ...}: {
  environment.systemPackages = [pkgs.libxkbcommon];

  my.xdgDirectSymlinks.config.xkb = "programs/xkb";
}
