#!/usr/bin/env bash

set -euo pipefail

# Config files
HYPRLAND_LOOK_N_FEEL_FILE=$HOME/.config/hypr/looknfeel.conf
HYPRLOCK_FILE=$HOME/.config/hypr/hyprlock.conf
WALKER_FILE=$HOME/.local/share/omarchy/default/walker/themes/omarchy-default/style.css
WAYBAR_FILE=$HOME/.config/waybar/style.css

BACKUP_LOCATION=$HOME/personal/projects/omarchy-custom/

DOT_FILE_BAK_LOG_DIR="$HOME/logs/dotfiles_backup"
DATE_TAG=$(date +'%Y-%m-%d')  # Format: YYYY-MM-DD
LOG_FILE="$DOT_FILE_BAK_LOG_DIR/run_${DATE_TAG}.log"

files=(
"$HYPRLAND_LOOK_N_FEEL_FILE"
"$HYPRLOCK_FILE"
"$WALKER_FILE"
"$WAYBAR_FILE"
)

log_msg() {
    local timestamp
    timestamp=$(date +'%Y-%m-%d %H:%M:%S')

    echo "[$timestamp] $1" | tee -a "$LOG_FILE"
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

echo "--- Running final command in $BACKUP_LOCATION ---"

# subshell to run git commands
(
    cd "$BACKUP_LOCATION" || exit

    if [ ! -d ".git" ]; then
        git init
        git remote add origin "https://github.com/kurian-thomas/omarchy-personal-customization.git"
    fi

    COMMIT_TIMESTAMP=$(date +'%Y-%m-%d_%H:%M:%S')

    git add --all
    git commit -m "backup of dotfiles on $COMMIT_TIMESTAMP" || log_msg "[INFO] Nothing to commit"
    git push -u origin master
)

log_msg "[INFO] Backup complete"
