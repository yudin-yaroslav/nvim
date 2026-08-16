return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"windwp/nvim-ts-autotag",
		"HiPhish/rainbow-delimiters.nvim",
	},
	config = function()
		-- Main treesitter setup
		require("nvim-treesitter").setup({
			highlight = { enable = true },
			indent = {
				enable = true,
				disable = { "cpp", "c" },
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					node_decremental = "<bs>",
					scope_incremental = false,
				},
			},
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
				"vimdoc",
				"dockerfile",
				"gitignore",
				"query",
				"c",
				"cpp",
				"python",
				"latex",
			},
			auto_install = true,
		})

		-- Custom Arduino parser (new 2026 way)
		vim.api.nvim_create_autocmd("User", {
			pattern = "TSUpdate",
			callback = function()
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
			end,
		})

		-- Rainbow Delimiters
		vim.g.rainbow_delimiters = {
			priority = { [""] = 512 },
			highlight = { "RainbowYellow", "RainbowPurple", "RainbowBlue" },
		}
		vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#ffd700" })
		vim.api.nvim_set_hl(0, "RainbowPurple", { fg = "#da70d6" })
		vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#179fff" })

		-- nvim-ts-autotag
		require("nvim-ts-autotag").setup({})
	end,
}
