{pkgs, ...}: {
  environment.systemPackages = [pkgs.imv];

  my.xdgDirectSymlinks.config.imv = "programs/imv";

  hj.xdg.mime-apps = {
    added-associations = {
      "image/*" = "imv.desktop";
    };
    default-applications = {
      "image/*" = "imv.desktop";
    };
  };
}
