{
  pkgs,
  localLib,
  ...
}: {
  environment.systemPackages = [pkgs.ungoogled-chromium];

  my.xdgDirectSymlinks.data.applications = localLib.path.join "programs/chromium" [
    "./google-meet.desktop"
  ];
}
