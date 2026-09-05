{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  programs.steam.enable = true;

  programs.spicetify = {
    enable = true;
    theme = {
      name = "Sleek";
      src = ../../config/spicetify/Themes/Sleek;
      injectCss = true;
      injectThemeJs = true;
      replaceColors = true;
      homeConfig = true;
      overwriteAssets = false;
    };
  };

  environment.systemPackages = with pkgs; [
    (qutebrowser.override {
      withPdfReader = false;
    })
    ungoogled-chromium

    drawy
    imv
    mpv
    mpv-handler
    obs-studio
    qbittorrent
    telegram-desktop
    (zathura.override {
      useMupdf = true;
    })
    (discord.override {
      withVencord = true;
    })
  ];
}
