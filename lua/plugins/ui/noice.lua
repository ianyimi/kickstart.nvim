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
          view = "cmdline_popup", -- Use the default cmdline at the bottom
        },
        -- Use default cmdline for '?' (search_up)
        search_up = {
          kind = "search",
          pattern = "^%?",
          icon = " ",
          lang = "regex",
          view = "cmdline_popup", -- Use the default cmdline at the bottom
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
      cmdline_popup_search = {
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
        -- Use custom highlight groups
        win_options = {
          winhighlight = "Normal:NoiceCmdlinePopupSearchNormal,FloatBorder:NoiceCmdlinePopupSearchBorder",
        },
      },
    }

    opts.highlights = vim.tbl_extend("force", opts.highlights or {}, {
      -- Adjust highlights for the default cmdline (used for search)
      Cmdline = { fg = "#FFFFFF", bg = "#000000" },
      CmdlinePrompt = { fg = "#FFFF00", bg = "#000000" },
      -- For '/' and '?' search popup
      NoiceCmdlinePopupSearchNormal = { fg = "#FFFFFF", bg = "#000000" },
      NoiceCmdlinePopupSearchBorder = { fg = "#FFFFFF", bg = "#000000" },
      -- If using MsgArea
      MsgArea = { fg = "#FFFFFF", bg = "#000000" },
    })
  end,
}
