DISABLE_AUTO_UPDATE="true"
plugins=(zsh-autosuggestions)
. $ZSH/oh-my-zsh.sh

HISTSIZE=10000000
SAVEHIST=10000000

# autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff"
bindkey '^[^M' autosuggest-execute # alt-return
bindkey '^ ' autosuggest-accept # ctrl-space

. ~/.bash_aliases
. ~/.inputrc

# fzf
# arch
[ -f /usr/share/fzf/key-bindings.zsh ] && . /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && . /usr/share/fzf/completion.zsh
# ubuntu
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && . /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && . /usr/share/doc/fzf/examples/completion.zsh

eval "$(starship init zsh)"
eval "$(zoxide init --cmd r zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"

export PNPM_HOME="/home/clemens/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
