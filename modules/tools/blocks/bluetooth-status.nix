{ pkgs, ... }:

let
  # Define the binary using writeShellScriptBin
  bluetooth-status = pkgs.writeShellScriptBin "bluetooth-status" ''
    #!/bin/sh

if bluetoothctl show | grep -q "Powered: yes"; then
    echo "󰂯 ON"
else
    echo "󰂲 OFF"
fi

  '';
in {
  # Ensure the binary is added to the PATH
  home.packages = [
    bluetooth-status
  ];
}

