local M = {}

function M.create_project(project_path)
  vim.fn.mkdir(project_path .. '/src', 'p')
  vim.fn.writefile({
    [[cmake_minimum_required(VERSION 3.10)]],
    [[project(]] .. vim.fn.fnamemodify(project_path, ':t') .. [[)]],
  }, project_path .. "/CMakeLists.txt")

  local name = vim.fn.fnamemodify(project_path, ':t')
  vim.cmd('mvn archetype:generate -DgroupId=com.letsblend.' .. name .. '-DartifactId=' .. name .. '-DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false')
end

function M.create_class(file_path, file_name)
  print('Create class doesn\'t work on java yet')
end

return M
