local M = {}

function M.create_project(project_path)
  vim.fn.mkdir(project_path .. '/src', 'p')
  vim.fn.writefile({
    [[cmake_minimum_required(VERSION 3.10)]],
    [[project(]] .. vim.fn.fnamemodify(project_path, ':t') .. [[)]],
    [[]],
    [[set(CMAKE_CXX_STANDARD 20)]],
    [[]],
    [[# Disable ALL automatic dependency tracking]],
    [[set(CMAKE_DEPENDS_USE_COMPILER FALSE)]],
    [[]],
    [[# Detect target OS (default: host OS)]],
    [[if(NOT DEFINED TARGET_OS)]],
    [[    if(CMAKE_SYSTEM_NAME STREQUAL "Windows")]],
    [[        set(TARGET_OS "Windows")]],
    [[    elseif(APPLE)]],
    [[        set(TARGET_OS "MacOS")]],
    [[    else()]],
    [[        set(TARGET_OS "Linux")]],
    [[    endif()]],
    [[endif()]],
    [[]],
    [[# Cross-compilation setup]],
    [[if(TARGET_OS STREQUAL "Windows")]],
    [[    # Cross-compilation setup]],
    [[    set(CMAKE_SYSTEM_NAME Windows)]],
    [[    set(CMAKE_SYSTEM_PROCESSOR x86_64)]],

    [[    # Use MinGW compilers]],
    [[    set(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)]],
    [[    set(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)]],
    [[    ]],
    [[]],
    [[    set(CMAKE_EXE_LINKER_FLAGS "-static")]],
    [[elseif(TARGET_OS STREQUAL "MacOS")]],
    [[    message(WARNING "MacOs is currently not supported!")]],
    [[    message(WARNING "Building Linux binaries instead. (Just get a better operating system anyway lol)")]],
    [[endif()]],
    [[add_executable(${PROJECT_NAME} src/main.cpp)]],
  }, project_path .. "/CMakeLists.txt")

  vim.fn.writefile({
    [[#include <iostream>]],
    [[]],
    [[int main()]],
    [[{]],
    [[    std::cout << "Hello World\n";]],
    [[}]],
  }, project_path .. "/src/main.cpp")

  vim.cmd('cd ' .. project_path)
  vim.cmd('e src/main.cpp')
end

function M.create_class(file_path, file_name)
  print(file_path .. '   ' .. file_name)
  -- Creates a class in the case of c++
  vim.fn.writefile({
    [[class ]] ..file_name .. [[ {]],
    [[    public:]],
    [[        ]] .. file_name .. [[() = default;]],
    [[        ~]] .. file_name .. [[() = default;]],
    [[};]],
  }, file_path .. file_name .. '.h')

  vim.fn.writefile({
    [[#include "]] .. file_name .. [[.h"]],
  }, file_path .. file_name .. '.cpp')

end

return M
