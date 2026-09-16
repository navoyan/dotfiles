{pkgs, ...}: {
  environment.systemPackages = [pkgs.lazygit];

  my.xdgDirectSymlinks.config.lazygit = "programs/lazygit";
}
