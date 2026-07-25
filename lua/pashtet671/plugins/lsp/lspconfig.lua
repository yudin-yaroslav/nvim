return {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		"hrsh7th/nvim-cmp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		local util = require("lspconfig.util")
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client then
					return
				end

				local bufnr = args.buf
				local opts = { buffer = bufnr, silent = true }

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", vim.lsp.buf.references, opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definition"
				keymap.set("n", "gd", vim.lsp.buf.definition, opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

				vim.notify("LSP attached: " .. client.name, vim.log.levels.INFO)

				if client.name == "svelte" then
					vim.api.nvim_create_autocmd("BufWritePost", {
						buffer = bufnr,
						pattern = { "*.js", "*.ts" },
						callback = function(ctx)
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
						end,
					})
				end

				if not client._completion_patched then
					client._completion_patched = true

					-- Hijack standard API requests
					local original_request = client.request
					client.request = function(method, params, handler, buf_nr)
						if method == "textDocument/completion" and handler then
							local original_handler = handler
							handler = function(err, result, ctx, config)
								if type(result) == "userdata" or result == vim.NIL then
									result = {}
								end
								return original_handler(err, result, ctx, config)
							end
						end
						return original_request(method, params, handler, buf_nr)
					end

					-- Hijack low-level RPC requests (what nvim-cmp uses directly)
					if client.rpc and client.rpc.request then
						local original_rpc_request = client.rpc.request
						client.rpc.request = function(method, params, handler, ...)
							if method == "textDocument/completion" and handler then
								local original_handler = handler
								handler = function(err, result, ...)
									if type(result) == "userdata" or result == vim.NIL then
										result = {}
									end
									return original_handler(err, result, ...)
								end
							end
							return original_rpc_request(method, params, handler, ...)
						end
					end
				end
			end,
		})

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = signs.Error,
					[vim.diagnostic.severity.WARN] = signs.Warn,
					[vim.diagnostic.severity.HINT] = signs.Hint,
					[vim.diagnostic.severity.INFO] = signs.Info,
				},
			},
		})

		mason.setup()

		vim.lsp.config("clangd", {
			capabilities = capabilities,
			cmd = { "clangd" },
			filetypes = { "c", "cpp" },
		})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					completion = { callSnippet = "Replace" },
					diagnostics = { globals = { "vim" }, disable = { "missing-fields" } },
				},
			},
		})

		vim.lsp.config("svelte", {
			capabilities = capabilities,
		})

		vim.lsp.config("texlab", {
			capabilities = capabilities,
			filetypes = { "tex", "bib", "plaintex" },
			settings = {
				texlab = {
					latexindent = {
						modifyLineBreaks = false,
						["local"] = "indentconfig.yaml",
					},
					auxDirectory = "build",
					build = {
						executable = "latexmk",
						args = {
							"-verbose",
							"-file-line-error",
							"-synctex=1",
							"-interaction=nonstopmode",
							"-outdir=build",
							"master.tex",
						},
						onSave = true,
					},
					forwardSearch = {
						executable = "zathura",
						args = { "--synctex-forward", "%l:1:%f", "%p" },
					},
					lint = {
						onEdit = false,
						onSave = true,
					},
					formatterLineLength = 40,
				},
			},
		})

		local arduino = require("pashtet671.config.arduino")

		vim.lsp.config("arduino_language_server", {
			capabilities = capabilities,
			filetypes = { "arduino" },
			cmd = {
				"arduino-language-server",
				"-cli",
				"arduino-cli",
				"-cli-config",
				vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
				"-clangd",
				vim.fn.expand("~/.local/share/nvim/mason/bin/clangd"),
				"-fqbn",
				arduino.arduino_config.fqbn,
			},
		})

		vim.lsp.config("graphql", {
			capabilities = capabilities,
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		})

		vim.lsp.config("emmet_ls", {
			capabilities = capabilities,
			filetypes = { "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		})

		vim.lsp.config("html", {
			capabilities = capabilities,
			filetypes = { "html", "htmldjango" },
		})

		vim.lsp.config("cssls", {
			capabilities = capabilities,
			filetypes = { "css", "scss", "less" },
		})

		vim.lsp.config("pyright", {
			capabilities = capabilities,
			filetypes = { "python" },
		})

		vim.lsp.config("biome", {})
		vim.lsp.config("prismals", {})

		vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
			if not result.diagnostics then
				return
			end

			result.diagnostics = vim.tbl_filter(function(diagnostic)
				return not diagnostic.message:match("Overfull \\hbox")
					and not diagnostic.message:match("Underfull \\hbox")
					and not diagnostic.message:match("Undefined reference")
			end, result.diagnostics)

			vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
		end

		mason_lspconfig.setup({
			ensure_installed = {
				"arduino_language_server",
				"svelte",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"biome",
				"lua_ls",
				"html",
				"cssls",
				"texlab",
				"clangd",
			},
			automatic_installation = true,
			automatic_enable = true,
		})
	end,
}
