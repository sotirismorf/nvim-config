vim.lsp.enable {
  'gopls',
  'templ',
  'tailwindcss',
  -- 'html',
  -- 'lua_ls',
  -- 'clangd',
  -- 'gopls',
  -- 'html',
  -- 'templ',
  -- 'htmx',
  -- 'deno',
}

vim.diagnostic.config { virtual_text = true }

vim.keymap.set('n', '<leader>ld', require('telescope.builtin').lsp_definitions, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', '<leader>lr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eferences' })
vim.keymap.set('n', '<Leader>lh', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
vim.keymap.set('n', '<Leader>lj', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<Leader>lk', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
