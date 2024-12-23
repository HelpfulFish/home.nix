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
    fira-code
    lazygit
    (config.lib.nixGL.wrap mpv)
    (config.lib.nixGL.wrap obsidian)
    vim
    vscode

    # i3
    i3
    i3lock
    # i3status
    i3blocks
    dmenu
    feh

    # tools
    cmus 
    imagemagick # strip image metadata
    tldr
    yt-dlp
    tmux
   
    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.fantasque-sans-mono
    powerline-fonts
  ];
}
