set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'


Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'burntsushi/ripgrep'
Plugin 'jremmen/vim-ripgrep'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'dense-analysis/ale'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line




autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

map <C-n> :NERDTreeToggle<CR>
:let g:NERDTreeWinSize=35
let NERDTreeShowHidden=1

"""""""""""""""""""
" airline plugin
" """""""""""""""""""

set laststatus=2
" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1



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

" turn on/off cursorline & cursorcolumn
nnoremap <SPACE> :set cursorcolumn!<Bar>set cursorline!<CR>

nnoremap <M-SPACE> :set list! list?<CR>

nnoremap <F3> :set wrap!<CR>

" buffers
nnoremap <F6> :bn<CR>
nnoremap <F5> :bp<CR>

" C++ style navigation

" switch cpp <---> h
map <F2> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

" NERDTree toggle
nmap ,n :NERDTreeFind<CR>
nmap ,m :NERDTreeToggle<CR>


set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

nnoremap <TAB><TAB><TAB> :set expandtab! expandtab?<CR>

"set foldmethod=syntax
"set foldlevel=20

"set foldmethod=indent
set foldmethod=syntax
set foldlevel=20
"set foldnestmax=20
nnoremap <space> za
vnoremap <space> zf

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

let g:ctrlp_max_files=0

nnoremap <Leader>b :ls<CR>:b<Space>
let g:buffergator_viewport_split_policy = "R"

:set smartcase

autocmd BufRead,BufNewFile TARGETS set filetype=python
autocmd BufRead,BufNewFile BUCK set filetype=python



" ALE
let g:ale_fix_on_save = 1
let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
let g:ale_linters = {}

" CPP
let g:ale_fixers.cpp = ['clang-format']
let g:ale_c_clangformat_executable = $CLANGFORMAT_EXE
" This requires additional setup, see
" https://www.internalfb.com/intern/wiki/Users/hariharanb/vim_Setup/ALE/#setting-up-lsp
" let g:ale_linters.cpp = ['cppls_fbcode']

" Python
let g:ale_fixers.python = ['black']
let g:ale_linters.python = ['flake8']
let g:ale_python_flake8_executable = 'flake8-3'

" Shell
" Static analysis
let g:ale_linters.sh = ['shellcheck']
let g:ale_sh_shellcheck_executable = $SHELLCHECK_EXE

""" Disable ALE on BUCK / .bzl as they are taken care of separately
let g:ale_pattern_options = {
      \ 'TARGETS': {'ale_enabled': 0,
      \             'ale_fixers': {}
      \            },
      \ 'BUCK': { 'ale_enabled': 0,
      \           'ale_fixers': {}
      \         },
      \ '\.bzl$': { 'ale_enabled': 0,
      \             'ale_fixers': {}
      \         }
      \ }

" Only running linters you asked for.
let g:ale_linters_explicit = 1
" Enable completion where available.
" " This setting must be set before ALE is loaded.
" "
" " You should not turn this setting on if you wish to use ALE as a completion
" " source for other completion plugins, like Deoplete.
let g:ale_completion_enabled = 1
" an omni-completion function you can use for triggering completion manually
" with <C-x><C-o>.
set omnifunc=ale#completion#OmniFunc

let g:airline#extensions#ale#enabled = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 1
let g:ale_list_window_size = 5


