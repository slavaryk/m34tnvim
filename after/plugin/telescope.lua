local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope git files" })

vim.keymap.set("n", "<leader>pg", function()
  local search_string = vim.fn.input("Grep > ")

  if (search_string ~= "" and search_string ~= nil) then
    print("wtf")
    builtin.grep_string({ search = search_string })
  end
end, { desc = "Telescope live grep but with vim grep" })

vim.keymap.set("n", "<leader>ps", builtin.grep_string, { desc = "Telescope grep" })
