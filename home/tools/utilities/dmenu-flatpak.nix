{ config, lib, pkgs, ... }:

with lib;

let

    cfg = config.dmenu-flatpak;
    
    writeScriptDir = path: text:
    pkgs.writeTextFile {
      inherit text;
      executable = true;
      name = builtins.baseNameOf path;
      destination = "${path}";
    };

    dmenu-flatpak = pkgs.writeShellScriptBin "dmenu-flatpak" ''
      #!/bin/bash

      # define default colors
      DEFAULT_NB="#222222"   # default normal background
      DEFAULT_SB="#005577"   # default selected background
      DEFAULT_NF="#eeeeee"   # default normal foreground

      # initialize color variables with default values
      nb=$DEFAULT_NB
      sb=$DEFAULT_SB
      nf=$DEFAULT_NF

      # Parse arguments
      while [[ $# -gt 0 ]]; do
          case $1 in
              -nb)
                  nb="$2"
                  shift
                  shift
                  ;;
              -sb)
                  sb="$2"
                  shift
                  shift
                  ;;
              -nf)
                  nf="$2"
                  shift
                  shift
                  ;;
              --debug)
                  DEBUG_MODE=false
                  shift # past argument
                  ;;
              *)
                  echo "Unknown option $1"
                  shift
                  ;;
          esac
      done

      # list all installed Flatpak applications and display unique application IDs
      apps=$(flatpak list --app --columns=application | sort -u)

      # debug: output the apps variable if debug mode is enabled
      if $DEBUG_MODE; then
          echo "Applications list:" > /tmp/flatpak_apps.txt
          echo "$apps" >> /tmp/flatpak_apps.txt
      fi

      # use dmenu to select an application with custom colors
      selected_app=$(echo "$apps" | dmenu -i -p "flatpak:" -nb "$nb" -sb "$sb" -nf "$nf" | xargs)

      # debug: output the selected app if debug mode is enabled
      if $DEBUG_MODE; then
          echo "Selected application: '$selected_app'" > /tmp/selected_flatpak_app.txt
      fi

      # check if selected_app is empty or not
      if [ -n "$selected_app" ]; then
          # verify the selected application is valid by checking if it is in the list of installed applications
          if echo "$apps" | grep -q "^$selected_app$"; then
              if $DEBUG_MODE; then
                  echo "Running application: '$selected_app' in background" >> /tmp/selected_flatpak_app.txt
              fi
              flatpak run "$selected_app" &
          else
              if $DEBUG_MODE; then
                  echo "Invalid application ID: '$selected_app'" >> /tmp/selected_flatpak_app.txt
              fi
          fi
      else
          if $DEBUG_MODE; then
              echo "No application selected or error in selection." >> /tmp/selected_flatpak_app.txt
          fi
      fi

    '';
in
{
  options.dmenu-flatpak = { enable = mkEnableOption "Enable 'dmenu-flatpak' to switch auto outputs"; };

  config = mkIf cfg.enable {
    home.packages = [
      dmenu-flatpak
    ];
  };
}