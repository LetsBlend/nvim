return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function ()
    require('toggleterm').setup({
      size = 20,                -- Terminal height (for horizontal) / width (for vertical)
      -- open_mapping = [[<leader>\]], -- Keymap to toggle terminal (Ctrl+\)
      direction = "tab",      -- Options: "horizontal", "vertical", "tab", "float"
      float_opts = {
        border = "curved",      -- Border style: "single", "double", "shadow", "curved"
        winblend = 3,           -- Transparency (0-100)
      },
    })

    local Terminal = require("toggleterm.terminal").Terminal
    local term = Terminal:new({
      direction = "tab", -- Or "horizontal"/"vertical"
      hidden = true,       -- Start hidden
    })

    -- Store the helper module globally or in package.loaded
    local M = {}

    function M.toggle()
      term:toggle()
    end

    function M.open()
      if not term:is_open() then
        term:open()
      end
    end

    function M.send(cmd)
      M.open()
      term:send(cmd, true)
    end

    -- Set keymap to toggle the persistent terminal
    vim.keymap.set("n", "<leader>'", function()
      M.toggle()
    end, { desc = "Toggle persistent terminal" })

    package.loaded["toggle_term"] = M
  end,
}

