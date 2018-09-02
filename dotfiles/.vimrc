" Plugins
call plug#begin('~/.vim/plugged')

Plug 'cocopon/iceberg.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'vim-syntastic/syntastic'
Plug 'rust-lang/rust.vim'
Plug 'davidhalter/jedi-vim'

call plug#end()


" Close vim if the only window left open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

map <C-n> :NERDTreeToggle<CR>


" Rust
let g:rustfmt_autosave = 1


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

