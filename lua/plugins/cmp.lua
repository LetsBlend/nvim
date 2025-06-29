
-- Completion engine configuration
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'saecki/crates.nvim',  -- Make sure crates.nvim is loaded
  },
  config = function()
    local cmp = require('cmp')

    -- Setting up `nvim-cmp`
    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'crates' },  -- Make crates.nvim use the `cmp` popup
      }),
    })

    -- Rust crate manager
    require('crates').setup {
      -- Optional configuration (see :help crates.setup())
      smart_insert = true,
      autoload = true,
      autoupdate = true,

      lsp = {
        enabled = true,
        -- on_attach = function(client, bufnr)
        --   local crates = require('crates')
        --   local map = function(keys, func, desc)
        --     vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'Crates: ' .. desc })
        --   end
        --
        --   -- Example crates.nvim keymaps (Doesn't quite work I think)
        --   -- map('<leader>cu', crates.update_crate, '[U]pdate current crate')
        --   -- map('<leader>cU', crates.upgrade_crate, 'Up[g]rade current crate')
        --   -- map('<leader>ca', crates.update_all_crates, 'Update [A]ll crates')
        --   -- map('<leader>cA', crates.upgrade_all_crates, 'Upgrade [A]ll crates')
        --   -- map('<leader>cd', crates.sopen_documentation, 'Show [D]ocumentation')
        --   -- map('<leader>cv', crates.show_versions_popup, 'Show [V]ersions')
        --   -- map('<leader>cf', crates.show_features_popup, 'Show [F]eatures')
        -- end,
        actions = true,
        completion = true,
        -- hover = true,
      },
      completion = {
        crates = {
          enabled = true, -- disabled by default
          max_results = 20, -- The maximum number of search results to display
          min_chars = 1, -- The minimum number of charaters to type before completions begin appearing
        }
      }
    }
  end,
}
