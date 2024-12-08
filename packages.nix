{ config, pkgs, ... }:

{
  home.sessionPath = [
    "$HOME/bin"
  ];

  fonts.fontconfig.enable = true;

  # Packages: https://search.nixos.org/packages
  home.packages = with pkgs; [
    (config.lib.nixGL.wrap anki)
    (config.lib.nixGL.wrap alacritty)
    (config.lib.nixGL.wrap brave)
    dmenu
    fira-code
    i3
    i3lock
    # i3status
    i3blocks
    lazygit
    (config.lib.nixGL.wrap mpv)
    (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" "FantasqueSansMono" ]; })
    (config.lib.nixGL.wrap obsidian)
    powerline-fonts
    tldr
    vim
    vscode
  ];
}
