{pkgs, ...}: {
  programs.zoxide = {
    enable = true;
    flags = ["--cmd j"];
  };

  environment.systemPackages = with pkgs; [
    btop
    libqalculate

    _7zip-zstd-rar
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
