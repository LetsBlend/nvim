
-- File: lua/plugins/harpoon.lua
return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" }, -- required dependency
  config = function()
    require("harpoon").setup({
      -- optional configuration
    })

    -- example keymaps
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    vim.keymap.set("n", "<C-a>", mark.add_file, { desc = "Harpoon add file" })
    vim.keymap.set("n", "<C-q>", ui.toggle_quick_menu, { desc = "Harpoon quick menu" })
    vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end, { desc = "Harpoon file 1" })
    vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end, { desc = "Harpoon file 2" })
    vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end, { desc = "Harpoon file 3" })
    vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end, { desc = "Harpoon file 4" })
  end,
}
