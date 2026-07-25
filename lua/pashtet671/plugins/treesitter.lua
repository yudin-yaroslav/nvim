return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},

	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
				if lang then
					pcall(vim.treesitter.start, args.buf, lang)
				end
			end,
		})
	end,
	config = function()
		require("nvim-treesitter").setup({})
		require("nvim-ts-autotag").setup()

		local ensure_installed = {
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
			"arduino",
		}
		require("nvim-treesitter").install(ensure_installed)
	end,
}
