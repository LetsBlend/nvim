-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    --Add your own debuggers here
    'leoluz/nvim-dap-go',
    'nvim-java/nvim-java-dap',

  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>BB',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>Bb',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
    {
      '<leader>?',
        function ()
          require('dapui').eval(nil, { enter = true })
        end,
      desc = 'Debug: Evaluate var under cursor.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',     -- Go debugger
        'codelldb',  -- Linux debugging (LLDB)
        'cpptools',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.30 },
            { id = "breakpoints", size = 0.10 },
            { id = "stacks", size = 0.30 },
            { id = "watches", size = 0.30 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 10,
          position = "bottom",
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '🞃', collapsed = '🞂', current_frame = '●' },
      controls = {
        icons = {
          pause = '',
          play = '',
          step_into = '',
          step_over = '',
          step_out = '',
          step_back = '',
          run_last = '',
          terminate = '',
          disconnect = '',
        },
      },
      setupCommands = {
        {
          text = "-enable-pretty-printing",
          description =  "enable pretty printing",
          ignoreFailures = false,
        },
      },
    }

    require("nvim-dap-virtual-text").setup {
      enabled = true,                        -- enable this plugin (the default)
      enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
      highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = true,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true,               -- show stop reason when stopped for exceptions
      commented = false,                     -- prefix virtual text with comment string
      only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
      all_references = true,                -- show virtual text on all all references of the variable (not only definitions)
      clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
      virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

      -- experimental features:
      all_frames = true,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
      virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
      -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    }

    -- Automatically set relative number in DAP UI windows
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "dapui_scopes", "dapui_breakpoints", "dapui_stacks", "dapui_watches", "dap-repl" },
      callback = function()
        vim.wo.relativenumber = true
        vim.wo.number = true
        vim.wo.signcolumn = 'yes'
      end,
    })

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
    and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    -- dap.adapters.lldb = {
    --   type = 'server',
    --   port = 50000,
    --   host = "192.168.0.157",
    -- }
    --
    -- dap.configurations.cpp = {
    --   {
    --     name = "Attach to codelldb server",
    --     type = "lldb",
    --     request = "launch",
    --     program = "/mnt/c/dev/CPlusPlus/CircleLoopAlgorithm/build/Windows/Debug/CircleLoopAlgorithm.exe",
    --     cwd = "${workspaceFolder}",
    --     stopOnEntry = false,
    --     args = {},
    --   }
    -- }
    -- -- dap.adapters.cppdbg = {
    --   id = 'cppdbg',
    --   type = 'executable',
    --   command = 'cmd.exe',
    --   args = {
    --     '/c',
    --     'C:\\Users\\Let\'sBlend\\.vscode\\extensions\\ms-vscode.cpptools-1.24.5-win32-x64\\debugAdapters\\bin\\OpenDebugAD7.exe',
    --   },
    -- }
    --
    -- dap.configurations.cpp = {
    --   {
    --     name = "Attach to gdbserver",
    --     type = "cppdbg",
    --     request = "launch",
    --     program = "C:\\dev\\CPlusPlus\\CircleLoopAlgorithm\\build\\Windows\\Debug\\CircleLoopAlgorithm.exe",
    --     cwd = "C:\\dev\\CPlusPlus\\CircleLoopAlgorithm",
    --     miDebuggerServerAddress = "192.168.0.157:50000",
    --     miDebuggerPath = "C:\\MinGW\\bin\\gdb.exe",
    --     stopAtEntry = false,
    --     setupCommands = {
    --       {
    --         text = "-enable-pretty-printing",
    --         description =  "enable pretty printing",
    --         ignoreFailures = false
    --       }
    --     },
    --     sourceMap = {
    --       ["C:/dev/CPlusPlus/CircleLoopAlgorithm"] = "/mnt/c/dev/CPlusPlus/CircleLoopAlgorithm"
    --     },
    --   }
    -- }

    -- dap.adapters.cpp_windows = {
    --   type = 'server',
    --   port = 4711,
    --   host = '127.0.0.1',  -- ← Key change for WSL2
    --   -- executable = {
    --   --   command = 'C:\\Users\\Let\'sBlend\\.vscode\\extensions\\vadimcn.vscode-lldb-1.11.4\\adapter\\codelldb.exe',
    --   --   args = { '--port', '${port}' },
    --   -- }
    -- }
    --
    -- dap.configurations.cpp = {
    --   {
    --     name = 'Debug Windows EXE',
    --     type = 'codelldb',
    --     request = 'launch',
    --     program = '/mnt/c/dev/CPlusPlus/CircleLoopAlgorithm/build/Windows/Debug/CircleLoopAlgorithm.exe',
    --     cwd = '${workspaceFolder}',
    --     stopOnEntry = true,
    --   },
    -- }

    -- dap.configurations.c = dap.configurations.cpp


    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
