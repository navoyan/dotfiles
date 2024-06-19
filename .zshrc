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
  zsh-syntax-highlighting
  zsh-autosuggestions
  kubectl
  helm
  bazel
)


source $ZSH/oh-my-zsh.sh

# --- Parameters for custom ZSH startup scripts ---


# --- Load custom ZSH scripts ---
for SCRIPT in ~/.custom-zsh/*; do
    source $SCRIPT
done


# --- Custom aliases ---
alias cl='clear && tmux clear-history'
alias g='git'
alias b='bazel'
alias v='nvim'
alias vh='v .'

# PATH changes
export PATH="/usr/bin/flutter-sdk/bin:/usr/local/go/bin:/home/narek/.pub-cache/bin:~/.local/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


# Setups
source ~/.cargo/env
eval "$(zoxide init --cmd cd zsh)"


# --- P10k ---
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- fzf ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pnpm
export PNPM_HOME="/home/narek/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

