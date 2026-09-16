{inputs, ...}: {
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  programs.spicetify = {
    enable = true;
    theme = {
      name = "Sleek";
      src = ./Themes/Sleek;
      injectCss = true;
      injectThemeJs = true;
      replaceColors = true;
      homeConfig = true;
      overwriteAssets = false;
    };
  };
}
