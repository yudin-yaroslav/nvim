return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap = require("dap")
		local utils = require("dap.utils")

		dap.adapters["pwa-node"] = {
			type = "server",
			host = "127.0.0.1",
			port = 8123,
			executable = {
				command = "js-debug-adapter",
			},
		}

		for _, language in ipairs({ "typescript", "javascript" }) do
			dap.configurations[language] = {
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
				runtimeExecutable = "node",
			}
		end
	end,
}
