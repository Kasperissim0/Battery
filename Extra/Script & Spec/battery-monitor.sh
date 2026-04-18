#!/bin/bash
set -e

# Battery Monitor Daemon
# Tracks the minimum battery percentage reached
SAVE_PATH="/Users/kasperissim0/Code/Projects/Retired/Battery Benchmark"
FILE_LOWEST="$SAVE_PATH/min_value.log"
FILE_LOG="$SAVE_PATH/min_battery.log"
CHECK_INTERVAL=45  # Check every 45 seconds
MAX_LOG_SIZE_MB=10

# Function to rotate logs if they exceed MAX_LOG_SIZE_MB
rotate_logs() {
    for log in "$FILE_LOG" "$SAVE_PATH/Extra/battery_monitor_out.log" "$SAVE_PATH/Extra/battery_monitor_err.log"; do
        if [ -f "$log" ]; then
            local size_kb=$(du -k "$log" | cut -f1)
            if [ $((size_kb / 1024)) -ge $MAX_LOG_SIZE_MB ]; then
                echo "$(date): Log file $log reached ${MAX_LOG_SIZE_MB}MB. Rotating..." >> "$log"
                delete "$log"
                touch "$log"
            fi
        fi
    done
}

# Initialize log file if it doesn't exist
if [ ! -f "$FILE_LOWEST" ]; then
    echo "100" > "$FILE_LOWEST"
    echo "$(date): Initialized minimum battery tracker at 100%" >> "$FILE_LOG"
fi

echo "$(date): Battery monitor daemon started" >> "$FILE_LOG"

while true; do
    rotate_logs
    # Get current battery percentage
    CURRENT=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
    
    # Skip if CURRENT is empty
    if [ -z "$CURRENT" ]; then
        echo "$(date): ERROR - Could not read battery percentage" >> "$FILE_LOG"
        sleep $CHECK_INTERVAL
        continue
    fi
    
    # Read the minimum value from file
    MIN=$(head -n 1 "$FILE_LOWEST")
    # echo "Current Value: $CURRENT %"
    
    # If current is lower than minimum, update the file
    if [ "$CURRENT" -lt "$MIN" ]; then
        echo "$CURRENT" > "$FILE_LOWEST"
        echo "$(date): New minimum reached: $CURRENT%" >> "$FILE_LOG"

        # Git commit (with error handling)
        cd "$SAVE_PATH" || { echo "$(date): ERROR - Could not cd to git repo" >> "$FILE_LOG"; sleep $CHECK_INTERVAL; continue; }
        
        echo "$(date): Syncing Changes With GitHub" >> "$FILE_LOG"
        if git add . 2>> "$FILE_LOG"; then
            if git commit -m "New Low Achieved: $CURRENT%" 2>> "$FILE_LOG"; then
                git push 2>> "$FILE_LOG" || echo "$(date): ERROR - Git push failed" >> "$FILE_LOG"
            else
                echo "$(date): ERROR - Git commit failed" >> "$FILE_LOG"
            fi
        else
            echo "$(date): ERROR - Git add failed" >> "$FILE_LOG"
        fi
    fi
    
    sleep $CHECK_INTERVAL
done