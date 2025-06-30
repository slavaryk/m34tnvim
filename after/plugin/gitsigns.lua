local gitsigns = require("gitsigns")

gitsigns.setup({
  signs = {
    add = { text = "a┃" },
    change = { text = "c┃" },
  },
})
