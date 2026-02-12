return {
	{
		"folke/tokyonight.nvim",
		opts = {
			style = "moon",
		},
		config = function()
			vim.cmd("colorscheme tokyonight")
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		opts = {
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			extensions = { "nvim-tree" },
			sections = {
				lualine_b = { "branch", "diff" },
				lualine_x = {
					"filesize",
					"encoding",
					"filetype",
				},
			},
		},
	},

	{
		"akinsho/bufferline.nvim",
		opts = {},
		keys = {
			{ "<leader>bh", ":BufferLineCyclePrev<CR>", desc = "Prev Buffer | 上个缓冲区", silent = true },
			{ "<leader>bl", ":BufferLineCycleNext<CR>", desc = "Next Buffer | 下个缓冲区", silent = true },
			{ "<leader>bd", ":bdelete<CR>", desc = "Delete This Buffer | 关闭当前缓冲区", silent = true },
			{
				"<leader>bo",
				":BufferLineCloseOthers<CR>",
				desc = "Close Other Buffer | 关闭其他缓冲区",
				silent = true,
			},
			{ "<leader>bp", ":BufferLinePick<CR>", desc = "Pick Buffer | 打开选中缓冲区", silent = true },
			{ "<leader>bc", ":BufferLinePickClose<CR>", desc = "Close Buffer | 关闭选中缓冲区", silent = true },
		},
		lazy = false,
	},
	
}
