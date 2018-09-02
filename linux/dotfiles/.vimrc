" Plugins
call plug#begin('~/.vim/plugged')

Plug 'cocopon/iceberg.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree'
Plug 'davidhalter/jedi-vim'

call plug#end()


" Close vim if the only window left open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

map <C-n> :NERDTreeToggle<CR>


" Color scheme
if !has('gui_running')
    set t_Co=256
endif

colorscheme iceberg
let g:lightline = { 'colorscheme': 'iceberg' }
set laststatus=2
set noshowmode

syntax on		" Enable syntax highlighting


set number		" Enable line numbers
set scrolloff=4
set splitbelow

