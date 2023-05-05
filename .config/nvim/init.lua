vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.encoding = 'UTF-8'

-- nvimtree options
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- barbar options
vim.g.barbar_auto_setup = false
vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>s', '<cmd>write<cr>')
vim.keymap.set({ 'n', 'x' }, 'cp', '"+y')
vim.keymap.set({ 'n', 'x' }, 'cv', '"+p')
vim.keymap.set({ 'n', 'x' }, 'x', '"_x')
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('folke/tokyonight.nvim', { branch = 'main' })
Plug('romgrk/barbar.nvim')
Plug('akinsho/toggleterm.nvim', { tag = '*' })
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-vsnip')
Plug('hrsh7th/vim-vsnip')
Plug('preservim/tagbar')
Plug('nvim-lualine/lualine.nvim')
Plug('lukas-reineke/indent-blankline.nvim')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

vim.call('plug#end')

vim.keymap.set('n', '<leader>n', '<cmd>:NvimTreeToggle<cr>')
vim.keymap.set('n', '<leader>b', '<cmd>:NvimTreeFocus<cr>')
vim.keymap.set('n', '<leader>&', '<cmd>:BufferGoto 1<cr>')
vim.keymap.set('n', '<leader>é', '<cmd>:BufferGoto 2<cr>')
vim.keymap.set('n', '<leader>"', '<cmd>:BufferGoto 3<cr>')
vim.keymap.set('n', "<leader>'", '<cmd>:BufferGoto 4<cr>')
vim.keymap.set('n', '<leader>(', '<cmd>:BufferGoto 5<cr>')
vim.keymap.set('n', '<leader>-', '<cmd>:BufferGoto 6<cr>')
vim.keymap.set('n', '<leader>è', '<cmd>:BufferGoto 7<cr>')
vim.keymap.set('n', '<leader>_', '<cmd>:BufferGoto 8<cr>')
vim.keymap.set('n', '<leader>ç', '<cmd>:BufferGoto 9<cr>')
vim.keymap.set('n', '<leader>j', '<cmd>:ToggleTerm size=12 direction=horizontal<cr>')
vim.keymap.set('n', '<leader>w', '<cmd>:BufferClose<cr>')
vim.keymap.set('n', '<leader>²', '<cmd>:TagbarToggle<cr>')

vim.cmd[[colorscheme tokyonight-storm]]

-- indentblankline options
vim.cmd [[highlight ExtraWhitespace guibg=red]]
vim.cmd [[match ExtraWhitespace /\s\+$/]]
vim.cmd [[highlight IndentBlanklineContextChar guifg=#bf80ff gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextStart guisp=#bf80ff gui=underline]]

require("indent_blankline").setup {
    char = '▏',
    show_current_context = true,
    show_current_context_start = true
}

require("nvim-tree").setup {
    live_filter = {
        always_show_folders = false
    }
}

require("barbar").setup {
    sidebar_filetypes = {
        NvimTree = true
    }
}

local lualine = require("lualine")

local function get_current_tag()
    local symbol_type = vim.fn["tagbar#currenttagtype"]('%s', '')
    local tag_icon = ''
    local flag = 'f'
    if symbol_type == 'class' or symbol_type == 'struct' or symbol_type == 'union' then
        tag_icon = ''
    elseif symbol_type == 'enum' then
        tag_icon = ''
    elseif symbol_type == 'enumerator' or symbol_type == 'member' then
        tag_icon = ''
    elseif symbol_type == 'function' or symbol_type == 'prototype' then
        tag_icon = '󰊕'
        flag = 'pf'
    elseif symbol_type == 'namespace' then
        tag_icon = ''
    end
    local symbol_signature = vim.fn["tagbar#currenttag"]('%s', '', flag, 'scoped-stl')
    if tag_icon ~= '' then
        return string.format("%s %s", tag_icon, symbol_signature)
    else
        return ''
    end
end

lualine.setup {
    options = {
        theme = 'auto',
        globalstatus = true
    },
   sections = {
        lualine_a = {
            "mode"
        },
        lualine_b = {
            "branch"
        },
        lualine_c = {
            "filename", "diagnostics"
        },
        lualine_x = {
            "searchcount", "selectioncount", "filetype", "encoding", "fileformat"
        },
        lualine_y = {
            get_current_tag
        },
        lualine_z = {
            "os.date('%H:%M:%S')", "location", "progress"
        }
    }
}

require("toggleterm").setup()

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
  pattern = "NvimTree_*",
  callback = function()
    local layout = vim.api.nvim_call_function("winlayout", {})
    if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then vim.cmd("confirm quit") end
  end
})

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
  end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    }, {
    { name = 'buffer' },
  })
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local lsp_config = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lsp_config.clangd.setup {
  capabilities = capabilities,
  root_dir = lsp_config.util.root_pattern(
            '.clangd',
            '.clang-tidy',
            '.clang-format',
            'build/compile_commands.json',
            'compile_flags.txt',
            'configure.ac',
            '.git')
}

lsp_config.cmake.setup {
    capabilities = capabilities
}

vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

