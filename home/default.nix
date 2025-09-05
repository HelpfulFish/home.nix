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
    # Core system packages (CLI tools, utilities)
    ./packages
    
    # Program configurations (shell, editors, development, desktop)
    ./programs
    
    # System services (keyring, notifications, etc.)
    ./services
    
    # Custom tools and scripts (i3blocks, utilities)
    ./tools
    
    # Hardware-specific configurations (temporarily disabled)
    # ./hardware  # Disabled due to nixGL issues
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

      # Qt theming - Force KDE/Plasma style for Qt applications
      # QT_QPA_PLATFORMTHEME = "kde";
      
      # # Additional Qt theming variables
      # QT_STYLE_OVERRIDE = "breeze";  # Use Breeze style as fallback
      
      # # GTK theming
      # GTK_THEME = "Adwaita:dark";    # Force dark theme for GTK applications
      
      # # XSettings for theme coordination
      # QT_AUTO_SCREEN_SCALE_FACTOR = "0";  # Disable automatic scaling
      
      # # Ensure QT apps respect the system theme
      # QT_QPA_PLATFORM = "xcb";      # Use X11 backend (important for i3wm)
      
      # # Additional variables for complete theming support
      # QT_SELECT = "5";              # Prefer Qt5 when available
      # QT_QPA_PLATFORMTHEME_5 = "kde"; # Explicitly set for Qt5
      # QT_QPA_PLATFORMTHEME_6 = "kde"; # Explicitly set for Qt6
      # QT5_PLATFORM_THEME = "kde";    # Alternative Qt5 variable
      
      # # Ensure configuration tools are available
      # QT_QPA_PLATFORMTHEME_CONFIG = "qt5ct:qt6ct";
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
