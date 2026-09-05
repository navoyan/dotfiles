{pkgs, ...}: {
  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    silent = true;
  };
  programs.zoxide = {
    enable = true;
    flags = ["--cmd j"];
  };
  programs.fzf.keybindings = true;

  environment.systemPackages = with pkgs; [
    kitty

    yazi

    bat
    bind
    btop
    delta
    dust
    fd
    fishPlugins.tide
    fzf
    gettext
    hydra-check
    inetutils
    jq
    libnotify
    libqalculate
    moreutils
    rbw
    ripgrep
    tealdeer
    tokei
    xwininfo
  ];
}
