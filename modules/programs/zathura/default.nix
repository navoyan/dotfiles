{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.zathura.override {
      useMupdf = true;
    })
  ];

  my.xdgDirectSymlinks.config.zathura = "programs/zathura";

  hj.xdg.mime-apps.default-applications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
  };
}
