return {
	"lunarvim/darkplus.nvim",
	config = function()
		vim.cmd("colorscheme darkplus")
		vim.api.nvim_set_hl(0, "Type", { fg = "#569CD6" })
		vim.api.nvim_set_hl(0, "@lsp.type.namespace.cpp", { fg = "#4EC9B0" })
		vim.api.nvim_set_hl(0, "@lsp.type.class.cpp", { fg = "#4EC9B0" })

		vim.api.nvim_set_hl(0, "@keyword.type.cpp", { fg = "#569CD6" })
		vim.api.nvim_set_hl(0, "@keyword.cpp", { fg = "#C586C0" })
		vim.api.nvim_set_hl(0, "@keyword.import.cpp", { fg = "#C586C0" })
		vim.api.nvim_set_hl(0, "@keyword.return", { fg = "#C586C0" })

		vim.api.nvim_set_hl(0, "@punctuation.bracket.latex", { fg = "#FFD700" })
		vim.api.nvim_set_hl(0, "@keyword.import.latex", { fg = "#C586C0" })
		vim.api.nvim_set_hl(0, "@string.latex", { fg = "#4EC9B0" })

		-- vim.api.nvim_set_hl(0, "@nospell.latex", { link = "Label" })
		vim.api.nvim_set_hl(0, "@comment.latex", { link = "@comment" })
		vim.api.nvim_set_hl(0, "@keyword.import.python", { fg = "#C586C0" })

		vim.api.nvim_set_hl(0, "SidebarNvimGitStatusFileIcon", { fg = "#FAB387" }) -- bright peach
		vim.api.nvim_set_hl(0, "SidebarNvimGitStatusFileName", { fg = "#CDD6F4" }) -- text
		vim.api.nvim_set_hl(0, "SidebarNvimSectionTitle", { fg = "#4FC1FF", bold = true }) -- section headers
		vim.api.nvim_set_hl(0, "SidebarNvimNormal", { bg = "#1E1E2E", fg = "#CDD6F4" }) -- sidebar bg/text
		vim.api.nvim_set_hl(0, "SidebarNvimSymbol", { fg = "#F9E2AF" }) -- e.g., for `ƒ` entries
		vim.api.nvim_set_hl(0, "SidebarNvimLabel", { fg = "#cc70c5", bold = true }) -- e.g., for `ƒ` entries
	end,
}
