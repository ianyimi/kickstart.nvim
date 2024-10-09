return {
	"echasnovski/mini.icons",
	lazy = true,
	opts = {
		file = {
			[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
			["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			[".chezmoiignore"] = { glyph = "", hl = "MiniIconsGrey" },
			[".chezmoiremove"] = { glyph = "", hl = "MiniIconsGrey" },
			[".chezmoiroot"] = { glyph = "", hl = "MiniIconsGrey" },
			[".chezmoiversion"] = { glyph = "", hl = "MiniIconsGrey" },
			["bash.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
			["json.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
			["ps1.tmpl"] = { glyph = "󰨊", hl = "MiniIconsGrey" },
			["sh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
			["toml.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
			["yaml.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
			["zsh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
		},
		filetype = {
			dotenv = { glyph = "", hl = "MiniIconsYellow" },
		},
	},
	init = function()
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
}
