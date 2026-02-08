return {
  'nvim-treesitter/nvim-treesitter',
  event = "VeryLazy",
  build = ':TSUpdate',
  opts = {
    highlight = { enable = true },
    ensure_installed = {
     "lua", "python", "toml", "markdown", "markdown-inline"
    },
  },
}
