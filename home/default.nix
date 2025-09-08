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

  # Session path for custom binaries
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"      # Rust cargo binaries
    "$HOME/.npm-global/bin" # Global npm packages
  ];

  # Core session variables
  home.sessionVariables = {
    EDITOR = "code";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    
    # Nix configuration
    NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
    
    # Qt theming (uncomment if needed)
    # QT_QPA_PLATFORMTHEME = "kde";
    # QT_STYLE_OVERRIDE = "breeze";
  };

  # File symlinks and configurations
  home.file = {
    # ZSH scripts
    ".config/zsh/scripts" = {
      source = ../scripts;
      recursive = true;
    };

    # X11 configuration for cursor size
    ".Xresources".text = ''
      Xcursor.size: 8
    '';
  };

  # XDG configuration
  xdg = {
    enable = true;
    mime.enable = true;
  };
}
