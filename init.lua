-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' }, { out, 'WarningMsg' } }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Options
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.background = 'dark'
vim.opt.pumheight = 10
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.wrap = false
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.clipboard = 'unnamedplus'
vim.opt.confirm = true

-- Keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<Leader>c', 'gcc', { desc = 'Toggle comment line', remap = true })
vim.keymap.set('v', '<Leader>c', 'gc', { desc = 'Toggle comment', remap = true })
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics quickfix' })

-- Autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('filetype-options', { clear = true }),
  pattern = { 'markdown', 'tex', 'text' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'el,en'
    vim.opt_local.textwidth = 80
  end,
})

-- Plugins
require('lazy').setup {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>lf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      notify_no_formatters = false,
      format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'goimports' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        svelte = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      diff_opts = { internal = true },
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = require 'gitsigns'
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
        map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
        map('n', '<leader>hb', gs.blame_line, 'Blame line')
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Stage hunk')
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Reset hunk')
      end,
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
    cmd = 'Neotree',
    keys = { { '<leader>b', ':Neotree toggle<CR>', desc = 'NeoTree toggle', silent = true } },
    opts = {
      filesystem = {
        filtered_items = { never_show_by_pattern = { '**/*_templ.go' } },
        window = { mappings = { ['\\'] = 'close_window' } },
      },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      require('telescope').setup {
        defaults = { file_ignore_patterns = { '^LICENSE*', '^license*', '%_templ.go$' } },
        pickers = { buffers = { theme = 'dropdown', initial_mode = 'normal', previewer = false } },
        extensions = { ['ui-select'] = { require('telescope.themes').get_dropdown() } },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local b = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>f', b.find_files, { desc = '[f]ind file' })
      vim.keymap.set('n', '<leader>F', b.live_grep, { desc = '[F]ind word' })
      vim.keymap.set('n', '<leader>s', b.buffers, { desc = '[S]earch buffers' })
      vim.keymap.set('n', '<leader><leader>', b.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>th', b.help_tags, { desc = '[T]elescope [H]elp' })
      vim.keymap.set('n', '<leader>tk', b.keymaps, { desc = '[T]elescope [K]eymaps' })
      vim.keymap.set('n', '<leader>ts', b.builtin, { desc = '[T]elescope [S]elect' })
      vim.keymap.set('n', '<leader>tw', b.grep_string, { desc = '[T]elescope [W]ord' })
      vim.keymap.set('n', '<leader>td', b.diagnostics, { desc = '[T]elescope [D]iagnostics' })
      vim.keymap.set('n', '<leader>tr', b.resume, { desc = '[T]elescope [R]esume' })
      vim.keymap.set('n', '<leader>t.', b.oldfiles, { desc = '[T]elescope recent files' })
      vim.keymap.set('n', '<leader>tn', function()
        b.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[T]elescope [N]eovim files' })
      vim.keymap.set('n', '<leader>/', function()
        b.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
      end, { desc = '[/] Fuzzy search buffer' })
      vim.keymap.set('n', '<leader>t/', function()
        b.live_grep { grep_open_files = true }
      end, { desc = '[T]elescope [/] open files' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    lazy = false,
    config = function()
      -- stylua: ignore
      require('nvim-treesitter').install {
        'bash', 'go', 'diff', 'html', 'javascript', 'lua', 'luadoc',
        'typst', 'markdown', 'markdown_inline', 'css', 'query', 'svelte',
        'typescript', 'vim', 'vimdoc',
      }
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          if pcall(vim.treesitter.start) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      icons = { mappings = true, keys = {} },
      spec = {
        { '<leader>l', group = '[L]SP' },
        { '<leader>t', group = '[T]elescope' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'enter' },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = { draw = { columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind', gap = 1 } } } },
      },
      signature = { enabled = true },
    },
  },
  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup { search_method = 'cover_or_next' }
      require('mini.indentscope').setup {
        symbol = '│',
        options = { try_as_border = true },
      }
      require('mini.pairs').setup()
      require('mini.notify').setup()
      local statusline = require 'mini.statusline'
      statusline.setup()
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    'eero-lehtinen/oklch-color-picker.nvim',
    event = 'VeryLazy',
    version = '*',
    keys = {
      {
        '<leader>v',
        function()
          require('oklch-color-picker').pick_under_cursor()
        end,
        desc = 'Color pick under cursor',
      },
    },
    opts = {},
  },
  { 'MeanderingProgrammer/render-markdown.nvim', dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, opts = {} },
  { 'tpope/vim-sleuth' },
  { 'christoomey/vim-tmux-navigator' },
  { 'pipoprods/nvm.nvim', config = true },
  { 'neovim/nvim-lspconfig' },
  { 'windwp/nvim-ts-autotag', config = true },
  { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true },
  { 'nvim-pack/nvim-spectre', config = true },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'williamboman/mason.nvim', config = true },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = {
        'stylua',
        'python-lsp-server',
        'tailwindcss-language-server',
        'css-lsp',
        'bash-language-server',
        'goimports',
        'gopls',
        'prettier',
        'shfmt',
        'yaml-language-server',
        'svelte-language-server',
        'templ',
        'tinymist',
        'typescript-language-server',
      },
      auto_update = true,
    },
  },
}

vim.cmd.colorscheme 'gruvbox'

-- LSP
vim.lsp.enable {
  'gopls',
  'templ',
  'tinymist',
  'svelte',
  'ts_ls',
  'bashls',
  'tailwindcss',
  'cssls',
  'pylsp',
  'yamlls',
}

vim.diagnostic.config {
  severity_sort = true,
  update_in_insert = false,
  virtual_text = true,
  float = { border = 'rounded', source = 'if_many' },
  jump = { float = true },
}

-- Document highlight on cursor hold
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method 'textDocument/documentHighlight' then
      local group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        buffer = event.buf,
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end
  end,
})

vim.keymap.set('n', '<leader>lR', vim.lsp.buf.rename, { desc = '[R]ename' })
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code [A]ction' })
vim.keymap.set('n', '<leader>ld', require('telescope.builtin').lsp_definitions, { desc = '[D]efinition' })
vim.keymap.set('n', '<leader>lr', require('telescope.builtin').lsp_references, { desc = '[R]eferences' })
vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, { desc = '[H]over' })
vim.keymap.set('n', '<leader>lj', function()
  vim.diagnostic.jump { count = 1 }
end, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>lk', function()
  vim.diagnostic.jump { count = -1 }
end, { desc = 'Prev diagnostic' })
