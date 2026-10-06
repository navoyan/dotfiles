{combinators, ...}:
with combinators; {
  gtk = compose [
    gui

    (fwd-env "GTK_THEME")
    (readonly (noescape "~/.local/share/themes"))
  ];
}
