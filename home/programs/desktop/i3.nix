{
  config,
  pkgs,
  lib,
  ...
}: {
  # i3 Window Manager Configuration
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;

    # You can add i3 config here or use the config file approach
    # config = {
    #   # i3 configuration options
    # };
  };

  # X session configuration for proper theming
  xsession = {
    enable = true;
    
    # Set environment variables for the X session
    profileExtra = ''
      # Qt theming
      export QT_QPA_PLATFORMTHEME=kde
      export QT_STYLE_OVERRIDE=breeze
      export QT_QPA_PLATFORM=xcb
      export QT_AUTO_SCREEN_SCALE_FACTOR=0
      
      # GTK theming
      export GTK_THEME=Adwaita:dark
      
      # Ensure XDG directories are set
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_CACHE_HOME="$HOME/.cache"
    '';
  };

  # i3blocks configuration
  # The actual config files are symlinked via home.file
  home.file = {
    ".config/i3" = {
      source = ../../../config/i3;
      recursive = true;
    };

    ".config/i3blocks" = {
      source = ../../../config/i3blocks;
      recursive = true;
    };
  };

  # Services related to i3
  services = {
    # Enable screen locker
    screen-locker = {
      enable = false;  # Set to true if you want automatic screen locking
      # inactiveInterval = 10;  # Lock after 10 minutes
    };
  };
}
