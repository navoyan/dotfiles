{pkgs, ...}: {
  mfpbar = pkgs.mpvScripts.buildLua {
    pname = "mfpbar";
    version = "unstable-2026-09-11";

    scriptPath = "mfpbar/mfpbar.lua";
    src = pkgs.fetchFromCodeberg {
      owner = "NRK";
      repo = "mpv-toolbox";
      rev = "ca506127fe7a3f9235ead023d95c855f6c71c3d6";
      hash = "sha256-wDxfhPipWs6UlnjD8dXU9RxjQH9vSuK1LrOEtisyl3w=";
    };
  };

  thumbyt = pkgs.mpvScripts.buildLua {
    pname = "thumbyt";
    version = "unstable-2026-09-11";

    scriptPath = "thumbyt/thumbyt.lua";
    src = pkgs.fetchFromCodeberg {
      owner = "NRK";
      repo = "mpv-toolbox";
      rev = "ca506127fe7a3f9235ead023d95c855f6c71c3d6";
      hash = "sha256-wDxfhPipWs6UlnjD8dXU9RxjQH9vSuK1LrOEtisyl3w=";
    };
  };

  thumbfast = pkgs.mpvScripts.thumbfast.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "N-R-K";
      repo = "thumbfast";
      rev = "edbc294010bb0d7b3fc5f929c70c6f9b44132654";
      hash = "sha256-AQ28Nm+6SEELbFOa0PpCWWapcwwJ3G8ttB99QlGgeCs=";
    };
  };
}
