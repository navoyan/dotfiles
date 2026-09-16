{
  pkgs,
  localLib,
  ...
}: {
  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    fishPlugins.tide
  ];

  my.xdgDirectSymlinks.config.fish = localLib.path.join "programs/fish" [
    "./config.fish"
    "./user_functions"
    "./themes"
  ];
}
