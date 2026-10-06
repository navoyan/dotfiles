{pkgs, ...}: let
  linuxPackages = pkgs.linuxPackages_latest;

  it87 = linuxPackages.it87.overrideAttrs (old: rec {
    version = "unstable-2026-10-07";
    name = "${old.pname}-${version}-${linuxPackages.kernel.version}";
    src = pkgs.fetchFromGitHub {
      owner = "frankcrawford";
      repo = "it87";
      rev = "bd7a566c8a60fe0308d67e26761e16260368191a";
      hash = "sha256-Xh882j0YK9RF+YqMoP7JydbSLmotxqMTUqF1pjZ6CVE=";
    };
  });
in {
  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = linuxPackages;
  boot.extraModulePackages = [it87];
}
