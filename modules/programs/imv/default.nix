{
  my.jail.imv = {
    enable = true;
    bootstrapService.enable = true;
    permissions = combinators:
      with combinators; [
        gui
        gpu

        (readonly (noescape "~/.config/imv"))

        (readonly (noescape "~/Downloads"))
        (readonly (noescape "~/Pictures"))
        (readonly (noescape "~/Documents"))
      ];
  };

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
