local M = {}

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

M.target_platform = 'Windows'
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
      configure = 'cmake -B build/' .. M.target_platform .. '/Debug -DCMAKE_BUILD_TYPE=Debug',
      build = 'cmake --build build/' .. M.target_platform .. '/Debug && find build -type f -exec touch {} +',
      run = function()
        local path = './build/' .. M.target_platform .. '/Debug/' .. get_project_name()
        if M.target_platform == 'Windows' then
          path = path .. '.exe'
        end
        return path
      end,
    },
    release = {
      configure = 'cmake -B build/' .. M.target_platform .. '/Release -DCMAKE_BUILD_TYPE=Release',
      build = 'cmake --build build/' .. M.target_platform .. '/Release --config Release && find build -type f -exec touch {} +',
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

-- TODO: Universaly store target_OS between sessions
-- (not super important to implement but would be nice i guess)
--
-- function M.save_data(data)
--   local file = file or vim.fn.stdpath("config") .. "/lua/lang/cpp.json"
--   local serialized = vim.json.encode(data)
--   vim.fn.writefile({serialized}, file)
-- end
--
-- function M.load_data(default_data)
--   local file = file or vim.fn.stdpath("config") .. "/lua/lang/cpp.json"
--   if vim.fn.filereadable(file) == 1 then
--     local data = vim.json.decode(vim.fn.readfile(file)[1])
--     return data
--   end
--   local serialzed = vim.json.encode(default_data)
--   vim.fn.writefile({serialzed}, file)
--   return default_data
-- end

function M.cycle_target_platforms()
  if M.target_platform == 'Windows' then
    M.target_platform = 'Linux'
  elseif M.target_platform == 'Linux' then
    M.target_platform = 'MacOS'
  elseif M.target_platform == 'MacOS' then
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
  local config = M.build_systems[M.current_build_systems][mode or 'debug']
  if not config then
    return
  end
  M.configure(mode)
  vim.cmd('! ' .. expand_cmd(config.build))
end

function M.run(mode)
  local config = M.build_systems[M.current_build_systems][mode or 'debug']
  if not config then
    return
  end
  vim.cmd('! ' .. expand_cmd(config.run))
end

function M.build_and_run(mode)
  M.build(mode)
  M.run(mode)
end

return M
