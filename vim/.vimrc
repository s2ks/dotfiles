" install vim-plug (https://github.com/junegunn/vim-plug):
"
"   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')

" extended support for Ctrl-A/Ctrl-X
Plug 'qwertologe/nextval.vim'

" some extra color schemes
Plug 'flazz/vim-colorschemes'
Plug 'rafi/awesome-vim-colorschemes'

" highlight trailing whitespaces and fix with :FixWhitespaces
Plug 'bronson/vim-trailing-whitespace'

" fancy status line
Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim'}
let g:powerline_pycmd="py3"

" Vim Tex plugin
Plug 'lervag/vimtex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_use_temp_files = 1
let g:tex_flavor = 'latex'

" You Complete Me
" Plug 'Valloric/YouCompleteMe'

" VimCompletesMe
Plug 'ajh17/VimCompletesMe'

call plug#end()

set nocompatible

" auto-indent
filetype indent plugin on

" syntax highlighting
syntax on

" no idea what this does
set hidden

" better command-line completion according to wiki
set wildmenu

set showcmd

" hightlight searches, disable temporarily with :noh
set hlsearch

" ignore case when searching
set ignorecase

" dont ignore uppercase
set smartcase

" allow backspacing over indentation, end of line and start of insert
set backspace=indent,eol,start

" enable automatic indentation
set autoindent

" disable some start of line movements
set nostartofline

" display cursor position
set ruler

" always display status line
set laststatus=2

" raise dialogue for unsaved changes
set confirm

" disable bell/beep
set visualbell
set t_vb=

" enable mouse usage
set mouse=a

" set command window height to x lines
set cmdheight=3
" enable line number / relative numbering
set number
set relativenumber

" some keycode timeouts
set notimeout ttimeout ttimeoutlen=200

" toggle between paste and nopaste
set pastetoggle=<F11>

" indentation defaults for easy switching
set shiftwidth=8
set tabstop=8

set encoding=utf-8

" use system clipboard by default
set clipboard=unnamedplus

set background=dark
colorscheme PaperColor


" st keybinds
if &term =~ "st"
	noremap <ESC>[1;2B 	<C-F>
	noremap <ESC>[1;2A 	<C-B>
	noremap <ESC>[1;2C 	w
	noremap <ESC>[1;2D 	b
	noremap [1;5C 	$
	noremap [1;5D 	0
	noremap [1;5A 	<nop>
	noremap [1;5B 	<nop>
endif
