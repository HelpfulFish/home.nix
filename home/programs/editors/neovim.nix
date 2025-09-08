# Neovim with LazyVim configuration
# Based on: https://github.com/LazyVim/LazyVim/discussions/1972
{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Essential packages for LazyVim
    extraPackages = with pkgs; [
      # LazyVim core
      lua-language-server
      stylua
      
      # Telescope dependencies
      ripgrep
      fd
      
      # Language servers and tools
      nodePackages.typescript-language-server
      nodePackages.eslint
      nodePackages.prettier
      nodePackages.eslint_d
      nodePackages.typescript
      
      # Additional language servers (uncomment as needed)
      # nil                     # Nix LSP
      # python3Packages.python-lsp-server  # Python LSP
      # rust-analyzer           # Rust LSP
    ];

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    extraLuaConfig =
      let
        plugins = with pkgs.vimPlugins; [
          # LazyVim core plugins
          LazyVim
          bufferline-nvim
          cmp-buffer
          cmp-nvim-lsp
          cmp-path
          cmp_luasnip
          conform-nvim
          dashboard-nvim
          dressing-nvim
          flash-nvim
          friendly-snippets
          gitsigns-nvim
          indent-blankline-nvim
          lualine-nvim
          neo-tree-nvim
          neoconf-nvim
          neodev-nvim
          noice-nvim
          nui-nvim
          nvim-cmp
          nvim-lint
          nvim-lspconfig
          nvim-notify
          nvim-spectre
          nvim-treesitter
          nvim-treesitter-context
          nvim-treesitter-textobjects
          nvim-ts-autotag
          nvim-ts-context-commentstring
          nvim-web-devicons
          persistence-nvim
          plenary-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          todo-comments-nvim
          tokyonight-nvim
          trouble-nvim
          vim-illuminate
          vim-startuptime
          which-key-nvim
          
          # Plugins with custom names
          { name = "LuaSnip"; path = luasnip; }
          { name = "catppuccin"; path = catppuccin-nvim; }
          { name = "mini.ai"; path = mini-nvim; }
          { name = "mini.bufremove"; path = mini-nvim; }
          { name = "mini.comment"; path = mini-nvim; }
          { name = "mini.indentscope"; path = mini-nvim; }
          { name = "mini.pairs"; path = mini-nvim; }
          { name = "mini.surround"; path = mini-nvim; }
        ];
        
        mkEntryFromDrv = drv:
          if lib.isDerivation drv then
            { name = "${lib.getName drv}"; path = drv; }
          else
            drv;
            
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      ''
        require("lazy").setup({
          defaults = {
            lazy = true,
          },
          dev = {
            -- reuse files from pkgs.vimPlugins.*
            path = "${lazyPath}",
            patterns = { "" },
            -- fallback to download
            fallback = true,
          },
          performance = {
            rtp = {
              -- Disable help tag generation to avoid Nix store write errors
              disabled_plugins = {
                "gzip",
                "man",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "shada",
                "spellfile",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
              },
            },
          },
          install = {
            -- Don't install missing plugins (all managed by Nix)
            missing = false,
          },
          change_detection = {
            -- Don't check for config changes
            enabled = false,
          },
          checker = {
            -- Don't check for plugin updates
            enabled = false,
          },
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            -- Fix LazyVim for Nix
            { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
            -- Disable mason.nvim (use Nix packages instead)
            { "williamboman/mason-lspconfig.nvim", enabled = false },
            { "williamboman/mason.nvim", enabled = false },
            -- Import custom plugins
            { import = "plugins" },
            -- Treesitter: clear ensure_installed (handled by Nix)
            { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
          },
        })
      '';
  };

  # Treesitter parsers
  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  xdg.configFile."nvim/parser".source =
    let
      parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
          # Core languages
          c
          lua
          vim
          vimdoc
          
          # Web development
          typescript
          tsx
          javascript
          html
          css
          json
          
          # Other languages (uncomment as needed)
          # nix
          # python
          # rust
          # markdown
          # yaml
          # toml
        ])).dependencies;
      };
    in
    "${parsers}/parser";

  # LazyVim configuration files (use existing config from config/nvim)
  xdg.configFile."nvim/lua".source = ../../../config/nvim/lua;
}
