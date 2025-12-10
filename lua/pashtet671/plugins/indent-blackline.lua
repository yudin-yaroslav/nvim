return {
    "lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
    main = "ibl",

	config = function()
		local ibl = require("ibl")

		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
		
		ibl.setup({
			indent = {
				char = "▏",
			},
			scope = {
				show_start = false,
				show_end = false,
			},
		})
	end,
}
