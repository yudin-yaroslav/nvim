return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = {
				"~/",
				"~/Dev/",
				"~/Downloads",
				"~/Documents",
				"~/Desktop/",
			},

			cwd_change_handling = true,

			post_cwd_changed_cmds = {
				function()
					pcall(vim.cmd, "NvimTreeClose")

					local ok_alpha, alpha = pcall(require, "alpha")
					if ok_alpha then
						alpha.start(false)
					end

					pcall(vim.cmd, "NvimTreeOpen")
				end,
			},

			post_restore_cmds = {
				function()
					local ok, api = pcall(require, "nvim-tree.api")
					if ok then
						pcall(api.tree.reload)
					end
				end,
			},
		})

		local keymap = vim.keymap
		keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
		keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
	end,
}
