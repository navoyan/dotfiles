{
  pkgs,
  localLib,
  ...
}: let
  mongodbCompassJailed = localLib.jail.pkg "mongodb-compass" pkgs.mongodb-compass (combinators:
    with combinators; [
      network
      gtk
      gpu
      xdg-desktop-portal
      secrets

      (wrap-entry (entry: ''
        ${entry} --ignore-additional-command-line-flags --password-store="gnome-libsecret"
      ''))

      (readwrite (noescape "~/.config/'MongoDB Compass'"))
      (rw-bind (noescape "~/.local/state/mongodb-compass") (noescape "~/.mongodb/compass"))

      (readonly (noescape "~/Downloads"))
      (readonly (noescape "~/projects"))
    ]);
in {
  environment.systemPackages = [mongodbCompassJailed];
}
