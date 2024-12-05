# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=~/.oh-my-zsh


ZSH_THEME="powerlevel10k/powerlevel10k"


# --- Parameters for Oh My ZSH plugins ---
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#abb4be"

# --- Oh My ZSH plugins ---
plugins=(
  kubectl
  helm
  bazel
)


source $ZSH/oh-my-zsh.sh

# --- custom ZSH functions ---
function mk-start {
  if minikube status | grep -E "Running"; then
    printf "\nMINIKUBE IS ALREADY RUNNING\n"
  else
    minikube start
  fi
}

# --- Custom aliases ---
alias cl='clear && tmux clear-history'
alias g='git'
alias b='bazel'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vh='v .'
alias kctx='kubectx'
alias kns='kubens'
alias ls='eza'
alias ll='eza --long --all --icons'
alias tree='eza --tree --all --icons'

# Well-known variable changes
export PATH="/home/narek/sdk/flutter/bin:/home/narek/go/bin:/home/narek/.pub-cache/bin:~/.local/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export EDITOR=nvim

# Setups
# source ~/.cargo/env
eval "$(zoxide init --cmd cd zsh)"

source <(fzf --zsh)

eval "$(register-python-argcomplete pipx)"

# --- P10k ---
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
