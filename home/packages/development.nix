{
  config,
  pkgs,
  pkgs-stable,
  lib,
  nixgl,
  ...
}: {
  # Development tools and programming languages
  home.packages = with pkgs; [
    # Editors
    vim
    vscode
    
    # Version control
    git
    lazygit
    # gh  # GitHub CLI
    
    # Languages and runtimes
    # nodejs
    # python3
    # rustc
    # cargo
    # zig
    
    # Containerization
    # docker
    # lazydocker
    # podman
    
    # Build tools and utilities
    # gnumake
    # cmake
    # pkg-config
    
    # Language servers and formatters
    # nil  # Nix LSP
    # nixfmt-rfc-style
    
    # Documentation and help
    tldr
    # manix  # Search Nix documentation
  ];
}
