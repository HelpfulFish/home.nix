{
  config,
  pkgs,
  lib,
  ...
}: {
  # Neovim configuration
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    
    # You can add plugins and extra config here
    # plugins = with pkgs.vimPlugins; [
    #   # Add vim plugins here
    # ];
  };

  # LazyVim configuration files
  home.file = {
    ".config/nvim" = {
      source = ../../../config/nvim;
      recursive = true;
    };
  };
}
