export ZSH="$HOME/.oh-my-zsh"

if [ -x "$(command -v nvim)" ]; then
    export EDITOR=nvim
    export VISUAL=nvim
else
    export EDITOR=vim
    export VISUAL=vim
fi

export TERMINAL=kitty
export BROWSER=firefox

# PATH
export PATH=$PATH:$HOME/.local/bin:$HOME/.cargo/bin

# pnpm
export PNPM_HOME="/home/clemens/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Android
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools

# GO
export GOPATH=/home/clemens/go

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
