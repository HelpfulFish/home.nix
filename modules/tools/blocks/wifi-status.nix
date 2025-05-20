{ pkgs, ... }:

let
  wifi-status = pkgs.writeShellScriptBin "wifi-status" ''
    #!/bin/bash

    # Handle click events
    case "$BLOCK_BUTTON" in
      1)
        nm-connection-editor &  # Left click: open GUI
        ;;
      3)
        # Right click: toggle Wi-Fi
        WIFI_STATE=$(nmcli radio wifi)
        if [ "$WIFI_STATE" = "enabled" ]; then
          nmcli radio wifi off
        else
          nmcli radio wifi on
        fi
        ;;
    esac

    # Show current connection status
    if [ "$(nmcli radio wifi)" = "disabled" ]; then
      echo "󰖪 Wi-Fi Off"
      exit 0
    fi

    WIFI_INFO=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep '^yes')

    if [ -z "$WIFI_INFO" ]; then
      echo "󰖪 Disconnected"
      exit 0
    fi

    SSID=$(echo "$WIFI_INFO" | cut -d: -f2)
    SIGNAL=$(echo "$WIFI_INFO" | cut -d: -f3)

    if [ "$SIGNAL" -ge 80 ]; then
      ICON="󰤨"
    elif [ "$SIGNAL" -ge 60 ]; then
      ICON="󰤥"
    elif [ "$SIGNAL" -ge 40 ]; then
      ICON="󰤢"
    elif [ "$SIGNAL" -ge 20 ]; then
      ICON="󰤟"
    else
      ICON="󰤯"
    fi

    echo "$ICON $SSID ($SIGNAL%)"
  '';
in {
  home.packages = [
    wifi-status
  ];
}

