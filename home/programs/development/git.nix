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
    userName = 
      let envName = builtins.getEnv "GIT_USER_NAME";
      in if envName != "" then envName else "username";
    
    userEmail = 
      let envEmail = builtins.getEnv "GIT_USER_EMAIL";
      in if envEmail != "" then envEmail else "username@gmail.com";
    
    # Git settings
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      
      pull = {
        rebase = false;
      };
      
      push = {
        default = "simple";
        autoSetupRemote = true;
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
      ci = "commit";
      ca = "commit -a";
      cm = "commit -m";
      cam = "commit -am";
      df = "diff";
      dc = "diff --cached";
      lg = "log --oneline --graph --decorate --all";
      ll = "log --pretty=format:'%h - %an, %ar : %s'";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
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
