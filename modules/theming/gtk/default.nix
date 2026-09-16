{pkgs, ...}: {
  environment.systemPackages = [pkgs.adwaita-icon-theme];

  hj.environment.sessionVariables = {
    GTK_THEME = "TokyoNight";
  };

  my.xdgDirectSymlinks.data.themes = "theming/gtk/themes";
}
