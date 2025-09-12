# Font configuration with Nerd Fonts for terminal icons and development
{ pkgs, ... }:

{
  # Font packages
  home.packages = with pkgs; [
    # Nerd Fonts for terminal icons and powerline symbols
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.fantasque-sans-mono
    
    # Additional fonts (uncomment as needed)
    # nerd-fonts.jetbrains-mono
    # nerd-fonts.hack
    # nerd-fonts.source-code-pro
    # nerd-fonts.ubuntu-mono
    
    # Regular fonts for system use
    # fira-code                    # Clean programming font
    # source-code-pro            # Adobe's programming font
    # jetbrains-mono             # JetBrains IDE font
    
    # System fonts (uncomment if needed)
    # liberation_ttf             # Microsoft font alternatives
    # dejavu_fonts               # Unicode coverage
    # noto-fonts                 # Google's font family
    # noto-fonts-emoji           # Emoji support
  ];

  # Enable fontconfig for proper font rendering
  fonts.fontconfig.enable = true;
}
