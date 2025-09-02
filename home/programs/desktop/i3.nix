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
