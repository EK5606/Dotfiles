return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },-- 单个工具
            python = { "ruff_format", "black" }, -- 逐个尝试工具
            javascript = { "prettierd", "prettier", stop_after_first = true }, -- 运行多个工具
        },
    },
}
