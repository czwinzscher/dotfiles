ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"
. $ZSH/oh-my-zsh.sh

# autosuggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff"
    bindkey '^[^M' autosuggest-execute # alt-return
    bindkey '^ ' autosuggest-accept # ctrl-space
fi

. ~/.bash_aliases
. ~/.inputrc
[ -f /etc/profile.d/vte.sh ] && . /etc/profile.d/vte.sh

# fzf
# arch
[ -f /usr/share/fzf/key-bindings.zsh ] && . /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && . /usr/share/fzf/completion.zsh
# ubuntu
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && . /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && . /usr/share/doc/fzf/examples/completion.zsh

# https://github.com/gsamokovarov/jump
eval "$(jump shell)"

HISTSIZE=10000000
SAVEHIST=10000000
