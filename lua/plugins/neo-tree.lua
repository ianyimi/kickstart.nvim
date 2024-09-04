local do_setcd = function(state)
  local p = state.tree:get_node().path
  print(p) -- show in command line
  vim.cmd(string.format('exec(":lcd %s")', p))
end

local function getTelescopeOpts(state, path)
  return {
    cwd = path,
    search_dirs = { path },
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if filename == nil then
          filename = selection[1]
        end
        -- any way to open the file without triggering auto-close event of neo-tree?
        require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
      end)
      return true
    end,
  }
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  keys = {
    {
      "<Space>e",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          source = "filesystem",
          position = "right",
        })
      end,
      desc = "Filesystem (root dir)",
    },
  },
  opts = {
    commands = {
      telescope_find = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("telescope.builtin").find_files(getTelescopeOpts(state, path))
      end,
      telescope_grep = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("telescope.builtin").live_grep(getTelescopeOpts(state, path))
      end,
      setcd = function(state)
        do_setcd(state)
      end,
      find_files = function(state)
        do_setcd(state)
        require("telescope.builtin").find_files()
      end,
      grep = function(state)
        do_setcd(state)
        require("telescope.builtin").live_grep()
      end,
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(arg)
          vim.cmd([[
              setlocal relativenumber
          ]])
        end,
      },
    },
    window = {
      position = "right",
      mappings = {
        ["o"] = "open",
        ["x"] = "close_node",
        ["u"] = "navigate_up",
        ["I"] = "toggle_hidden",
        ["C"] = "set_root",
        ["r"] = "refresh",
        ["c"] = "setcd",
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["m"] = function() end,
        ["z"] = function() end,
        ["<CTRL-a>"] = {
          "add",
          config = {
            show_path = "relative",
          },
        },
        ["<CTRL-c>"] = {
          "copy",
          config = {
            show_path = "relative",
          },
        },
        ["<CTRL-d>"] = "delete",
        ["<CTRL-f>"] = "telescope_find",
        ["<CTRL-g>"] = "telescope_grep",
        ["<CTRL-m>"] = {
          "move",
          config = {
            show_path = "relative",
          },
        },
      },
    },
    filesystem = {
      filtered_items = {
        -- visible = true,
        show_hidden_count = true,
        hide_dotfiles = true,
        hide_gitignored = false,
        hide_by_name = {
          -- ".git",
          ".DS_Store",
          -- 'thumbs.db',
        },
        never_show = {},
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
    },
    use_libuv_file_watcher = false,
  },
}
