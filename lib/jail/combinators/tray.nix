pkgs: builtinCombinators:
with builtinCombinators; {
  tray = dbus {
    talk = ["org.kde.StatusNotifierWatcher"];
  };
}
