{
  config,
  pkgs,
  pkgs-stable,
  lib,
  nixgl,
  ...
}: {
  # System utilities and command-line tools
  home.packages = with pkgs; [
    # System monitoring
    htop
    btop
    
    # File management
    lsd  # Better ls
    fd   # Better find
    ripgrep  # Better grep
    
    # Terminal utilities
    tmux
    xclip  # Clipboard utility
    
    # Archive and file manipulation
    unzip
    zip
    imagemagick  # Image manipulation (for metadata stripping)
    
    # Network utilities
    curl
    wget
    
    # Media
    # cmus  # Terminal music player
    # yt-dlp  # YouTube downloader
    
    # System information
    neofetch
    
    # Process management
    killall
    
    # Text processing
    jq  # JSON processor
    
    # Notification utilities
    libnotify
  ];
}
