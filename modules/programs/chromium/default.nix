{
  pkgs,
  localLib,
  ...
}: {
  my.jail.chromium = {
    enable = true;
    bootstrapService.enable = true;
    package = pkgs.ungoogled-chromium;
    permissions = combinators:
      with combinators; [
        network
        gui
        gpu
        xdg-open
        xdg-desktop-portal
        notifications
        camera

        (readwrite (noescape "~/.config/chromium"))
        (readwrite (noescape "~/.cache/chromium"))

        (readwrite (noescape "~/Downloads"))
        (readwrite (noescape "~/Documents"))
        (readwrite (noescape "~/Pictures"))
      ];
  };

  my.xdgDirectSymlinks.data.applications = localLib.path.join "programs/chromium" [
    "./google-meet.desktop"
  ];
}
