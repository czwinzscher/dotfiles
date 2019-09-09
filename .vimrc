set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tmsvg/pear-tree'
Plug 'PotatoesMaster/i3-vim-syntax'

call plug#end()

" general
filetype plugin indent on
syntax on
set background=dark
set nospell
set ruler
set listchars=tab:\ \ ,eol:$
set showmatch
set showmode
set splitright
set splitbelow
set autochdir
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.o
set completeopt-=preview
set termguicolors
set encoding=utf-8
set nostartofline
set scrolloff=5
set confirm
set lazyredraw
set laststatus=0
set wildmenu
set backspace=indent,eol,start

autocmd BufWritePre * %s/\s\+$//e

" Tabs
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set smarttab
set hidden
set autoindent

" Search
set incsearch
set ignorecase
set smartcase

" Time
set timeout timeoutlen=1500
set ttimeout ttimeoutlen=200

" Mappings
set pastetoggle=<F6>
map Y y$
inoremap jj <esc>
let mapleader=","
nnoremap <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>" : "o<Esc>"
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <leader>c :e ~/.vimrc<CR>

" plugins
let g:pear_tree_smart_openers = 0
let g:pear_tree_smart_closers = 0
let g:pear_tree_smart_backspace = 0

hi QuickFixLine NONE
