local keymap = vim.keymap

-- cut characters to void register
keymap.set("n", "x", '"_x')
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

--  save
keymap.set("n", "<leader>w", "<cmd>w<cr><Esc>", { desc = "[W]rite file" })
keymap.set("v", "<leader>w", "<cmd>w<cr><Esc>", { desc = "[W]rite file" })

--  comment
keymap.set("n", "<leader>.", "<cmd>normal gcc<CR>", { noremap = true, desc = "[C]omment line" })
keymap.set("v", "<leader>.", "<cmd>normal gcc<CR>", { noremap = true, desc = "[C]omment lines" })

-- select all
keymap.set("n", "<C-a>", "gg<S-v><S-g>", { desc = "Select All" })
keymap.set("n", "<C-y>", "gg<S-v><S-g>y", { desc = "[Y]ank All" })

--  upshift line below
keymap.set("n", "<S-j>", "mz<S-j>`z", { desc = "Upshift line below" })

-- pane controls
keymap.set("n", "<leader>v", "<C-w>v", { desc = "Split window right" })
keymap.set("n", "<leader>b", "<C-w>s", { desc = "Split window below" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>x", "<cmd>close<CR>", { desc = "Close current split" })
--  pane navigation
keymap.set("n", "<leader>h", "<C-w><C-h>", { desc = "Move focus to the left pane" })
keymap.set("n", "<leader>l", "<C-w><C-l>", { desc = "Move focus to the right pane" })
keymap.set("n", "<leader>j", "<C-w><C-j>", { desc = "Move focus to the lower pane" })
keymap.set("n", "<leader>k", "<C-w><C-k>", { desc = "Move focus to the upper pane" })

-- tab controls
keymap.set("n", "<a-t>", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<a-x>", "<cmd>tabclose<CR>", { desc = "Close current tab" })
-- tab navigation
keymap.set("n", "<alt-h>", "<cmd>tabnext", { desc = "Split window right" })
keymap.set("n", "<alt-l>", "<cmd>tabprev", { desc = "Split window below" })

-- buffer controls
keymap.set("n", "<S-x>", ":bd<CR>", { noremap = true, silent = true, desc = "Close Buffer" })
-- buffer navigation
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous Buffer" }) --  downshift selected code block
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" }) --  downshift selected code block

keymap.set("v", "<S-j>", ":m '>+1<CR>gv=gv", { desc = "Downshift selected code" })
keymap.set("v", "<S-k>", ":m '<-2<CR>gv=gv", { desc = "Upshift selected code" })

-- delete to void register & paste
keymap.set("x", "<C-p>", '"_dP', { desc = "[P]aste & Delete to void" })

keymap.set("n", "<leader>d", '"_d', { desc = "[D]elete to void" })
keymap.set("v", "<leader>d", '"_d', { desc = "[D]elete to void" })
-- keymap.set("n", "<leader>y", '"+y', { desc = "[Y]ank to system clipboard" })
-- keymap.set("v", "<leader>y", '"+y', { desc = "[Y]ank to system clipboard" })
-- keymap.set("n", "<leader>p", '"+p', { desc = "[P]aste from system clipboard" })
-- keymap.set("v", "<leader>p", '"+p', { desc = "[P]aste from system clipboard" })

-- void shift-q
keymap.set("n", "<S-q>", "<nop>") 
