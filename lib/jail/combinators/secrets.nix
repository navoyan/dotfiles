pkgs: builtinCombinators:
with builtinCombinators; {
  secrets = dbus {
    talk = ["org.freedesktop.secrets"];
  };
}
