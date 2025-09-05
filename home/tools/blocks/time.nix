{ pkgs, ... }:

let
  # Define the binary using writeShellScriptBin
  current-time = pkgs.writeShellScriptBin "current-time" ''
    #!/bin/sh

    current_time=$(date +"%I:%M %p")
    echo $current_time
  '';
in {
  # Ensure the binary is added to the PATH
  home.packages = [
    current-time
  ];
}

