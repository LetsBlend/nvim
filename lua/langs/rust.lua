local M = {}

------------------------------------------------------------------------------
--- C++ Build System
------------------------------------------------------------------------------
local function get_project_name()
end

M.target_platform = 'Linux'
M.current_build_systems = 'cargo'
M.build_systems = {
  cargo = {
    debug = {
      configure = 'cargo check',
      build = 'cargo build',
      run = ' cargo run',
    },
    release = {
      configure = 'cargo check --release',
      build = 'cargo build --release',
      run = 'cargo run --release',
    },
    test = {
      configure = 'cargo check --tests',
      build = 'cargo test --no-run',
      run = 'cargo test',
    },
    bench = {
      configure = 'cargo check --benches',
      build = 'cargo bench --no-run',
      run = 'cargo bench',
    },
  },
}

function M.cycle_target_platforms()
  vim.notify('Current setup can only compile to Linux')
end

--- Helper function to replace placeholders
local function expand_cmd(cmd)
  if type(cmd) == 'function' then
    return cmd()
  end
  return cmd:gsub('%%', vim.fn.expand '%'):gsub('%%<', vim.fn.expand '%:r')
end


function M.configure(mode)
end

function M.build(mode)
  local toggleterm = require 'toggle_term'
  local config = M.build_systems[M.current_build_systems][mode or 'debug']
  -- Handle different platforms if needed
  toggleterm.open()
  toggleterm.send('clear')
  toggleterm.send(config.build)
end

function M.run(mode)
  local toggleterm = require 'toggle_term'
  local config = M.build_systems[M.current_build_systems][mode or 'debug']
  -- Handle different platforms if needed
  toggleterm.open()
  toggleterm.send('clear')
  toggleterm.send(config.run)
end

function M.build_and_run(mode)
  M.build(mode)
  M.run(mode)
end

function M.keybinds()
end

return M
