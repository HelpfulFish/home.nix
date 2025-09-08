{
  config,
  pkgs,
  lib,
  myLib ? null,
  ...
}: {
  # Git configuration
  programs.git = {
    enable = true;
    
    # Basic configuration - you can set these via environment variables:
    # export GIT_USER_NAME="Your Name"
    # export GIT_USER_EMAIL="your@email.com"
    # Or update the defaults below
    userName = 
      let envName = builtins.getEnv "GIT_USER_NAME";
      in if envName != "" then envName else lib.mkDefault "your_username";  # Update this with your username
    
    userEmail = 
      let envEmail = builtins.getEnv "GIT_USER_EMAIL";
      in if envEmail != "" then envEmail else lib.mkDefault "your.email@example.com";  # Update this with your email
    
    # Git settings
    extraConfig = {
      init = {
        defaultBranch = lib.mkDefault "main";
      };
      
      pull = {
        rebase = lib.mkDefault true;
      };
      
      push = {
        default = "simple";
        autoSetupRemote = lib.mkDefault true;
      };
      
      core = {
        editor = "code --wait";  # Use VS Code as default editor
        autocrlf = "input";
      };
      
      # Better diffs
      diff = {
        algorithm = "patience";
        compactionHeuristic = true;
      };
      
      # Rerere (reuse recorded resolution)
      rerere = {
        enabled = true;
      };
    };
    
    # Git aliases for productivity
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      cm = "commit -m";
      unstage = "reset HEAD --";
    };
    
    # Delta for better diffs (optional)
    delta = {
      enable = false;  # Set to true if you want delta
      options = {
        navigate = true;
        light = false;
        line-numbers = true;
      };
    };
  };
  
  # Additional git tools are defined in packages/development.nix
}
