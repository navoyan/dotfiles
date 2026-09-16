{pkgs, ...}: {
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    drawy
    libreoffice
    obs-studio
    telegram-desktop

    protonplus
  ];
}
