{
  config,
  pkgs,
  lib,
  ...
}: {
  # Terminal emulator configuration
  
  # Alacritty configuration files
  home.file = {
    ".config/alacritty" = {
      source = ../../../config/alacritty;
      recursive = true;
    };
  };
}
