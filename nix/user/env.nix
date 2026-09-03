{
  config,
  ...
}:
{
  hjem.users.narek.files = {
    ".bash_profile".text = /* bash */ ''
      source ${config.hjem.users.narek.environment.loadEnv}

      if [[ $(tty) == "/dev/tty3" ]]; then
          export MANGOHUD_CONFIGFILE=~/.config/MangoHud/MangoHud.conf
          scoperun --mango --steam --mango -- steam -gamepadui
          chvt 2
          exit
      fi
    '';
  };

  hjem.users.narek.environment.sessionVariables = rec {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    PATH = [
      "$HOME/dotfiles/local/bin"
      "$HOME/.local/share/goverlay/gameconfig/global"
      "$PATH"
    ];

    NIXOS_OZONE_WL = "1";

    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qtengine";

    GTK_THEME = "TokyoNight";

    TERMINAL = "kitty";

    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
    PAGER = "env NVIM_APPNAME=npage page -W -q 90000 -z 90000";
    MANPAGER = "env NVIM_APPNAME=npage nvim +Man!";

    FZF_DEFAULT_COMMAND = "fd --type f --hidden --exclude drive_c";
    FZF_DEFAULT_OPTS =
      "--bind 'ctrl-backspace:backward-kill-word'"
      + " --highlight-line"
      + " --info=inline-right"
      + " --ansi"
      + " --layout=reverse"
      + " --border=none"
      + " --color=bg+:#283457"
      + " --color=border:#27a1b9"
      + " --color=fg:#c0caf5"
      + " --color=gutter:#16161e"
      + " --color=header:#ff9e64"
      + " --color=hl+:#2ac3de"
      + " --color=hl:#2ac3de"
      + " --color=info:#545c7e"
      + " --color=marker:#ff007c"
      + " --color=pointer:#ff007c"
      + " --color=prompt:#2ac3de"
      + " --color=query:#c0caf5:regular"
      + " --color=scrollbar:#27a1b9"
      + " --color=separator:#ff9e64"
      + " --color=spinner:#ff007c";

    AWWW_TRANSITION = "any";
    AWWW_TRANSITION_FPS = "180";

    # force xdg base directory specification:
    CARGO_HOME = "${XDG_DATA_HOME}/cargo";
    CLAUDE_CONFIG_DIR = "${XDG_CONFIG_HOME}/claude";
    DOCKER_CONFIG = "${XDG_CONFIG_HOME}/docker";
    HISTFILE = "${XDG_STATE_HOME}/bash/history";
    KUBECACHEDIR = "${XDG_CACHE_HOME}/kube";
    KUBECONFIG = "${XDG_CONFIG_HOME}/kube/config";
    LESSHISTFILE = "${XDG_STATE_HOME}/lesshst";
    MINIKUBE_HOME = "${XDG_DATA_HOME}/minikube";
    PYTHON_HISTORY = "${XDG_STATE_HOME}/python_history";
    RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
    XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
  };
}
