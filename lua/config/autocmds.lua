-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
local autocmd = vim.api.nvim_create_autocmd

-- rewrite all augroups using tis function
local function augroup(name)
  return vim.api.nvim_create_augroup("sergio-lazyvim_" .. name, { clear = true })
end

-- augroup('formatonsave', { clear = true })
autocmd("BufWritePre", {
  group = augroup("formatonsave"),
  desc = "Trigger format on save",
  pattern = { "*.astro", "*.lua", "*.py", "*.js", "*.ts", "*.jsx", "*.tsx", "*.sh", "*.md" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- stop telescope from going into insert mode on close
autocmd({ "BufLeave", "BufWinLeave" }, {
  callback = function(event)
    if vim.bo[event.buf].filetype == "TelescopePrompt" then
      vim.api.nvim_exec2("silent! stopinsert!", {})
    end
  end,
})
