#!/bin/bash

# Check for required commands and exit if not found
for cmd in rofi notify-send play yad; do
    if ! command -v $cmd &> /dev/null; then
        notify-send "Error: $cmd is not installed. Exiting..."
        exit 1
    fi
done

# Function to prompt user using Rofi
prompt_with_rofi() {
    rofi -dmenu -p "$1" -config /usr/share/rofi/themes/Arc-Dark.rasi
}

# Prompt for reminder text
REMINDER_TEXT=$(prompt_with_rofi "Enter reminder text:")
# Exit if no text was entered
[ -z "$REMINDER_TEXT" ] && exit 1

# Prompt for time in minutes
REMINDER_TIME=$(prompt_with_rofi "In how many minutes?:")
# Exit if no time was entered or it's not a number
[[ ! "$REMINDER_TIME" =~ ^[0-9]+$ ]] && exit 1

# Calculate delay in seconds
DELAY=$((REMINDER_TIME * 60))

# Show notification icon
yad --notification --image="dialog-information" --text="Reminder ON" &
# Get the PID of the yad command to kill it later
YAD_PID=$!

# Set the reminder
(
    sleep $DELAY
    notify-send "Reminder" "$REMINDER_TEXT"
    play -n synth 0.3 sin 550 vol -15dB > /dev/null 2>&1
    kill $YAD_PID
)
