{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.fzf];

  programs.fzf.keybindings = true;

  hj.environment.sessionVariables = {
    FZF_DEFAULT_COMMAND = let
      fdArgs = lib.cli.toCommandLineShellGNU {} {
        type = "file";
        hidden = true;
        exclude = ["drive_c" ".hidden"];
      };
    in "fd ${fdArgs}";

    FZF_DEFAULT_OPTS = let
      mkMappings = keyValues: keyValues |> lib.mapAttrsToList (key: value: "${key}:${value}");
    in
      lib.cli.toCommandLineShellGNU {} {
        highlight-line = true;
        ansi = true;
        info = "inline-right";
        layout = "reverse";
        border = "none";
        bind = mkMappings {
          "ctrl-backspace" = "backward-kill-word";
        };
        color = mkMappings {
          "bg+" = "#283457";
          "border" = "#27a1b9";
          "fg" = "#c0caf5";
          "gutter" = "#16161e";
          "header" = "#ff9e64";
          "hl+" = "#2ac3de";
          "hl" = "#2ac3de";
          "info" = "#545c7e";
          "marker" = "#ff007c";
          "pointer" = "#ff007c";
          "prompt" = "#2ac3de";
          "query" = "#c0caf5:regular";
          "scrollbar" = "#27a1b9";
          "separator" = "#ff9e64";
          "spinner" = "#ff007c";
        };
      };
  };
}
