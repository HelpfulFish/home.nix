{ pkgs, ... }:

let
  bluetooth-status = pkgs.writeShellScriptBin "bluetooth-status" ''
    #!/bin/sh

    if [ "$BLOCK_BUTTON" = "1" ]; then
      # Toggle Bluetooth power on left click
      if bluetoothctl show | grep -q "Powered: yes"; then
        bluetoothctl power off
      else
        bluetoothctl power on
      fi
    fi

    # Show current Bluetooth status
    if bluetoothctl show | grep -q "Powered: yes"; then
      echo "󰂯 ON "
    else
      echo "󰂲 OFF "
    fi
  '';
in {
  home.packages = [
    bluetooth-status
  ];
}

