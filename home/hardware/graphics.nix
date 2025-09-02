{
  config,
  pkgs,
  lib,
  nixgl,
  ...
}: {
  # NixGL configuration for GPU support on non-NixOS systems
  # Documentation: https://github.com/nix-community/nixGL
  
  # Make nixGL packages available without the problematic time dependency
  home.packages = with nixgl; [
    nixGLNvidia
    # nixVulkanNvidia  # Commented out due to currentTime issue
  ];
  
  # Session variables for GPU acceleration
  home.sessionVariables = {
    # Uncomment if using Anki with QT issues
    # QT_XCB_GL_INTEGRATION = "none";
  };
}
