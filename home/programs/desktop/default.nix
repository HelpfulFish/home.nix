{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./i3.nix
    ./terminal.nix
    ./notifications.nix
  ];

  # Desktop environment file configurations
  home.file = {
    # Wallpapers
    ".wallpapers" = {
      source = ../../../config/wallpapers;
      recursive = true;
    };
  };
}
