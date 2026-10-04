{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  my.jail.spotify = {
    enable = true;
    bootstrapService.enable = true;
    package = config.programs.spicetify.spicedSpotify;
    permissions = combinators:
      with combinators; [
        network
        gui
        gpu
        xdg-open
        xdg-desktop-portal

        (dbus {
          own = ["org.mpris.MediaPlayer2.spotify"];
        })

        (readwrite (noescape "~/.cache/spotify"))
        (readwrite (noescape "~/.config/spotify"))
      ];
  };

  programs.spicetify.theme = {
    name = "Sleek";
    src = ./Themes/Sleek;
    injectCss = true;
    injectThemeJs = true;
    replaceColors = true;
    homeConfig = true;
    overwriteAssets = false;
  };
}
