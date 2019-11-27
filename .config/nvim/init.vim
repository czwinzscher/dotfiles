" Plugins
call plug#begin()

" general
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'

" navigation
Plug 'justinmk/vim-sneak'
Plug 'junegunn/vim-slash'

" completion
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/deoplete-lsp'
Plug 'Shougo/neopairs.vim'

" lsp
Plug 'neovim/nvim-lsp'

" syntax
Plug 'sheerun/vim-polyglot'
Plug 'bfrg/vim-cpp-modern'

" git
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'

" fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" lint
" Plug 'dense-analysis/ale'

" snippets
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

" statusline
" Plug 'itchyny/lightline.vim'
" Plug 'maximbaz/lightline-ale'

" color schemes
Plug 'joshdick/onedark.vim'

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
set autochdir
set splitright
set splitbelow
set breakindent
set confirm
set signcolumn=no
set pumheight=5
set scrolloff=5
set wildignore+=*.so,*.swp,*.zip,*.o,*.tar*
set shortmess+=c
set tags+=./.tags
set clipboard+=unnamedplus
set completeopt-=preview
set fillchars=eob:\ 
set cinoptions=N-s,g0,+0
set pastetoggle=<F6>
set termguicolors

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

" Colors
augroup colorextend
    autocmd!
    autocmd ColorScheme * call onedark#extend_highlight("MatchParen", { "gui": "bold" })
augroup END

colorscheme onedark
highlight Search NONE
highlight QuickFixLine NONE

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python'
let g:python3_host_skip_check = 1

" Mappings
let mapleader=","

map Y y$
inoremap jj <esc>

" insert new line with enter in normal mode
nnoremap <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>" : "o<Esc>"

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

xnoremap <  <gv
xnoremap >  >gv

" accept pum item with enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

nnoremap <C-B> :Buffers<CR>
nnoremap <expr> <C-P> Find_git_root() == "" ? ":Files<CR>" : ":GFiles<CR>"
nnoremap <expr> gr Find_git_root() == "" ? ":Rg<CR>" : ":GRg<CR>"
nnoremap gh :History<CR>
nnoremap gl :BLines<CR>
nnoremap gb :BTags<CR>
nnoremap gt :Tags<CR>
nnoremap gp :Projects<CR>

" jump between ale errors
nnoremap gen :ALENext<CR>zz
nnoremap gep :ALEPrevious<CR>zz
nnoremap gel :lopen<CR>

" git
nnoremap gs :Gstatus<CR>
nnoremap <leader>gs :GitMessenger<CR>

" quickly open config file
nnoremap <silent> <leader>gi :e ~/.config/nvim/init.vim<CR>

" use escape to go to normal mode in terminal
tnoremap <Esc> <C-\><C-n>

" commentstrings
" use // instead of /* */
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" dont insert comments in the next line automatically
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" delete trailing whitespace on save
" autocmd BufWritePre * %s/\s\+$//e

" lsp
" see lua/lsp_setup.lua
lua require('lsp_setup').setup()

function! LSP_maps()
    nnoremap <buffer> <silent> K  :lua vim.lsp.buf.hover()<CR>
    nnoremap <buffer> <silent> gd :lua vim.lsp.buf.definition()<CR>
    nnoremap <buffer> <silent> <leader>f :lua vim.lsp.buf.formatting()<CR>
    nnoremap <buffer> <silent> <leader>r :lua vim.lsp.buf.rename()<CR>
    " nnoremap <buffer> <silent> <leader>d :lua vim.lsp.util.show_line_diagnostics()<CR>
    nnoremap <buffer> <silent> <leader>d :lua require('lsp_utils').show_line_diagnostics()<CR>
endfunction

autocmd FileType cpp,haskell,python,rust,go,tex call LSP_maps()
autocmd Filetype cpp,haskell,python,rust,go,tex setlocal omnifunc=v:lua.vim.lsp.omnifunc

autocmd FileType tex nnoremap <buffer> <silent> <leader>b <cmd>TexlabBuild<CR>
" autocmd BufWritePre *.go lua vim.lsp.buf.formatting()

" netrw
let g:netrw_dirhistmax = 0

" plugins

" slash
" center cursor on screen while searching
noremap <plug>(slash-after) zz

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_start_length = 3
call deoplete#custom#option('auto_complete_delay', 200)
call deoplete#custom#option('ignore_sources', {'_': ['ultisnips']})
call deoplete#custom#source('_', 'matchers', ['matcher_length', 'matcher_head'])
call deoplete#custom#source('_', 'converters', ['converter_auto_paren'])

" ALE
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1

let g:ale_linters = {
            \ 'asm': [],
            \ 'c': ['clang'],
            \ 'cpp': [],
            \ 'go': [],
            \ 'haskell': [],
            \ 'python': [],
            \ 'rust': [],
            \ }

" let g:ale_type_map = { 'flake8': {'ES': 'WS'}, }

" Ultisnips
let g:UltiSnipsEditSplit = "vertical"
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips', 'UltiSnips']

" fzf
" hide statusline when fzf is active
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noruler
            \| autocmd BufLeave <buffer> set laststatus=2 ruler

let g:fzf_layout = { 'down': '~15%' }

" Rg [reg] [path]
command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always --smart-case '
            \   . (len(<q-args>) > 0 ? <q-args> : '""'),
            \   1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'))

" Rg in git project
command! -nargs=* GRg
            \ call fzf#vim#grep(
            \   'rg --column -n --no-heading --color=always --smart-case '
            \   . shellescape(<q-args>),
            \   0,
            \   fzf#vim#with_preview({
            \     'dir': systemlist('git rev-parse --show-toplevel')[0]
            \   },
            \   'right:50%:hidden',
            \   '?'))

function! Get_files_command()
    if Find_git_root() == ""
        Files
    else
        GFiles
    endif
endfunction

command! GFilesOrFiles call Get_files_command()

" search projects
let project_dirs = [
            \ "~/code",
            \ "~/Nextcloud/Studium/Semester5",
            \ ]

function! s:proj_handler(dir)
    execute 'lcd '.a:dir
    GFilesOrFiles
    call feedkeys('i')
endfunction

command! Projects
            \ call fzf#run(fzf#wrap({
            \ 'source': project_dirs,
            \ 'sink': function('<sid>proj_handler') }))

" change directory
command! -nargs=* -complete=dir Cd
            \ call fzf#run(fzf#wrap(
            \ {'source': 'fd -t d -I -H . '.(len(<q-args>) < 1 ? '.' : <q-args>),
            \ 'sink': 'cd'}))

" cd in git project
command! GCd
            \ call fzf#run(fzf#wrap(
            \ {'source': 'fd -t d -I -H . '.(Find_git_root()), 'sink': 'cd'}))

" lightline
function! LightlineFilename()
    let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
    let modified = &modified ? ' +' : ''
    return filename . modified
endfunction

function! LightlineFiletype()
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

let g:lightline = {
            \ 'colorscheme': 'one',
            \ 'active': {
            \   'left': [ [ 'paste' ],
            \             [ 'gitbranch', 'readonly', 'filename' ] ],
            \   'right': [ [ 'linter_errors', 'linter_warnings' ],
            \              [ 'percent', 'lineinfo' ],
            \              [ 'filetype' ] ],
            \ },
            \ 'component_function': {
            \   'gitbranch': 'fugitive#head',
            \   'filename': 'LightlineFilename',
            \   'filetype': 'LightlineFiletype',
            \ },
            \ 'component_expand': {
            \  'linter_warnings': 'lightline#ale#warnings',
            \  'linter_errors': 'lightline#ale#errors',
            \ },
            \ 'component_type': {
            \     'linter_warnings': 'warning',
            \     'linter_errors': 'error',
            \ },
            \ }

" functions
function! Find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

" commands
command DeleteTrailingWhitespace :%s/\s\+$//e
