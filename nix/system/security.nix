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

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  systemd.user.services.lxqt-polkit = {
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    environment = {
      QT_PLUGIN_PATH = lib.makeSearchPath "lib/qt-6/plugins" [
        pkgs.qtengine
        pkgs.klassy
      ];
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      Telegram = {
        executable = "${pkgs.telegram-desktop}/bin/Telegram";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pinentry-qt
    lxqt.lxqt-policykit

    snapper
  ];
}
