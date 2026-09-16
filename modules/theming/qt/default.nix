{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.nur.repos.ilya-fedin.overlays.qt6ct
  ];

  environment.systemPackages = with pkgs; [
    qt6Packages.qt6ct
    klassy
    kdePackages.breeze-icons
  ];

  hj.environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };

  my.xdgDirectSymlinks = let
    base = "theming/qt";
  in {
    config.qt6ct = "${base}/qt6ct";
    config.klassy = "${base}/klassy";
    data.color-schemes = "${base}/color-schemes";
  };
}
