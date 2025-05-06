local M = {}

------------------------------------------------------------------------------
--- C++ Build System
------------------------------------------------------------------------------
local function get_project_name()
  local cmake_lists = io.open('CMakeLists.txt', 'r')
  if not cmake_lists then
    vim.notify('Couldn\'t find CMakeLists.txt file', vim.log.levels.ERROR)
    return nil
  end

  for line in cmake_lists:lines() do
    local project_name = line:match("project%(([%w_]+)%)")
    if project_name then
      cmake_lists:close()
      return project_name
    end
  end
  vim.notify('Couldn\'t find project name in the CMakeLists.txt file', vim.log.levels.ERROR)
  cmake_lists:close()
  return nil
end

M.target_platform = 'Linux'
M.current_build_systems = 'cmake'
M.build_systems = {
  direct = {
    debug = {
      build = 'clang++ -g -Wall -Wextra -std=c++20 % -o %<',
      run = './%<',
    },
    release = {
      build = 'clang++ -O2 -Wall -Wextra -std=c++20 % -o %<',
      run = './%<',
    },
  },
  cmake = {
    debug = {
      configure = function ()
        return 'cmake -B ./build/' .. M.target_platform .. '/Debug -DCMAKE_BUILD_TYPE=Debug'
      end,
      build = function ()
        return 'cmake --build build/' .. M.target_platform .. '/Debug && find build -type f -exec touch {} +'
      end,
      run = function()
        local path = './build/' .. M.target_platform .. '/Debug/' .. get_project_name()
        if M.target_platform == 'Windows' then
          path = path .. '.exe'
        end
        return path
      end,
    },
    release = {
      configure = function ()
        return 'cmake -B build/' .. M.target_platform .. '/Release -DCMAKE_BUILD_TYPE=Release'
      end,
      build = function()
        return 'cmake --build build/' .. M.target_platform .. '/Release --config Release && find build -type f -exec touch {} +'
      end,
      run = function()
        local path = './build/' .. M.target_platform .. '/Release/' .. get_project_name()
        if M.target_platform == 'Windows' then
          path = path .. '.exe'
        end
        return path
      end,
    },
  },
}

function M.cycle_target_platforms()
  if M.target_platform == 'Windows' then
    M.target_platform = 'Linux'
  elseif M.target_platform == 'Linux' then
    M.target_platform = 'Windows'
  end

  vim.notify('Switched target platform to ' .. M.target_platform, vim.log.levels.INFO)
end

--- Helper function to replace placeholders
local function expand_cmd(cmd)
  if type(cmd) == 'function' then
    return cmd()
  end
  return cmd:gsub('%%', vim.fn.expand '%'):gsub('%%<', vim.fn.expand '%:r')
end


-- Function to toggle between build systems
function toggle_build_systems()
  if M.current_build_systems == 'direct' then
    M.current_build_systems = 'cmake'
    vim.notify('Switched to Cmake build system', vim.log.levels.INFO)
  else
    M.current_build_systems = 'direct'
    vim.notify('Switched to Direct build system', vim.log.levels.INFO)
  end
end

function M.configure(mode)
  if M.current_build_systems ~= 'cmake' then
    return
  end

  local config = M.build_systems[M.current_build_systems][mode or 'debug']
  if not config then
    return
  end
  vim.cmd('! ' .. expand_cmd(config.configure) .. ' -DTARGET_OS=' .. M.target_platform)
end


function M.build(mode)
  local toggleterm = require 'toggle_term'

  toggleterm.open()
  toggleterm.send('clear', false)
  local config = M.build_systems[M.current_build_systems][mode or "debug"]
  local cmd = expand_cmd(config.build) -- Your expanded run command (e.g., "./build/Debug/myapp")
  toggleterm.send(config.build())
end

function M.run(mode)
  local toggleterm = require 'toggle_term'

  toggleterm.open()
  toggleterm.send('clear', false)
  local config = M.build_systems[M.current_build_systems][mode or "debug"]
  local cmd = expand_cmd(config.run) -- Your expanded run command (e.g., "./build/Debug/myapp")
  toggleterm.send(config.run())
end

function M.build_and_run(mode)
  M.build(mode)
  M.run(mode)
end

------------------------------------------------------------------------------
--- C++ Header/Source Switching
------------------------------------------------------------------------------
local headers = { ".h", ".hpp", ".hh" }
local sources = { ".cpp", ".cc", ".cxx", ".c" }

local function get_extension(filename)
  return filename:match("^.+(%..+)$")
end

local function file_exists(path)
  local f = io.open(path, "r")
  if f then f:close() return true end
  return false
end

function M.switch_header_source()
  local current = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(current, ":h")
  local name = vim.fn.fnamemodify(current, ":t:r")
  local ext = get_extension(current)

  local candidates = {}

  if vim.tbl_contains(headers, ext) then
    -- We're in a header → look for source
    for _, s_ext in ipairs(sources) do
      table.insert(candidates, dir .. "/" .. name .. s_ext)
    end
  elseif vim.tbl_contains(sources, ext) then
    -- We're in a source → look for header
    for _, h_ext in ipairs(headers) do
      table.insert(candidates, dir .. "/" .. name .. h_ext)
    end
  else
    vim.notify("Not a recognized C/C++ file", vim.log.levels.WARN)
    return
  end

  for _, candidate in ipairs(candidates) do
    if file_exists(candidate) then
      vim.cmd("edit " .. vim.fn.fnameescape(candidate))
      return
    end
  end

  vim.notify("No corresponding header/source found.", vim.log.levels.WARN)
end

function M.keybinds()
  -- TODO: Implement header and source syncing.
  -- vim.keymap.set('n', '<leader>us', function() require('langs.cppsync').sync() end, { desc = "Sync header to source" })

  vim.keymap.set("n", "<leader>h", function()
    M.switch_header_source()
  end, { desc = "[S]witch Header/Source" })
end

return M
