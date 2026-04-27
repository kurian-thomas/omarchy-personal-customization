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

# Git wrapper for fzf interactive commands
git() {
    if [ "$1" = "fswitch" ]; then
        # 1. Fetch branches and open fzf
        local branch=$(command git branch -a --format="%(refname:short)" | sort -u | fzf --preview "git log --color=always --oneline -10 {}")
        
        # 2. If a branch was selected, pre-fill the command line
        if [ -n "$branch" ]; then
            # 'read -e -i' pre-fills the text and waits for you to press Enter
            read -e -i "git switch $branch" -p "$ " cmd
            history -s "$cmd" # Add it to your up-arrow bash history
            eval "$cmd"       # Execute the command
        fi

    elif [ "$1" = "fpush" ]; then
        local branch=$(command git branch -a --format="%(refname:short)" | sort -u | fzf --preview "git log --color=always --oneline -10 {}")
        
        if [ -n "$branch" ]; then
            read -e -i "git push -u origin $branch" -p "$ " cmd
            history -s "$cmd"
            eval "$cmd"
        fi

    else
        # Pass all other regular commands (commit, pull, etc.) directly to git
        command git "$@"
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

# open vscodium instead of oss code
alias code="codium"

# Alias cdi to interactive zoxide
alias cdi='zi'
