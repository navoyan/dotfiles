{
  pkgs,
  lib,
  user,
  ...
}: let
  jailDevDir = "/run/jail/gaming/dev";
in {
  systemd.mounts = [
    {
      what = "tmpfs";
      where = jailDevDir;
      type = "tmpfs";
      options = "mode=0755,size=1m,noexec,nosuid";
      wantedBy = ["local-fs.target"];
      before = ["systemd-udevd.service" "systemd-udev-trigger.service"];
    }
  ];

  systemd.tmpfiles.rules = [
    "d ${jailDevDir}/.stage 0700 root root -"

    "d ${jailDevDir}/dri   0755 root root -"
    "d ${jailDevDir}/input 0755 root root -"
    # mountpoint only, the jail mounts its own private tmpfs on it:
    "d ${jailDevDir}/shm   1777 root root -"

    "c+ ${jailDevDir}/null    0666 root root - 1:3"
    "c+ ${jailDevDir}/zero    0666 root root - 1:5"
    "c+ ${jailDevDir}/full    0666 root root - 1:7"
    "c+ ${jailDevDir}/random  0666 root root - 1:8"
    "c+ ${jailDevDir}/urandom 0666 root root - 1:9"
    "c+ ${jailDevDir}/tty     0666 root root - 5:0"

    "L+ ${jailDevDir}/fd     - - - - /proc/self/fd"
    "L+ ${jailDevDir}/stdin  - - - - /proc/self/fd/0"
    "L+ ${jailDevDir}/stdout - - - - /proc/self/fd/1"
    "L+ ${jailDevDir}/stderr - - - - /proc/self/fd/2"
  ];

  # make sure nothing that touches the tmpfs runs before it is mounted:
  systemd.services = {
    systemd-tmpfiles-setup.unitConfig.RequiresMountsFor = jailDevDir;
    systemd-udevd.unitConfig.RequiresMountsFor = jailDevDir;
    systemd-udev-trigger.unitConfig.RequiresMountsFor = jailDevDir;
  };

  services.udev.extraRules = let
    mirror = lib.getExe (pkgs.writeShellApplication {
      name = "jail-gaming-dev-mirror";
      inheritPath = false;
      runtimeInputs = [pkgs.coreutils];
      text = ''
        action=$1; dir=$2; name=$3
        stage=${jailDevDir}/.stage
        case "$action" in
          add)
            # to be extra safe:
            mkdir --mode 0700 "$stage"
            mkdir --mode 0755 "$dir"

            rm --force -- "$stage/$name"
            mknod --mode 0600 "$stage/$name" c "$MAJOR" "$MINOR"
            chown ${user}:root "$stage/$name"
            mv --force --no-target-directory -- "$stage/$name" "$dir/$name"
            ;;
          remove)
            rm --force -- "$dir/$name"
            ;;
        esac
      '';
    });
  in
    # udev
    ''
      # gpu:
      # DEVTYPE can be either "drm_minor" (real device node) or "drm_connector" (e.g. card0-HDMI-A-1)
      SUBSYSTEM=="drm", ENV{DEVTYPE}=="drm_minor", KERNEL=="renderD[0-9]*", ACTION=="add",    RUN+="${mirror} add    ${jailDevDir}/dri %k"
      SUBSYSTEM=="drm", ENV{DEVTYPE}=="drm_minor", KERNEL=="card[0-9]*",    ACTION=="add",    RUN+="${mirror} add    ${jailDevDir}/dri %k"
      SUBSYSTEM=="drm", ENV{DEVTYPE}=="drm_minor",                          ACTION=="remove", RUN+="${mirror} remove ${jailDevDir}/dri %k"


      # uinput:
      # NOTE: gives access to creating virtual inputs, needed for Steam Input.
      # Allows jailed process to feed device inputs into system,
      # but there seem to be no workarounds:
      SUBSYSTEM=="misc", KERNEL=="uinput", ACTION=="add",    RUN+="${mirror} add    ${jailDevDir} %k"
      SUBSYSTEM=="misc", KERNEL=="uinput", ACTION=="remove", RUN+="${mirror} remove ${jailDevDir} %k"

      # ntsync for Proton performance:
      SUBSYSTEM=="misc", KERNEL=="ntsync", ACTION=="add",    RUN+="${mirror} add    ${jailDevDir} %k"
      SUBSYSTEM=="misc", KERNEL=="ntsync", ACTION=="remove", RUN+="${mirror} remove ${jailDevDir} %k"

      # any gamepad input:
      SUBSYSTEM=="input", KERNEL=="event[0-9]*|js[0-9]*", ENV{ID_INPUT_JOYSTICK}=="1", ACTION=="add", RUN+="${mirror} add ${jailDevDir}/input %k"

      # any motion sensor:
      SUBSYSTEM=="input", KERNEL=="event[0-9]*", ENV{ID_INPUT_ACCELEROMETER}=="1",                      ACTION=="add", RUN+="${mirror} add ${jailDevDir}/input %k"
      # DualSense touchpad (<bus>:054c:0ce6:<iid>):
      SUBSYSTEM=="input", KERNEL=="event[0-9]*", ENV{ID_INPUT_TOUCHPAD}=="1", KERNELS=="*:054C:0CE6.*", ACTION=="add", RUN+="${mirror} add ${jailDevDir}/input %k"

      # cleanup input:
      SUBSYSTEM=="input", KERNEL=="event[0-9]*|js[0-9]*", ACTION=="remove", RUN+="${mirror} remove ${jailDevDir}/input %k"


      # DualSense hidraw (<bus>:054c:0ce6:<iid>):
      SUBSYSTEM=="hidraw", KERNELS=="*:054C:0CE6.*", ACTION=="add", RUN+="${mirror} add ${jailDevDir} %k"

      # cleanup hidraw:
      SUBSYSTEM=="hidraw", ACTION=="remove", RUN+="${mirror} remove ${jailDevDir} %k"
    '';
}
