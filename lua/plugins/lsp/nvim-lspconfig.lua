return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			table.insert(opts.ensure_installed, "js-debug-adapter")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- make sure mason installs the server
			servers = {
				eslint = {
					settings = {
						-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
						workingDirectories = { mode = "auto" },
						format = auto_format,
					},
				},
				--- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
				--- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
				tsserver = {
					enabled = false,
				},
				ts_ls = {
					enabled = false,
				},
				vtsls = {
					-- explicitly add default filetypes, so that we can extend
					-- them in related extras
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
					settings = {
						complete_function_calls = true,
						vtsls = {
							enableMoveToFileCodeAction = true,
							autoUseWorkspaceTsdk = true,
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
						typescript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								completeFunctionCalls = true,
							},
							inlayHints = {
								enumMemberValues = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								variableTypes = { enabled = false },
							},
						},
					},
					keys = {
						-- Preview Hover
						{
							"gh",
							vim.lsp.buf.hover,
							desc = "Preview Hover",
						},
						-- Go to Definition
						{
							"gd",
							require("telescope.builtin").lsp_definitions,
							desc = "[G]oto [D]efinition",
						},
						-- Go to References
						{
							"gr",
							require("telescope.builtin").lsp_references,
							desc = "[G]oto [R]eferences",
						},
						-- Show Diagnostic
						{
							"<leader>cd",
							vim.diagnostic.open_float,
							desc = "[S]how [D]iagnostic",
						},
						-- Go to Implementation
						{
							"gI",
							require("telescope.builtin").lsp_implementations,
							desc = "[G]oto [I]mplementation",
						},
						-- Type Definition
						{
							"<leader>D",
							require("telescope.builtin").lsp_type_definitions,
							desc = "Type [D]efinition",
						},
						-- Document Symbols
						{
							"<leader>ds",
							require("telescope.builtin").lsp_document_symbols,
							desc = "[D]ocument [S]ymbols",
						},
						-- Workspace Symbols
						{
							"<leader>ws",
							require("telescope.builtin").lsp_dynamic_workspace_symbols,
							desc = "[W]orkspace [S]ymbols",
						},
						-- Rename
						{
							"<leader>rn",
							vim.lsp.buf.rename,
							desc = "[R]e[n]ame",
						},
						-- Code Action
						{
							"<leader>ca",
							vim.lsp.buf.code_action,
							desc = "[C]ode [A]ction",
						},
						-- Go to Declaration
						{
							"gD",
							vim.lsp.buf.declaration,
							desc = "[G]oto [D]eclaration",
						},
					}
				},
			},
			setup = {
				eslint = function()
					if not auto_format then
						return
					end

					local function get_client(buf)
						return LazyVim.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
					end

					local formatter = LazyVim.lsp.formatter({
						name = "eslint: lsp",
						primary = false,
						priority = 200,
						filter = "eslint",
					})

					-- Use EslintFixAll on Neovim < 0.10.0
					if not pcall(require, "vim.lsp._dynamic") then
						formatter.name = "eslint: EslintFixAll"
						formatter.sources = function(buf)
							local client = get_client(buf)
							return client and { "eslint" } or {}
						end
						formatter.format = function(buf)
							local client = get_client(buf)
							if client then
								local diag = vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
								if #diag > 0 then
									vim.cmd("EslintFixAll")
								end
							end
						end
					end

					-- register the formatter with LazyVim
					LazyVim.format.register(formatter)
				end,
				--- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
				--- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
				tsserver = function()
					-- disable tsserver
					return true
				end,
				ts_ls = function()
					-- disable tsserver
					return true
				end,
				vtsls = function(_, opts)
					LazyVim.lsp.on_attach(function(client, buffer)
						client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
							---@type string, string, lsp.Range
							local action, uri, range = unpack(command.arguments)

							local function move(newf)
								client.request("workspace/executeCommand", {
									command = command.command,
									arguments = { action, uri, range, newf },
								})
							end

							local fname = vim.uri_to_fname(uri)
							client.request("workspace/executeCommand", {
								command = "typescript.tsserverRequest",
								arguments = {
									"getMoveToRefactoringFileSuggestions",
									{
										file = fname,
										startLine = range.start.line + 1,
										startOffset = range.start.character + 1,
										endLine = range["end"].line + 1,
										endOffset = range["end"].character + 1,
									},
								},
							}, function(_, result)
								---@type string[]
								local files = result.body.files
								table.insert(files, 1, "Enter new path...")
								vim.ui.select(files, {
									prompt = "Select move destination:",
									format_item = function(f)
										return vim.fn.fnamemodify(f, ":~:.")
									end,
								}, function(f)
									if f and f:find("^Enter new path") then
										vim.ui.input({
											prompt = "Enter move destination:",
											default = vim.fn.fnamemodify(fname, ":h") .. "/",
											completion = "file",
										}, function(newf)
											return newf and move(newf)
										end)
									elseif f then
										move(f)
									end
								end)
							end)
						end
					end, "vtsls")
					-- copy typescript settings to javascript
					opts.settings.javascript =
					vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
				end,
			},
		},
	},
}
