{
  pkgs,
  jail-nix,
  ...
}: rec {
  bin = jail-nix.lib.extend {
    inherit pkgs;

    additionalCombinators = import ./combinators pkgs;
    basePermissions = combinators:
      with combinators; [
        # defaults:
        base
        bind-nix-store-runtime-closure
        fake-passwd

        # essential env:
        (fwd-env "USER")
        (fwd-env "XDG_CURRENT_DESKTOP")
        (fwd-env "NIXOS_OZONE_WL")

        # bash:
        (add-pkg-deps [pkgs.bash])
        (ro-bind "${pkgs.bash}/bin/bash" "/bin/bash")
        (ro-bind "${pkgs.coreutils}/bin/env" "/usr/bin/env")

        # locale:
        (add-pkg-deps [pkgs.glibcLocales])
        (set-env "LOCALE_ARCHIVE" "${pkgs.glibcLocales}/lib/locale/locale-archive")

        # configs:
        (readonly (noescape "~/dotfiles"))
      ];
  };

  pkg = name: pkg: permissions:
    pkgs.symlinkJoin {
      inherit (pkg) name;
      paths = [
        (bin name pkg permissions)
        pkg
      ];
    };
}
