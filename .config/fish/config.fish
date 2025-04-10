set -gx EDITOR nvim
set -gx SUDOEDITOR nvim

abbr v nvim

abbr g git
abbr b bazel

abbr k kubectl
abbr kns kubens
abbr kctx kubectx

bind -M insert ctrl-backspace backward-kill-word

bind -M visual y fish_clipboard_copy
bind -m visual V beginning-of-line begin-selection end-of-line force-repaint

zoxide init fish --cmd cd | source
fzf --fish | source
