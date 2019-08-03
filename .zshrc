# Path to your oh-my-zsh installation.
export ZSH=/home/clemens/.oh-my-zsh

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

DISABLE_AUTO_UPDATE="true"

# Which plugins would you like to load?
# plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# plugins=()

. $ZSH/oh-my-zsh.sh

. ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^[^M' autosuggest-execute
bindkey '^ ' autosuggest-accept

# source aliases and inputrc
. ~/.bash_aliases
. ~/.inputrc

# shellcheck source=/home/clemens/.fzf.zsh
. ~/.fzf.zsh
