set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'w0rp/ale'
Plugin 'embear/vim-localvimrc'
Plugin 'SirVer/ultisnips'
Plugin 'junegunn/fzf',
Plugin 'tpope/vim-fugitive'
Plugin 'junegunn/fzf.vim'
Plugin 'mileszs/ack.vim'
Plugin 'honza/vim-snippets'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'arcticicestudio/nord-vim'
Bundle 'Valloric/YouCompleteMe'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Python
let python_highlight_all=1
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_autoclose_preview_window_after_completion=1

" Javascript
let g:syntastic_javascript_checkers=["eslint"]

" Airline
set t_Co=256
set nosmd " Gets rid of vim mode line. Don't need it with airline
let g:airline_theme='nord'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#close_symbol = '×'
let g:airline#extensions#tabline#show_close_button = 0


" Code snippets
let g:UltiSnipsExpandTrigger="<c-space>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsUsePythonVersion = 3

" fzf
" start fuzzy file search with ;
nmap ; :Files<CR>

" nord
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_uniform_status_lines = 1

" ALE
let g:ale_linters = {"c": ["gcc"], "python": ["flake8"]}

" General
" au BufNewFile,BufRead *.md,*.txt,*.py,*.c,*.h,*.js,*.jsx,*.json,*.html,*.css,*.scss setl ts=4 softtabstop=4 sw=4 et autoindent
setl ts=4 softtabstop=4 sw=4 et autoindent
au BufWritePre *.md,*.txt,*.c,*.jsx,*.js,*.py %s/\s\+$//e " Get rid of extra whitespace on save
set number
set relativenumber
set autoindent
set background=dark
set encoding=utf-8
set mouse=a
set clipboard=unnamedplus " Sets the default clipboard to the system clipboard
colorscheme nord
highlight LineNr ctermfg=grey
syntax on
