let mapleader = " "

set smartindent
set autowriteall
set relativenumber
set nohlsearch
set hidden!
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set noshowmode
set showcmd!
set nu
set nowrap
set noswapfile
set nobackup
set undodir=~/.nvim/undodir
set undofile
set incsearch
set scrolloff=16
" set noshowmode
set termguicolors
set signcolumn=yes
set isfname+=@-@
set clipboard=
" set ls=0
set conceallevel=1
set jumpoptions+=stack

set textwidth=130

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c


inoremap <C-c> <esc>

nnoremap x "_x
vnoremap x "_x

nnoremap v "_v
vnoremap v "_v

nnoremap V "_V
vnoremap V "_V


" " Copy to clipboard
vnoremap  <leader>cy  "+y
nnoremap  <leader>cY  "+yg_
nnoremap  <leader>cy  "+y
nnoremap  <leader>cyy  "+yy

" " Paste from clipboard
nnoremap <leader>cp "+p
nnoremap <leader>cP "+P
vnoremap <leader>cp "+p
vnoremap <leader>cP "+P

nnoremap <leader>p "0p
vnoremap <leader>p "0p

noremap <C-j> <C-d>
noremap <C-k> <C-u>

cnoremap <M-Bs> <C-w>

nmap <leader>C <cmd>tab split<cr>
nmap <leader>x <cmd>tabclose<cr>
for i in range(1, 10)
  execute 'nmap <C-'.i.'> <cmd>tabn '.i.'<cr>'
endfor
