# Main overlay composition
final: prev: 
# Import all overlays
(import ./nixgl.nix final prev) // {
  # Import pinned packages if needed
  # (import ./pinned.nix final prev) // {
  #   # Add any additional overlays here
  # }
}
