vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0

vim.opt.autoread = true

vim.opt.splitbelow = true
vim.opt.splitright = true

-- vim.opt.clipboard = "unnamedplus"
vim.opt.autowrite = true

vim.opt.shada = {
    "!",           -- 保存/恢复全局变量
    "'1000",       -- 保存最近 1000 个文件的光标位置和标记
    "<50",         -- 保存最近 50 条命令行历史
    ">50",         -- 保存最近 50 条搜索历史
    "s10",         -- 保存最近 10 条搜索模式历史 (search string history)
    "h"            -- 不保存搜索/替换模式的历史 (默认行为，通常不用修改)
}
