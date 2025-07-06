local harpoon = require("harpoon")
local telescope_config = require("telescope.config").values
local telescope_finders = require("telescope.finders")
local telescope_pickers = require("telescope.pickers")
local telescope_state = require("telescope.actions.state")

-- REQUIRED
harpoon:setup()
-- REQUIRED

local function get_paths(files)
  local paths = {}
  local items = files.items
  local len = files._length
  local index = 1

  for i = 1, len do
    local item = items[i]

    if item ~= nil then
      paths[index] = item.value
      index = index + 1
    end
  end

  return paths
end

local make_finder = function(paths)
  return telescope_finders.new_table({ results = paths })
end

local function toggle_telescope(harpoon_files)
  local file_paths = get_paths(harpoon_files)

  telescope_pickers.new({}, {
    prompt_title = "Harpoon",
    finder = make_finder(file_paths),
    previewer = telescope_config.file_previewer({}),
    sorter = telescope_config.generic_sorter({}),
    layout_strategy = "center",
    initial_mode = "normal",
    attach_mappings = function(prompt_buffer_number, map)
      -- Remove entry
      map("n", "<C-d>", function()
        local selected_entry = telescope_state.get_selected_entry()
        local current_picker = telescope_state.get_current_picker(prompt_buffer_number)

        harpoon:list():remove(selected_entry)
        current_picker:refresh(make_finder(get_paths(harpoon:list())))
      end)

    return true
  end,
}):find()
end

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end)

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
