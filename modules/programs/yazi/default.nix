{
  pkgs,
  localLib,
  ...
}: {
  environment.systemPackages = [pkgs.yazi];

  my.xdgDirectSymlinks.config.yazi = localLib.path.join "programs/yazi" [
    "./yazi.toml"
    "./keymap.toml"
    "./theme.toml"
    "./package.toml"
    "./plugins/confirm-paste-force.yazi"
  ];

  hj.xdg.mime-apps = {
    added-associations = {
      "folder/local" = "yazi.desktop";
    };
    default-applications = {
      "folder/local" = "yazi.desktop";
      "inode/directory" = "yazi.desktop";
    };
  };
}
