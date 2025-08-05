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

# alias fd to fdfind on ubuntu
if ! type fd &> /dev/null; then
  if type fdfind &> /dev/null; then
    alias fd='fdfind'
  fi
fi

eval "$(starship init zsh)"
eval "$(zoxide init --cmd r zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"

export PNPM_HOME="/home/clemens/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
