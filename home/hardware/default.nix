{
  config,
  pkgs,
  lib,
  nixgl,
  ...
}: {
  imports = [
    ./graphics.nix
  ];
}
