{
  pkgs,
  localLib,
  ...
}: let
  chromium = pkgs.ungoogled-chromium;

  permissions = combinators:
    with combinators; [
      network
      gui
      gpu
      xdg-desktop-portal
      notifications
      camera

      (readwrite (noescape "~/.config/chromium"))
      (readwrite (noescape "~/.cache/chromium"))

      (readwrite (noescape "~/Downloads"))
      (readwrite (noescape "~/Documents"))
      (readwrite (noescape "~/Pictures"))
    ];

  chromiumJailed = localLib.jail.pkg "chromium" chromium permissions;
in {
  environment.systemPackages = [chromiumJailed];

  my.xdgDirectSymlinks.data.applications = localLib.path.join "programs/chromium" [
    "./google-meet.desktop"
  ];
}
