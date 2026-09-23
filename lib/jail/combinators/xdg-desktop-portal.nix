pkgs: builtinCombinators:
with builtinCombinators; {
  xdg-desktop-portal = dbus {
    talk = ["org.freedesktop.portal.Desktop"];
  };
}
