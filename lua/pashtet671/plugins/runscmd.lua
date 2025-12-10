return {
	"aveplen/ruscmd.nvim",
	event = "VeryLazy",

	config = function()
		require("ruscmd").setup({
			abbreviations = true, -- let :й, :ц, … expand to :q, :w, …
			keymaps = true, -- map NORMAL keys so яф == za, яв == zd, etc.
		})
	end,
}
