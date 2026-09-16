{pkgs, ...}: {
  environment.systemPackages = [pkgs.swaynotificationcenter];

  my.xdgDirectSymlinks.config.swaync = "programs/swaync";
}
