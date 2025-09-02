# Main overlay composition
# This file imports and composes all overlays
final: prev:

# Import other overlays
let
  pinnedOverlay = import ./pinned.nix;
in
  # Compose overlays
  (pinnedOverlay final prev) // {
    # Add any additional overlays here
  }
