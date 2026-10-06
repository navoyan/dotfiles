{
  pkgs,
  combinators,
  ...
}:
with combinators; {
  xdg-open = compose [
    (add-pkg-deps [
      (pkgs.writeShellScriptBin "xdg-open" ''
        exec xdgopenchannel "$1"
      '')
    ])
    (jail-to-host-channel "xdgopenchannel"
      # bash
      ''
        xdg-open "$1"
      '')
  ];
}
