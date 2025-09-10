# Main Home Manager configuration
# This is the entry point for your unified personal/development setup
{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ./home
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    username = userConfig.username;
    homeDirectory = userConfig.homeDirectory;
    stateVersion = "24.05";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Enable for non-NixOS systems
  targets.genericLinux.enable = true;

  # Personal environment variables
  home.sessionVariables = {
    # Add any personal-specific environment variables here
  };

  # Personal shell aliases (in addition to those defined in programs/shell/zsh.nix)
  programs.zsh.shellAliases = {
    # Directory shortcuts
    dotfiles = "cd ~/.config/home-manager";

    # Development shortcuts  
    dev-public = "cd ~/Documents/src/public";
    dev-private = "cd ~/Documents/src/private";
    dev-local = "cd ~/Documents/src/local";
  };
}
