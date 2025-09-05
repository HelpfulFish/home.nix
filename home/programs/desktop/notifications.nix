{
  config,
  pkgs,
  lib,
  ...
}: {
  # Notification system configuration
  
  # Dunst notification daemon configuration
  home.file = {
    ".config/dunst" = {
      source = ../../../config/dunst;
      recursive = true;
    };
  };
}
