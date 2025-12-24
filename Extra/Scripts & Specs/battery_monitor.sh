#!/bin/bash

# Battery Monitor Daemon
# Tracks the minimum battery percentage reached
SAVE_PATH="/Users/kornienkodaniel/Documents/1_Projects/Battery Health"
FILE_LOWEST="$SAVE_PATH/min_value.log"
FILE_LOG="$SAVE_PATH/min_battery.log"
CHECK_INTERVAL=45  # Check every 45 seconds

# Initialize log file if it doesn't exist
if [ ! -f "$FILE_LOWEST" ]; then
    echo "100" > "$FILE_LOWEST"
    echo "$(date): Initialized minimum battery tracker at 100%" >> "$FILE_LOG"
fi

echo "$(date): Battery monitor daemon started" >> "$FILE_LOG"

while true; do
    # Get current battery percentage
    CURRENT=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
    
    # Read the minimum value from file
    MIN=$(head -n 1 "$FILE_LOWEST")
    
    # If current is lower than minimum, update the file
    if [ "$CURRENT" -lt "$MIN" ]; then
        echo "$CURRENT" > "$FILE_LOWEST"
        echo "$(date): New minimum reached: $CURRENT%" >> "$FILE_LOG"
    fi
    
    sleep $CHECK_INTERVAL
done