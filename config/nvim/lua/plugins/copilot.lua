-- GitHub Copilot auto-completion configuration (LazyVim style)
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = true,  -- Force enable for inline suggestions
        auto_trigger = true,
        debounce = 75,   -- Faster triggering
        keymap = {
          accept = "<C-J>", -- Custom accept key
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
        javascript = true,
        typescript = true,
        typescriptreact = true,
        javascriptreact = true,
        lua = true,
        python = true,
        go = true,
        rust = true,
        html = true,
        css = true,
        scss = true,
        json = true,
        yaml = true,
        nix = true,
      },
    },
  },
}
