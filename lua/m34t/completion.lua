-- https://gist.github.com/MariaSolOs/2e44a86f569323c478e5a078d0cf98cc
-- Autoselect the first item but don"t insert it.
vim.opt.completeopt = { "menu", "menuone", "noinsert" }

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    -- Utility for keymap creation.
    -- @param lhs string
    -- @param rhs string|function
    -- @param opts string|table
    -- @param mode? string|string[]
    local function keymap(lhs, rhs, opts, mode)
      opts = type(opts) == "string" and { desc = opts }
      or vim.tbl_extend("error", opts --[[@as table]], { buffer = args.buf })
      mode = mode or "n"
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- For replacing certain <C-x>... keymaps.
    -- @param keys string
    local function feedkeys(keys)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
    end

    -- Is the completion menu open?
    local function pumvisible()
      return tonumber(vim.fn.pumvisible()) ~= 0
    end

    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      print("No client")
      return
    end

    -- Enable completion and configure keybindings.
    if client:supports_method("textDocument/completion") then
      -- Enable completion on every char hit in insert mode
      vim.api.nvim_create_autocmd("InsertCharPre", {
        callback = function()
          vim.lsp.completion.get()
        end,
      })

      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

      -- Use enter to accept completions.
      keymap("<cr>", function()
        return pumvisible() and "<C-y>" or "<cr>"
      end, { expr = true }, "i")

      -- Use slash to dismiss the completion menu.
      keymap("/", function()
        return pumvisible() and "<C-e>" or "/"
      end, { expr = true }, "i")

      -- Use <C-n> to navigate to the next completion or:
      -- - Trigger LSP completion.
      -- - If there"s no one, fallback to vanilla omnifunc.
      keymap("<C-n>", function()
        if pumvisible() then
          feedkeys "<C-n>"
        else
          if next(vim.lsp.get_clients { bufnr = 0 }) then
            vim.lsp.completion.get()
          else
            if vim.bo.omnifunc == "" then
              feedkeys "<C-x><C-n>"
            else
              feedkeys "<C-x><C-o>"
            end
          end
        end
      end, "Trigger/select next completion", "i")

      -- Buffer completions.
      keymap("<C-u>", "<C-x><C-n>", { desc = "Buffer completions" }, "i")

      -- Inside a snippet, use backspace to remove the placeholder.
      keymap("<BS>", "<C-o>s", {}, "s")
    end
  end,
})
