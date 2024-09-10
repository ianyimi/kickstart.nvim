return { -- Autoformat
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>ft",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    formatters = {
      prettier = function()
        return {
          ext_parsers = {
            astro = "mdx",
          },
        }
      end,
    },
    notify_on_error = false,
    formatters_by_ft = {
      astro = { "astro" },
      lua = { "stylua" },
      go = { "goimports", "gofmt" },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      javascript = { "prettierd", "biome", "prettier", stop_after_first = true },
      typescript = { "prettierd", "biome", "prettier", stop_after_first = true },
    },
  },
}
