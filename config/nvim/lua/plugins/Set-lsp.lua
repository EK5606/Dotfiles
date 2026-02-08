return {
  "saghen/blink.cmp",
  build = "cargo build --release",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = {
        function(cmp)
          if cmp.is_visible() then
            return cmp.select_next()
          elseif cmp.snippet_active() then
            return cmp.snippet_forward()
          else
            return false
          end
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          if cmp.is_visible() then
            return cmp.select_prev()
          elseif cmp.snippet_active() then
            return cmp.snippet_backward()
          else
            return false
          end
        end,
        "fallback",
      },
    },
    cmdline = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
    -- ...
    completion = {
      -- ...
      list = {
        selection = {
          preselect = function(ctx)
            return ctx.mode ~= "cmdline"
          end,
          auto_insert = function(ctx)
            return ctx.mode == "cmdline"
          end,
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "stylua" },
        python = { "ruff_format" },
        rust = { "rustfmt", lsp_format = "fallback" },
        ["*"] = { "trim_whitespace" },
      },
    },
    keys = {
      {
        "<M-f>",
        function()
          require("conform").format()
        end,
        mode = { "n", "v" },
      },
    },
  },
}

