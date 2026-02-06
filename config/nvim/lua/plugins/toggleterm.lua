return {
    "akinsho/toggleterm.nvim",
    opts = {
        start_in_insert = true,
        direction = "horizontal",
        float_opts = {
            border = "curved",
        },         
    },
    keys = {
        { "<leader>tf", "<Cmd>ToggleTerm<CR>", desc = "Terminal | 终端" },
        { '<C-h>', [[<Cmd>wincmd h<CR>]], mode = { 'n', 't' }, desc = "test" },
        { '<C-j>', [[<Cmd>wincmd j<CR>]], mode = { 'n', 't' }, desc = "test" },
        { '<C-k>', [[<Cmd>wincmd k<CR>]], mode = { 'n', 't' }, desc = "test" },
        { '<C-l>', [[<Cmd>wincmd l<CR>]], mode = { 'n', 't' }, desc = "test" },

    },
    config = function(_, opts)
        require("toggleterm").setup(opts)

        function _G.set_terminal_keymaps()
            local mapping_opts = { buffer = 0 }
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], mapping_opts) 
        end

        local term_group = vim.api.nvim_create_augroup("ToggleTermConfig", { clear = true })
        vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*",
            group = term_group,
            callback = function()
                set_terminal_keymaps() -- 这里不需要 _G
            end,
        })
        vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FocusGained" }, {
            pattern = "term://*",
            group = term_group,
            callback = function()
                -- 只有在当前缓冲区确实是终端时才执行
                if vim.bo.buftype == "terminal" then
                    vim.schedule(function()
                        -- 检查是否已经在插入模式，避免重复触发
                        if vim.api.nvim_get_mode().mode ~= 't' then
                            vim.cmd("startinsert")
                        end
                    end)
                end
            end,
        })
    end,
}
