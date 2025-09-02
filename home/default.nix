{
  config,
  pkgs,
  pkgs-stable,
  lib,
  nixgl,
  inputs,
  userConfig,
  ...
}: {
  imports = [
    ./programs
    ./services
    ./packages
    # ./hardware  # Temporarily disabled due to nixGL issues
    ./tools
  ];

  # Basic home configuration
  home = {
    username = userConfig.username;
    homeDirectory = userConfig.homeDirectory;

    stateVersion = "24.05";

    # Session variables
    sessionVariables = {
      EDITOR = "code";
      NVM_DIR = "$HOME/.config/nvm";
      NVM_DIRECTORY = "$HOME/Documents/nvm";
      
      # Nix configuration
      NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
    };

    sessionPath = [
      "$HOME/bin"
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/.npm-global/bin"
    ];

    # File symlinks and configurations
    file = {
      # ZSH scripts
      ".config/zsh/scripts" = {
        source = ../scripts;
        recursive = true;
      };

      # X11 configuration
      ".Xresources".text = ''
        Xcursor.size: 8
      '';
    };
  };

  # XDG configuration
  xdg = {
    enable = true;
    mime.enable = true;
  };

  # Generic Linux target
  targets.genericLinux.enable = true;

  # Nix configuration
#   nix = {
#     package = pkgs.nix;
#     settings = {
#       experimental-features = [ "nix-command" "flakes" ];
#       auto-optimise-store = true;
#       warn-dirty = false;
#       extra-substituters = [
#         "https://cache.nixos.org/"
#         "https://nix-community.cachix.org"
#       ];
#       extra-trusted-public-keys = [
#         "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
#         "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
#       ];
#     };
#   };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Font configuration
  fonts.fontconfig.enable = true;
}
