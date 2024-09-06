return {
  "sainnhe/sonokai",
  name = "sonokai",
  enabled = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.g.sonokai_transparent_background = "1"
    vim.g.sonokai_enable_style = "1"
    vim.g.sonokai_style = "espresso"

    -- You can configure highlights by doing something like:
    -- vim.cmd.hi("Comment gui=none")
  end,
}
