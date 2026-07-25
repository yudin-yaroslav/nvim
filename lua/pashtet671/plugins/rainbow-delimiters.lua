return {
	"hiphish/rainbow-delimiters.nvim",
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = function()
		local rainbow_delimiters = require("rainbow-delimiters")

		local function apply_rainbow_highlights()
			vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#ffd700", force = true })
			vim.api.nvim_set_hl(0, "RainbowDelimiterPurple", { fg = "#da70d6", force = true })
			vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#179fff", force = true })
		end

		apply_rainbow_highlights()

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = apply_rainbow_highlights,
		})

		require("rainbow-delimiters.setup").setup({
			strategy = {
				[""] = rainbow_delimiters.strategy["global"],
			},
			query = {
				[""] = "rainbow-delimiters",
			},
			priority = {
				[""] = 512, -- Override standard TS punctuation layers completely
			},
			highlight = {
				"RainbowDelimiterYellow",
				"RainbowDelimiterPurple",
				"RainbowDelimiterBlue",
			},
			condition = function(buf)
				-- Fail-safe check to make sure TS is attached right before the scan
				local ft = vim.bo[buf].filetype
				local lang = vim.treesitter.language.get_lang(ft)
				if lang then
					pcall(vim.treesitter.start, buf, lang)
				end
				return true
			end,
		})
	end,
}
