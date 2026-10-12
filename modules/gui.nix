{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    drawy
    libreoffice
    obs-studio

    iloader
  ];
}
