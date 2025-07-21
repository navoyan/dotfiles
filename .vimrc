let mapleader = " "
let maplocalleader = " "

set autowriteall
set relativenumber

set ignorecase
set smartcase
set incsearch
set inccommand=split

set smartindent

" Overwritten by `guess-indent.nvim` in Neovim:
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab

set hidden!
set noerrorbells
set noshowmode
set showcmd!
set nu
set nowrap
set noswapfile
set nobackup
set undodir=~/.nvim/undodir
set undofile
set scrolloff=16
" set noshowmode
set termguicolors
set signcolumn=yes
set isfname+=@-@
" set ls=0
set conceallevel=1
set jumpoptions+=stack

if empty($SSH_TTY)
  set clipboard=unnamedplus
else
  set clipboard=
endif

set textwidth=200

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

nnoremap x "_x
vnoremap x "_x

nnoremap v "_v
vnoremap v "_v

nnoremap V "_V
vnoremap V "_V

nnoremap <Esc> <cmd>nohlsearch<cr>

nnoremap gp `[v`]

noremap <C-j> <C-d>
noremap <C-k> <C-u>

cnoremap <M-Bs> <C-w>
cnoremap <C-Bs> <C-w>

inoremap <C-Bs> <C-w>

nnoremap m ;
nnoremap ; m

nnoremap sl "_dl

nmap <leader>C <cmd>tab split<cr>
nmap <leader>x <cmd>tabclose<cr>
for i in range(1, 10)
  execute 'nmap <C-'.i.'> <cmd>tabn '.i.'<cr>'
endfor
