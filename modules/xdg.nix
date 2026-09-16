{
  config,
  lib,
  ...
}: let
  base = "${config.programs.nh.flake}/modules";

  xdgDirs = ["config" "data" "cache" "state"];
in {
  options = let
    sourceType = lib.types.oneOf [
      lib.types.str
      (lib.types.listOf lib.types.str)
    ];

    xdgDirOption = lib.mkOption {
      type = lib.types.attrsOf sourceType;
      default = {};
    };
  in {
    my.xdgDirectSymlinks = lib.genAttrs xdgDirs (_: xdgDirOption);
  };

  config = let
    mkEntry = programName: source:
      if builtins.isString source
      then [
        (lib.nameValuePair programName {
          source = "${base}/${source}";
        })
      ]
      else
        source
        |> map (rel: let
        in (lib.nameValuePair "${programName}/${baseNameOf rel}" {
          source = "${base}/${rel}";
        }));
  in {
    hj.xdg = lib.genAttrs xdgDirs (
      xdgDir: {
        files =
          config.my.xdgDirectSymlinks.${xdgDir}
          |> lib.mapAttrsToList mkEntry
          |> lib.concatLists
          |> lib.listToAttrs;
      }
    );
  };
}
