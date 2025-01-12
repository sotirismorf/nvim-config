-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'markdown', 'tex', 'text' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'el,en'
    vim.opt_local.textwidth = 80
  end,
})
