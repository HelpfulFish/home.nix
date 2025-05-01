{ config, pkgs, lib, nixgl, ... }:

{

  nixpkgs.overlays = [
    (import ./overlays/pinned.nix)
  ];

  imports = [
    ./packages.nix
    ./modules/tools
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";

    sessionVariables = {
      # EDITOR = "code";
      EDITOR = "nvim";

      NVM_DIR="$HOME/.config/nvm";
      NVM_DIRECTORY="$HOME/Documents/nvm";

      # anki
      # QT_XCB_GL_INTEGRATION="none";
    };

    sessionPath = [
      "$HOME/bin"
    ];

    # zsh scripts
    file.".config/zsh/scripts".source = ./scripts;
    file.".config/zsh/scripts".recursive = true;

    # i3
    file.".config/i3".source = ./modules/programs/i3;
    file.".config/i3".recursive = true;

    # i3blocks
    file.".config/i3blocks".source = ./modules/programs/i3blocks;
    file.".config/i3blocks".recursive = true;

    # alacritty
    file.".config/alacritty".source = ./modules/programs/alacritty;
    file.".config/alacritty".recursive = true;

    # nvim
    # docs https://www.lazyvim.org
    # source https://github.com/LazyVim/starter
    file.".config/nvim".source = ./modules/programs/nvim;
    file.".config/nvim".recursive = true;

    # .wallpapers
    file.".wallpapers".source = ./modules/programs/wallpapers;
    file.".wallpapers".recursive = true;

    # dunst (notification)
    file.".config/dunst".source = ./modules/programs/dunst;
    file.".config/dunst".recursive = true;


    # .Xresources 

    file.".Xresources" = {
    text = ''
      Xcursor.size: 8
    '';
    };
  };

  programs.bat = {
    enable = false;
    config = {
      theme = "Nord";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.htop.enable = true;
  programs.jq.enable = false;
  programs.lsd.enable = true;

  programs.zsh = (pkgs.callPackage ./modules/programs/zsh.nix {}).programs.zsh;
  programs.vscode = (pkgs.callPackage ./modules/programs/vscode/vscode.nix {}).programs.vscode;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # tools: bin wrappers
  docker-down.enable = true;
  dmenu-flatpak.enable = true;

  audio-output = {
    enable = true;
    enableLogs = true; 
  };
  
  # Run the below if you get this: xdg-desktop-portal-gnome.service loaded failed
  # systemctl --user daemon-reload

  services.gnome-keyring.enable = true;

  # cni version issues? go to: .config/cni/net.d and update <application>.conflist file: "cniVersion": "0.4.0"
  # services.podman.enable = true;
  
  # i3wm
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;
  };
  
  # nixGL
  # https://github.com/nix-community/nixGL
  # use: `nvidia-smi` to verify processes are using GPU
  # original source: https://nix-community.github.io/home-manager/index.xhtml#sec-usage-gpu-non-nixos
  nixGL.packages = import <nixgl> { inherit pkgs; };
  nixGL.defaultWrapper = "nvidiaPrime";
  nixGL.installScripts = [ "nvidiaPrime" ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # XDG configuration to handle desktop entries
  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;
}
