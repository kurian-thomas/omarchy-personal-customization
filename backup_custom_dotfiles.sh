#!/usr/bin/env bash

set -euo pipefail

# Config files
HYPRLAND_LOOK_N_FEEL_FILE=$HOME/.config/hypr/looknfeel.conf
HYPRLOCK_FILE=$HOME/.config/hypr/hyprlock.conf
WALKER_FILE=$HOME/.local/share/omarchy/default/walker/themes/omarchy-default/style.css
WAYBAR_FILE=$HOME/.config/waybar/style.css
WAYBAT_CONF=$HOME/.config/waybar/config.jsonc
HYPR_INPUT_FILE=$HOME/.config/hypr/input.conf
HYPR_IDLE=$HOME/.config/hypr/hypridle.conf

BACKUP_LOCATION=$HOME/personal/projects/omarchy-custom/

# nvim backup location
NVIM_CONFIG=$HOME/.config/nvim/

# Custom screensaver script
SCREEN_SAVER_LAUNCH=$HOME/.local/bin/custom_scripts/nova-custom-screensaver
SCREEN_SAVER_SCRIPT=$HOME/.local/bin/custom_scripts/nova-cmd-screensaver

# bashrc backup
BASH_RC=$HOME/.bashrc

DOT_FILE_BAK_LOG_DIR="$HOME/logs/dotfiles_backup"
DATE_TAG=$(date +'%Y-%m-%d')  # Format: YYYY-MM-DD
LOG_FILE="$DOT_FILE_BAK_LOG_DIR/run_${DATE_TAG}.log"

files=(
"$HYPRLAND_LOOK_N_FEEL_FILE"
"$HYPRLOCK_FILE"
"$WALKER_FILE"
"$WAYBAR_FILE"
"$HYPR_INPUT_FILE"
"$WAYBAT_CONF"
"$BASH_RC"
"$HYPR_IDLE"
"$SCREEN_SAVER_LAUNCH"
"$SCREEN_SAVER_SCRIPT"
)

log_msg() {
    local timestamp
    timestamp=$(date +'%Y-%m-%d %H:%M:%S')

    echo "[$timestamp] $1" | tee -a "$LOG_FILE"
}

git_backup() {
    local backup_dir="$1"
    
    log_msg "[INFO] Running final git commands in $backup_dir"

    # subshell to run git commands
    (
        cd "$backup_dir" || { log_msg "[ERROR] Could not change directory to $backup_dir"; exit 1; }

        if [ ! -d ".git" ]; then
            log_msg "[ERROR] Git dir not initialized or missing, setup git init on $backup_dir"
            return
        fi

        COMMIT_TIMESTAMP=$(date +'%Y-%m-%d_%H:%M:%S')

        git add --all
        git commit -m "backup of dotfiles on $COMMIT_TIMESTAMP" || log_msg "[INFO] Nothing to commit"
        git push -u origin master || log_msg "[ERROR] Push error, validate git branch state in repo $backup_dir"
    )
}

error_handler() {
    local line_no=$1
    local command=$2
    local code=$3
    log_msg "[ERROR] Command '$command' failed on line $line_no with exit code $code."
}
trap 'error_handler ${LINENO} "$BASH_COMMAND" $?' ERR

mkdir -p "$DOT_FILE_BAK_LOG_DIR"
mkdir -p "$BACKUP_LOCATION"

echo "--- Backup file list ---"
printf '%s\n' "${files[@]}"

for file in "${files[@]}"; do

    if [[ -f "$file" ]]; then
        parent_dir=$(basename "$(dirname "$file")")
        filename=$(basename "$file")
        dest_filename="${parent_dir}_${filename}"
        
        log_msg "[INFO] Processing: $file -> $dest_filename"
        cp -f "$file" "$BACKUP_LOCATION/$dest_filename"
    else
        log_msg "[WARN] Skipping: $file (File not found)"
    fi
done

git_backup "$BACKUP_LOCATION"
git_backup "$NVIM_CONFIG"

log_msg "[INFO] Backup complete"
