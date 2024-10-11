return {
	"ThePrimeagen/git-worktree.nvim",
	dependencies = {
		"stevearc/oil.nvim"
	},
	opts = function()
		local worktree = require("git-worktree")
		local oil_ok, oil = pcall(require, "oil")
		local mini_files_ok, mini_files = pcall(require, "mini.files")
		-- Function to normalize paths to use backslashes
    local function normalize_path(path)
      return path:gsub("/", "\\")
    end
		worktree.on_tree_change(function(op, metadata)
			if op == worktree.Operations.Switch then
				local new_path = normalize_path(metadata.path)
				vim.api.nvim_set_current_dir(new_path)
				if oil_ok then
					oil.open(new_path)
				elseif mini_files_ok then
					mini_files.open(new_path)
				end
				print("Updated Directory: " .. metadata.prev_path .. " > " .. new_path)
			end
		end)
		return {}
	end,
}
