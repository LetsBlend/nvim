return {
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')

      dashboard.opts.opts.noautocmd = false

      -- Set header
      dashboard.section.header.val = {
        '                                                     ',
        '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
        '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
        '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
        '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
        '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
        '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
        '                                                     ',
      }

      -- Set menu
      dashboard.section.buttons.val = {
        dashboard.button('f', '  > Find projects', function()
          require('project_manager').switch_projects()
        end),
        dashboard.button('n', '  > New Project', ':lua require("project_manager").new_project()<CR>'),
        dashboard.button('r', '  > Recent files', ':Telescope oldfiles<CR>'),
        dashboard.button('s', '  > Restore session', ':lua require("persistence").load( {last = true} )<CR>'),
        dashboard.button('c', '  > Config', ':e $MYVIMRC<CR>'),
        dashboard.button('l', '󰒲  > Lazy', ':Lazy<CR>'),
        dashboard.button('q', '󰈆  > Quit', ':qa<CR>'),
      }

      -- Set footer
      local function footer()
        local version = vim.version()
        local print_version = 'v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
        local datetime = os.date('%Y-%m-%d %H:%M:%S')

        return print_version .. ' · ' .. datetime
      end

      dashboard.section.footer.val = footer()

      -- Send config to alpha
      alpha.setup(dashboard.opts)

      -- Disable folding on alpha buffer
      vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

      -- Show Dashboard
      vim.keymap.set("n", "<leader>ud", "<cmd>Alpha<CR>", { desc = "Dashboard" })
    end
  }
}
