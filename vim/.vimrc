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
" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## 56f4ae146aab28f121e2f79326b45a39 ## you can edit, but keep this line
if count(s:opam_available_tools,"ocp-indent") == 0
  source "/Users/amit/.opam/4.12.0/share/ocp-indent/vim/indent/ocaml.vim"
endif
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line
