local M = {}

local telescope = require('telescope.builtin')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

local templates = {
  cpp = require 'langs.templates.cpp_template',
  rust = '',
  java = '',
  csharp = '',
  lua = '',
}

local language_dirs = {
  cpp = '/mnt/c/dev/CPlusPlus/',
  rust = '/mnt/c/dev/Rust/',
  java = '/mnt/c/dev/Java/',
  csharp = '/mnt/c/dev/CSharp/',
  lua = '/mnt/c/dev/Lua/',
}

local function create_project(lang, name)
  local base_path = vim.fn.expand(language_dirs[lang])
  local project_path = base_path .. name

  if vim.fn.isdirectory(project_path) == 1 then
    vim.notify('Project already exists: ' .. project_path, vim.log.levels.WARN)
    return
  end

  templates[lang](project_path)
end

function M.new_project()
  local langs = vim.tbl_keys(language_dirs)

  pickers.new({}, {
    prompt_title = 'Select language',
    finder = finders.new_table {
      results = langs,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local function on_select()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local lang = selection[1]

        vim.ui.input({ prompt = 'Project name: ' }, function(name)
          if not name or name == '' then return end
          create_project(lang, name)
        end)
      end

      map('i', '<CR>', on_select)
      map('n', '<CR>', on_select)
      return true
    end,
  }):find()
end

return M
