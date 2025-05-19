{ config, pkgs, ... }:

{
  home.sessionPath = [
    "$HOME/bin"
  ];

  fonts.fontconfig.enable = true;

  # Packages: https://search.nixos.org/packages
  home.packages = with pkgs; [
    anki
    # (config.lib.nixGL.wrap anki)
    (config.lib.nixGL.wrap alacritty)
    # (config.lib.nixGL.wrap brave)
    brave
    fira-code
    krita
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
    dunst
    flameshot
    imagemagick # strip image metadata
    # libnotify
    tldr
    yt-dlp
    tmux
    xclip
   
    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.fantasque-sans-mono
    powerline-fonts
  ];
}
