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

"" snippet engine
"Plug 'SirVer/ultisnips'
"let g:UltiSnipsExpandTrigger="<S-Tab>"
"let g:UltiSnipsJumpForwardTrigger="<C-Down>"
"let g:UltiSnipsJumpBackwardTrigger="<C-Up>"
"let g:UltiSnipsSnippetDirectories=["UltiSnips", "custom_snips"]

"" Snippets
"Plug 'honza/vim-snippets'

" You Complete Me
" Plug 'Valloric/YouCompleteMe'

" VimCompletesMe
Plug 'ajh17/VimCompletesMe'

call plug#end()

set nocompatible

" spell checking
set spell spelllang=nl,en

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

" no line wrapping
set nowrap

set encoding=utf-8

" use system clipboard by default
set clipboard=unnamedplus

set background=dark
colorscheme PaperColor

"if empty(v:servername) && exists('*remote_startserver')
	"call remote_startserver('VIM')
"endif

" st keybinds
if &term =~ "st"
	noremap <ESC>[1;2A 	<S-Up>
	noremap <ESC>[1;2B 	<S-Down>
	noremap <ESC>[1;2D 	<S-Left>
	noremap <ESC>[1;2C 	<S-Right>
	noremap [1;5D 	<C-Left>
	noremap [1;5C 	<C-Right>
	noremap [1;5A 	<C-Up>
	noremap [1;5B 	<C-Down>
endif
