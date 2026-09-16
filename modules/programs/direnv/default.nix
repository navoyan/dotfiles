{
  programs.direnv = {
    enable = true;
    silent = true;
  };

  my.xdgDirectSymlinks.config.direnv = "programs/direnv";
}
