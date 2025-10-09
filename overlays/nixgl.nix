# nixGL overlay - create simple wrapper scripts
final: prev: {
  # Simple nixGL wrapper script for anki
  anki-nixgl = final.writeShellScriptBin "anki-nixgl" ''
    if command -v nixGL >/dev/null 2>&1; then
      exec nixGL ${prev.anki}/bin/anki "$@"
    else
      echo "nixGL not found. Install with: nix profile install github:nix-community/nixGL --impure"
      exit 1
    fi
  '';
  
  # Simple nixGL wrapper script for alacritty  
  alacritty-nixgl = final.writeShellScriptBin "alacritty-nixgl" ''
    if command -v nixGL >/dev/null 2>&1; then
      exec nixGL ${prev.alacritty}/bin/alacritty "$@"
    else
      echo "nixGL not found. Install with: nix profile install github:nix-community/nixGL --impure"
      exit 1
    fi
  '';
}
