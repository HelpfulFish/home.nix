{
  imports = [
    # i3blocks scripts
    ./blocks/volume.nix
    ./blocks/audio-device-status.nix
    ./blocks/time.nix
    ./blocks/calendar.nix
    ./blocks/memory.nix
    ./blocks/bluetooth-status.nix
    ./blocks/gpu-info.nix
    
    # System utilities
    ./utilities/strip-metadata.nix
    ./utilities/docker-down.nix
    ./utilities/audio-output.nix
    ./utilities/dmenu-flatpak.nix
  ];
}
