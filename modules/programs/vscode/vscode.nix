{ pkgs }:

let 
  vscodeConfig = import ./config.nix;
in
{
   programs.vscode = {
    enable = true;
    userSettings = vscodeConfig.settings;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      formulahendry.auto-rename-tag
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      # eamodio.gitlens
      # hashicorp.terraform
      # github.copilot
      # golang.go
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # rerun home-manager to get expected hash 
      # or 
      # manually download from extension store and run sha256sum
      {
        # https://marketplace.visualstudio.com/items?itemName=vscodevim.vim
        name = "vim";
        publisher = "vscodevim";
        version = "1.27.3";
        sha256 = "sha256-zshuABicdkT52Nqj1L2RrfMziBRgO+R15fM32SCnyXI=";
      }
    ];
  };
}
