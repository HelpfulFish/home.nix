{ config, lib, pkgs, ... }:

with lib;

let

    cfg = config.audio-output;
    
    writeScriptDir = path: text:
    pkgs.writeTextFile {
      inherit text;
      executable = true;
      name = builtins.baseNameOf path;
      destination = "${path}";
    };

    audio-output = pkgs.writeShellScriptBin "audio-output" ''
      #!/bin/sh

get_sink() {
    local sink_name=$(pactl list short sinks | awk "/$1/ {print \$2}")
    if [ -z "$sink_name" ]; then
        echo "Error: No sink found for $1" >&2
        exit 1
    fi
    echo "$sink_name"
}

get_device() {
    local device_mac=$(bluetoothctl devices | awk "/$1/ {print \$2}")
    if [ -z "$device_mac" ]; then
        echo "Error: No Bluetooth device found for $1" >&2
        exit 1
    fi
    echo "$device_mac"
}

# Get sinks: `pactl list short sinks`
# Define the sink names
HEADPHONES_SINK=$(get_sink "usb")
SPEAKERS_SINK=$(get_sink "hdmi-stereo")
BLUETOOTH_SINK=$(get_sink "bluez_output")
BLUETOOTH_DEVICE=$(get_device "EDIFIER")



set_sink() {
    local sink_name="$1"
    local sink_friendly_name="$2"
    pactl set-default-sink "$sink_name"

    # Move all currently playing streams to the new sink
    for INPUT in $(pactl list short sink-inputs | cut -f1); do
        pactl move-sink-input "$INPUT" "$sink_name"
    done

    zenity --notification --text="Switched to $sink_friendly_name"
}

power_on_bluetooth() {
    # Check if Bluetooth is blocked and unblock if necessary
    rfkill list bluetooth | grep -i "Soft blocked: yes" > /dev/null
    if [ $? -eq 0 ]; then
        echo "Unblocking Bluetooth adapter..."
        rfkill unblock bluetooth
    fi

    # Ensure Bluetooth adapter is powered on
    bluetoothctl show | grep "Powered: no" > /dev/null
    if [ $? -eq 0 ]; then
        echo "Powering on Bluetooth adapter..."
        bluetoothctl power on
    fi
}

power_off_bluetooth() {
    echo "Powering off Bluetooth adapter..."
    bluetoothctl power off
}

discover_and_pair() {
    echo "Starting Bluetooth discovery..."
    bluetoothctl scan on
    echo "Make sure your headphones are in pairing mode."

    # To pair:
    # Find your device's MAC address in the discovery output
    # Then run: bluetoothctl pair XX:XX:XX:XX:XX:XX

    # To trust the device (recommended for automatic reconnect):
    # bluetoothctl trust XX:XX:XX:XX:XX:XX

    # Stop scanning after pairing:
    # bluetoothctl scan off
}

connect_bluetooth() {
    echo "Attempting to connect to Bluetooth headphones..."
    bluetoothctl connect "$BLUETOOTH_DEVICE"
    if [ $? -eq 0 ]; then
        zenity --notification --text="Connected to Bluetooth headphones"
    else
        zenity --notification --text="Failed to connect to Bluetooth headphones"
        exit 1
    fi
}

disconnect_bluetooth() {
    echo "Disconnecting Bluetooth headphones..."
    bluetoothctl disconnect "$BLUETOOTH_DEVICE"
    zenity --notification --text="Disconnected Bluetooth headphones"
}

case "$1" in
    --headphones)
        set_sink "$HEADPHONES_SINK" "Headphones"
        disconnect_bluetooth
        power_off_bluetooth 
        ;;
    --speakers)
        # Switch to speakers
        set_sink "$SPEAKERS_SINK" "Speakers"
        disconnect_bluetooth  
        power_off_bluetooth  
        ;;
    --bluetooth)
        power_on_bluetooth  
        connect_bluetooth  
        set_sink "$BLUETOOTH_SINK" "Bluetooth Headphones"
        ;;
    *)
        echo "Invalid argument. Usage: $0 --headphones | --speakers | --bluetooth"
        echo "Available sinks:"
        pactl list short sinks
        exit 1
        ;;
esac

   '';
in
{
  options.audio-output = { enable = mkEnableOption "Enable 'audio-output' to switch auto outputs"; };

  config = mkIf cfg.enable {
    home.packages = [
      audio-output
    ];
  };
}
