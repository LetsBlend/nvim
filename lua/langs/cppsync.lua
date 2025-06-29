-- cppsync.lua (fixed get_node_text_compat)

local M = {}
local api = vim.api
local Path = require('plenary.path')

-- Extract text manually for compatibility and safety
local function get_node_text_compat(node, bufnr)
  if not node or type(node.range) ~= "function" then
    return ""
  end
  local start_row, start_col, end_row, end_col = node:range()
  local lines = api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
  if #lines == 0 then return '' end
  lines[1] = lines[1]:sub(start_col + 1)
  lines[#lines] = lines[#lines]:sub(1, end_col)
  return table.concat(lines, '\n')
end

-- Detect function declarations in header files
function M.get_function_declarations(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, 'cpp')
  local tree = parser:parse()[1]
  local root = tree:root()

local query = [[
  (function_declarator) @func_decl
]]

local parsed_query = vim.treesitter.query.parse('cpp', query)
local declarations = {}

for _, match, _ in parsed_query:iter_matches(root, bufnr, 0, -1) do
  local name_node = match[1]
  local param_node = match[2]
  local name = get_node_text_compat(name_node, bufnr)
  local params = get_node_text_compat(param_node, bufnr)
  print("Function name:", name)
  print("Parameters:", params)
  table.insert(declarations, { name = name, params = params })
end

return declarations
end

-- Generate definition stub for a declaration
function M.generate_definition(decl, class_name)
  local scope = ""
  if class_name and #class_name > 0 then
    scope = class_name .. "::"
  end
  return string.format("void %s%s%s {\n    // TODO: implement\n}\n", scope, decl.name, decl.params)
end

-- Append definition to .cpp file
function M.append_to_cpp(cpp_path, definition)
  local cpp_file = Path:new(cpp_path)
  cpp_file:write("\n" .. definition, "a")
end

-- Main function to sync from header to source
function M.sync()
  local bufnr = api.nvim_get_current_buf()
  local filename = api.nvim_buf_get_name(bufnr)
  if not filename:match("%.h$") then
    print("Not a header file")
    return
  end

  local declarations = M.get_function_declarations(bufnr)
  local cpp_path = filename:gsub("%.h$", ".cpp")

  if not Path:new(cpp_path):exists() then
    print("Corresponding .cpp file not found")
    return
  end

  for _, decl in ipairs(declarations) do
    local stub = M.generate_definition(decl)
    M.append_to_cpp(cpp_path, stub)
  end

  print("Synced declarations to " .. cpp_path)
end

return M
