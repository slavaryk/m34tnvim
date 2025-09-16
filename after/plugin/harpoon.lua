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

local function make_finder(paths)
  return telescope_finders.new_table({ results = paths })
end

local function toggle_telescope(harpoon_files)
  local file_paths = get_paths(harpoon_files)

  local function select_after_refresh(current_picker, row)
    -- Pretty hacky way to select right row after swap
    -- As far as I know there is no way to do that by some Telescope api
    -- https://github.com/nvim-telescope/telescope-file-browser.nvim/issues/104
    current_picker:register_completion_callback(function()
      vim.defer_fn(function() current_picker:set_selection(row) end, 10)
      local num_cb = #current_picker._completion_callbacks
      current_picker._completion_callbacks[num_cb] = nil
    end)
  end

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
        local selection_row = current_picker:get_selection_row()

        harpoon:list():remove(selected_entry)

        select_after_refresh(current_picker, selection_row)
        current_picker:refresh(make_finder(get_paths(harpoon:list())))
      end)

      -- Swap current entry with next entry
      map("n", "<C-k>", function()
        local selected_entry = telescope_state.get_selected_entry()
        local selected_entry_index = selected_entry.index

        if selected_entry_index + 1 > harpoon:list()._length then
          return
        end

        local current_picker = telescope_state.get_current_picker(prompt_buffer_number)
        local selection_row = current_picker:get_selection_row()
        local next_entry = table.remove(harpoon_files.items, selected_entry_index + 1)
        local curr_entry = table.remove(harpoon_files.items, selected_entry_index)

        table.insert(harpoon_files.items, selected_entry_index, next_entry)
        table.insert(harpoon_files.items, selected_entry_index + 1, curr_entry)

        select_after_refresh(current_picker, selection_row - 1)
        current_picker:refresh(make_finder(get_paths(harpoon:list())))
      end)

      -- Swap current entry with prev entry
      map("n", "<C-j>", function()
        local selected_entry = telescope_state.get_selected_entry()
        local selected_entry_index = selected_entry.index

        -- print(selected_entry_index)

        if selected_entry_index - 1 == 0 then
          return
        end

        local current_picker = telescope_state.get_current_picker(prompt_buffer_number)
        local selection_row = current_picker:get_selection_row()
        local curr_entry = table.remove(harpoon_files.items, selected_entry_index)
        local prev_entry = table.remove(harpoon_files.items, selected_entry_index)

        table.insert(harpoon_files.items, selected_entry_index, prev_entry)
        table.insert(harpoon_files.items, selected_entry_index - 1, curr_entry)

        select_after_refresh(current_picker, selection_row + 1)
        current_picker:refresh(make_finder(get_paths(harpoon:list())))
      end)


    return true
  end,
}):find()
end

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end)
