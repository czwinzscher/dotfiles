export ZSH="$HOME/.oh-my-zsh"

export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=gnome-terminal
export BROWSER=firefox
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

#[ "$TMUX" = "" ] && export TERM="xterm-256color"

# GO
export GOPATH=/home/clemens/go

# PATH
# export PATH=$PATH:$HOME/.cabal/bin:$HOME/.cargo/bin:$/usr/local/go/bin
export PATH=$PATH:$HOME/.local/bin

# Rust
rust_root=$(rustc --print sysroot)
export RUST_SRC_PATH="$rust_root/lib/rustlib/src/rust/src"

# FZF
export FZF_DEFAULT_COMMAND='fd --type file --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# CMake
export CMAKE_EXPORT_COMPILE_COMMANDS=ON

# GHCup
export GHCUP_USE_XDG_DIRS=1

# nvm
# . /usr/share/nvm/init-nvm.sh
