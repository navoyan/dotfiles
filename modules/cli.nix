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
    eza
    fastfetch
    fd
    gettext
    hydra-check
    jq
    libnotify
    moreutils
    nix-index
    rbw
    ripgrep
    tealdeer
    tokei
  ];
}
