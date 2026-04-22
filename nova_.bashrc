# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Function to add to PATH only if it doesn't already exist
add_to_path() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
alias virt-manager='/usr/bin/python3 /usr/bin/virt-manager'
export PATH="/home/nova/package-downloads/sdk/flutter/bin:$PATH"

# Cargo binary PATH

CARGO_INSTALLED_BIN_PATH="$HOME/.cargo/bin"
add_to_path "$CARGO_INSTALLED_BIN_PATH"

# Android Home
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_AVD_HOME=$HOME/.config/.android/avd

# Rocksdb C_GO binding env vars
export CGO_CFLAGS="-I/usr/local/include"
export CGO_LDFLAGS="-L/usr/local/lib -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -llz4 -lzstd -luring"

# Add essential Android directories
add_to_path "$ANDROID_HOME/emulator"
add_to_path "$ANDROID_HOME/platform-tools"
add_to_path "$ANDROID_HOME/cmdline-tools/latest/bin"

# Clean up the function so it doesn't linger in your environment
unset -f add_to_path

# Git Aliases
alias gdiff='git diff'

alias glog='git log --oneline --graph --decorate --all'

alias cat='bat --theme="gruvbox-dark" --style="numbers,changes,header,snip"'

# Alias cdi to interactive zoxide
alias cdi='zi'
