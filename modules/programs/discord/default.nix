{localLib, ...}: {
  my.jail.vesktop = {
    enable = true;
    bootstrapService.enable = true;
    permissions = combinators:
      with combinators; [
        network
        gui
        gpu
        xdg-open
        xdg-desktop-portal
        notifications

        tray
        (dbus {
          # to own `org.freedesktop.StatusNotifierItem-<pid>-<n>`:
          own = ["org.freedesktop.*"];
        })

        (readwrite (noescape "~/.config/vesktop"))

        (readonly (noescape "~/Downloads"))
        (readonly (noescape "~/Pictures"))
      ];
  };

  my.xdgDirectSymlinks.config.vesktop = localLib.path.join "programs/discord" [
    "./themes"
  ];
}
