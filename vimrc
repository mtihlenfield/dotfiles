set nocompatible              " be iMproved, required
filetype off                  " required

" test
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'w0rp/ale'
" Plugin 'embear/vim-localvimrc'
Plugin 'SirVer/ultisnips'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'junegunn/fzf',
Plugin 'junegunn/fzf.vim'
Plugin 'honza/vim-snippets'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'arcticicestudio/nord-vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'majutsushi/tagbar'
" I'd like to use this but it cause a ~3 second delay when changing from
" insert-> normal mode
" Plugin 'townk/vim-autoclose'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Python
let python_highlight_all=1
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_autoclose_preview_window_after_completion=1

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
" Search and replace word in file
nmap <S-r> "ryiw :%s/<C-R>r/
setl ts=4 softtabstop=4 sw=4 et autoindent
au BufWritePre *.sh,*.md,*.txt,*.c,*.jsx,*.js,*.py %s/\s\+$//e " Get rid of extra whitespace on save
set updatetime=200 " Mostly doing this so that gitgutter changes show up more quicky
set ttimeoutlen=50
set number
set relativenumber
set background=dark
set encoding=utf-8
set mouse=a
set clipboard=unnamedplus " Sets the default clipboard to the system clipboard
set virtualedit=all " TODO I only really want this for markdown/rs/text
colorscheme nord
highlight LineNr ctermfg=grey
syntax on
