local cmd = vim.cmd
local api = vim.api

--- plugins
cmd 'packadd paq-nvim'
local paq = require'paq-nvim'.paq

paq 'savq/paq-nvim'
paq 'tpope/vim-surround'
paq 'tpope/vim-commentary'
paq 'jiangmiao/auto-pairs'
paq 'justinmk/vim-sneak'
paq 'junegunn/vim-slash'
paq 'RRethy/vim-illuminate'
paq 'nvim-lua/popup.nvim'
paq 'nvim-lua/plenary.nvim'
paq 'nvim-telescope/telescope.nvim'
paq {'nvim-telescope/telescope-fzy-native.nvim', hook='git submodule update --init --recursive' }
-- 'shoumodip/ido.nvim'
paq 'neovim/nvim-lspconfig'
-- paq 'glepnir/lspsaga.nvim'
-- paq 'kosayoda/nvim-lightbulb'
paq 'nvim-treesitter/nvim-treesitter'
paq 'hrsh7th/nvim-compe'
paq 'hrsh7th/vim-vsnip'
-- paq 'hrsh7th/vim-vsnip-integ'
paq 'mg979/vim-visual-multi'
paq 'mattn/emmet-vim'
paq 'sheerun/vim-polyglot'
paq 'neovimhaskell/haskell-vim'
paq 'vim-pandoc/vim-pandoc'
paq 'vim-pandoc/vim-pandoc-syntax'
paq 'rhysd/git-messenger.vim'
-- paq 'ttys3/nvim-blamer.lua'
-- paq 'norcalli/nvim-colorizer.lua'
paq 'tomasiser/vim-code-dark'
paq 'Th3Whit3Wolf/one-nvim'
paq 'bluz71/vim-moonfly-colors'

--- options
-- local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
-- local function opt(scope, key, value)
--     scopes[scope][key] = value
--     if scope ~= 'o' then scopes['o'][key] = value end
-- end

vim.o.spell = false
vim.o.title = true
vim.o.titlestring = '%f'
vim.o.list = true
vim.wo.list = true
vim.o.showcmd = false
vim.o.showmode = false
vim.o.foldenable = false
vim.wo.foldenable = false
vim.o.autochdir = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.breakindent = true
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.hidden = true
vim.o.signcolumn = 'no'
vim.wo.signcolumn = 'no'
vim.o.pumheight = 5
vim.o.scrolloff = 7
vim.o.cinoptions = 'N-s,g0,+0'
vim.o.pastetoggle = '<F6>'
vim.o.completeopt = 'menu,menuone,noselect,noinsert'
vim.o.wildignore = '*.so,*.swp,*.zip,*.o,*.tar*'
vim.o.shortmess = vim.o.shortmess .. 'caI'
vim.o.clipboard = vim.o.clipboard .. 'unnamedplus'
vim.o.listchars = [[tab:  ]]
vim.o.fillchars = [[eob: ]]

vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.softtabstop = 4
vim.bo.softtabstop = 4
vim.o.expandtab = true
vim.bo.expandtab = true

vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wildignorecase = true
vim.o.inccommand = 'nosplit'

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

--- treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = {"cpp", "lua", "rust", "typescript", "go"},
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
require('telescope').setup()
require('telescope').load_extension('fzy_native')
map('n', '<C-P>', '<cmd>Telescope git_files<cr>')
map('n', '<C-B>', '<cmd>Telescope buffers<cr>')

--- compe
require'compe'.setup {
    min_length = 2,
  
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
cmd [[ hi def link LspReferenceText CursorLine ]]
cmd [[ hi def link LspReferenceWrite CursorLine ]]
cmd [[ hi def link LspReferenceRead CursorLine ]]

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
    init_options = {
        haskell = {
            hlintOn = true,
            formattingProvider = "ormolu",
            completionSnippetsOn = true,
            formatOnImportOn = true,
        },
    },
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
