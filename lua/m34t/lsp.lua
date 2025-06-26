vim.lsp.config("luals", {
  on_init = function()
    print("luals running in background")
  end,
  on_attach = function()
    print("luals is attached to this file")
  end,
})
vim.lsp.enable("luals")

vim.lsp.config("tsls", {
  on_init = function()
    print("tsls is running in backround")
  end,
  on_attach = function()
    print("tsls is attached to this file")
  end,
})
vim.lsp.enable("tsls")

vim.lsp.config("vuels", {
  on_init = function()
    print("vuels is running in backround")
  end,
  on_attach = function()
    print("vuels is attached to this file")
  end,
})
vim.lsp.enable("vuels")
