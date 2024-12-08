{ pkgs, ... }:

let
  audio-device-status = pkgs.writeShellScriptBin "audio-device-status" ''
    #!/bin/bash

DEFAULT_SINK=$(pactl get-default-sink 2>/dev/null || echo "")
DEFAULT_PREFIX="Audio:"

if [ -z "$DEFAULT_SINK" ]; then
    echo "$DEFAULT_PREFIX No Device"
    exit 1
fi

case "$DEFAULT_SINK" in
    *bluez_output*)
        BATTERY_DEVICE=$(upower -e | grep -m 1 'battery')
        if [ -n "$BATTERY_DEVICE" ]; then
            BATTERY_STATUS=$(upower -i "$BATTERY_DEVICE" | awk '/percentage:/ {print $2}')
        else
            BATTERY_STATUS="No Battery"
        fi
        AUDIO_STATUS="$DEFAULT_PREFIX 󰂯 ($BATTERY_STATUS)"
        ;;
    *usb*)
        AUDIO_STATUS="$DEFAULT_PREFIX "
        ;;
    *hdmi*)
        AUDIO_STATUS="$DEFAULT_PREFIX 󰓃"
        ;;
    *)
        AUDIO_STATUS="$DEFAULT_PREFIX 🔊 Unknown"
        ;;
esac

echo "$AUDIO_STATUS"

  '';

in
{
 # Ensure the binary is added to the PATH
  home.packages = [
    audio-device-status
  ];
}

