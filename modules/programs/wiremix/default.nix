{
  pkgs,
  localLib,
  ...
}: {
  environment.systemPackages = [pkgs.wiremix];

  my.xdgDirectSymlinks = {
    config.wiremix = localLib.path.join "programs/wiremix" [
      "./wiremix.toml"
    ];
    data.applications = localLib.path.join "programs/wiremix" [
      "./wiremix.desktop"
    ];
  };
}
