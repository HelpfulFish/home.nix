{ pkgs, ... }:

let
  wifi-status = pkgs.writeShellScriptBin "wifi-status" ''
#!/bin/bash

# Get the current active Wi-Fi connection
WIFI_INFO=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep '^yes')

if [ -z "$WIFI_INFO" ]; then
  echo "󰖪 Disconnected"  # nf-md-wifi_off
  exit 0
fi

# Parse fields
SSID=$(echo "$WIFI_INFO" | cut -d: -f2)
SIGNAL=$(echo "$WIFI_INFO" | cut -d: -f3)

# Select icon based on signal strength
if [ "$SIGNAL" -ge 80 ]; then
  ICON="󰤨"  # nf-md-wifi_strength_4
elif [ "$SIGNAL" -ge 60 ]; then
  ICON="󰤥"  # nf-md-wifi_strength_3
elif [ "$SIGNAL" -ge 40 ]; then
  ICON="󰤢"  # nf-md-wifi_strength_2
elif [ "$SIGNAL" -ge 20 ]; then
  ICON="󰤟"  # nf-md-wifi_strength_1
else
  ICON="󰤯"  # nf-md-wifi_strength_outline
fi

echo "$ICON $SSID ($SIGNAL%)"
  '';
in {
  home.packages = [
    wifi-status
  ];
}

