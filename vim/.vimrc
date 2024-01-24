" Tries its best to sync with nvim remaps
" For cases where I dont have nvim and have to raw dog vim lmao
" Last updated 24/01/24

" __________________ "
" SETTINGS
" __________________ "

" Line and rulers
set ruler
set nu
set relativenumber
" Tabs, indent and other good stuff
syntax on
set smartindent
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set backspace=2
set colorcolumn=80
" Scrolling
set scrolloff=8
set signcolumn=yes
" Use undofile instead of swapfile garbage
set noswapfile
set nobackup
set undodir=~/.vim/undo-dir
set undofile
" Search settings
set hlsearch
set incsearch
" Terminal stuff
set termguicolors
set guicursor=
" Some file name shit
set isfname+=@-@
" Update time shit
set updatetime=750


" __________________ "
" REMAPS
" __________________ "
" Leader keys
let mapleader = " "
" Open file explorer
nnoremap <leader>pv :Ex<CR>
" Sliding lines up and down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" Joining lines without moving the cursor in normal mode with J
nnoremap J mzJ`z
" Centering the screen after scrolling with Ctrl-d and Ctrl-u:
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
" Centering the screen after searching with n and N:
nnoremap n nzzzv
nnoremap N Nzzzv
" Pasting over without replacing the clipboard in visual mode with <leader>p:
xnoremap <leader>p "_dP
" Using Ctrl-c as escape in insert mode:
inoremap <C-c> <Esc>
