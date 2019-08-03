# LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# standard editor
export EDITOR=vim
export VISUAL=vim
export TERMINAL=/usr/bin/gnome-terminal
export BROWSER=/usr/bin/firefox

export TERM=xterm-256color

[ "$TMUX" = "" ] && export TERM="xterm-256color"

# GO
export GOPATH=/home/clemens/go

# PATH
export PATH=$PATH:$HOME/.cabal/bin:/usr/local/go/bin:$GOPATH/bin:$HOME/.cargo/bin:$HOME/bin:$HOME/.local/bin

# Rust
rust_root=$(rustc --print sysroot)
export RUST_SRC_PATH="$rust_root/lib/rustlib/src/rust/src"

# FZF
export FZF_DEFAULT_COMMAND='fdfind --type file --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# NNN
export NNN_BMS='s:~/Nextcloud/Studium/Semester4'
export NNN_CONTEXT_COLORS='2222'
