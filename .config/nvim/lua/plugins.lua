-- Load plugins

local cmd 	= vim.cmd
local g 	= vim.g

local function Plug(arg)
	cmd('Plug ' .. "'" .. arg .. "'")
end

-- Load vim-plug
cmd [[call plug#begin(stdpath('data') . '/plugged')]]

-- extended support for Ctrl-A/Ctrl-X
Plug 'qwertologe/nextval.vim'

-- highlight trailing whitespaces and fix with :FixWhitespaces
Plug 'bronson/vim-trailing-whitespace'

-- some extra color schemes
Plug 'flazz/vim-colorschemes'
Plug 'rafi/awesome-vim-colorschemes'

-- snippet engine
Plug 'SirVer/ultisnips'
g.UltiSnipsExpandTrigger 	= "<S-Tab>"
g.UltiSnipsJumpForwardTrigger 	= "<C-Down>"
g.UltiSnipsJumpBackwardTrigger 	= "<C-Up>"
g.UltiSnipsSnippetDirectories 	= { "UltiSnips", "custom_snips" }

-- Snippets
Plug 'honza/vim-snippets'

-- VimCompletesMe
Plug 'ajh17/VimCompletesMe'

-- Draw diagrams
Plug 'jbyuki/venn.nvim'

-------------------
--  Latex stuff  --
-------------------

--Vimtex plugin
Plug 'lervag/vimtex'

g.vimtex_view_method 		= 'zathura'
g.vimtex_view_use_temp_files 	= true
g.vimtex_compiler_latexmk 	= {
	build_dir 	= '',
	callback 	= true,
	continuous 	= true,
	executable 	= latexmk,
	hooks 		= {},
	options 	= {
		'-verbose',
		'-file-line-error',
		'-synctex=1',
		'-interaction=nonstopmode',
		'-shell-escape'
	}
}
g.tex_flavor 		= 'latex'
g.vimtex_grammar_vlty 	= {
	lt_command 	= 'languagetool',
	show_suggestions= true
}

-------------------
--  Status line  --
-------------------

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

g.airline_powerline_fonts = true

-- candidates:
-- 	bubblegum, behelit, angr, wombat, violet, [tender], seoul256, lighthaus
--

g.airline_theme = 'angr'

cmd [[let g:airline#extensions#tabline#enabled = 1]]
cmd [[let g:airline#extensions#tabline#formatter = 'unique_tail']]



cmd [[call plug#end()]]
