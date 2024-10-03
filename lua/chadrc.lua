local M = {}

M.base46 = {
	theme = "one_light"
}

M.ui = {
	telescope = { style = "bordered" },
	statusline = { 
		style = "minimal",
		separator_style = "block",
		order = { "mode", "git", "%=", "f", "%=", "cwd" },
		modules = {
			f = "%F"
		}
	},
}

return M
