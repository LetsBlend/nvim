local M = {}

------------------------------------------------------------------------------
--- C++ Build System
------------------------------------------------------------------------------
local src_dir = "src"
local build_dir = "build"

local function get_project_name()
end

M.current_build_systems = 'gradle'
M.build_systems = {
}

function M.cycle_target_platforms()
  print("Java can run on any platform!")
end

--- Helper function to replace placeholders
local function expand_cmd(cmd)
  if type(cmd) == 'function' then
    return cmd()
  end
  return cmd:gsub('%%', vim.fn.expand '%'):gsub('%%<', vim.fn.expand '%:r')
end


function M.configure(mode)
  print("Nothing to configure in Java!")
end


function M.build(mode)
  require('java').build.build_workspace()
end

local app_term

function M.run(mode)
  local Terminal = require("toggleterm.terminal").Terminal

  if not app_term then
    app_term = Terminal:new({
      direction = "horizontal",
      hidden = true,
    })
  app_term:open()
  end

  -- Now send the new command into the terminal
  app_term:send("clear", false)
  local cmd = "./gradlew run"
  app_term:send(cmd, true) -- the 'true' means send <CR> after
end

function M.build_and_run(mode)
  M.build(mode)
  M.run(mode)
end

function M.keybinds()

end

return M
