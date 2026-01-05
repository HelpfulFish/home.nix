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
    settings = {
      user = {
        name = let envName = builtins.getEnv "GIT_USER_NAME";
          in if envName != "" then envName else lib.mkDefault "your_username";
        email = let envEmail = builtins.getEnv "GIT_USER_EMAIL";
          in if envEmail != "" then envEmail else lib.mkDefault "your.email@example.com";
      };
      init.defaultBranch = lib.mkDefault "main";
      pull.rebase = lib.mkDefault true;
      push.default = "simple";
      push.autoSetupRemote = lib.mkDefault true;
      core.editor = "code --wait";
      core.autocrlf = "input";
      diff.algorithm = "patience";
      diff.compactionHeuristic = true;
      rerere.enabled = true;
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        cm = "commit -m";
        unstage = "reset HEAD --";
      };
    };
  };

  programs.delta = {
    enable = false;  # Set to true if you want delta
    options = {
      navigate = true;
      light = false;
      line-numbers = true;
    };
  };
}
