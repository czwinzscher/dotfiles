DISABLE_AUTO_UPDATE="true"
plugins=(zsh-autosuggestions fzf)
. $ZSH/oh-my-zsh.sh

HISTSIZE=10000000
SAVEHIST=10000000

# autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff"
bindkey '^[^M' autosuggest-execute # alt-return
bindkey '^ ' autosuggest-accept # ctrl-space

. ~/.bash_aliases
. ~/.inputrc

eval "$(starship init zsh)"
eval "$(zoxide init --cmd r zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"
