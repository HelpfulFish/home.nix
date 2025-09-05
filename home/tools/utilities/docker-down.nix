{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.docker-down;

  writeScriptDir = path: text:
    pkgs.writeTextFile {
      inherit text;
      executable = true;
      name = builtins.baseNameOf path;
      destination = "${path}";
    };

  docker-down = pkgs.writeShellScriptBin "docker-down" ''
      #!/bin/sh

      # Determine the container runtime (docker or podman)
      if command -v docker >/dev/null 2>&1; then
        runtime=docker
      elif command -v podman >/dev/null 2>&1; then
        runtime=podman
      else
        echo "Error: Neither Docker nor Podman is installed." >&2
        exit 1
      fi

      echo "Using container runtime: $runtime"

      # Get list of running containers
      containers=$($runtime ps -aq)

      # Get list of volumes (Podman uses a different command for volumes)
      if [ "$runtime" = "podman" ]; then
        volumes=$($runtime volume ls --quiet --format '{{.Name}}')
      else
        volumes=$($runtime volume ls -q)
      fi

      if [ -z "$containers" ] && [ -z "$volumes" ]; then
        echo "Nothing to bring down..."
      else
        if [ -n "$containers" ]; then
          echo "Stopping and removing containers..."
          $runtime stop $containers
          $runtime rm $containers
        fi

        if [ -n "$volumes" ]; then
          echo "Removing volumes..."
          $runtime volume rm $volumes
        fi
      fi
  '';
in
{
  options.docker-down = { enable = mkEnableOption "Enable 'docker-down' script to clear containers and volumes"; };

  config = mkIf cfg.enable {
    home.packages = [
      docker-down
    ];
  };
}

