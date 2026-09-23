pkgs: builtinCombinators:
with builtinCombinators; {
  xdg-runtime = file:
    try-readwrite (noescape "\"$XDG_RUNTIME_DIR/${file}\"");
}
