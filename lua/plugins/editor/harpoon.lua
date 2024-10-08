return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	lazy = false,
	opts = {
		menu = {
			width = vim.api.nvim_win_get_width(0) - 4,
		},
		settings = {
			save_on_toggle = true,
		},
	},
	keys = function()
		local harpoon = require("harpoon")
		-- basic telescope configuration
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			local make_finder = function()
				local paths = {}

				for _, item in ipairs(harpoon_files.items) do
					table.insert(paths, item.value)
				end

				return require("telescope.finders").new_table({
					results = paths,
				})
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = make_finder(),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
					attach_mappings = function(prompt_bufnr, map)
						local actions = require("telescope.actions")
						local action_state = require("telescope.actions.state")
						local current_picker = action_state.get_current_picker(prompt_bufnr)
						local ok, mark = pcall(require, "harpoon.mark")
						if not ok then
							return true
						end

						local function delete_mark()
							local selection = action_state.get_selected_entry()
							if selection == nil then
								return
							end

							harpoon:list():removeAt(selection.index)
							current_picker:refresh(make_finder())
							-- -- Find the index of the selected file in Harpoon's marks
							-- local harpoon_marks = mark.get_marked_file_list()
							-- local target_index = nil
							-- for idx, entry in ipairs(harpoon_marks) do
							-- 	if entry.filename == selection.value then
							-- 		target_index = idx
							-- 		break
							-- 	end
							-- end
							--
							-- if target_index then
							-- 	mark.rm_file(target_index)
							--
							-- 	local picker = action_state.get_current_picker(prompt_bufnr)
							-- 	picker:refresh(make_finder(), { reset_prompt = true })
							--
							-- 	require("bufferline").refresh()
							-- end
						end

						map("i", "<C-d>", delete_mark)
						map("n", "<C-d>", delete_mark)
						return true
					end,
				})
				:find()
		end

		local keys = {
			{
				"<leader>H",
				function()
					harpoon:list():add()
				end,
				desc = "Harpoon File",
			},
			{
				"<leader>h",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon Quick Menu",
			},
		}

		for i = 1, 9 do
			table.insert(keys, {
				"<leader>" .. i,
				function()
					harpoon:list():select(i)
				end,
				desc = "Harpoon to File " .. i,
			})
		end
		return keys
	end,
}
