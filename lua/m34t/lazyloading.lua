-- Loads Lazy

require("lazy").setup({
  spec = {
    { import = "m34t.plugins" },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})
