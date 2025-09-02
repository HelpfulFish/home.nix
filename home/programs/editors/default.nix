{
  imports = [
    ./neovim.nix
    ./vscode.nix
  ];

  # Additional editor configurations
  home.file = {
    # Alacritty terminal configuration
    ".config/alacritty" = {
      source = ../../../config/alacritty;
      recursive = true;
    };

    # Dunst notification configuration
    ".config/dunst" = {
      source = ../../../config/dunst;
      recursive = true;
    };

    # Wallpapers
    ".wallpapers" = {
      source = ../../../config/wallpapers;
      recursive = true;
    };
  };
}
