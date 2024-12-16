{
  imports = [
    ./docker-down.nix
    ./audio-output.nix
    ./dmenu-flatpak.nix

    ./strip-metadata.nix

    # i3blocks
    ./blocks/volume.nix
    ./blocks/audio-device-status.nix
    ./blocks/time.nix
    ./blocks/calendar.nix
    ./blocks/memory.nix
    ./blocks/bluetooth-status.nix
    ./blocks/gpu-info.nix
  ];
}
