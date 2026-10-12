{
  config,
  pkgs,
  ...
}: let
  scriptsDir = "${config.programs.nh.flake}/modules/programs/steam/scripts";

  scoperun = pkgs.writeShellApplication {
    name = "scoperun";
    runtimeInputs = with pkgs; [
      gamescope
      mangohud
    ];
    text = ''
      exec "${scriptsDir}/scoperun.sh" "$@"
    '';
  };

  wlrun = pkgs.writeShellApplication {
    name = "wlrun";
    runtimeInputs = with pkgs; [
      gamescope
      mangohud
    ];
    text = ''
      exec "${scriptsDir}/wlrun.sh" "$@"
    '';
  };
in {
  programs.steam.extraPackages = [
    scoperun
    wlrun
  ];
}
