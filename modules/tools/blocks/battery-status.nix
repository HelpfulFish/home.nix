{ pkgs, ... }:

let
  # Define the binary using writeShellScriptBin
  battery-status = pkgs.writeShellScriptBin "battery-status" ''
#!/bin/bash

# Specific battery path on your system
BATTERY="/org/freedesktop/UPower/devices/battery_BAT1"

# Get battery info
BATTERY_INFO=$(upower -i "$BATTERY")

# Extract percentage and state
PERCENTAGE=$(echo "$BATTERY_INFO" | awk '/percentage:/ {gsub("%",""); print $2}')
CHARGING_STATE=$(echo "$BATTERY_INFO" | awk '/state:/ {print $2}')

# Set icon based on state and level
ICON=""
COLOR="#FFFFFF"  # Default fallback color

if [[ "$CHARGING_STATE" == "charging" ]]; then
    ICON="⚡"
elif [[ "$CHARGING_STATE" == "discharging" ]]; then
    if [ "$PERCENTAGE" -ge 80 ]; then
        ICON="🔋"
    elif [ "$PERCENTAGE" -ge 60 ]; then
        ICON="🔋"
    elif [ "$PERCENTAGE" -ge 40 ]; then
        ICON="🔋"
    elif [ "$PERCENTAGE" -ge 20 ]; then
        ICON="🔌"
    else
        ICON="🪫"
    fi
elif [[ "$CHARGING_STATE" == "fully-charged" ]]; then
    ICON="✅"
fi

# Output for i3blocks
echo "$ICON $PERCENTAGE% ($CHARGING_STATE)"

  '';
in {
  # Ensure the binary is added to the PATH
  home.packages = [
    battery-status
  ];
}

