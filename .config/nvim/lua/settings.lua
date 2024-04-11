local opt = vim.opt

vim.cmd [[filetype indent plugin on]] 	-- auto indent
vim.cmd [[syntax on]] 			-- enable syntax highlighting

vim.cmd [[set spell spelllang=nl,en]] 	-- spell checking

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
vim.cmd [[set nostartofline]] 		-- disable some start of line movements

opt.laststatus = 2 			-- always display status line
opt.confirm = true 			-- raise dialog for unsaved changes

opt.visualbell = true 			-- disable bell/beep
vim.cmd [[set t_vb=]]

opt.mouse = 'a' 			-- allow mouse usage

opt.cmdheight = 3 			-- set command window height

opt.ruler = true 			-- display cursor position
opt.number = true 			-- enable line numbering
opt.relativenumber = true 		-- set line numbering to be relative to cursor

opt.shiftwidth = 4 			-- indentation defaults
opt.tabstop = 4
-- expand tabs to spaces to fix alignment issues with the venn plugin.
-- I don't care about the extra bytes used, it does introduce alignment
-- issues with general usage
opt.expandtab = false

-- Use a tab width of 2 for xml-style files
vim.cmd [[autocmd FileType xml,html,xhtml,javascriptreact setlocal shiftwidth=2 tabstop=2]]


--cmd [[set nowrap]] 			-- no line wrapping
opt.encoding = 'utf-8'

opt.clipboard = 'unnamedplus' 		-- use system clipboard by default

-------------
--  Theme  --
-------------
opt.background = 'dark'
vim.cmd [[colorscheme PaperColor]]
vim.cmd [[highlight! link FloatBorder NONE]]
vim.cmd [[highlight! link NormalFloat NONE]]

-- I honestly don't remember what this was for
vim.cmd [[
if empty(v:servername) && exists('*remote_startserver')
	call remote_startserver('VIM')
	endif
]]

-- st keybinds
vim.cmd [[
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

vim.cmd [[let g:NERDCompactSexyComs=1]]
vim.cmd [[let g:NERDCustomDelimiters={'arduino': { 'left': '/*', 'right': '*/', 'leftAlt': '//' }}]]
