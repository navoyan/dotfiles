final: prev: {
  # replace light variant icons with dark variants:
  pinentry-qt = prev.pinentry-qt.overrideAttrs (old: {
    postPatch =
      (old.postPatch or "")
      +
      # bash
      ''
        for f in qt/icons/*_dark.svg; do
          dir=$(dirname "$f")
          base=$(basename "$f" _dark.svg)
          cp "$f" "$dir/$base.svg"
        done
      '';
  });
}
