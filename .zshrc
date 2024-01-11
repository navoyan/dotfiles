# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=~/.oh-my-zsh


ZSH_THEME="powerlevel10k/powerlevel10k"


# --- Parameters for Oh My ZSH plugins ---
ZSH_TMUX_AUTOSTART=true


# --- Oh My ZSH plugins ---
plugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
  kubectl
  helm
  bazel
  tmux
)


source $ZSH/oh-my-zsh.sh


# --- Parameters for custom ZSH startup scripts ---
OPENVPN_PROFILE_NAME="sagesse"


# --- Load custom ZSH scripts ---
for SCRIPT in ~/.custom-zsh/*; do
    source $SCRIPT
done


# --- Custom aliases ---
alias cl='clear && tmux clear-history'
alias g='git'
alias b='bazel'


# Krew PATH changes
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


# --- P10k ---
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
