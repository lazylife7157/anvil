" vim: set foldmethod=marker foldlevel=0 nomodeline:
" ============================================================================
" Plugins {{{

call plug#begin('~/.vim/plugged')

Plug 'cocopon/iceberg.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'posva/vim-vue'

if has('nvim')
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
    \ }
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif

call plug#end()

" }}}
" Basic settings {{{

let mapleader      = ' '
let maplocalleader = ' '

set number
set scrolloff=8
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set backspace=indent,eol,start
set clipboard=unnamedplus       " Alias unnamed register to the X Window clipboard

" }}}
" Mappings {{{

nnoremap <M-I> <C-w> +
nnoremap <M-J> <C-w> <
nnoremap <M-K> <C-w> -
nnoremap <M-L> <C-w> >

" }}}
" Color scheme {{{

if !has('gui_running')
    set t_Co=256
endif

colorscheme iceberg
let g:lightline = { 'colorscheme': 'iceberg' }
set laststatus=2
set noshowmode

" }}}
" NERDTree {{{

" Close vim if the only window left open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

map <C-n> :NERDTreeToggle<CR>

" }}}
" LanguageClient-neovim {{{

set hidden " Required for operations modifying multiple buffers like rename.

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'python': ['pyls'],
    \ 'vue': ['vls'],
    \ }
let g:LanguageClient_changeThrottle = 0.4

nnoremap <leader>lc :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nmap <leader>h K
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nmap <leader>gd gd
nnoremap <leader>fr :call LanguageClient#textDocument_references()<CR>
nnoremap <leader>r :call LanguageClient#textDocument_rename()<CR>

" }}}
" Deoplete {{{

let g:deoplete#enable_at_startup = 1

" }}}
" Vue {{{

autocmd FileType vue syntax sync fromstart

" }}}
