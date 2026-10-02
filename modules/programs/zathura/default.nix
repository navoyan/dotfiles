{pkgs, ...}: {
  my.jail.zathura = {
    enable = true;
    bootstrapService.enable = true;
    package = pkgs.zathura.override {
      useMupdf = true;
    };
    permissions = combinators:
      with combinators; [
        gui
        gpu
        xdg-open

        (readwrite (noescape "~/.config/zathura"))
        (readwrite (noescape "~/.local/share/zathura"))

        (readonly (noescape "~/Downloads"))
        (readonly (noescape "~/Documents"))
      ];
  };

  my.xdgDirectSymlinks.config.zathura = "programs/zathura";

  hj.xdg.mime-apps.default-applications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
  };
}
