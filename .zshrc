ZSH_THEME="robbyrussell"

DISABLE_AUTO_UPDATE="true"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=()

. $ZSH/oh-my-zsh.sh

# autosuggestions
. ~/.zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=6"
bindkey '^[^M' autosuggest-execute # alt-return
bindkey '^ ' autosuggest-accept # ctrl-space

. ~/.bash_aliases
. ~/.inputrc
. /usr/share/fzf/key-bindings.zsh
. /usr/share/fzf/completion.zsh
