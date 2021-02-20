set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'sheerun/vim-polyglot'

call plug#end()

" general
filetype plugin indent on
syntax on
set background=dark
set nospell
set ruler
set list
set listchars=tab:\ \ 
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
set laststatus=0
set wildmenu
set backspace=indent,eol,start
set laststatus=2

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

" autocmd BufWritePre * %s/\s\+$//e

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Time
set ttimeout ttimeoutlen=200

" Mappings
set pastetoggle=<F6>
map Y y$
inoremap hh <esc>
let mapleader=","
nnoremap <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>" : "o<Esc>"

nnoremap <leader>i :e ~/.vimrc<CR>

" colors
hi QuickFixLine NONE

" neo mappings
noremap r j
noremap j r
noremap t k
noremap k t
