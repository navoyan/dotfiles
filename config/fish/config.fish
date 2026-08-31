set -gx SHELL $(which fish)

set -g fish_greeting ""
set -g fish_key_bindings fish_vi_key_bindings

set fish_function_path "$__fish_config_dir/user_functions" $fish_function_path
set fish_complete_path $fish_complete_path "/usr/share/fish/completions"

abbr v nvim
abbr se sudoedit

abbr g git
abbr b bazel

abbr k    kubectl
abbr kns  kubens
abbr kctx kubectx

abbr rust evcxr

alias page "command $PAGER"
abbr  p     page

function netbird-switch -a profile
    netbird profile select $profile
    netbird up
end
abbr ns netbird-switch
abbr n netbird

function fish_user_key_bindings
    bind -M insert ctrl-backspace backward-kill-word
    bind -M insert ctrl-enter     'commandline -i \\n' expand-abbr

    bind                         yy fish_clipboard_copy
    bind -M visual -m default -s y  "fish_clipboard_copy; commandline -f end-selection repaint-mode"

    bind --erase --preset s
    bind                  sl __fish_vi_delete_char

    bind -m visual x begin-selection
    bind -m visual X beginning-of-line begin-selection end-of-line force-repaint

    bind m repeat-jump
    bind -M visual m repeat-jump
end

zoxide init fish --cmd j | source
fzf --fish | source
