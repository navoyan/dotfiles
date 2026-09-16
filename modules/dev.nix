{pkgs, ...}: {
  programs.nh.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  };
  services.envfs.enable = true;

  virtualisation.containers = {
    enable = true;
    containersConf.settings = {
      containers.pids_limit = 20480;
    };
  };
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  environment.systemPackages = with pkgs; [
    rustup
    rust-script

    gcc
    gdb
    gammaray

    prek
    shellcheck

    # work-specific:
    kubectl
  ];
}
