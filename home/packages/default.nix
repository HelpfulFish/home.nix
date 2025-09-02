{
  config,
  pkgs,
  pkgs-stable,
  lib,
  nixgl,
  ...
}: {
  imports = [
    ./desktop.nix
    ./development.nix
    ./system.nix
  ];

  # Enable font configuration
  fonts.fontconfig.enable = true;

  # Session path additions
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];
}
