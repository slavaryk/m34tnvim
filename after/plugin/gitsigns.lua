local gitsigns = require("gitsigns")

gitsigns.setup({
  signs = {
    add = { text = "a┃" },
    change = { text = "c┃" },
  },
  current_line_blame = true,
})
