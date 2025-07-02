-- Keymaps and remaps of standard vim

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<leader>i", function()
	vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
end, { desc = "Toggle diagnostics" })

vim.keymap.set("n", "<leader>d", function()
  vim.lsp.buf.definition()
end, { desc = "Jump to definition of symbol under cursor" })

vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
