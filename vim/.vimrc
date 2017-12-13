set number
set showmatch
set nobackup
set noswapfile
set syntax=on

" change tab to 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set hidden
set confirm

set scrolloff=10

set showcmd

" fix vim color in tmux
set background=dark
set t_Co=256

set tags=tags;
set autochdir
let Tlist_auto_open=1

set nocompatible
highlight LineNr ctermfg=grey
set cursorline
highlight CursorLine cterm=NONE


" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'haya14busa/incsearch.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/taglist.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'ctrlpvim/ctrlp.vim'

"Plug 'bling/vim-bufferline'

" Initialize plugin system
call plug#end()

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

let g:airline#extensions#tabline#enabled = 1

let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_powerline_fonts=1
let g:airline_theme = 'papercolor'
let g:airline#extensions#tmuxline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'

"let g:bufferline_show_bufnr = 1
"let g:bufferline_echo = 0


"Window splitting remap"
nnoremap <C-j> :bnext<CR>
nnoremap <C-k> :bprev<CR>

nnoremap <C-h> <C-w>w
nnoremap <C-l> <C-w>W
:imap jj <Esc>
"inoremap <C-i> <Esc>
"inoremap <M-i> <Esc>

nnoremap <C-x> :bd<CR>

" Use ; for : in normal and visual mode, less keystrokes
nnoremap ; :
vnoremap ; :

nnoremap <silent> <C-s> :<C-u>update<CR>
vnoremap <silent> <C-s> <C-C>:update<CR>
inoremap <silent> <C-s> <C-C>:update<CR>

