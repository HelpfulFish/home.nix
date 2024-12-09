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

# Get sinks: `pactl list short sinks`
# Define the sink names dynamically

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

connect_bluetooth() {
    echo "Attempting to connect to Bluetooth headphones..."
    bluetoothctl connect "$BLUETOOTH_DEVICE"
    local retries=5
    local delay=2

    for i in $(seq 1 $retries); do
        if [ $? -eq 0 ]; then
            zenity --notification --text="Connected to Bluetooth headphones"
            return 0
        fi
        echo "Connection attempt $i failed. Retrying in $delay seconds..."
        sleep $delay
        bluetoothctl connect "$BLUETOOTH_DEVICE"
    done

    zenity --notification --text="Failed to connect to Bluetooth headphones"
    exit 1
}

disconnect_bluetooth() {
    echo "Disconnecting Bluetooth headphones..."
    bluetoothctl disconnect "$BLUETOOTH_DEVICE"
    zenity --notification --text="Disconnected Bluetooth headphones"
}

# Get the Bluetooth device MAC address dynamically
BLUETOOTH_DEVICE=$(get_device "EDIFIER")

case "$1" in
    --headphones)
        HEADPHONES_SINK=$(get_sink "usb")
        set_sink "$HEADPHONES_SINK" "Headphones"
        disconnect_bluetooth
        power_off_bluetooth
        ;;
    --speakers)
        SPEAKERS_SINK=$(get_sink "hdmi-stereo")
        set_sink "$SPEAKERS_SINK" "Speakers"
        disconnect_bluetooth
        power_off_bluetooth
        ;;
    --bluetooth)
        power_on_bluetooth
        # disconnect_bluetooth  # Disconnect any pre-existing connection
        connect_bluetooth

        # Construct the Bluetooth sink name dynamically
        MAC_ADDRESS=$(echo "$BLUETOOTH_DEVICE" | tr ':' '_')  # Replace ":" with "_"
        BLUETOOTH_SINK="bluez_output.$MAC_ADDRESS.1"

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

