local cmd = vim.cmd
local api = vim.api

--- plugins
require "paq" {
    'savq/paq-nvim';

    'tpope/vim-surround';
    'tpope/vim-commentary';
    'jiangmiao/auto-pairs';
    'justinmk/vim-sneak';
    'junegunn/vim-slash';
    'RRethy/vim-illuminate';
    'nvim-lua/popup.nvim';
    'nvim-lua/plenary.nvim';
    'tami5/sql.nvim';
    'nvim-telescope/telescope.nvim';
    {'nvim-telescope/telescope-fzy-native.nvim', hook='git submodule update --init --recursive' };
    'nvim-telescope/telescope-frecency.nvim';
    'nvim-telescope/telescope-project.nvim';
    -- 'shoumodip/ido.nvim';
    'neovim/nvim-lspconfig';
    -- 'glepnir/lspsaga.nvim';
    -- 'kosayoda/nvim-lightbulb';
    {'nvim-treesitter/nvim-treesitter', branch='0.5-compat'};
    'rafamadriz/friendly-snippets';
    'hrsh7th/nvim-compe';
    'hrsh7th/vim-vsnip';
    'hrsh7th/vim-vsnip-integ';
    'mg979/vim-visual-multi';
    'mattn/emmet-vim';
    'sheerun/vim-polyglot';
    -- 'neovimhaskell/haskell-vim';
    'vim-pandoc/vim-pandoc';
    'vim-pandoc/vim-pandoc-syntax';
    'rhysd/git-messenger.vim';
    -- 'ttys3/nvim-blamer.lua';
    -- 'norcalli/nvim-colorizer.lua';
    'Th3Whit3Wolf/one-nvim';
    -- 'bluz71/vim-moonfly-colors';
}

vim.opt.spell = false
vim.opt.title = true
vim.opt.titlestring = '%f'
vim.opt.list = true
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.foldenable = false
vim.opt.autochdir = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.breakindent = true
vim.opt.confirm = true
vim.opt.termguicolors = true
vim.opt.hidden = true
vim.opt.signcolumn = 'no'
vim.opt.pumheight = 5
vim.opt.scrolloff = 7
vim.opt.cinoptions = {'N-s', 'g0', '+0'}
vim.opt.pastetoggle = '<F6>'
vim.opt.completeopt = {'menuone', 'noselect'}
vim.opt.wildignore = {'*.so', '*.swp', '*.zip', '*.o', '*.tar*'}
vim.opt.shortmess:append('caI')
vim.opt.clipboard = 'unnamedplus'
vim.opt.listchars = [[tab:  ]]
vim.opt.fillchars = [[eob: ]]

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
vim.opt.inccommand = 'nosplit'

-- cmd 'colorscheme default'
cmd 'colorscheme one-nvim'

--- variables
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = '/usr/bin/python'
vim.g.netrw_dirhistmax = 0
vim.g.mapleader = ','

--- highlighting
cmd 'highlight Search NONE'
cmd 'highlight QuickFixLine NONE'
cmd 'highlight TrailingWhitespace ctermbg=red guibg=red'
cmd [[match TrailingWhitespace /\s\+\%#\@<!$/]]

--- autocommands
cmd 'autocmd TextYankPost * lua vim.highlight.on_yank {higroup = "IncSearch", timeout = 1000, on_visual = false}'
cmd [[autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s]]
cmd 'autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o'

--- commands
cmd [[command DeleteTrailingWhitespace :%s/\s\+$//e]]

--- functions
local map_default_opts = {noremap = true, silent = true}

local function map(mode, lhs, rhs, opts)
    local options = opts or map_default_opts
    api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function buf_map(mode, lhs, rhs)
    api.nvim_buf_set_keymap(0, mode, lhs, rhs, map_default_opts)
end

local function find_git_root()
    local handle = io.popen('git rev-parse --show-toplevel 2> /dev/null')
    local result = handle:read("*a")
    handle:close()

    return string.sub(result, 1, string.len(result) - 1)
end

--- mappings
map('', 'r', 'j')
map('', 'j', 'r')
map('', 't', 'k')
map('', 'k', 't')
map('n', 'Y', 'y$')
map('i', 'hh', '<esc>')
map('x', '<', '<gv')
map('x', '>', '>gv')
map('n', 'gel', ':lopen<CR>')
map('n', '<leader>i', ':e ~/.config/nvim/init.lua<CR>')
map('t', '<esc>', [[<C-\><C-n>]])
map('n', '<cr>', [[&buftype ==# 'quickfix' ? "\<cr>" : "o<esc>"]], {expr = true})
map('i', '<cr>', [[pumvisible() ? compe#confirm('<cr>') : "\<cr>"]], {expr = true})
map('n', 'gp', ':bp<cr>')
map('n', 'gn', ':bn<cr>')

--- treesitter
require'nvim-treesitter.configs'.setup {
    -- ensure_installed = {"cpp", "lua", "rust", "go"},
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
}

--- telescope
local telescope = require('telescope')
telescope.setup()
telescope.load_extension('fzy_native')
telescope.load_extension('frecency')
telescope.load_extension('project')
map('n', '<C-F>', '<cmd>Telescope git_files<cr>')
map('n', '<C-P>',
    "<cmd>lua require'telescope'.extensions.project.project{ change_dir = true }<cr>")
map('n', '<C-B>', '<cmd>Telescope buffers<cr>')
map('n', '<leader>gr', [[<cmd>lua require('telescope.builtin').live_grep{ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] }<cr>]])

--- compe
require'compe'.setup {
    min_length = 1,
  
    source = {
        path = true,
        buffer = true,
        vsnip = true,
        nvim_lsp = true,
        nvim_lua = true,
        treesitter = true,
    },
}
map('i', '<C-Space>', 'compe#complete()', {expr = true, silent = true})

-- vsnip
map('i', '<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], {expr = true, silent = true})
map('i', '<Tab>', [[vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>']], {expr = true, silent = true})
map('i', '<S-Tab>', [[snip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>']], {expr = true, silent = true})

--- colorizer
-- require'colorizer'.setup({ css = { rgb_fn = true } })

--- lsp
local nvim_lsp = require'lspconfig'
local illuminate = require'illuminate'

-- diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- virtual_text = false,
        signs = false,
        update_in_insert = false
    }
)

-- highlighting
cmd [[ highlight def link LspReferenceText CursorLine ]]
cmd [[ highlight def link LspReferenceWrite CursorLine ]]
cmd [[ highlight def link LspReferenceRead CursorLine ]]

-- language servers
function lsp_maps()
    buf_map('n', 'K', ':lua vim.lsp.buf.hover()<CR>')
    buf_map('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
    buf_map('n', '<leader>f', ':lua vim.lsp.buf.formatting()<CR>')
    buf_map('n', '<leader>r', ':lua vim.lsp.buf.rename()<CR>')
    buf_map('n', '<leader>a', ':lua vim.lsp.buf.code_action()<CR>')
    buf_map('n', '<leader>d', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    buf_map('n', 'gen', ':lua vim.lsp.diagnostic.goto_next()<CR>')
    buf_map('n', 'gep', ':lua vim.lsp.diagnostic.goto_prev()<CR>')
    buf_map('n', 'gel', ':lua vim.lsp.diagnostic.set_loclist()<CR>')

    cmd [[setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
end

local function lsp_on_attach(client)
    illuminate.on_attach(client)
    lsp_maps()
end

nvim_lsp.clangd.setup {
    on_attach = lsp_on_attach,
}

-- TODO format on save
nvim_lsp.gopls.setup {
    settings = {
        gopls = {
            analyses = {
                unreachable = true,
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
    on_attach = lsp_on_attach,
}

nvim_lsp.rust_analyzer.setup {
    on_attach = lsp_on_attach,
}

nvim_lsp.texlab.setup {
    on_attach = lsp_on_attach,
}

nvim_lsp.tsserver.setup {
    on_attach = lsp_on_attach,
}

nvim_lsp.sumneko_lua.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            runtime = {
                version = "LuaJIT",
            },
        },
    },
    on_attach = lsp_on_attach,
}

nvim_lsp.hls.setup{
    on_attach = lsp_on_attach,
}

--- slash
map('n', '<plug>(slash-after)', 'zz')

--- polyglot
vim.g.vim_markdown_folding_disabled = 1
vim.g.cpp_class_scope_highlight = 1
vim.g.cpp_member_variable_highlight = 1
vim.g.cpp_class_decl_highlight = 1

--- emmet
vim.g.user_emmet_leader_key = '<C-Z>'
vim.g.user_emmet_install_global = 0
cmd [[
augroup emmet
autocmd FileType html,css EmmetInstall
augroup END
]]

--- illuminate
vim.g.Illuminate_delay = 500
vim.g.Illuminate_highlightUnderCursor = 0
-- map('n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>')
-- map('n', '<a-p>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>')

--- git-messenger
map('n', 'gm', ':GitMessenger<CR>')
