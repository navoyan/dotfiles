let mapleader = " "
let maplocalleader = " "

""" Options """
set undofile " Enable persistent undo
set nobackup " Don't store backup while overwriting the file
set nowritebackup " Don't store backup while overwriting the file
set noswapfile " Don't use swapfiles

set number " Show line numbers
set relativenumber " Show relative line numbers 
set cursorline " Highlight current line
set cursorlineopt=number " Highlight only the number of the current line
set signcolumn=yes " Always show sign column (otherwise it will shift text)
set noruler " Don't show cursor position in command line
set fillchars=eob:\  " Don't show `~` outside of buffer

set incsearch " Show search results while typing
set ignorecase " Ignore case when searching
set smartcase " Don't ignore case when searching if pattern has upper case

set foldlevel=99 " Open all folds by default

set nowrap " Disable line wrapping
set linebreak " Wrap long lines at 'breakat' (if 'wrap' is set)
set smartindent " Insert indents automatically
set virtualedit=block " Allow going past the end of line in visual block mode
set formatoptions=qjl1 " Don't autoformat comments

set infercase " Infer letter cases for a richer built-in keyword completion
set completeopt=menu,menuone,noselect " Customize completions

set splitkeep=screen " Reduce scroll during window split
set scrolloff=16 " Make the cursor more centered
set jumpoptions+=stack " Make the jumplist behave like the tagstack

" NOTE: Overwritten by `guess-indent.nvim` when possible in Neovim:
set tabstop=4 " Number of spaces tabs count for
set shiftwidth=0 " Use 'tabstop' to determine number of spaces for 'smartindent', `>`, `<`, etc.
set expandtab " Use spaces when inserting tabs

set shortmess+=WcCsS " Reduce command line messages
set updatetime=50 " How often `CursorHold` is triggered in milliseconds

if empty($SSH_TTY)
    " Use system clipboard
    set clipboard=unnamedplus
endif


""" Mappings """
nnoremap <Space> <Nop>

nnoremap v "_v
vnoremap v "_v

nnoremap V "_V
vnoremap V "_V

nnoremap <Esc> <cmd>nohlsearch<cr>

noremap <C-j> <C-d>zz
noremap <C-k> <C-u>zz

cnoremap <M-Bs> <C-w>
cnoremap <C-Bs> <C-w>

inoremap <C-Bs> <C-w>

noremap m ;
noremap ; m


nnoremap s <Nop>
nnoremap sl "_dl

" yank current path
nnoremap syp <Cmd>let @+=expand("%:~:.")<Cr>
nnoremap syl <Cmd>let @+=expand("%:~:.") . ':' . line(".")<Cr>

" creating vim splits
nnoremap <Leader>sh <Cmd>vertical leftabove split<Cr>
nnoremap <Leader>sj <Cmd>horizontal belowright split<Cr>
nnoremap <Leader>sk <Cmd>horizontal aboveleft split<Cr>
nnoremap <Leader>sl <Cmd>vertical rightbelow split<Cr>

nmap <Leader>x <Cmd>bdelete<Cr>

nmap <Leader>C <Cmd>tab split<Cr>
nmap <Leader>X <Cmd>tabclose<Cr>
for n in range(1, 10)
    execute 'noremap <C-'.n.'> <Cmd>tabn '.n.'<Cr>'
endfor

if !has("nvim")
    syntax on
    set termguicolors " Enable gui colors

    set foldmethod=indent " Fold by lines with equal indent

    if $TERM =~ 'xterm'
      set noek
    endif

    " Almost minimal colors from TokyoNight to be used in clean Vim.
    " Stripped from https://github.com/folke/tokyonight.nvim/blob/main/extras/vim/colors/tokyonight-night.vim
    hi clear
    hi Bold cterm=bold guibg=NONE guifg=#c0caf5
    hi Character guibg=NONE guifg=#9ece6a
    hi ColorColumn guibg=#15161e
    hi Comment cterm=italic guibg=NONE guifg=#565f89
    hi Conceal guibg=NONE guifg=#737aa2
    hi Constant guibg=NONE guifg=#ff9e64
    hi Cursor guibg=#c0caf5 guifg=#1a1b26
    hi CursorColumn guibg=#292e42
    hi CursorIM guibg=#c0caf5 guifg=#1a1b26
    hi CursorLine guibg=#292e42
    hi CursorLineNr cterm=bold guibg=NONE guifg=#27A1B9
    hi Debug guibg=NONE guifg=#ff9e64
    hi DiagnosticError guibg=NONE guifg=#db4b4b
    hi DiagnosticHint guibg=NONE guifg=#1abc9c
    hi DiagnosticInfo guibg=NONE guifg=#0db9d7
    hi DiagnosticUnderlineError gui=undercurl guibg=NONE guisp=#db4b4b
    hi DiagnosticUnderlineHint gui=undercurl guibg=NONE guisp=#1abc9c
    hi DiagnosticUnderlineInfo gui=undercurl guibg=NONE guisp=#0db9d7
    hi DiagnosticUnderlineWarn gui=undercurl guibg=NONE guisp=#e0af68
    hi DiagnosticUnnecessary guibg=NONE guifg=#414868
    hi DiagnosticVirtualTextError guibg=#2d202a guifg=#db4b4b
    hi DiagnosticVirtualTextHint guibg=#1a2b32 guifg=#1abc9c
    hi DiagnosticVirtualTextInfo guibg=#192b38 guifg=#0db9d7
    hi DiagnosticVirtualTextWarn guibg=#2e2a2d guifg=#e0af68
    hi DiagnosticWarn guibg=NONE guifg=#e0af68
    hi DiffAdd guibg=#20303b
    hi DiffChange guibg=#1f2231
    hi DiffDelete guibg=#37222c
    hi DiffText guibg=#394b70
    hi Directory guibg=NONE guifg=#7aa2f7
    hi EndOfBuffer guibg=NONE guifg=#1a1b26
    hi Error guibg=NONE guifg=#db4b4b
    hi ErrorMsg guibg=NONE guifg=#db4b4b
    hi FloatBorder guibg=#16161e guifg=#27a1b9
    hi FloatTitle guibg=#16161e guifg=#27a1b9
    hi FoldColumn guibg=#1a1b26 guifg=#565f89
    hi Folded guibg=#3b4261 guifg=#7aa2f7
    hi Foo guibg=#ff007c guifg=#c0caf5
    hi Function guibg=NONE guifg=#7aa2f7
    hi Identifier guibg=NONE guifg=#bb9af7
    hi IncSearch guibg=#ff9e64 guifg=#15161e
    hi Italic cterm=italic guibg=NONE guifg=#c0caf5
    hi Keyword cterm=italic guibg=NONE guifg=#7dcfff
    hi LineNr guibg=NONE guifg=#3b4261
    hi LineNrAbove guibg=NONE guifg=#3b4261
    hi LineNrBelow guibg=NONE guifg=#3b4261
    hi MatchParen cterm=bold guibg=NONE guifg=#ff9e64
    hi ModeMsg cterm=bold guibg=NONE guifg=#a9b1d6
    hi MoreMsg guibg=NONE guifg=#7aa2f7
    hi MsgArea guibg=NONE guifg=#a9b1d6
    hi NonText guibg=NONE guifg=#545c7e
    hi Normal guibg=#1a1b26 guifg=#c0caf5
    hi NormalFloat guibg=#16161e guifg=#c0caf5
    hi NormalNC guibg=#1a1b26 guifg=#c0caf5
    hi NormalSB guibg=#16161e guifg=#a9b1d6
    hi Operator guibg=NONE guifg=#89ddff
    hi Pmenu guibg=#16161e guifg=#c0caf5
    hi PmenuMatch guibg=#16161e guifg=#2ac3de
    hi PmenuMatchSel guibg=#343a55 guifg=#2ac3de
    hi PmenuSbar guibg=#1f1f29
    hi PmenuSel guibg=#343a55
    hi PmenuThumb guibg=#3b4261
    hi PreProc guibg=NONE guifg=#7dcfff
    hi Question guibg=NONE guifg=#7aa2f7
    hi QuickFixLine cterm=bold guibg=#283457
    hi Search guibg=#3d59a1 guifg=#c0caf5
    hi SignColumn guibg=#1a1b26 guifg=#3b4261
    hi SignColumnSB guibg=#16161e guifg=#3b4261
    hi Special guibg=NONE guifg=#2ac3de
    hi SpecialKey guibg=NONE guifg=#545c7e
    hi SpellBad gui=undercurl guibg=NONE guisp=#db4b4b
    hi SpellCap gui=undercurl guibg=NONE guisp=#e0af68
    hi SpellLocal gui=undercurl guibg=NONE guisp=#0db9d7
    hi SpellRare gui=undercurl guibg=NONE guisp=#1abc9c
    hi Statement guibg=NONE guifg=#bb9af7
    hi StatusLine guibg=#16161e guifg=#a9b1d6
    hi StatusLineNC guibg=#16161e guifg=#3b4261
    hi String guibg=NONE guifg=#9ece6a
    hi Substitute guibg=#f7768e guifg=#15161e
    hi TabLine guibg=#16161e guifg=#3b4261
    hi TabLineFill guibg=#15161e
    hi TabLineSel guibg=#7aa2f7 guifg=#15161e
    hi Title cterm=bold guibg=NONE guifg=#7aa2f7
    hi Todo guibg=#e0af68 guifg=#1a1b26
    hi Type guibg=NONE guifg=#2ac3de
    hi Underlined gui=underline guibg=NONE
    hi VertSplit guibg=NONE guifg=#15161e
    hi Visual guifg=NONE guibg=#283457
    hi VisualNOS guifg=NONE guibg=#283457
    hi WarningMsg guibg=NONE guifg=#e0af68
    hi Whitespace guibg=NONE guifg=#3b4261
    hi WildMenu guibg=#283457
    hi WinSeparator cterm=bold guibg=NONE guifg=#15161e
    hi dbugBreakpoint guibg=#192b38 guifg=#0db9d7
    hi debugPC guibg=#16161e
    hi diffAdded guibg=#20303b guifg=#449dab
    hi diffChanged guibg=#1f2231 guifg=#6183bb
    hi diffFile guibg=NONE guifg=#7aa2f7
    hi diffIndexLine guibg=NONE guifg=#bb9af7
    hi diffLine guibg=NONE guifg=#565f89
    hi diffNewFile guibg=#20303b guifg=#2ac3de
    hi diffOldFile guibg=#37222c guifg=#2ac3de
    hi diffRemoved guibg=#37222c guifg=#914c54
    hi healthError guibg=NONE guifg=#db4b4b
    hi healthSuccess guibg=NONE guifg=#73daca
    hi healthWarning guibg=NONE guifg=#e0af68
    hi helpCommand guibg=#414868 guifg=#7aa2f7
    hi helpExample guibg=NONE guifg=#565f89
    hi lCursor guibg=#c0caf5 guifg=#1a1b26
    hi! link CurSearch IncSearch
    hi! link Delimiter Special
    hi! link WinBar StatusLine
    hi! link WinBarNC StatusLineNC
end
