{
  config,
  pkgs,
  pkgs-stable,
  lib,
  nixgl,
  ...
}: {
  # Desktop and GUI applications
  home.packages = with pkgs; [
    # Terminal emulator (you can wrap with nixGL manually later)
    alacritty
    
    # Browsers and communication
    # brave
    
    # Media and graphics
    # mpv
    # obsidian
    # krita
    
    # Productivity
    joplin-desktop
    # anki
    
    # AI and ML
    ollama

    # Window manager and desktop utilities
    i3blocks
    dmenu
    feh  # Image viewer and wallpaper setter
    dunst  # Notification daemon
    flameshot  # Screenshot tool
    gnome-keyring  # Keyring management

    # Fonts
    fira-code
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
  ];
  
  # Note: For GPU acceleration, you can manually wrap applications like:
  # nixVulkanNvidia alacritty
  # nixGLNvidia <application>
}
