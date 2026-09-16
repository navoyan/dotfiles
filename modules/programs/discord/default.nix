{
  pkgs,
  localLib,
  ...
}: {
  environment.systemPackages = [
    (pkgs.discord.override {
      withVencord = true;
    })
  ];

  my.xdgDirectSymlinks.config.Vencord = localLib.path.join "programs/discord" [
    "./themes"
  ];
}
