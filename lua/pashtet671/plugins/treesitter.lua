return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},

	config = function()
		local treesitter = require("nvim-treesitter.configs")
		local rainbow_delimiters = require("rainbow-delimiters")

		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		parser_config.arduino = {
			install_info = {
				url = "/home/yudin-yaroslav/bin/tree-sitter-arduino", -- local path or git repo
				files = { "src/parser.c", "src/scanner.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
				branch = "main", -- default branch in case of git repo if different from master
				generate_requires_npm = false, -- if stand-alone parser without npm dependencies
				requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
			},
			filetype = "arduino", -- if filetype does not match the parser name
		}

		vim.g.rainbow_delimiters = {
			priority = { [""] = 512 },
			highlight = { "RainbowYellow", "RainbowPurple", "RainbowBlue" },
		}

		vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#ffd700" }) -- Yellow
		vim.api.nvim_set_hl(0, "RainbowPurple", { fg = "#da70d6" }) -- Purple
		vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#179fff" }) -- Blue

		treesitter.setup({
			rainbow = {
				enable = true,
				query = "rainbow-parens",
				strategy = rainbow_delimiters.strategy.global,
			},

			highlight = {
				enable = true,
			},

			indent = { enable = true },

			autotag = {
				enable = true,
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
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"c",
				"cpp",
				"python",
				"latex",
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
