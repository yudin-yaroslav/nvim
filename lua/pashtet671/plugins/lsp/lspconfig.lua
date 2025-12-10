return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
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

		local function on_attach(client, bufnr)
			local opts = { buffer = bufnr, silent = true }

			opts.desc = "Show LSP references"
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

			opts.desc = "Go to declaration"
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

			opts.desc = "Show LSP definitions"
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

			opts.desc = "Show LSP implementations"
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

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
		end

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

		-- clangd
		vim.lsp.config("clangd", {
			on_attach = on_attach,
			capabilities = capabilities,
			cmd = { "clangd" },
			filetypes = { "c", "cpp" },
		})

		-- lua_ls
		vim.lsp.config("lua_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					completion = { callSnippet = "Replace" },
					diagnostics = { globals = { "vim" }, disable = { "missing-fields" } },
				},
			},
		})

		-- svelte
		vim.lsp.config("svelte", {
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePost", {
					buffer = bufnr,
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
					end,
				})
			end,
			capabilities = capabilities,
		})

		-- texlab
		vim.lsp.config("texlab", {
			on_attach = on_attach,
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

		-- arduino_language_server (if needed)
		vim.lsp.config("arduino_language_server", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "arduino", "ino" },
			-- cmd = { ... },  -- Uncomment/customize as needed
		})

		-- graphql
		vim.lsp.config("graphql", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		})

		-- emmet_ls
		vim.lsp.config("emmet_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		})

		-- html
		vim.lsp.config("html", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "html", "htmldjango" },
		})

		-- cssls
		vim.lsp.config("cssls", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "css", "scss", "less" },
		})

		-- pyright
		vim.lsp.config("pyright", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "python" },
		})

		-- Basic configs for non-custom servers
		vim.lsp.config("biome", {
			-- on_attach = on_attach,  -- Uncomment if needed
			-- capabilities = capabilities,
		})

		vim.lsp.config("prismals", {
			-- on_attach = on_attach,  -- Uncomment if needed
			-- capabilities = capabilities,
		})

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
				-- "arduino_language_server",
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
