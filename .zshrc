ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"
. $ZSH/oh-my-zsh.sh

# autosuggestions
. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=6"
bindkey '^[^M' autosuggest-execute # alt-return
bindkey '^ ' autosuggest-accept # ctrl-space

. ~/.bash_aliases
. ~/.inputrc
. /etc/profile.d/vte.sh
. /usr/share/fzf/key-bindings.zsh
. /usr/share/fzf/completion.zsh
. /usr/share/nvm/init-nvm.sh

# https://github.com/gsamokovarov/jump
eval "$(jump shell)"
