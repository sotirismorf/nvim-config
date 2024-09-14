-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<Leader>lj', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<Leader>lk', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })

-- Toggle comments (built-in since v0.10 https://github.com/neovim/neovim/pull/28176)
vim.keymap.set('n', '<Leader>c', 'gcc', { desc = 'Toggle comment line', remap = true })
vim.keymap.set('v', '<Leader>c', 'gc', { desc = 'Toggle comment', remap = true })

-- Who even uses esc
vim.keymap.set('i', 'jj', '<ESC>')

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
