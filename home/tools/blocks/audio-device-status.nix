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
        AUDIO_STATUS="$DEFAULT_PREFIX 󰂯"
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

