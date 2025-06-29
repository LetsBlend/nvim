vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.o.autoindent = true
vim.o.smartindent = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clip oard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = false

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("config") .. "/undodir"

vim.opt.termguicolors = true

-- Change cursor style
vim.opt.guicursor = 'n-v-c-i:block'

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()
vim.keymap.set('n', '<C-f>', ':q<CR>')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- For indentation
vim.keymap.set('n', 'p', function()
  vim.cmd('normal! "+p')
  vim.cmd('normal! `[v`]=')
  vim.cmd('normal! `[_')
end)
vim.keymap.set('n', '<leader>i', 'gg=G<C-o>', { desc = 'Indent file' })
vim.keymap.set('i', '<S-Tab>', '<C-d>', { desc = 'Outdent line' })
vim.keymap.set('n', '<leader>uw', '<cmd>set shiftwidth=4<CR>', { desc = 'Set shiftwidth to default' })

-- Others
vim.keymap.set('n', '<leader>ur', ':ProjectRoot<CR>', { desc = 'Set Project Root' })

-- Cycle through files
vim.keymap.set('n', 'L', ':bnext<CR>', { noremap = true })
vim.keymap.set('n', 'H', ':bprevious<CR>', { noremap = true })

vim.keymap.set('n', 'K', require('plugins.hover_docs').hover_to_glow, { desc = 'LSP Hover with Glow' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('x', 'p', '"_dP', { desc = 'Paste without overwriting register' })

-- Prevents { from littering the jump list
vim.keymap.set('n', '{', function() vim.cmd('keepjumps normal! {') end, { silent = true })
vim.keymap.set('n', '}', function() vim.cmd('keepjumps normal! }') end, { silent = true })


-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Diagnostic globals ]]
-- vim.diagnostic.config({ update_in_insert = true })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Force rust_analyzer to fully update
-- By default rust_analyzer only updates on save for better performance
-- We manually ask it to re-check the file usind an autocmd
local function save_and_notify_lsp()
  if vim.bo.modified then
    vim.cmd("silent write")
    -- notify LSP manually, just in case
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
      if client.name == "rust_analyzer" then
        -- manually ask it to re-check
        client.notify("textDocument/didSave", {
          textDocument = { uri = vim.uri_from_bufnr(0) }
        })
      end
    end
  end
end

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
  pattern = "*.rs",
  callback = function()
    save_and_notify_lsp()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)








-- [[ Configure and install build configurations]]
-- Edit this file to add support for more languages
require('langs.init').setup()






-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --

  -- Vim-Games Plugin
  'ThePrimeagen/vim-be-good',

  -- Icons Plugin
  'nvim-tree/nvim-web-devicons',


  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Session manager Plugin
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- lazy-load on file open
    config = function()
      require("persistence").setup()
    end,
  },

  -- Alpha Nvim Plugin
  require 'plugins.alphanvim',

  -- WhichKey Plugin
  require 'plugins.whichkey',

  -- Terminal Plugin
  require 'plugins.toggleterm',

  -- Telescope Fuzzy Finder Plugin
  require 'plugins.telescope',

  -- Projects Plugin
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        -- these are the defaults, customize if needed
        detection_methods = { "lsp", "pattern" },
        patterns = {
          ".git",                 -- Git repos
          "Makefile",             -- C / C++ / general builds
          "CMakeLists.txt",       -- C / C++ with CMake
          "package.json",         -- Node.js / npm
          "requirements.txt",     -- Python (pip)
          "pyproject.toml",       -- Python (modern packaging)
          "setup.py",             -- Python (legacy packaging)
          "Pipfile",              -- Python (pipenv)
          "poetry.lock",          -- Python (poetry)
          "Cargo.toml",           -- Rust
          "go.mod",               -- Go
          "go.sum",               -- Go
          "composer.json",        -- PHP (Composer)
          "Gemfile",              -- Ruby (Bundler)
          "mix.exs",              -- Elixir (Mix)
          "build.gradle",         -- Java / Kotlin (Gradle)
          "pom.xml",              -- Java (Maven)
          ".project",             -- Custom fallback marker
          "tsconfig.json",        -- TypeScript
          "deno.json",            -- Deno
          "elm.json",             -- Elm
          "shard.yml",            -- Crystal
          "Justfile",             -- just task runner
          ".env",                 -- Often present in projects
          ".project",            -- Custom marker 
        },
      })
    end,
  },

  -- LSP Plugins
  require 'plugins.lsp',

  -- LSP UI
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
    opts = {
      style = 'dark',   -- Try other styles like 'dark', 'light', or 'solarized'
      border = 'rounded',  -- Options: 'single', 'double', 'rounded', 'solid'
      width = 100,  -- Set the width of the window
      height = 30,  -- Set the height of the window
      max_width = 120,  -- Set maximum width
      max_height = 40,  -- Set maximum height
    }
  },

  -- Autoformat Plugins
  -- require 'plugins.autoformat',

  -- Autocompletion Plugins
  require 'plugins.autocomplete',

  {
    'saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function(_, opts)
      local crates = require('crates')
      crates.setup(opts)
      crates.show()
    end
  },

  -- Autopairs Plugin
  require 'plugins.autopairs',

  -- Tree-Hirarchy plugin
  require 'plugins.neo-tree',

  -- Harpoon Plugin
  require 'plugins.harpoon',

  -- Highlighting and Colorscemes
  require 'plugins.highlighter',

  -- Auto save plugin
  -- {
  --   "Pocco81/auto-save.nvim",
  --   config = function()
  --     require("auto-save").setup({
  --       trigger_events = { "InsertLeave", "TextChanged" },
  --       condition = function(buf)
  --         return vim.bo[buf].modifiable and vim.bo[buf].buftype == ""
  --       end,
  --     })
  --   end,
  -- },

  -- UndoTree Plugin
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle", -- lazy-load on command
    keys = {
      { "<leader>ut", "<cmd>UndotreeToggle<cr>", desc = "[U]ndo[T]ree" }
    },
    config = function()
      vim.g.undotree_WindowLayout = 2 -- Optional: vertical split
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },

  --back-and-forth file jumping
  {
    'wilfreddenton/history.nvim',
    config = function ()
      require('history').setup({
        keybinds = {
          back = 'J',
          forward = 'K',
          view = '<leader>uf'
        }
      })
    end
  },

  -- Fold Plugin
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      -- Global fold settings
      vim.o.foldcolumn = "1" -- Show fold column
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      -- Folding providers: Treesitter + fallback to indent
      require("ufo").setup({
        provider_selector = function(_, filetype, _)
          return { "treesitter", "indent" }
        end,
        preview = {
          winhighlight = "FloatBorder:WinSeparator",  -- Match border to window separator
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },  -- Optional: Custom border
        }
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "python", "javascript", "typescript", "json", "html", "css", "cpp", "c", "java", "rust", -- add more as needed
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 3,            -- How many lines the context window should span
        trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded
        mode = 'cursor',          -- Line used to calculate context (cursor or topline)
        separator = nil,          -- Separator between context and content (can be a string like "─")
      })
    end,
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- tried to setup debugging for windows applications in cplusplus but failed (sadge)
  -- you can expect quite a bit of work future me
  require 'plugins.debug',

  -- require 'plugins.indent_line',
  -- require 'plugins.lint',
  require 'plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- Tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", 
      transparent = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
---- Add to your noice.nvim config or init.lua
-- vim.api.nvim_set_hl(0, 'MarkdownH1', { bold = true, fg = '#ff9e64' })
-- vim.api.nvim_set_hl(0, 'MarkdownH2', { bold = true, fg = '#7aa2f7' })
-- vim.api.nvim_set_hl(0, 'MarkdownCode', { bg = '#1a1a2e' })
-- vim.api.nvim_set_hl(0, 'MarkdownLinkText', { underline = true, fg = '#7dcfff' })
-- vim.api.nvim_set_hl(0, 'MarkdownItalic', { italic = true })
-- vim.api.nvim_set_hl(0, 'MarkdownBold', { bold = true })

-- Window Seperation
vim.wo.winhighlight = "WinSeparator:WinSeparator"
vim.opt.fillchars = {
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vert = "│",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
}
vim.opt.laststatus = 3 -- Global statusline for cleaner separation
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#00a5be', bg = 'NONE' })

-- Make relative numbers more visible
vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#7a8ba8" })  -- Makes the line number color the same as Normal text
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = "#565f89" })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = "#565f89"})


-- Snippets
local ls = require("luasnip")

vim.keymap.set({ "i", "s", "n" }, "<C-k>", function()
  if ls.expand_or_jumpable() then ls.expand_or_jump() end
end, { silent = true })

vim.keymap.set({ "i", "s", "n" }, "<C-j>", function()
  if ls.jumpable(-1) then ls.jump(-1) end
end, { silent = true })




