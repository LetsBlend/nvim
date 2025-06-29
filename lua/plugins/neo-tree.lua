-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
        { '\\', ':Neotree reveal toggle float<CR>', desc = 'NeoTree reveal', silent = true },
        { '<C-\\>', ':Neotree left reveal toggle<CR>', desc = 'NeoTree (sidebar)', silent = true },
    },
    opts = function()
        local events = require("neo-tree.events")

        return {
            close_if_last_window = true,
            popup_border_style = "rounded",
            enable_modified_markers = true, -- Show file modification status
            default_component_configs = {
                indent = { with_expanders = true },
            },
            window = {
                position = "float",
                width = 60,
                height = 30,
                mappings = {
                    ['\\'] = 'close_window',
                },
            },
            filesystem = {
                window = {
                    position = 'left',
                    width = function()
                        return math.min(math.floor(vim.o.columns * 0.3), 50)
                    end,
                },
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                follow_current_file = {
                    enabled = true,
                },
            },
            event_handlers = {
                {
                    event = events.NEO_TREE_BUFFER_ENTER,
                    handler = function()
                        vim.opt_local.relativenumber = true
                    end,
                },
                {
                    event = events.FILE_ADDED,
                    handler = function(file_path)
                        if file_path:match("%.class$") then
                            local directory = vim.fn.fnamemodify(file_path, ":h") .. '/'
                            local filename = vim.fn.fnamemodify(file_path, ":t:r")

                            print("Detected class scaffold: " .. filename .. " in " .. directory)

                            require("project_manager").create_class(directory, filename)

                            os.remove(file_path)
                        end
                    end,
                },
            },
        }
    end,
}
