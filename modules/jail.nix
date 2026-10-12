{
  pkgs,
  lib,
  localLib,
  config,
  ...
}: let
  enabledJails = config.my.jail |> lib.filterAttrs (_: jailCfg: jailCfg.enable);
  bootstrappedJails = enabledJails |> lib.filterAttrs (_: jailCfg: jailCfg.bootstrapService.enable);

  # connects to the jail socket and passes argv
  jailTx = jailName:
    pkgs.writeShellScriptBin jailName ''
      ${pkgs.s6}/bin/s6-sudo "$XDG_RUNTIME_DIR/h2jc/${jailName}/sock" "$@"
    '';

  # serves connections accepted on the jail socket:
  jailRx = jailName: jailCfg:
    localLib.jail.bin "${jailName}-jail-rx" jailCfg.package (
      combinators:
        (jailCfg.permissions combinators)
        ++ (with combinators; [
          (add-pkg-deps [pkgs.s6])
          (wrap-entry (entry:
            # bash
            ''
              handler() {
                ${entry}
              }
              export -f handler

              exec s6-ipcserverd -c 8 \
                s6-sudod "$BASH" -c 'handler "$@"' handler
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
      [
        pkgs.bubblewrap # for man pages and tricks
      ]
      ++ (enabledJails
        |> lib.mapAttrsToList (
          jailName: jailCfg:
            if jailCfg.bootstrapService.enable
            then
              pkgs.symlinkJoin {
                name = "${jailCfg.package.name}-jail-tx";
                paths = [
                  (jailTx jailName)
                  jailCfg.package
                ];
              }
            else (localLib.jail.pkg jailName jailCfg.package jailCfg.permissions)
        ));

    systemd.user.sockets =
      bootstrappedJails
      |> lib.concatMapAttrs (jailName: _: {
        "${lib.toLower jailName}-jail" = {
          wantedBy = ["sockets.target"];
          socketConfig = {
            ListenStream = "%t/h2jc/${jailName}/sock";
            Accept = false;
            SocketMode = "0600";
            DirectoryMode = "0700";
          };
        };
      });

    systemd.user.services =
      bootstrappedJails
      |> lib.concatMapAttrs (jailName: jailCfg: {
        "${lib.toLower jailName}-jail" = {
          enable = true;
          wantedBy = ["graphical-session.target"];
          path = ["/run/current-system/sw"];
          serviceConfig = {
            Type = "exec";
            StandardInput = "socket";
            ExecStart = lib.getExe (jailRx jailName jailCfg);
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      });

    # derive fake machine-id from host /etc/machine-id:
    systemd.services.jail-fake-machine-id = {
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = [pkgs.coreutils];
      script = ''
        mkdir -p /run/jail
        echo "jail:$(< /etc/machine-id)" | sha256sum | cut -c1-32 > /run/jail/fake-machine-id
      '';
    };
  };
}
