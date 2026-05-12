set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'burntsushi/ripgrep'
Plugin 'jremmen/vim-ripgrep'
Plugin 'tpope/vim-fugitive'
Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'sheerun/vim-polyglot'

call vundle#end()            " required
filetype plugin indent on    " required

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

map <C-n> :NERDTreeToggle<CR>
:let g:NERDTreeWinSize=35
let NERDTreeShowHidden=1

" airline
set laststatus=2
let g:airline_detect_paste=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled=0
let g:airline_section_c = '%f'

syntax on

set backspace=indent,eol,start
set ruler
set number
set mouse=a
set background=dark
set showcmd
set incsearch
set hlsearch

colorscheme desert

set cc=101
set cursorline
set cursorcolumn

" toggle cursorline & cursorcolumn
nnoremap <SPACE> :set cursorcolumn!<Bar>set cursorline!<CR>
nnoremap <M-SPACE> :set list! list?<CR>
nnoremap <F3> :set wrap!<CR>

" buffers
nnoremap <F6> :bn<CR>
nnoremap <F5> :bp<CR>

" switch cpp <---> h
map <F2> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

" NERDTree
nmap ,n :NERDTreeFind<CR>
nmap ,m :NERDTreeToggle<CR>

set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
nnoremap <TAB><TAB><TAB> :set expandtab! expandtab?<CR>

set foldmethod=indent
set foldlevel=20
nnoremap <space> za
vnoremap <space> zf

map z1  :set foldlevel=0<CR><Esc>
map z2  :set foldlevel=1<CR><Esc>
map z3  :set foldlevel=2<CR><Esc>
map z4  :set foldlevel=3<CR><Esc>
map z5  :set foldlevel=4<CR><Esc>
map z6  :set foldlevel=5<CR><Esc>
map z7  :set foldlevel=6<CR><Esc>
map z8  :set foldlevel=7<CR><Esc>
map z9  :set foldlevel=8<CR><Esc>

noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>

set pastetoggle=<F7>
noremap <F8> :set list!<CR>
inoremap <F8> <C-o>:set list!<CR>
cnoremap <F8> <C-c>:set list!<CR>

noremap <F9> :cprevious<CR>
noremap <F10> :cnext<CR>
noremap <F11> :tp<CR>
noremap <F12> :tn<CR>

nnoremap <Leader>b :ls<CR>:b<Space>
let g:buffergator_viewport_split_policy = "R"

:set smartcase

" Auto-reload files changed on disk
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
call timer_start(1000, {-> execute('silent! checktime')}, {'repeat': -1})

set expandtab

" fzf keymaps
nnoremap <C-p> :GFiles<Cr>
nnoremap <C-l> :Buffers<Cr>
nnoremap <C-g> :Ag<Cr>

let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 0.8, 'relative': v:true, 'yoffset': 1.0 } }

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
  copen
  cc
endfunction

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
