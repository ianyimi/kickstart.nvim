return {
  "wuelnerdotexe/vim-astro",
  config = function()
    -- Enable TypeScript and TSX highlighting for .astro files
    vim.g.astro_typescript = "enable"

    -- Enable Stylus syntax for .astro files
    vim.g.astro_stylus = "enable"
  end,
}
