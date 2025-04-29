return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function ()
    require('toggleterm').setup({
      size = 20,                -- Terminal height (for horizontal) / width (for vertical)
      -- open_mapping = [[<leader>\]], -- Keymap to toggle terminal (Ctrl+\)
      direction = "float",      -- Options: "horizontal", "vertical", "tab", "float"
      float_opts = {
        border = "curved",      -- Border style: "single", "double", "shadow", "curved"
        winblend = 3,           -- Transparency (0-100)
      },
    })

    local toggleterm = require 'toggleterm'
    vim.keymap.set('n', '<leader>\\', function ()
      toggleterm.toggle(1)
    end, { desc = "Toggle terminal" })
  end,
}
