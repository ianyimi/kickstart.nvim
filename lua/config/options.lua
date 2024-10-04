vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- Set filetype to `bigfile` for files larger than 1.5 MB
-- Only vim syntax will be enabled (with the correct filetype)
-- LSP, treesitter and other ft plugins will be disabled.
-- mini.animate will also be disabled.
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB
-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.opt.spelllang = { "en" }

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
vim.opt.cursorcolumn = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false

vim.opt.expandtab = false
local tabSize = 2
vim.opt.tabstop = tabSize
vim.opt.shiftwidth = tabSize

-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
vim.opt.scrolloff = 999

vim.opt.virtualedit = "block"

-- vim.opt.inccommand = "split"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.showmode = false

vim.opt.undofile = true
