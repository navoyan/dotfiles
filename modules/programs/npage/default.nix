{pkgs, ...}: {
  environment.systemPackages = [pkgs.page];

  hj.environment.sessionVariables = {
    PAGER = "env NVIM_APPNAME=npage page -W -q 90000 -z 90000";
    MANPAGER = "env NVIM_APPNAME=npage nvim +Man!";
  };

  my.xdgDirectSymlinks.config.npage = "programs/npage";
}
