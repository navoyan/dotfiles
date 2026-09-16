{pkgs, ...}: let
  overlay = self: super: {
    # replace light variant icons with dark variants:
    pinentry-qt = super.pinentry-qt.overrideAttrs (old: {
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
  };
in {
  nixpkgs.overlays = [overlay];

  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;

  environment.systemPackages = [pkgs.pinentry-qt];
}
