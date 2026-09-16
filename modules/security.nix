{
  pkgs,
  lib,
  ...
}: {
  security.polkit = {
    enable = true;
    enablePkexecWrapper = true;
  };
  security.sudo-rs.enable = true;

  programs.gnupg.agent.enable = true;

  systemd.user.services.lxqt-polkit = {
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    environment = {
      QT_PLUGIN_PATH = lib.makeSearchPath "lib/qt-6/plugins" [
        pkgs.qt6Packages.qt6ct
        pkgs.klassy
      ];
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = lib.getExe pkgs.lxqt.lxqt-policykit;
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit

    snapper
    btrfs-assistant
  ];
}
