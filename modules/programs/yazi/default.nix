{
  pkgs,
  localLib,
  ...
}: let
  _7z = pkgs._7zip-zstd-rar;
  _7zPermissions = combinators:
    with combinators; [
      mount-cwd
    ];
  _7zJailedPackages =
    ["7z" "7za" "7zr" "7zz"]
    |> map (bin: localLib.jail.pkg bin _7z _7zPermissions);

  yazi = pkgs.yazi.override {
    _7zz = localLib.jail.bin "7zz" _7z _7zPermissions;
  };
in {
  environment.systemPackages =
    [yazi]
    ++ _7zJailedPackages;

  my.xdgDirectSymlinks.config.yazi = localLib.path.join "programs/yazi" [
    "./yazi.toml"
    "./keymap.toml"
    "./theme.toml"
    "./package.toml"
    "./init.lua"
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
