{
  pkgs,
  localLib,
  ...
}: let
  zathura = pkgs.zathura.override {
    useMupdf = true;
  };

  permissions = combinators:
    with combinators; [
      gui
      gpu
      open-urls-in-browser

      (readwrite (noescape "~/.config/zathura"))
      (readwrite (noescape "~/.local/share/zathura"))

      (readonly (noescape "~/Downloads"))
      (readonly (noescape "~/Documents"))
    ];

  zathuraJailed = localLib.jail.pkg "zathura" zathura permissions;
in {
  environment.systemPackages = [zathuraJailed];

  my.xdgDirectSymlinks.config.zathura = "programs/zathura";

  hj.xdg.mime-apps.default-applications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
  };
}
