return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_compiler_method = "latexmk"

		vim.g.vimtex_compiler_latexmk = {
			executable = "latexmk",
			options = {
				"-auxdir=build",
				"-lualatex",
				"-file-line-error",
				"-synctex=1",
				"-interaction=nonstopmode",
				"-shell-escape",
				"-emulate-aux-dir",
				"-silent",
			},
		}
		vim.g.vimtex_quickfix_mode = 0
		vim.g.vimtex_quickfix_open_on_warning = 0
		vim.g.vimtex_quickfix_open_on_error = 0

		vim.g.vimtex_quickfix_ignore_filters = {
			"Warning",
			"Underfull",
			"Overfull",
		}

		vim.g.vimtex_quickfix_autoclose_after_keystrokes = 0

		vim.g.vimtex_view_method = "sioyek"
	end,
}
