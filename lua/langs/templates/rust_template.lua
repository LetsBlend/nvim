local M = {}

function M.create_project(project_path)
  vim.fn.mkdir(project_path .. '/src', 'p')
  vim.fn.writefile({
    [[[package] ]],
    [[name = "]] .. vim.fn.fnamemodify(project_path, ':t') .. [["]],
    [[version = "0.1.0"]],
    [[edition = "2021"]],
    [[]],
    [[# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html]],

    [[[dependencies] ]],
  }, project_path .. "/Cargo.toml")

  vim.fn.writefile({
    [[fn main() {]],
    [[  println!("Hello, world!");]],
    [[}]],
  }, project_path .. "/src/main.rs")

  vim.cmd('cd ' .. project_path)
  vim.cmd('e src/main.rs')
end

function M.create_class(file_path, file_name)
  print('Rust doesn\'t have classes my G')
end

return M
