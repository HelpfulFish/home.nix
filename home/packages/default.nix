{
  config,
  pkgs,
  pkgs-stable,
  lib,
  nixgl,
  ...
}: {
  imports = [
    # Core system packages and utilities
    ./system.nix
    
    # Development tools and languages
    ./development.nix
    
    # Desktop applications and GUI tools
    ./desktop.nix
  ];

  # Global font configuration
  fonts.fontconfig.enable = true;

  # Global session path additions
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];
}
