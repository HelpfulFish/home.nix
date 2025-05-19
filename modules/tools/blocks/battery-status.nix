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

# Set Nerd Font icon based on state and level
ICON=""
COLOR="#FFFFFF" # Not used in output, kept for compatibility

if [[ "$CHARGING_STATE" == "charging" ]]; then
  ICON="" # nf-fa-plug
elif [[ "$CHARGING_STATE" == "discharging" ]]; then
  if [ "$PERCENTAGE" -ge 80 ]; then
    ICON="" # nf-fa-battery_full
  elif [ "$PERCENTAGE" -ge 60 ]; then
    ICON="" # nf-fa-battery_three_quarters
  elif [ "$PERCENTAGE" -ge 40 ]; then
    ICON="" # nf-fa-battery_half
  elif [ "$PERCENTAGE" -ge 20 ]; then
    ICON="" # nf-fa-battery_quarter
  else
    ICON="" # nf-fa-battery_empty
  fi
elif [[ "$CHARGING_STATE" == "fully-charged" ]]; then
  ICON="" # Same as full battery
fi

# Output for i3blocks or status bar
# echo "$ICON $PERCENTAGE% ($CHARGING_STATE)"
echo "$ICON  $PERCENTAGE%"
  
'';
in {
  # Ensure the binary is added to the PATH
  home.packages = [
    battery-status
  ];
}

