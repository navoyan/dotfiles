pkgs: builtinCombinators:
with builtinCombinators; {
  cleanup-lockfile = path:
    add-runtime
    #bash
    ''
      lockfile=${escape path}
      [[ -f "$lockfile" ]] && exit
      trap 'rm -f "$lockfile"' EXIT
    '';
}
