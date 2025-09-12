# Node.js development environment
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Node.js and package managers (v20 LTS for Copilot.lua compatibility)
    nodejs_20
    yarn
    # pnpm              # Alternative package manager (uncomment if needed)
    
    # Node.js development tools
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.eslint_d
    
  ];

  # Node.js development aliases
  programs.zsh.shellAliases = {   
    # Yarn shortcuts
    yi = "yarn install";
    ys = "yarn start";
    yb = "yarn build";
    yt = "yarn test";
    
    # NPM shortcuts (if using npm)
    ni = "npm install";
    ns = "npm start";
    nb = "npm run build";
    nt = "npm test";
  };
}
