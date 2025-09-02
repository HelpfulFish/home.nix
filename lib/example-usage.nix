{
  config,
  pkgs,
  lib,
  myLib,
  ...
}: 
let
  # Use helper to conditionally include packages
  devPackages = myLib.conditionalPackages true [
    pkgs.git
    pkgs.vim
    pkgs.curl
  ];
  
  guiPackages = myLib.conditionalPackages (builtins.getEnv "DISPLAY" != "") [
    pkgs.firefox
    pkgs.vscode
  ];
  
  # Merge package lists
  allPackages = myLib.mergePackages [ devPackages guiPackages ];
  
  # Create development scripts using helper
  myScripts = [
    (myLib.mkDevScript "update-system" ''
      echo "Updating home-manager..."
      cd ~/.config/home-manager
      nix flake update
      home-manager switch --flake .#default
    '')
    
    (myLib.mkDevScript "clean-nix" ''
      echo "Cleaning Nix store..."
      nix-collect-garbage -d
      nix-store --gc
    '')
  ];
  
in {
  # Example of using the lib helpers
  home.packages = allPackages ++ myScripts;
  
  # This could be used in any module that needs conditional logic
}
