{ pkgs, ... }:

let
  docker-status = pkgs.writeShellScriptBin "docker-status" ''
    #!/bin/bash

    # Check if Docker daemon is running
    if ! docker info >/dev/null 2>&1; then
        exit 0  # Don't show anything if Docker isn't running
    fi

    # Count running containers
    RUNNING_CONTAINERS=$(docker ps -q | wc -l)

    # Only show if there are running containers
    if [ "$RUNNING_CONTAINERS" -gt 0 ]; then
        echo " 󰡨 $RUNNING_CONTAINERS"
    fi
  '';
in {
  home.packages = [
    docker-status
  ];
}
