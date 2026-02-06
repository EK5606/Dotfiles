return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        explorer = { enabled = true },-- 文件浏览器
        indent = { 
            enabled = true,
            -- hl = {
            --     "RainbowRed",
            --      "RainbowOrange",
            --      "RainbowYellow",
            --      "RainbowGreen",
            --      "RainbowBlue",
            --      "RainbowViolet",
            --      "RainbowCyan",
            -- },
            scope = {
                enabled = true,
                -- underline = true, -- 在作用域底部绘制横线
                hl = {
                    'RainbowRed',
                    'RainbowYellow',
                    'RainbowBlue',
                    'RainbowOrange',
                    'RainbowGreen',
                    'RainbowViolet',
                    'RainbowCyan',
                }
            },
            chunk = {
                enabled = true,
                hl = {
                    'RainbowRed',
                    'RainbowYellow',
                    'RainbowBlue',
                    'RainbowOrange',
                    'RainbowGreen',
                    'RainbowViolet',
                    'RainbowCyan',
                }
            },
        },-- 缩进线
        picker = { enabled = true }, -- 模糊查找器
    },
    keys = {
        { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer | 文件浏览器" },
        { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History | 命令历史记录" },
    },
    config = function(_, opts)
        local colors = {
            RainbowRed = "#E06C75",
            RainbowYellow = "#E5C07B",
            RainbowBlue = "#61AFEF",
            RainbowOrange = "#D19A66",
            RainbowGreen = "#98C379",
            RainbowViolet = "#C678DD",
            RainbowCyan = "#56B6C2",
        }
        for group, color in pairs(colors) do
            vim.api.nvim_set_hl(0, group, { fg = color })
        end
        require("snacks").setup(opts)
    end,   
}
