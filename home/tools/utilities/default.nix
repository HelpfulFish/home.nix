{
  imports = [
    ./docker-down.nix
    ./audio-output.nix
    ./dmenu-flatpak.nix
    ./strip-metadata.nix
  ];

  audio-output.enable = true;
  docker-down.enable = true;
  dmenu-flatpak.enable = true;
}
