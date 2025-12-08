set -gx SHELL $(which fish)

set fish_function_path "$__fish_config_dir/user_functions" $fish_function_path


abbr v nvim

abbr g git
abbr b bazel

abbr k kubectl
abbr kns kubens
abbr kctx kubectx

abbr rust evcxr

alias explore "NVIM_APPNAME=nvim-explorer nvim"
abbr e explore

bind -M insert ctrl-backspace backward-kill-word
bind -M insert ctrl-enter 'commandline -i \\n' expand-abbr

bind -M visual y fish_clipboard_copy
bind -m visual V beginning-of-line begin-selection end-of-line force-repaint

zoxide init fish --cmd cd | source
fzf --fish | source
