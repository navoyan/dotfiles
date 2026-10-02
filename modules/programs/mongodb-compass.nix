{
  my.jail.mongodb-compass = {
    enable = true;
    bootstrapService.enable = true;
    permissions = combinators:
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
      ];
  };
}
