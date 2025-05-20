{ pkgs, ... }:

let
  flight-mode = pkgs.writeShellScriptBin "flight-mode" ''
    #!/bin/bash

    # Click actions
    case "$BLOCK_BUTTON" in
      3)
        WIFI_STATE=$(nmcli -t -f WIFI radio)
        WWAN_STATE=$(nmcli -t -f WWAN radio)
        if [ "$WIFI_STATE" = "disabled" ] && [ "$WWAN_STATE" = "disabled" ]; then
          nmcli radio all on
        else
          nmcli radio all off
        fi
        ;;
    esac

    # Check flight mode status
    WIFI_STATE=$(nmcli -t -f WIFI radio)
    WWAN_STATE=$(nmcli -t -f WWAN radio)

    if [ "$WIFI_STATE" = "disabled" ] && [ "$WWAN_STATE" = "disabled" ]; then
      echo "󰀝 Flight Mode"
    fi
  '';
in {
  home.packages = [
    flight-mode
  ];
}

