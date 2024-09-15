-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')
--  See `:help hlsearch`
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Toggle Undo Tree
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

--  comment
keymap.set("n", "<leader>.", "<cmd>normal gcc<CR>", { noremap = true, desc = "[C]omment line" })
keymap.set("v", "<leader>.", "<cmd>normal gcc<CR>", { noremap = true, desc = "[C]omment lines" })

-- select all
keymap.set("n", "<C-a>", "gg<S-v><S-g>", { desc = "Select All" })
keymap.set("n", "<C-y>", "gg<S-v><S-g>y", { desc = "[Y]ank All" })

--  upshift line below
keymap.set("n", "<S-j>", "mz<S-j>`z", { desc = "Upshift line below" })

--  exit file and neotree in tandem
keymap.set("n", "<S-z><S-z>", "<S-z><S-z><S-z><S-z>", { desc = "Quit [x2]" })

--  save
keymap.set("n", "<leader>w", "<cmd>w<cr><Esc>", { desc = "[W]rite file" })
keymap.set("v", "<leader>w", "<cmd>w<cr><Esc>", { desc = "[W]rite file" })

--  pane navigation
keymap.set("n", "<leader>h", "<C-w><C-h>", { desc = "Move focus to the left pane" })
keymap.set("n", "<leader>l", "<C-w><C-l>", { desc = "Move focus to the right pane" })
keymap.set("n", "<leader>j", "<C-w><C-j>", { desc = "Move focus to the lower pane" })
keymap.set("n", "<leader>k", "<C-w><C-k>", { desc = "Move focus to the upper pane" })

-- pane controls
keymap.set("n", "<leader>v", "<C-w>v", { desc = "Split window right" }) -- split window vertically
keymap.set("n", "<leader>b", "<C-w>s", { desc = "Split window below" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>x", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- tab
keymap.set("n", "<C-t>", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<C-w>", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab

-- buffer
keymap.set("n", "<S-x>", ":bd<CR>", { noremap = true, silent = true, desc = "Close Buffer" })

keymap.set("v", "<S-j>", ":m '>+1<CR>gv=gv", { desc = "Downshift selected code" }) --  downshift selected code block
keymap.set("v", "<S-k>", ":m '<-2<CR>gv=gv", { desc = "Upshift selected code" }) --  downshift selected code block

-- delete to void register & paste
keymap.set("x", "<leader>p", '"_dP', { desc = "[P]aste & Delete to void" }) --  upshift line below

keymap.set("n", "<leader>d", '"_d', { desc = "[d]elete to void" }) --  delete to voidt
keymap.set("v", "<leader>d", '"_d', { desc = "[d]elete to void" }) --  delete to void
keymap.set("n", "<leader>y", '"+y', { desc = "[y]ank to system clipboard" }) --  yank to system clipboard
keymap.set("v", "<leader>y", '"+y', { desc = "[y]ank to system clipboard" }) --  yank to system clipboard

keymap.set("n", "<S-q>", "<nop>") --  void shift-q functionality

keymap.set("n", "<leader>e", function()
  require("oil").open()
end, { desc = "[E]xplore Files" })
