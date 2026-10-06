{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [
    pkgs.adwaita-icon-theme
  ];

  hj.xdg.data.files = {
    "icons/default/index.theme" = {
      generator = lib.generators.toINI {};
      value = {
        "Icon Theme".Inherits = "Adwaita";
      };
    };
  };
}
