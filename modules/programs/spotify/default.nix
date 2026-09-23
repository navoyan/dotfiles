{
  inputs,
  config,
  localLib,
  ...
}: let
  spotify = config.programs.spicetify.spicedSpotify;

  permissions = combinators:
    with combinators; [
      (set-hostname config.networking.hostName)
      network
      gui
      gpu
      xdg-desktop-portal
      open-urls-in-browser

      (dbus {
        own = ["org.mpris.MediaPlayer2.spotify"];
      })

      (readwrite (noescape "~/.cache/spotify"))
      (readwrite (noescape "~/.config/spotify"))
    ];

  spotifyJailed = localLib.jail.pkg "spotify" spotify permissions;
in {
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  environment.systemPackages = [spotifyJailed];

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
