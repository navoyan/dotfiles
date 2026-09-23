pkgs: builtinCombinators:
with builtinCombinators; {
  open-urls-in-browser = compose [
    (add-pkg-deps [
      (pkgs.writeShellScriptBin "xdg-open" ''
        exec browserchannel "$1"
      '')
    ])
    (jail-to-host-channel "browserchannel" ''
      if [[ "$1" =~ ^https://|^http:// ]]; then
        xdg-open "$1"
      fi
    '')
  ];
}
