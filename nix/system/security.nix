{pkgs, ...}: {
  security.polkit = {
    enable = true;
    enablePkexecWrapper = true;
  };
  security.sudo-rs.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt; # options: pinentry-qt, pinentry-gtk2, pinentry-gnome3, pinentry-curses
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
    pinentry-gnome3
    polkit_gnome

    snapper
  ];
}
