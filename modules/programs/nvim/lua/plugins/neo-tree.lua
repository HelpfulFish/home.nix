return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          always_show = { -- remains visible even if other settings would normally hide it
            ".gitignored",
          },
          always_show_by_pattern = { -- uses glob style patterns
            ".env*",
          },
        },
      },
    },
  },
}
