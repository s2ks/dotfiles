local opt = vim.opt
local cmd = vim.cmd

cmd [[filetype indent plugin on]] 	-- auto indent
cmd [[syntax on]] 			-- enable syntax highlighting

cmd [[set spell spelllang=nl,en]] 	-- spell checking

--opt.nocompatible = true
opt.hidden = true
opt.showcmd = true
opt.wildmenu = true
opt.showcmd = true

opt.hlsearch = true 			-- hightlight searches, disable with :noh

opt.ignorecase = true 			-- ignore case when searching
opt.smartcase = true 			-- don't ignore uppercase
opt.backspace = 'indent,eol,start' 	-- allow backspacing over indentation,
-- end of line and start of insert

opt.autoindent = true 			-- enable auto indent
cmd [[set nostartofline]] 		-- disable some start of line movements

opt.laststatus = 2 			-- always display status line
opt.confirm = true 			-- raise dialog for unsaved changes

opt.visualbell = true 			-- disable bell/beep
cmd [[set t_vb=]]

opt.mouse = 'a' 			-- allow mouse usage

opt.cmdheight = 3 			-- set command window height

opt.ruler = true 			-- display cursor position
opt.number = true 			-- enable line numbering
opt.relativenumber = true 		-- set line numbering to be relative to cursor

opt.shiftwidth = 8 			-- indentation defaults
opt.tabstop = 8
-- expand tabs to spaces to fix alignment issues with the venn plugin.
-- I don't care about the extra bytes used, it does introduce alignment
-- issues with general usage
opt.expandtab = false

-- Use a tab width of 2 for xml-style files
cmd [[autocmd FileType xml,html,xhtml setlocal shiftwidth=2 tabstop=2]]


cmd [[set nowrap]] 			-- no line wrapping
opt.encoding = 'utf-8'

opt.clipboard = 'unnamedplus' 		-- use system clipboard by default

-------------
--  Theme  --
-------------
opt.background = 'dark'
cmd [[colorscheme PaperColor]]

-- I honestly don't remember what this was for
cmd [[
if empty(v:servername) && exists('*remote_startserver')
	call remote_startserver('VIM')
	endif
]]

-- st keybinds
cmd [[
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
]]
