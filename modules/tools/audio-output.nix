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

LOCKFILE="/tmp/audio-output.lock"
LOGFILE="/tmp/audio-output.log"
LOGGING_ENABLED=${toString cfg.enableLogs}

log() {
    if [ "$LOGGING_ENABLED" = 1 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
    fi
}

# Create a lock file
acquire_lock() {
    log "Attempting to acquire lock..."
    exec 9>"$LOCKFILE" || exit 1
    flock -n 9 || {
        log "Another instance of the script is running. Exiting."
        exit 1
    }
    log "Lock acquired."
}

# Release the lock file
release_lock() {
    log "Releasing lock."
    flock -u 9
    rm -f "$LOCKFILE"
}
trap release_lock EXIT

# Parse arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        --headphones|--speakers|--bluetooth)
            TARGET="$1"
            shift
            ;;
        *)
            echo "Invalid argument: $1"
            echo "Usage: $0 --headphones | --speakers | --bluetooth"
            exit 1
            ;;
    esac
done

if [ -z "$TARGET" ]; then
    echo "Error: No target specified."
    echo "Usage: $0 --headphones | --speakers | --bluetooth"
    exit 1
fi

acquire_lock

get_sink() {
    local sink_name=$(pactl list short sinks | awk "/$1/ {print \$2}")
    if [ -z "$sink_name" ]; then
        log "Error: No sink found for $1"
        exit 1
    fi
    echo "$sink_name"
}

get_device() {
    local device_mac=$(bluetoothctl devices | awk "/$1/ {print \$2}")
    if [ -z "$device_mac" ]; then
        log "Error: No Bluetooth device found for $1"
        exit 1
    fi
    echo "$device_mac"
}

set_sink() {
    local sink_name="$1"
    local sink_friendly_name="$2"
    pactl set-default-sink "$sink_name" || {
        log "Error: Failed to set default sink to $sink_name"
        exit 1
    }

    for INPUT in $(pactl list short sink-inputs | cut -f1); do
        pactl move-sink-input "$INPUT" "$sink_name" || {
            log "Error: Failed to move sink input $INPUT to $sink_name"
        }
    done

    log "Switched to $sink_friendly_name"
    zenity --notification --text="Switched to $sink_friendly_name"
}

power_on_bluetooth() {
    log "Powering on Bluetooth adapter..."
    rfkill unblock bluetooth || true
    bluetoothctl power on || {
        log "Error: Failed to power on Bluetooth"
        exit 1
    }
    log "Bluetooth adapter powered on."
}

power_off_bluetooth() {
    log "Powering off Bluetooth adapter..."
    bluetoothctl power off || {
        log "Error: Failed to power off Bluetooth"
        exit 1
    }
    log "Bluetooth adapter powered off."
}

connect_bluetooth() {
    log "Attempting to connect to Bluetooth headphones..."
    local retries=5
    local delay=1

    for i in $(seq 1 $retries); do
        bluetoothctl connect "$BLUETOOTH_DEVICE" && {
            log "Bluetooth headphones connected successfully."
            return 0
        }
        log "Connection attempt $i failed. Retrying in $delay seconds..."
        sleep $delay
    done

    log "Error: Failed to connect to Bluetooth headphones after $retries attempts"
    exit 1
}

disconnect_bluetooth() {
    log "Disconnecting Bluetooth headphones..."
    bluetoothctl disconnect "$BLUETOOTH_DEVICE" || log "Warning: No active connection to disconnect"
    log "Bluetooth headphones disconnected."
    zenity --notification --text="Disconnected Bluetooth headphones"
}

BLUETOOTH_DEVICE=$(get_device "EDIFIER")

case "$TARGET" in
    --headphones)
        log "Switching to headphones..."
        HEADPHONES_SINK=$(get_sink "usb")
        set_sink "$HEADPHONES_SINK" "Headphones"
        disconnect_bluetooth
        power_off_bluetooth
        log "Switched to headphones."
        ;;
    --speakers)
        log "Switching to speakers..."
        SPEAKERS_SINK=$(get_sink "hdmi-stereo")
        set_sink "$SPEAKERS_SINK" "Speakers"
        disconnect_bluetooth
        power_off_bluetooth
        log "Switched to speakers."
        ;;
    --bluetooth)
        log "Switching to Bluetooth headphones..."
        power_on_bluetooth
        connect_bluetooth

        MAC_ADDRESS=$(echo "$BLUETOOTH_DEVICE" | tr ':' '_')
        BLUETOOTH_SINK="bluez_output.$MAC_ADDRESS.1"

        set_sink "$BLUETOOTH_SINK" "Bluetooth Headphones"
        log "Switched to Bluetooth headphones."
        ;;
    *)
        log "Invalid argument: $TARGET"
        echo "Usage: $0 --headphones | --speakers | --bluetooth"
        exit 1
        ;;
esac
'';
in
{
  options.audio-output = {
    enable = mkEnableOption "Enable 'audio-output' to switch auto outputs.";
    enableLogs = mkOption {
      type = types.bool;
      default = false;
      description = "Enable logging for the audio-output script.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      audio-output
    ];
  };
}

