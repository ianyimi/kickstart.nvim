-- helper function to parse output
local function parse_output(proc)
  local result = proc:wait()
  local ret = {}
  if result.code == 0 then
    for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
      -- Remove trailing slash
      line = line:gsub("/$", "")
      ret[line] = true
    end
  end
  return ret
end

-- build git status cache
local function new_git_status()
  return setmetatable({}, {
    __index = function(self, key)
      local ignore_proc = vim.system(
        { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
        {
          cwd = key,
          text = true,
        }
      )
      local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
        cwd = key,
        text = true,
      })
      local ret = {
        ignored = parse_output(ignore_proc),
        tracked = parse_output(tracked_proc),
      }

      rawset(self, key, ret)
      return ret
    end,
  })
end
local git_status = new_git_status()

-- -- Clear git status cache on refresh
-- local refresh = require("oil.actions").refresh
-- local orig_refresh = refresh.callback
-- refresh.callback = function(...)
--   git_status = new_git_status()
--   orig_refresh(...)
-- end

-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local dir = require("oil").get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

return {
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = { "icon", "mtime", "size" },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        watch_for_changes = true,
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return name == ".." or name == ".git"
          end,
          is_hidden_file = function(name, bufnr)
            local dir = require("oil").get_current_dir(bufnr)
            local is_dotfile = vim.startswith(name, ".") and name ~= ".."
            -- if no local directory (e.g. for ssh connections), just hide dotfiles
            if not dir then
              return is_dotfile
            end
            -- dotfiles are considered hidden unless tracked
            if is_dotfile then
              return not git_status[dir].tracked[name]
            else
              -- Check if file is gitignored
              return git_status[dir].ignored[name]
            end
          end,
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 0,
        },
        win_options = {
          wrap = true,
          winblend = 0,
          winbar = "%!v:lua.get_oil_winbar()",
        },
        keymaps = {
          ["<C-c>"] = false,
          ["gx"] = false,
          ["q"] = "actions.close",
          ["<Esc>"] = "actions.close",
          ["."] = "actions.parent",
          [";"] = "actions.cd",
          ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
          ["<C-r>"] = "actions.refresh",
          ["<C-s>"] = "actions.change_sort",
          ["<C-h>"] = "actions.toggle_hidden",
          ["<C-x>"] = "actions.toggle_trash",
          ["<C-d>"] = {
            desc = "Toggle file detail view",
            callback = function()
              detail = not detail
              if detail then
                require("oil").set_columns({ "icon", "size", "mtime" })
              else
                require("oil").set_columns({ "icon" })
              end
            end,
          },
        },
      })
    end,
  },
}
