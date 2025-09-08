-- GitHub Copilot auto-completion configuration (LazyVim style)
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = "<C-J>", -- Custom accept key
          next = "<M-]>",
          prev = "<M-[>",
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
