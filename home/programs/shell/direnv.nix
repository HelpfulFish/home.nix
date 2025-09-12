# Direnv - automatic environment loading
{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    # Configuration
    config = {
      # Global direnv configuration
      global = {
        # Automatically load .envrc files
        load_dotenv = true;
        # Hide direnv log messages by default
        hide_env_diff = false;
        # Warn when direnv takes too long
        warn_timeout = "5s";
      };
    };
  };
}
