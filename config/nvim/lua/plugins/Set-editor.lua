return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "User FilePost",
    opts = {},
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
  {
    "Kicamon/im-switch.nvim",
    event = "InsertEnter", 
    opts = {
      input_toggle = 1,
      text = {
        enable = true,
        files = { "*.md", "*.txt" },
      },
      code = {
        enable = true,
        files = { "*" },
      },
      en = "fcitx5-remote -c",
      zh = "fcitx5-remote -o",
      check = "fcitx5-remote",
    },
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
}
