return { -- Autocompletion
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        -- Build step is needed for regex support in snippets
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
          return nil
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        -- You can add snippet collections here
        -- Example:
        -- {
        --   "rafamadriz/friendly-snippets",
        --   config = function()
        --     require("luasnip.loaders.from_vscode").lazy_load()
        --   end,
        -- },
      },
    },
    -- For Luasnip completion
    "saadparwaiz1/cmp_luasnip",
    -- Adds LSP completion capabilities
    "hrsh7th/cmp-nvim-lsp",
    -- Adds path completion
    "hrsh7th/cmp-path",
  },
  opts = function(_, opts)
    -- Ensure opts is initialized
    opts = opts or {}

    -- Require necessary modules
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Set up Luasnip
    luasnip.config.setup({})

    -- Define your completion options
    opts.snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    }

    opts.completion = {
      completeopt = "menu,menuone,noinsert",
    }

    -- Key mappings
    opts.mapping = cmp.mapping.preset.insert({
      -- Select the next item
      ["<Down>"] = cmp.mapping.select_next_item(),
      -- Select the previous item
      ["<Up>"] = cmp.mapping.select_prev_item(),
      -- Scroll documentation
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      -- Accept completion
      ["<Tab>"] = cmp.mapping.confirm({ select = true }),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      -- Manually trigger completion
      ["<C-Space>"] = cmp.mapping.complete({}),
      -- Navigate snippets
      ["<C-l>"] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-h>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    })

    -- Completion sources
    opts.sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
    })

    -- Return the final opts table
    return opts
  end,
}
