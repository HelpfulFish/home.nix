# nixGL overlay - create simple wrapper scripts
# NOTE: nix run --impure github:nix-community/nixGL#nixGLNvidia -- <program_name> is a workaround, ideally install nixGL globally

final: prev: {
  # Simple nixGL wrapper script for anki
  anki-nixgl = final.writeShellScriptBin "anki-nixgl" ''
    if command -v nixGL >/dev/null 2>&1; then
      exec nix run --impure github:nix-community/nixGL#nixGLNvidia -- ${prev.anki}/bin/anki "$@"
    else
      echo "nixGL not found. Install with: nix profile install github:nix-community/nixGL --impure"
      exit 1
    fi
  '';
  
  # Simple nixGL wrapper script for alacritty  
  alacritty-nixgl = final.writeShellScriptBin "alacritty-nixgl" ''
    if command -v nixGL >/dev/null 2>&1; then
      exec nix run --impure github:nix-community/nixGL#nixGLNvidia ${prev.alacritty}/bin/alacritty "$@"
    else
      echo "nixGL not found. Install with: nix profile install github:nix-community/nixGL --impure"
      exit 1
    fi
  '';
  
  # Simple nixGL wrapper script for picom
  # picom-nixgl = final.writeShellScriptBin "picom-nixgl" ''
  #   if command -v nixGL >/dev/null 2>&1; then
  #     exec nix run --impure github:nix-community/nixGL#nixGLNvidia ${prev.picom}/bin/picom "$@"
  #   else
  #     echo "nixGL not found. Install with: nix profile install github:nix-community/nixGL --impure"
  #     exit 1
  #   fi
  # '';
}
