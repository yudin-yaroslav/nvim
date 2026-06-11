return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	branch = "main",
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"HiPhish/rainbow-delimiters.nvim",
	},

	config = function()
		local treesitter = require("nvim-treesitter")
		local rainbow_delimiters = require("rainbow-delimiters")

		local parsers = require("nvim-treesitter.parsers")
		parsers.arduino = {
			install_info = {
				url = "/home/yudin-yaroslav/bin/tree-sitter-arduino",
				files = { "src/parser.c", "src/scanner.c" },
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "arduino",
		}

		vim.g.rainbow_delimiters = {
			strategy = {
				[""] = rainbow_delimiters.strategy.global,
			},
			priority = { [""] = 512 },
			highlight = { "RainbowYellow", "RainbowPurple", "RainbowBlue" },
		}

		vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#ffd700" }) -- Yellow
		vim.api.nvim_set_hl(0, "RainbowPurple", { fg = "#da70d6" }) -- Purple
		vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#179fff" }) -- Blue

		require("nvim-ts-autotag").setup()

		treesitter.setup({
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"c",
				"cpp",
				"python",
				"latex",
			},
		})
	end,
}
