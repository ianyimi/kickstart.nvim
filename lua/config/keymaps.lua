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
-- open oil.nvim file explorer
keymap.set("n", "<leader>e", function()
  require("oil").open()
end, { desc = "[E]xplore Files" })
