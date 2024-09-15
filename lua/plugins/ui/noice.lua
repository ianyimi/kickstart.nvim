return {
  "folke/noice.nvim",
  opts = function(_, opts)
    table.insert(opts.routes or {}, {
      filter = {
        event = "msg_show",
        kind = "search_count",
      },
      opts = { skip = true },
    })
    opts.presets = opts.presets or {}
    opts.presets.lsp_doc_border = true
    opts.cmdline = {
      enabled = true,
      view = "cmdline_popup", -- Use the popup for ':'

      -- Override formats for different command-line modes
      format = {
        -- Use cmdline_popup for ':'
        cmdline = { pattern = "^:", icon = "", lang = "vim" },
        -- Use default cmdline for '/' (search_down)
        search_down = {
          kind = "search",
          pattern = "^/",
          icon = " ",
          lang = "regex",
          view = "cmdline", -- Use the default cmdline at the bottom
        },
        -- Use default cmdline for '?' (search_up)
        search_up = {
          kind = "search",
          pattern = "^%?",
          icon = " ",
          lang = "regex",
          view = "cmdline", -- Use the default cmdline at the bottom
        },
        -- Add any other overrides if necessary
      },
    }
    -- Customize the cmdline_popup view if needed
    opts.views = {
      cmdline_popup = {
        position = {
          row = "10%",
          col = "50%",
        },
        size = {
          width = "auto",
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = "NormalFloat:NoiceCmdlinePopup,FloatBorder:NoiceCmdlinePopupBorder",
        },
      },
    }
  end,
}
