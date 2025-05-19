{ pkgs, ... }:

let
  wifi-status = pkgs.writeShellScriptBin "wifi-status" ''
#!/bin/bash

# Detect click
# 1) = left click
# 3) = right click
case "$BLOCK_BUTTON" in
  1) 
    nm-connection-editor &  # GUI alternative
    ;;
esac

# Show current connection
WIFI_INFO=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep '^yes')

if [ -z "$WIFI_INFO" ]; then
  echo "󰖪 Disconnected"  # nf-md-wifi_off
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

