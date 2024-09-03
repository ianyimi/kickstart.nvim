return {
  "laytan/tailwind-sorter.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
  opts = {
    on_save_pattern = { "*.html", "*.astro", "*.jsx", "*.tsx" },
  },
}
