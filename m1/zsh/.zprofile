# HomeBrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# AnyEnv PATH
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

eval "$(direnv hook zsh)"

# Remove duplication path
typeset -U PATH
