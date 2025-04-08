-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Must set leader before plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

require 'options'
require 'keymaps'
require 'autocommands'

-- Setup lazy.nvim
require('lazy').setup {

  require 'plugins/conform',
  require 'plugins/gitsigns',
  require 'plugins/blink',
  require 'plugins/neo-tree',
  require 'plugins/telescope',
  require 'plugins/treesitter',
  require 'plugins/which-key',

  -- collection of many useful plugins
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.indentscope').setup()
      require('mini.pairs').setup()
      require('mini.notify').setup()
      require('mini.statusline').setup { section_location = '%2l:%-2v v' }

      require('mini.statusline').section_location = function()
        return '%2l:%-2v v'
      end
    end,
  },

  { 'tpope/vim-sleuth' }, -- Detect tabstop and shiftwidth automatically
  { 'christoomey/vim-tmux-navigator' }, -- TMUX integration
  { 'pipoprods/nvm.nvim', config = true },
  { 'brianaung/compl.nvim' },
  { 'catgoose/nvim-colorizer.lua', event = 'BufReadPre', opts = { user_default_options = { names = false } } },
  { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true },
  { 'williamboman/mason.nvim', config = true },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' } },
}

vim.api.nvim_command 'colorscheme gruvbox'

require 'lsp'
