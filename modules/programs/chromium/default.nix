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

        # for webhid/webusb, should be relatively safe with
        # chromium's permission system and my usecases for chromium:
        (unsafe-dev "/dev")
        (readonly "/sys/bus/usb")
        (readonly "/sys/class/hidraw")
        (readonly "/sys/class/input")
        (readonly "/sys/devices")

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
