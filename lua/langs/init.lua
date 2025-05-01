return {
  setup = function()
    local group = vim.api.nvim_create_augroup('LanguageBuilder', { clear = true })
    -- Add further languages to support here (don't forget to also create a file that manages building for that language)
    local languages = { 'cpp', 'java', 'rust' }

    for _, lang in ipairs(languages) do
      local ok, language = pcall(require, 'langs.' .. lang)
      if not ok then
        vim.notify('Failed to load language: ' .. lang, vim.log.levels.WARN)
        goto continue  -- Skip to next language if loading fails
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = lang,
        callback = function(args)
          local bufnr = args.buf  -- Get current buffer number

          vim.keymap.set('n', '<leader>to', function()
            language.cycle_target_platforms()
          end, {buffer = bufnr, desc = '[T]oggle target [O]perating Systems'})

          vim.keymap.set('n', '<leader>bd', function()
            language.build('debug')
          end, { buffer = bufnr, desc = '[B]uild [D]ebug' })

          vim.keymap.set('n', '<leader>br', function()
            language.build('release')
          end, { buffer = bufnr, desc = '[B]uild [R]elease' })

          vim.keymap.set('n', '<leader>rd', function()
            language.run('debug')
          end, { buffer = bufnr, desc = '[R]un [D]ebug' })

          vim.keymap.set('n', '<leader>rr', function()
            language.run('release')
          end, { buffer = bufnr, desc = '[R]un [R]elease' })

          vim.keymap.set('n', '<leader>ad', function()
            language.build_and_run('debug')
          end, { buffer = bufnr, desc = '[B]uild & [R]un [D]ebug' })

          vim.keymap.set('n', '<leader>ar', function()
            language.build_and_run('release')
          end, { buffer = bufnr, desc = '[B]uild and [R]un [R]elease' })

          language.keybinds()
        end,
      })
      ::continue::
    end
  end,
}
