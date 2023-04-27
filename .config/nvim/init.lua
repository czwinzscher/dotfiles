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

vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = '/usr/bin/python'
vim.g.netrw_dirhistmax = 0
vim.g.mapleader = ' '

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank {
            higroup = "IncSearch",
            timeout = 500,
            on_visual = false
        }
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"c", "cpp", "cs", "java"},
    callback = function()
        vim.cmd.setlocal([[commentstring=//\ %s]])
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        vim.cmd.setlocal([[formatoptions-=c formatoptions-=r formatoptions-=o]])
    end,
})

vim.cmd.command([[DeleteTrailingWhitespace :%s/\s\+$//e]])

local map_default_opts = {silent = true}

local function map(mode, lhs, rhs, opts)
    local options = opts or map_default_opts
    vim.keymap.set(mode, lhs, rhs, options)
end

local function buf_map(mode, lhs, rhs)
    map(mode, lhs, rhs, {buffer=true})
end

local function find_git_root()
    local handle = io.popen('git rev-parse --show-toplevel 2> /dev/null')
    local result = handle:read("*a")
    handle:close()

    local dir = string.sub(result, 1, string.len(result) - 1)
    if dir ~= '' then
        return dir
    end
end

map('', 'r', 'j')
map('', 'j', 'r')
map('', 't', 'k')
map('', 'k', 't')
map('n', 'Y', 'y$')
map('i', 'hh', '<esc>')
map('x', '<', '<gv')
map('x', '>', '>gv')
map('n', '<leader>i', ':e ~/.config/nvim/init.lua<CR>')
map('t', '<esc>', [[<C-\><C-n>]])
map('n', '<cr>', [[&buftype ==# 'quickfix' ? "\<cr>" : "o<esc>"]], {expr = true})

vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = { only_current_line = true },
    signs = false,
    update_in_insert = false,
})

-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "tpope/vim-commentary",
    "jiangmiao/auto-pairs",
    "mg979/vim-visual-multi",
    {
        "vim-pandoc/vim-pandoc",
        init = function()
            vim.g["pandoc#spell#enabled"] = false
        end,
    },
    "vim-pandoc/vim-pandoc-syntax",
    "rhysd/git-messenger.vim",
    {
        "kylechui/nvim-surround",
        config = true,
    },
    {
        "justinmk/vim-sneak",
        init = function()
            vim.g["sneak#s_next"] = 1
            vim.g["sneak#use_ic_scs"] = 1
        end,
    },
    {
        "junegunn/vim-slash",
        config = function()
            map('n', '<plug>(slash-after)', 'zz')
        end,
    },
    {
        "RRethy/vim-illuminate",
        config = function()
            vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "LspReferenceText" })
            vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "LspReferenceRead" })
            vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "LspReferenceWrite" })
            require("illuminate").configure({
                under_cursor = false,
                delay = 500,
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {"nvim-lua/plenary.nvim"},
        config = function()
            require("telescope").setup {
                defaults = {
                    layout_strategy = 'vertical'
                },
            }

            local builtin = require("telescope.builtin")
            local function find_files_in_project()
                builtin.find_files({ cwd = find_git_root(), hidden = true })
            end
            local function live_grep_in_project()
                builtin.live_grep({ cwd = find_git_root() })
            end

            map('n', 'gb', builtin.buffers)
            map('n', 'go', builtin.oldfiles)
            map('n', 'gh', builtin.help_tags)
            map('n', 'gt', find_files_in_project)
            map('n', 'ga', live_grep_in_project)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local nvim_lsp = require("lspconfig")

            function lsp_maps()
                buf_map('n', 'K', vim.lsp.buf.hover)
                buf_map('n', 'gd', vim.lsp.buf.definition)
                buf_map('n', '<leader>f', function() vim.lsp.buf.format {async = true} end)
                buf_map('n', '<leader>r', vim.lsp.buf.rename)
                buf_map('n', '<leader>a', vim.lsp.buf.code_action)
                buf_map('n', '<leader>d', vim.diagnostic.open_float)
                buf_map('n', 'gen', function() vim.diagnostic.goto_next {float = false} end)
                buf_map('n', 'gep', function() vim.diagnostic.goto_prev {float = false} end)
                buf_map('n', 'gel', vim.diagnostic.setloclist)

                vim.cmd.setlocal([[omnifunc=v:lua.vim.lsp.omnifunc]])
            end

            local function lsp_on_attach(client)
                lsp_maps()
            end

            nvim_lsp.clangd.setup {
                on_attach = lsp_on_attach,
            }

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

            nvim_lsp.hls.setup{
                on_attach = lsp_on_attach,
            }
        end,
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = true,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = "all",
            highlight = {
                enable = true,
                disable = { "markdown" },
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
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {"rafamadriz/friendly-snippets"},
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()

            local luasnip = require("luasnip")

            map('i',
                '<Tab>',
                function()
                    return luasnip.expand_or_jumpable() and "<Plug>luasnip-expand-or-jump" or "<Tab>"
                end,
                {expr = true})
            map('s', '<Tab>', function() luasnip.jump(1) end)
            map({'i', 's'}, '<C-Tab>', function() luasnip.jump(-1) end)
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup {
               snippet = {
                   expand = function(args)
                       require("luasnip").lsp_expand(args.body)
                   end,
               },

               mapping = {
                   ['<C-p>'] = cmp.mapping.select_prev_item(),
                   ['<C-n>'] = cmp.mapping.select_next_item(),
                   ['<Up>'] = cmp.mapping.select_prev_item(),
                   ['<Down>'] = cmp.mapping.select_next_item(),
                   ['<C-Space>'] = cmp.mapping.complete(),
                   ['<C-e>'] = cmp.mapping.close(),
                   ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                   ['<CR>'] = cmp.mapping.confirm({
                       select = true,
                       behavior = cmp.ConfirmBehavior.Replace,
                   }),
               },

               sources = {
                   { name = 'buffer' },
                   { name = 'path' },
                   { name = 'luasnip' },
                   { name = 'nvim_lsp' },
               },
        }
        end,
    },
    {
        "Th3Whit3Wolf/one-nvim",
        lazy = true,
    },
    {
        "Th3Whit3Wolf/space-nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('space-nvim')
        end,
    },
})

vim.api.nvim_set_hl(0, "Search", {})
vim.api.nvim_set_hl(0, "QuickFixLine", {})

vim.api.nvim_set_hl(0, "TrailingWhitespace", {ctermbg="red", bg="red"})
vim.cmd.match([[TrailingWhitespace /\s\+\%#\@<!$/]])
