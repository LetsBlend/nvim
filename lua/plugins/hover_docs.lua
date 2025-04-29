local M = {}

local function is_executable(cmd)
  return vim.fn.executable(cmd) == 1
end

function M.hover_to_glow()
  if not is_executable("glow") then
    vim.notify("Glow is not installed!", vim.log.levels.ERROR)
    return
  end

  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result, ctx, config)
    if err or not result or not result.contents then
      vim.notify("No hover info available", vim.log.levels.WARN)
      return
    end

    local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    -- markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then
      vim.notify("Empty hover contents", vim.log.levels.WARN)
      return
    end

    -- Save to temp file
    local tmpfile = vim.fn.tempname() .. ".md"
    vim.fn.writefile(markdown_lines, tmpfile)

    print(tmpfile)
    vim.cmd('Glow ' .. tmpfile)
  end)
end

return M
