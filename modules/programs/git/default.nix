{localLib, ...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  my.xdgDirectSymlinks.config.git = localLib.path.join "programs/git" [
    "./config"
  ];
}
