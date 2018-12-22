" Plugins
call plug#begin('~/.vim/plugged')

Plug 'cocopon/iceberg.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'majutsushi/tagbar'
Plug 'w0rp/ale'
Plug 'posva/vim-vue'

call plug#end()


" Close vim if the only window left open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

map <C-n> :NERDTreeToggle<CR>


" ALE
let g:ale_completion_enabled = 1

let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'rust': ['rls'],
\   'python': ['pyls'],
\}
let g:ale_rust_rls_executable = 'rls'
let g:ale_rust_rls_toolchain = 'nightly'

let g:ale_fixers = {
\   'rust': ['rustfmt'],
\   'python': ['black'],
\}
let g:ale_fix_on_save = 1



" Vue
autocmd FileType vue syntax sync fromstart


" Color scheme
if !has('gui_running')
    set t_Co=256
endif

colorscheme iceberg
let g:lightline = { 'colorscheme': 'iceberg' }
set laststatus=2
set noshowmode

syntax on           " Enable syntax highlighting


set number          " Enable line numbers
set scrolloff=16
set splitbelow

" Indentation
set autoindent
set smartindent

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab       " Insert space characters instead of tab characters

set backspace=indent,eol,start  " Allow backspacing over everything

set clipboard=unnamedplus       " Alias unnamed register to the X Window clipboard

