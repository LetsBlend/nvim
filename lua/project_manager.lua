local M = {}

local telescope = require('telescope.builtin')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

local templates = {
  cpp = require 'langs.templates.cpp_template',
  rust = require 'langs.templates.rust_template',
  java = require 'langs.templates.java_template',
  csharp = '',
  lua = '',
}

local language_dirs = {
  cpp = '~/00_usr/dev/cpp/',
  rust = '~/00_usr/dev/rust/',
  java = '~/00_usr/dev/java/',
  -- csharp = '/mnt/c/dev/CSharp/',
  -- lua = '/mnt/c/dev/Lua/',
}

function M.get_lsp_root()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.config.root_dir then
      return client.config.root_dir
    end
  end
  return nil
end

function M.get_project_language()
  local name_to_lang = {
    clangd = 'cpp',
    rust_analyzer = 'rust',
    jdtls = 'java',
    lua_ls = 'lua',
    omnisharp = 'csharp',
  }

  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    local name = name_to_lang[client.name]
    if name then
      return name
    end
  end
  return ""
end

print("LSP Language: " .. M.get_project_language())

local function create_project(lang, name)
  local base_path = vim.fn.expand(language_dirs[lang])
  local project_path = base_path .. name

  if vim.fn.isdirectory(project_path) == 1 then
    vim.notify('Project already exists: ' .. project_path, vim.log.levels.WARN)
    return
  end

  templates[lang].create_project(project_path)

  vim.fn.writefile({lang}, project_path .. '/.project')
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


function M.switch_projects()
  -- First ensure the projects extension is available
  local ok, _ = pcall(require, 'telescope._extensions.projects')
  if not ok then
    vim.notify("Telescope projects extension not available", vim.log.levels.ERROR)
    return
  end

  local action_state = require('telescope.actions.state')
  local actions = require('telescope.actions')

  local function open_in_new_nvim(prompt_bufnr)
    local selected = action_state.get_selected_entry()
    if not selected then return end

    actions.close(prompt_bufnr)

    vim.ui.input({
      prompt = "Close current Neovim instance? (Y/N): ",
      default = "Y"
    }, function(input)
      local term_cmd = 'wt.exe wsl -e bash -lic "cd ' .. selected.value .. '&& nvim"'
      if input == "Y" then
        print(term_cmd .. '/' .. 'build.gradle')
        if vim.fn.filereadable( selected.value .. '/' .. 'build.gradle') == 0 then
          -- vim.cmd('Telescope projects')
          vim.cmd('cd ' .. selected.value)
          local builtin = require 'telescope.builtin'
          builtin.find_files()
          return
        end
        vim.fn.system(term_cmd)
        vim.cmd("qa!")
      else
        vim.fn.system(term_cmd)
      end
    end)
  end

  require('telescope').extensions.projects.projects({
    attach_mappings = function(_, map)
      map('i', '<CR>', open_in_new_nvim)
      map('n', '<CR>', open_in_new_nvim)
      return true
    end
  })
end

function M.create_class(directory_path, file_name)
  local lang = M.get_project_language()
  templates[lang].create_class(directory_path, file_name)
end

return M
