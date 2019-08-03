if &compatible
    set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')

    call dein#add('~/.cache/dein')

    " general
    call dein#add('tpope/vim-surround')
    call dein#add('tpope/vim-commentary')
    call dein#add('jiangmiao/auto-pairs')
    call dein#add('terryma/vim-multiple-cursors')

    " navigation
    call dein#add('justinmk/vim-sneak')
    call dein#add('junegunn/vim-slash')

    " completion
    call dein#add('Shougo/deoplete.nvim')
    call dein#add('Shougo/neopairs.vim')
    call dein#add('ervandew/supertab')

    " programming
    call dein#add('autozimu/LanguageClient-neovim', {
                \ 'build': './install.sh',
                \ 'rev': 'next',
                \ })
    call dein#add('maksimr/vim-jsbeautify')
    call dein#add('sheerun/vim-polyglot')

    " git
    call dein#add('tpope/vim-fugitive')
    call dein#add('rhysd/git-messenger.vim', {
                \   'lazy' : 1,
                \   'on_cmd' : 'GitMessenger',
                \   'on_map' : '<Plug>(git-messenger',
                \ })

    " fzf
    call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
    call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

    " lint
    call dein#add('dense-analysis/ale')

    " snippets
    call dein#add('SirVer/ultisnips')
    call dein#add('honza/vim-snippets')

    " statusline
    call dein#add('itchyny/lightline.vim')
    call dein#add('maximbaz/lightline-ale')

    " color schemes
    call dein#add('joshdick/onedark.vim')
    call dein#add('gruvbox-community/gruvbox')

    call dein#end()
    call dein#save_state()
endif

if dein#check_install()
    call dein#install()
endif

" general
filetype plugin indent on
syntax enable
set nospell
set title
set titlestring=%f
set listchars=tab:\ \ ,eol:$
"set list listchars=tab:\ \ "cursor on tab at beginning not end
set showmatch
set noshowcmd
set noshowmode
" set nostartofline
set signcolumn=no
set splitright
set splitbelow
set breakindent
set pumheight=5
set scrolloff=5
set autochdir
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.o,*.fls,*.tar*
set wildoptions+=pum
set shortmess+=c
set tags+=./.tags;/
set clipboard+=unnamedplus
set completeopt-=preview
set encoding=utf-8
set fcs=eob:\ "hides tildes after eof
set confirm
set lazyredraw

" Tabs
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
autocmd FileType asm,html setlocal expandtab
set hidden

" Search
set nohlsearch
set ignorecase
set smartcase
set inccommand=nosplit

let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
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

set pastetoggle=<F6>

" commentstrings
" use // instead of /* */
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s
" use ; for asm
autocmd FileType asm setlocal commentstring=;\ %s

" delete trailing whitespace on save
au BufWritePre * %s/\s\+$//e

" plugins

" netrw
let g:netrw_dirhistmax = 0

" slash
" center cursor on screen while searching
noremap <plug>(slash-after) zz

" supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" LanguageClient
let g:LanguageClient_serverCommands = {
            \ 'haskell': ['/home/clemens/.local/bin/hie-wrapper'],
            \ 'cpp': ['/home/clemens/src/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
            \ 'python': ['/home/clemens/.local/bin/pyls'],
            \ 'rust': ['/home/clemens/.cargo/bin/rustup', 'run', 'stable', 'rls'],
            \ 'go': ['/home/clemens/go/bin/gopls']
            \ }

" use ale for diagnostics
let g:LanguageClient_diagnosticsEnable = 0

" function that enables lc keybindings
function! LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <buffer> <F5> :call LanguageClient_contextMenu()<CR>
        nnoremap <buffer> K :call LanguageClient#textDocument_hover()<CR>
        nnoremap <buffer> gd :call LanguageClient#textDocument_definition()<CR>
        nnoremap <buffer> <leader>r :call LanguageClient#textDocument_rename()<CR>
        nnoremap <buffer> <leader>f :call LanguageClient#textDocument_formatting()<CR>
    endif
endfunction

autocmd FileType haskell,cpp,python,rust,go call LC_maps()
" run gofmt on save
autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

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
            \ 'cpp': ['clangcheck'],
            \ 'c': ['clang'],
            \ 'python': ['flake8'],
            \ 'rust': ['cargo'],
            \ 'haskell': ['ghc'],
            \ 'asm': [],
            \}

" let g:ale_cpp_clang_options='-std=c++17 -Weverything -Wno-c++98-compat'
let g:ale_type_map = { 'flake8': {'ES': 'WS'}, }

" gutentags
" let g:gutentags_ctags_tagfile = '.tags'
" let g:gutentags_file_list_command = {'markers': {'.git': 'git ls-files'}}

" Ultisnips
let g:UltiSnipsEditSplit = "vertical"
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips', 'UltiSnips']

" fzf
" hide statusline when fzf is active
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler" airline
let g:fzf_layout = { 'down': '~20%' }

" Rg [reg] [path]
command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always -S '
            \  . (len(<q-args>) > 0 ? <q-args> : '""'), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'))

" Rg in git project
command! -nargs=* GRg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always -S '.shellescape(<q-args>),
            \   0, fzf#vim#with_preview({ 'dir': systemlist('git rev-parse --show-toplevel')[0] },
            \   'right:50%:hidden', '?'))

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
            \ "~/code/mission-uncuttable",
            \ "~/code/automata-lib",
            \ "~/Nextcloud/Studium/Semester5"
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
command! -nargs=* -complete=dir Cd call fzf#run(fzf#wrap(
            \ {'source': 'fd -t d -I -H . '.(len(<q-args>) < 1 ? '.' : <q-args>), 'sink': 'cd'}))

" cd in git project
command! GCd call fzf#run(fzf#wrap(
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

" colors
set termguicolors
colorscheme onedark
" highlight Search NONE
hi QuickFixLine NONE

" functions
function! Find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
