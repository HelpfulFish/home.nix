{ pkgs, ... }:

let
  # Define the binary using writeShellScriptBin
  volume = pkgs.writeShellScriptBin "volume" ''
    #!/bin/sh

    # Get the current volume and mute status using `pactl`
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '/Volume/ {print $5}' | tr -d '%')
    mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '/Mute/ {print $2}')

    # Decide the icon based on mute status and volume level
    if [[ "$mute" == "yes" ]]; then
      icon="🔇"  # Muted icon
    else
      if [[ "$volume" -eq 0 ]]; then
        icon="🔈"  # Low volume
      elif [[ "$volume" -le 50 ]]; then
        icon="🔉"  # Medium volume
      else
        icon="🔊"  # High volume
      fi
    fi

    # Output for i3blocks
    echo "$icon $volume%"
    echo "$icon $volume%"  # Short text for status bar
    echo "#FFFFFF"         # Color (optional, default is white)

    # Handle button clicks
    case $BLOCK_BUTTON in
      1) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;        # Left click: toggle mute
      4) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;         # Scroll up: increase volume
      5) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;         # Scroll down: decrease volume
    esac
  '';
in {
  # Ensure the binary is added to the PATH
  home.packages = [
    volume
  ];
}

