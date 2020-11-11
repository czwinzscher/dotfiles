" Plugins
call plug#begin()

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/vim-slash'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
Plug 'neovim/nvim-lsp'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'mattn/emmet-vim'
Plug 'sheerun/vim-polyglot'
Plug 'bfrg/vim-cpp-modern'
Plug 'neovimhaskell/haskell-vim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'rhysd/git-messenger.vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tomasiser/vim-code-dark'
Plug 'arzg/vim-colors-xcode'

call plug#end()

" general
set nospell
set title
set titlestring=%f
set list
set listchars=tab:\ \ 
set noshowcmd
set noshowmode
set nofoldenable
set autochdir
set splitright
set splitbelow
set breakindent
set confirm
set termguicolors
set hidden
" set laststatus=0
set signcolumn=no
set pumheight=5
set scrolloff=7
set cinoptions=N-s,g0,+0
set pastetoggle=<F6>
set wildignore+=*.so,*.swp,*.zip,*.o,*.tar*
set shortmess+=caI
set tags+=./.tags
set clipboard+=unnamedplus
set completeopt=menu,noselect,noinsert
set fillchars=eob:\ 

" Tabs
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab

" Search
set nohlsearch
set ignorecase
set smartcase
set wildignorecase
set inccommand=nosplit

" colorscheme
" colorscheme codedark
colorscheme darkblue

" highlighting
highlight Search NONE
highlight QuickFixLine NONE
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+\%#\@<!$/
augroup highlight_yank
    autocmd!
    autocmd TextYankPost *
                \ silent! lua vim.highlight.on_yank
                \ {higroup="IncSearch", timeout=1000, on_visual=false}
augroup END

" python
let g:loaded_python_provider = 0
let g:python3_host_prog = '/usr/bin/python'

" netrw
let g:netrw_dirhistmax = 0

" mappings
let g:mapleader=","

nnoremap Y y$
inoremap hh <esc>

" insert new line with enter in normal mode
nnoremap <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>" : "o<Esc>"

nnoremap <C-J> <C-D>
nnoremap <C-K> <C-U>

xnoremap <  <gv
xnoremap >  >gv

" accept pum item with enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

nnoremap <silent> <leader>c :Clap providers<CR>
" nnoremap <silent> <expr> <C-P> Find_git_root() == "" ? ":Clap files<CR>"
"             \ : ":Clap gfiles<CR>"
nnoremap <silent> <C-P> :Clap files<CR>
nnoremap <silent> <C-B> :Clap buffers<CR>
nnoremap <silent> gp :Clap projects<CR>
nnoremap <silent> gf :Clap filer<CR>

nnoremap <silent> gel :lopen<CR>

nnoremap <silent> gm :GitMessenger<CR>

nnoremap <silent> <leader>i :e ~/.config/nvim/init.vim<CR>

" use escape to go to normal mode in terminal
tnoremap <Esc> <C-\><C-n>

" neo mappings
noremap r j
noremap j r
noremap t k
noremap k t

augroup commentstrings
    autocmd!
    autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s
augroup END

augroup fmtoptions
    autocmd!
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r
                \ formatoptions-=o
augroup END

" functions
function! Find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

" commands
command DeleteTrailingWhitespace :%s/\s\+$//e

"" plugins
" clap
let g:clap_disable_bottom_top = 1
let g:clap_insert_mode_only = v:true

" colorizer
lua require('colorizer').setup( { css = { rgb_fn = true } } )

" slash
noremap <plug>(slash-after) zz

" polyglot
let g:vim_markdown_folding_disabled = 1

let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

" Emmet
let g:user_emmet_leader_key='<C-Z>'
let g:user_emmet_install_global = 0

augroup emmet
    autocmd!
    autocmd FileType html,css EmmetInstall
augroup END

" Clap
let g:clap_provider_projects = {
            \ 'source': 'cat '.luaeval('require("projects").get_project_file()'),
            \ 'sink': 'Clap files'
            \ }

" lsp
lua require('lsp_config').setup()

function! LSP_maps()
    nnoremap <buffer> <silent> K  :lua vim.lsp.buf.hover()<CR>
    nnoremap <buffer> <silent> gd :lua vim.lsp.buf.definition()<CR>
    nnoremap <buffer> <silent> <leader>f :lua vim.lsp.buf.formatting()<CR>
    nnoremap <buffer> <silent> <leader>r :lua vim.lsp.buf.rename()<CR>
    nnoremap <buffer> <silent> <leader>a :lua vim.lsp.buf.code_action()<CR>
    nnoremap <buffer> <silent> <leader>d :lua vim.lsp.util.show_line_diagnostics()<CR>
    nnoremap <buffer> <silent> gen :NextDiagnosticCycle<CR>
    nnoremap <buffer> <silent> gep :PrevDiagnosticCycle<CR>
    setlocal omnifunc=v:lua.vim.lsp.omnifunc
endfunction

augroup lsp
    autocmd!
    autocmd FileType c,cpp,go,haskell,lua,python,rust,tex,typescript
                \ call LSP_maps()
    autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()
augroup END

" completion
autocmd BufEnter * lua require'completion'.on_attach()
let g:completion_matching_ignore_case = 1

" diagnostic
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_trimmed_virtual_text = '0'
let g:diagnostic_show_sign = 0
let g:diagnostic_insert_delay = 1

" projects
lua require('projects').setup()
