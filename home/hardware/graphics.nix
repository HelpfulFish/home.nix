{
  config,
  pkgs,
  lib,
  nixgl,
  ...
}: {
  # NixGL configuration for GPU support on non-NixOS systems
  # Documentation: https://github.com/nix-community/nixGL
  
  # Install nixGL globally via nix profile (run this manually):
  # nix profile install github:nix-community/nixGL --impure
  
  # Session variables for GPU acceleration
  home.sessionVariables = {
    # Fix for Anki QT/GLX issues
    QT_XCB_GL_INTEGRATION = "none";
  };
}
