{
  pkgs,
  lib,
  myLib ? null,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Workaround for zsh syntax highlighting slowness on copy/paste
    # https://github.com/zsh-users/zsh-syntax-highlighting/issues/295#issuecomment-214581607
    initContent = ''
      zstyle ':bracketed-paste-magic' active-widgets '.self-*'

      # SSH agent management
      if [ -z "$SSH_AUTH_SOCK" ]; then
          eval $(ssh-agent) > /dev/null
          # Add SSH keys silently
          for key in ~/.ssh/id_ed25519_*; do 
              if [[ -f "$key" && ! "$key" == *.pub ]]; then
                  ssh-add "$key" > /dev/null 2>&1
              fi
          done
      fi

      # Kill ssh-agent when shell exits
      cleanup() {
          ssh-agent -k > /dev/null
      }
      trap cleanup EXIT
    '';

    plugins = [
      {
        name = "fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ../../../config/p10k;
        file = "p10k.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git-extras"
        "git"
        "gitfast"
        "github"
        "z"
      ];
    };

    shellAliases = lib.mkMerge [
      # Directory navigation (use mkDefault to allow overrides)
      (lib.mkDefault {
        ll = "ls -la";
        la = "ls -la";
        l = "ls -la";
        ".." = "cd ..";
        "..." = "cd ../..";
      })
      
      # Non-conflicting aliases
      {
        # Safety aliases
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        
        # Git shortcuts
        lg = "lazygit";
        gs = "git status";
        gl = "git log --oneline";
        gd = "git diff";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        
        # Development tools
        lzd = "lazydocker";
        code = "code --password-store=\"gnome-libsecret\"";
        
        # System shortcuts
        reload = "source ~/.zshrc";
        cls = "clear";
        
        # Nix/Home Manager shortcuts
        hm-switch = "home-manager switch --flake .";
        hm-build = "home-manager build --flake .";
        nix-search = "nix search nixpkgs";
        
        # Network and system info
        myip = "curl ifconfig.me";
        ports = "ss -tuln";
        
        # Quick utilities
        json = "jq .";
        
        # Directory shortcuts
        dotfiles = "cd ~/.config/home-manager";
        projects = "cd ~/projects";
        work = "cd ~/work";
        dev = "cd ~/development";
        
        # Quick nixGL wrapper for other apps
        ngl = "nixGL";  # ngl <app> for manual wrapping
      }
    ];
  };
}
