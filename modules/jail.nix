{
  pkgs,
  lib,
  localLib,
  config,
  ...
}: let
  cfg = config.my.jail;

  basePath = name: "$XDG_RUNTIME_DIR/h2jc/${name}";
  fifoPath = name: "${basePath name}/fifo";

  # runs on the host and forwards args via fifo:
  jailTx = name:
    pkgs.writeShellScriptBin name ''
      fifo="${fifoPath name}"

      if [[ ! -p "$fifo" ]]; then
        echo "no jail listening on $fifo" >&2
        exit 1
      fi

      printf "%s\0" "$#" "$@" > "$fifo"
    '';

  # runs inside the jail and executes args from fifo:
  jailRx = name: jailCfg:
    localLib.jail.bin "${name}-jail-rx" jailCfg.package (
      combinators:
        (jailCfg.permissions combinators)
        ++ (with combinators; [
          (add-runtime
            # bash
            ''
              mkdir -p "${basePath name}"
              fifo="${fifoPath name}"
              if [[ ! -p "$fifo" ]]; then
                mkfifo "$fifo"
              fi
            '')
          (add-cleanup
            # bash
            ''
              rm -rf "${basePath name}"
            '')
          (readonly (noescape "\"${basePath name}\""))
          (wrap-entry (entry:
            # bash
            ''
              fifo="${fifoPath name}"
              while [[ -p "$fifo" ]]; do
                readarray -d "" -t args < "$fifo"
                set -- "''${args[@]}"
                shift # skip count prefix
                echo "Executing: " ${entry} >&2
                ${entry} &
              done
            ''))
        ])
    );
in {
  options = {
    my.jail = lib.options.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
        options = {
          enable = lib.mkEnableOption "jail for ${name}";
          package = lib.options.mkPackageOption pkgs name {};
          bootstrapService = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  example = true;
                };
              };
            };
          };
          permissions = lib.mkOption {
            type = lib.types.anything;
            example =
              lib.literalExpression
              # nix
              ''
                combinators:
                  with combinators; [
                  ]
              '';
          };
        };
      }));
    };
  };

  config = {
    environment.systemPackages =
      cfg
      |> lib.filterAttrs (_: jailCfg: jailCfg.enable)
      |> lib.mapAttrsToList (
        name: jailCfg:
          if jailCfg.bootstrapService.enable
          then
            pkgs.symlinkJoin {
              name = "${jailCfg.package.name}-jail-tx";
              paths = [
                (jailTx name)
                jailCfg.package
              ];
            }
          else (localLib.jail.pkg name jailCfg.package jailCfg.permissions)
      );

    systemd.user.services =
      cfg
      |> lib.filterAttrs (_: jailCfg: jailCfg.enable && jailCfg.bootstrapService.enable)
      |> lib.concatMapAttrs (name: jailCfg: {
        "${lib.toLower name}-jail" = {
          enable = true;
          wantedBy = ["default.target"];
          path = ["/run/current-system/sw"];
          serviceConfig = {
            Type = "exec";
            ExecStart = lib.getExe (jailRx name jailCfg);
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      });
  };
}
