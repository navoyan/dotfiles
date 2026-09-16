{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    neovim
    neovim-remote

    tree-sitter

    bash-language-server
    helm-ls
    lua-language-server
    nixd
    ruff
    rustup
    tombi
    typescript-language-server
    typos
    vscode-json-languageserver
    yaml-language-server

    alejandra
    biome
    nixfmt-rs
    stylua

    shellcheck
  ];

  my.xdgDirectSymlinks.config.nvim = "programs/nvim";

  hj.environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
  };

  hj.xdg.mime-apps = {
    added-associations = {
      "application/json" = "nvim.desktop";
    };
    default-applications = {
      "application/json" = "nvim.desktop";
      "text/*" = "nvim.desktop";
    };
  };
}
