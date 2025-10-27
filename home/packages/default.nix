{ config
, pkgs
, pkgs-stable
, lib
, nixgl
, ...
}: {
  home.packages = with pkgs; [
    # === SYSTEM UTILITIES ===
    tmux
    xclip # Clipboard utility for X11
    imagemagick # Image manipulation (for metadata stripping)
    libnotify # Desktop notifications

    # === DEVELOPMENT TOOLS ===
    vscode
    lazygit
    tldr
    gh

    # === DESKTOP APPLICATIONS ===
    alacritty
    joplin-desktop
    ollama # AI and ML

    # === WINDOW MANAGER & DESKTOP ===
    i3blocks
    dmenu
    feh # Image viewer and wallpaper setter
    flameshot # Screenshot tool
    gnome-keyring # Keyring management

    # === AUDIO ===
    playerctl

    # === NETWORKING ===
    networkmanagerapplet

    # === OPTIONAL PACKAGES (uncomment as needed) ===
    # System monitoring
    # htop
    # btop              # Alternative to htop

    # Archives and file manipulation
    # unzip             # Archive extraction
    # zip               # Archive creation

    # Network utilities
    # curl
    # wget

    # Media tools
    # cmus              # Terminal music player
    # yt-dlp              # YouTube downloader for mpv

    # System information
    # neofetch          # System info display

    # Development tools
    # gh                # GitHub CLI
    # docker            # Containerization
    # lazydocker        # Docker TUI
    # podman            # Alternative to Docker
    # gnumake           # Build tool
    # cmake             # Build system
    # pkg-config        # Package configuration
    # tree              # Directory tree viewer
    # manix             # Search Nix documentation
    # httpie            # HTTP client

    # Desktop applications
    # brave             # Browser
    mpv # Media player
    obsidian # Note taking
    # krita             # Digital painting

    # === NIXGL WRAPPED APPLICATIONS ===
    # These are automatically wrapped with nixGL via overlay
    anki-nixgl # GPU accelerated Anki
    alacritty-nixgl # GPU accelerated Alacritty (if needed)
    picom-nixgl # GPU accelerated picom compositor
    # krita-nixgl       # GPU accelerated Krita (if needed)
  ];

  # Note: For GPU acceleration with nixGL, you can manually wrap applications like:
  # nixVulkanNvidia alacritty
  # nixGLNvidia <application>
}
