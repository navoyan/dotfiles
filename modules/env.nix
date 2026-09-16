{config, ...}: {
  hj.files = {
    ".bash_profile".source = config.hj.environment.loadEnv;
  };

  hj.environment.sessionVariables = rec {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    PATH = [
      "$HOME/dotfiles/modules/scripts"
      "$HOME/.local/share/goverlay/gameconfig/global"
      "$PATH"
    ];

    NIXOS_OZONE_WL = "1";

    AWWW_TRANSITION = "any";
    AWWW_TRANSITION_FPS = "180";

    # force xdg base directory specification:
    CARGO_HOME = "${XDG_DATA_HOME}/cargo";
    DOCKER_CONFIG = "${XDG_CONFIG_HOME}/docker";
    HISTFILE = "${XDG_STATE_HOME}/bash/history";
    KUBECACHEDIR = "${XDG_CACHE_HOME}/kube";
    KUBECONFIG = "${XDG_CONFIG_HOME}/kube/config";
    MINIKUBE_HOME = "${XDG_DATA_HOME}/minikube";
    PYTHON_HISTORY = "${XDG_STATE_HOME}/python_history";
    RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
    XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
  };
}
