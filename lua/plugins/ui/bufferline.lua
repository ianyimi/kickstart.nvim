return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	dependencies = { "ThePrimeagen/harpoon", lazy = false },
	keys = {
		{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
		{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
		{ "<leader>bxo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
		{ "<leader>bxr", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
		{ "<leader>bxl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
		{ "<leader>br", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
		{ "<leader>bl", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		-- { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		-- { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
	},
	opts = function()
		local function get_marked_buffers()
			local ok, mark = pcall(require, "harpoon.mark")
			if not ok then
				return {}
			end
			local harpoon_buffers = {}
			local current_idx = 1

			while mark.get_marked_file_name(current_idx) do
				harpoon_buffers[current_idx] = mark.get_marked_file_name(current_idx)
				current_idx = current_idx + 1
			end

			return harpoon_buffers
		end

		local function get_index_of_value(table, value)
			local index = nil
			for i, v in pairs(table) do
				if v == value then
					index = i
					break
				end
			end

			return index
		end

		return {
			options = {
				-- stylua: ignore
				close_command = function(n) LazyVim.ui.bufremove(n) end,
				-- stylua: ignore
				right_mouse_command = function(n) LazyVim.ui.bufremove(n) end,
				diagnostics = "nvim_lsp",
				always_show_bufferline = true,
				diagnostics_indicator = function(_, _, diag)
					local icons = LazyVim.config.icons.diagnostics
					local ret = (diag.error and icons.Error .. diag.error .. " " or "")
						.. (diag.warning and icons.Warn .. diag.warning or "")
					return vim.trim(ret)
				end,
				---@param opts bufferline.IconFetcherOpts
				get_element_icon = function(opts)
					return LazyVim.config.icons.ft[opts.filetype]
				end,
				numbers = function(buffer)
					-- get the harpoon buffers and the name of the buffer
					local buf_name = vim.fn.bufname(buffer.id)
					local harpoon_buffers = get_marked_buffers()

					return get_index_of_value(harpoon_buffers, buf_name) or ""
				end,
				sort_by = function(buffer_a, buffer_b)
					-- get the harpoon buffers and the names of the buffers
					local harpoon_buffers = get_marked_buffers()
					local buf_name_a = vim.fn.bufname(buffer_a.id)
					local buf_name_b = vim.fn.bufname(buffer_b.id)

					local idx_a = get_index_of_value(harpoon_buffers, buf_name_a)
					local idx_b = get_index_of_value(harpoon_buffers, buf_name_b)

					if idx_a and idx_b then
						-- Both buffers are Harpoon files; sort by their Harpoon index
						return idx_a < idx_b
					elseif idx_a then
						-- Only buffer_a is a Harpoon file; it comes first
						return true
					elseif idx_b then
						-- Only buffer_b is a Harpoon file; it comes first
						return false
					else
						-- Neither buffer is a Harpoon file; sort by buffer ID or name
						return buffer_a.id < buffer_b.id
						-- Alternatively, sort by name:
						-- return buf_name_a < buf_name_b
					end
				end,
			},
		}
	end,
	config = function(_, opts)
		require("bufferline").setup(opts)

		local function open_harpoon_buffers()
			vim.notify('bufferline setup start')
			local ok, mark = pcall(require, "harpoon.mark")
			if not ok then
				vim.notify('harpoon mark not found')
				return
			end
			local harpoon_marks = mark.get_marked_file_list()

			for _, mark_item in ipairs(harpoon_marks) do
				local buf_name = mark_item.filename
				vim.notify(buf_name)
				-- Check if buffer is already loaded
				local buf = vim.fn.bufnr(buf_name, true)
				if buf == -1 then
					-- Buffer not loaded, load it
					vim.notify('buffer not loaded')
					vim.cmd("edit " .. vim.fn.fnameescape(buf_name))
					-- After opening, move back to previous buffer to avoid changing the current window
					vim.cmd("b#" .. vim.fn.fnameescape(buf_name))
				else 
					vim.notify('buffer is loaded')
					-- ensure the buffer is listed
					vim.bo[buf].buflisted = true
				end 
			end 

			vim.schedule(function()
				pcall(require("bufferline").refresh)
			end)

		end
		-- Fix bufferline when restoring a session
		vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
			callback = function()
				vim.schedule(function()
					pcall(require("bufferline").refresh)
				end)
			end,
		})
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function() 
				vim.defer_fn(function()
					open_harpoon_buffers()
				end, 1000)
			end,
		})

	end,
}
