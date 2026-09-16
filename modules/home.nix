{
  inputs,
  lib,
  user,
  config,
  ...
}: {
  imports = [
    inputs.hjem.nixosModules.default
    (lib.mkAliasOptionModule ["hj"] ["hjem" "users" user])
  ];

  hj.directory = "/home/${user}";

  programs.nh.flake = "${config.hj.directory}/dotfiles";

  services.snapper.configs = {
    home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = [user];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = 10;
      TIMELINE_LIMIT_DAILY = 7;
      TIMELINE_LIMIT_WEEKLY = 1;
      TIMELINE_LIMIT_MONTHLY = 0;
      TIMELINE_LIMIT_YEARLY = 0;
    };
  };
}
