" Plugins
call plug#begin()

" general
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'

" navigation
Plug 'justinmk/vim-sneak'
Plug 'junegunn/vim-slash'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

" completion
" Plug 'Shougo/deoplete.nvim'
" Plug 'Shougo/deoplete-lsp'
" Plug 'Shougo/neopairs.vim'

" programming
Plug 'neovim/nvim-lsp'
Plug 'mattn/emmet-vim'

" syntax
Plug 'sheerun/vim-polyglot'

" git
" Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'

" snippets
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

" colorizer
Plug 'norcalli/nvim-colorizer.lua'

" color schemes
Plug 'tomasiser/vim-code-dark'

call plug#end()

" general
set nospell
set title
set titlestring=%f
set list
set listchars=tab:\ \ 
set showmatch
set noshowcmd
set noshowmode
set nofoldenable
set autochdir
set splitright
set splitbelow
set breakindent
set confirm
set termguicolors
set laststatus=0
set signcolumn=no
set pumheight=5
set scrolloff=7
set cinoptions=N-s,g0,+0
set pastetoggle=<F6>
set wildignore+=*.so,*.swp,*.zip,*.o,*.tar*
set shortmess+=caI
set tags+=./.tags
set clipboard+=unnamedplus
set completeopt=menu,noselect
set fillchars=eob:\ 

" Tabs
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set hidden

" Search
set nohlsearch
set ignorecase
set smartcase
set inccommand=nosplit

" colorscheme
colorscheme codedark

" highlighting
highlight Search NONE
highlight QuickFixLine NONE
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+\%#\@<!$/

" python
let g:loaded_python_provider = 0
let g:python3_host_prog = '/usr/bin/python'

" netrw
let g:netrw_dirhistmax = 0

" mappings
let g:mapleader=","

nnoremap Y y$
inoremap jj <esc>

" insert new line with enter in normal mode
nnoremap <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>" : "o<Esc>"

nnoremap <C-J> <C-D>
nnoremap <C-K> <C-U>

xnoremap <  <gv
xnoremap >  >gv

" accept pum item with enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

nnoremap <silent> <C-B> :Clap buffers<CR>
nnoremap <silent> <expr> <C-P> Find_git_root() == "" ? ":Clap files<CR>"
            \ : ":Clap gfiles<CR>"
nnoremap <silent> gp :Clap projects<CR>
nnoremap <silent> gf :Clap filer<CR>

nnoremap <silent> gel :lopen<CR>

" git
" nnoremap gs :Gstatus<CR>
nnoremap <silent> gm :GitMessenger<CR>

" quickly open config file
nnoremap <silent> <leader>gi :e ~/.config/nvim/init.vim<CR>

" use escape to go to normal mode in terminal
tnoremap <Esc> <C-\><C-n>

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

" plugins

" clap
let g:clap_disable_bottom_top = 1

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

" deoplete
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#auto_complete_start_length = 1
" call deoplete#custom#option('auto_complete_delay', 50)
" call deoplete#custom#option('ignore_sources', {'_': ['ultisnips']})
" call deoplete#custom#source('_', 'matchers', ['matcher_length', 'matcher_head'])
" call deoplete#custom#source('_', 'converters', ['converter_auto_paren'])

" Ultisnips
" let g:UltiSnipsEditSplit = 'vertical'
" let g:UltiSnipsExpandTrigger = '<c-k>'
" let g:UltiSnipsJumpForwardTrigger = '<c-f>'
" let g:UltiSnipsJumpBackwardTrigger = '<c-b>'
" let g:UltiSnipsSnippetDirectories = [stdpath('config').'/UltiSnips', 'UltiSnips']

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
    nnoremap <buffer> <silent> <leader>d :lua require('lsp_config').show_line_diagnostics()<CR>
    setlocal omnifunc=v:lua.vim.lsp.omnifunc
endfunction

augroup lsp
    autocmd!
    autocmd FileType c,cpp,go,haskell,lua,python,rust,tex,typescript
                \ call LSP_maps()
    autocmd FileType tex nnoremap <buffer> <silent> <leader>b
                \ <cmd>TexlabBuild<CR>
    autocmd BufWritePre *.go lua require('lsp_config').formatting_sync()
augroup END

" projects
lua require('projects').setup()
