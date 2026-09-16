{pkgs, ...}: rec {
  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = with boot.kernelPackages; [
    it87
  ];
}
