{pkgs, ...}: {
  environment.systemPackages = [pkgs.bat];

  my.xdgDirectSymlinks.config.bat = "programs/bat";
}
