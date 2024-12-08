{ pkgs, lib }:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
	    autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        # this is to workaround zsh syntax highlighting slowness on copy/paste
        # https://github.com/zsh-users/zsh-syntax-highlighting/issues/295#issuecomment-214581607
        initExtra = ''
        zstyle ':bracketed-paste-magic' active-widgets '.self-*'

        # initialize nvm autoloader
        [[ ! -f ~/.config/zsh/scripts/nvm.sh ]] || source ~/.config/zsh/scripts/nvm.sh
        
        # only start ssh-agent if not already running
        if [ -z "$SSH_AUTH_SOCK" ]; then
            eval $(ssh-agent) > /dev/null
            # add SSH keys silently
            for key in ~/.ssh/id_ed25519_*; do 
                if [[ -f "$key" && ! "$key" == *.pub ]]; then
                    ssh-add "$key" > /dev/null 2>&1
                fi
            done
        fi

        # kill ssh-agent when shell exits
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
                src = lib.cleanSource ./p10k;
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
            #theme = "frozencow";
            #theme = "agnoster";
            # theme = "jispwoso";
            # theme = "half-life";
        };

        shellAliases = {
            lg="lazygit";
            code="nvim";
            docker="podman";
        };
    };
}
