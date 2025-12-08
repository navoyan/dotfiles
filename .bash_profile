[[ -f ~/.bashrc ]] && . ~/.bashrc

export QT_QPA_PLATFORMTHEME="hyprqt6engine"
export QT_QPA_PLATFORM="wayland"

export GTK_THEME="TokyoNight"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    alias nvim="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export VISUAL=nvim
    export EDITOR=nvim
fi
export SUDOEDITOR=nvim

export LESSKEYIN="$XDG_CONFIG_HOME/lesskey/config"
export MANPAGER="bash -c 'NVIM_APPNAME=nvim-explorer nvim +Man!'"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --bind 'ctrl-backspace:backward-kill-word' \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#283457 \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"
