{pkgs, ...}: {
  programs.zoxide = {
    enable = true;
    flags = ["--cmd j"];
  };

  environment.systemPackages = with pkgs; [
    btop
    libqalculate

    delta
    dust
    fastfetch
    fd
    gettext
    hydra-check
    jq
    libnotify
    moreutils
    rbw
    ripgrep
    tealdeer
    tokei
  ];
}
