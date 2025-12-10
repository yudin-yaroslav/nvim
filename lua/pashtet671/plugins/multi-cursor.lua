return {
	"vscode-neovim/vscode-multi-cursor.nvim",
	event = "VeryLazy",
	opts = {},

	config = function()
		require("vscode-multi-cursor").setup({
			default_mappings = true,
			no_selection = false,
		})
	end,
}
