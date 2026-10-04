{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.usbmuxd.enable = true;

  hardware.keyboard.zsa.enable = true;

  programs.coolercontrol.enable = true;

  programs.librepods.enable = true;
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    gparted
    nvtopPackages.amd
    alsa-utils

    keymapp
  ];
}
