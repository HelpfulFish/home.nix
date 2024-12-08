{ pkgs, ... }:

let
  # Define the binary using writeShellScriptBin
  calendar = pkgs.writeShellScriptBin "calendar" ''
    #!/bin/sh

    # Get current date in DD-MM-YYYY format
    current_date=$(date +"%d-%m-%Y")
    echo " $current_date"
  '';
in {
  # Ensure the binary is added to the PATH
  home.packages = [
    calendar
  ];
}

