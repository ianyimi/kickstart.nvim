return {
	-- LSP Zero Configuration
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v4.x',
		lazy = true,
		config = false,
	},
	-- Mason for managing LSP servers and tools
	{
		'williamboman/mason.nvim',
		lazy = false,
		opts = {},
	},
	{
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		config = function()
			local ensure_installed = {
				-- LSP servers
				'astro-language-server',
				'bash-language-server',
				'css-lsp',
				'clangd',
				'eslint-lsp',
				'gopls',
				'html-lsp',
				'tailwindcss-language-server',
				'taplo',
				'vtsls',
				'svelte-language-server',
				'lua-language-server',
				'yaml-language-server',
				-- Formatters
				'stylua',
				'prettierd',
				-- 'fish_indent',
				'shfmt',
				-- 'gofmt',
			}
			require('mason-tool-installer').setup({ ensure_installed = ensure_installed })
		end,
	},
	-- nvim-cmp for autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-emoji',
			'saadparwaiz1/cmp_luasnip',
			'L3MON4D3/LuaSnip',
		},
		config = function()
			-- Set up nvim-cmp.
			local luasnip = require('luasnip')
			local cmp = require('cmp')

			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<CR>'] = cmp.mapping.confirm({ select = false }),
					['<Esc>'] = cmp.mapping(function(fallback)
						cmp.mapping.abort()
						vim.cmd('stopinsert')
					end, { 'i', 's' }),
				}),
				sources = cmp.config.sources({
					{ name = 'emoji' },
					{ name = 'nvim_lsp' },
					{ name = 'nvim_lsp_signature_help' },
					{ name = 'luasnip' },
				}, {
					{ name = 'buffer' },
				}),
			})

			-- Setup cmdline `/` and `?` with buffer source
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = {
					['<Tab>'] = cmp.mapping.confirm({ select = true }),
					['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
					['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
				},
				sources = {
					{ name = 'buffer' },
				},
			})

			-- Setup cmdline ':' with path and cmdline sources
			cmp.setup.cmdline(':', {
				mapping = {
					['<Tab>'] = cmp.mapping.confirm({ select = true }),
					['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
					['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
				},
				sources = cmp.config.sources({
					{ name = 'path' },
				}, {
					{ name = 'cmdline' },
				}),
			})
		end,
	},
	-- LSP configurations
	{
		'neovim/nvim-lspconfig',
		cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'j-hui/fidget.nvim',                opts = {} },
			{ 'b0o/SchemaStore.nvim',             lazy = true, version = false },
		},
		config = function()
			local lsp = require('lsp-zero').preset({})

			-- Set up nvim-cmp capabilities
			local cmp = require('cmp')
			local cmp_mappings = cmp.mapping.preset.insert({
				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif require('luasnip').expand_or_jumpable() then
						require('luasnip').expand_or_jump()
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif require('luasnip').jumpable(-1) then
						require('luasnip').jump(-1)
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<CR>'] = cmp.mapping.confirm({ select = false }),
				['<Esc>'] = cmp.mapping(function(fallback)
					cmp.mapping.abort()
					vim.cmd('stopinsert')
				end, { 'i', 's' }),
			})

			cmp.setup({
				mapping = cmp_mappings,
				sources = cmp.config.sources({
					{ name = 'emoji' },
					{ name = 'nvim_lsp' },
					{ name = 'nvim_lsp_signature_help' },
					{ name = 'luasnip' },
				}, {
					{ name = 'buffer' },
				}),
			})

			-- Ensure LSP servers are installed using mason-lspconfig
			require('mason-lspconfig').setup({
				ensure_installed = {
					'astro',
					'bashls',
					'cssls',
					'clangd',
					'eslint',
					'gopls',
					'html',
					'tailwindcss',
					'taplo',
					'vtsls',
					'svelte',
					'lua_ls',
					'yamlls',
				},
				handlers = {
					lsp.default_setup,
					-- You can specify custom handlers per server
					['lua_ls'] = function()
						lsp.nvim_workspace()
					end,
				},
			})

			lsp.on_attach(function(client, bufnr)
				local map = function(keys, func, desc)
					vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
				end

				-- Key mappings
				map('gh', vim.lsp.buf.hover, 'Preview Hover')
				map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
				map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
				map('<leader>cd', vim.diagnostic.open_float, '[S]how [D]iagnostic')
				map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
				map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
				map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
				map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
				map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
				map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
				map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

				-- Highlight references
				if client.supports_method('textDocument/documentHighlight') then
					local highlight_augroup = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
					vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
						group = highlight_augroup,
						buffer = bufnr,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
						group = highlight_augroup,
						buffer = bufnr,
						callback = vim.lsp.buf.clear_references,
					})
				end

				-- Format on save using lsp-zero's built-in formatting
				if client.supports_method('textDocument/formatting') then
					vim.api.nvim_create_autocmd('BufWritePre', {
						group = vim.api.nvim_create_augroup('LspFormatOnSave', { clear = true }),
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format()
						end,
					})
				end
			end)

			-- Configure individual LSP servers
			lsp.configure('astro', {
				root_dir = require('lspconfig').util.root_pattern(
					'package.json',
					'tsconfig.json',
					'jsconfig.json',
					'.git'
				),
			})

			lsp.configure('tailwindcss', {
				root_dir = require('lspconfig').util.root_pattern(
					'package.json',
					'.git',
					'tailwind.config.*'
				),
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								{ 'cva\\(([^)]*)\\)', '[\"\'`]([^\"\'`]*).*?[\"\'`]' },
								{ 'cx\\(([^)]*)\\)',  "(?:'|\"|`)([^']*)(?:'|\"|`)" },
							},
						},
					},
				},
			})

			lsp.configure('vtsls', {
				root_dir = require('lspconfig').util.root_pattern('package.json', '.git'),
				filetypes = {
					'javascript',
					'javascriptreact',
					'javascript.jsx',
					'typescript',
					'typescriptreact',
					'typescript.tsx',
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
						updateImportsOnFileMove = { enabled = 'always' },
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							parameterNames = { enabled = 'literals' },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
					},
				},
			})

			lsp.configure('eslint', {
				settings = {
					workingDirectories = { mode = 'auto' },
				},
			})

			lsp.configure('lua_ls', {
				settings = {
					Lua = {
						completion = {
							callSnippet = 'Replace',
						},
						-- Uncomment below to disable 'missing-fields' diagnostics
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
			})

			lsp.configure('yamlls', {
				capabilities = {
					textDocument = {
						foldingRange = {
							dynamicRegistration = false,
							lineFoldingOnly = true,
						},
					},
				},
				on_new_config = function(new_config)
					new_config.settings.yaml.schemas = vim.tbl_deep_extend(
						'force',
						new_config.settings.yaml.schemas or {},
						require('schemastore').yaml.schemas()
					)
				end,
				settings = {
					redhat = { telemetry = { enabled = false } },
					yaml = {
						keyOrdering = false,
						format = { enable = true },
						validate = true,
						schemaStore = {
							enable = false,
							url = '',
						},
					},
				},
			})

			-- Setup the LSP
			lsp.setup()
		end,
	},
}
