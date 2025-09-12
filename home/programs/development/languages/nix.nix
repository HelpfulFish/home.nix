# Nix development environment
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Nix development tools
    nil               # Nix language server
    nixfmt-rfc-style  # RFC-style formatter
    statix            # Static analyzer
    nix-tree          # Dependency tree viewer
    nix-diff          # Compare derivations
    
    # Additional tools
    cachix            # Binary cache management
    # nix-update      # Update package versions (uncomment if needed)
  ];

  # Nix-specific aliases for zsh
  programs.zsh.shellAliases = {
    nix-search = "nix search nixpkgs";
    nix-shell-pure = "nix-shell --pure";
    
    # Flake commands
    nix-flake-update = "nix flake update";
    nix-flake-check = "nix flake check";
    nix-flake-show = "nix flake show";
    
    # Home Manager shortcuts
    hm-switch = "home-manager switch --flake .";
    hm-build = "home-manager build --flake .";
  };
}
