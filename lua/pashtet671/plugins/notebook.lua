return {
	"GCBallesteros/NotebookNavigator.nvim",
	dependencies = {
		"benlubas/molten-nvim", -- for cell execution support
		"mfussenegger/nvim-dap", -- optional
	},
	config = function()
		require("notebook-navigator").setup()
	end,
	ft = { "python", "ipynb" },
}
