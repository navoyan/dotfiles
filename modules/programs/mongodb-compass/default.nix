{
  pkgs,
  localLib,
  ...
}: {
  environment.systemPackages = [pkgs.mongodb-compass];

  my.xdgDirectSymlinks.data.applications = localLib.path.join "programs/mongodb-compass" [
    "./mongodb-compass.desktop"
  ];
}
