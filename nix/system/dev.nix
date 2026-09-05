{pkgs, ...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

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
    neovim
    neovim-remote
    page
    tree-sitter
    lazygit

    rustup
    rust-script

    gcc
    gdb

    bash-language-server
    helm-ls
    lua-language-server
    nixd
    ruff
    tombi
    typescript-language-server
    typos
    vscode-json-languageserver
    yaml-language-server

    alejandra
    biome
    stylua

    prek
    shellcheck

    # work-specific:
    claude-code
    codegraph
    kubectl
    mongodb-compass
  ];
}
