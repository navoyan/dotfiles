{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.rofi.override {
      plugins = [pkgs.rofi-calc];
    })
  ];

  my.xdgDirectSymlinks.config.rofi = "programs/rofi";
}
