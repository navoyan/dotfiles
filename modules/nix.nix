{
  nix.channel.enable = false;
  nix.settings = {
    use-xdg-base-directories = true;
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
