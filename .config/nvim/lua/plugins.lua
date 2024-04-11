-- Load plugins

local cmd 	= vim.cmd
local g 	= vim.g

local function Plug(arg)
	vim.cmd('Plug ' .. "'" .. arg .. "'")
end

vim.cmd [[let g:airline#extensions#tabline#enabled = 1]]
vim.cmd [[let g:airline#extensions#tabline#formatter = 'unique_tail']]

return {
	'neovim/nvim-lspconfig',

	'andweeb/presence.nvim',

	-- extended support for Ctrl-A/Ctrl-X
	'qwertologe/nextval.vim',

	-- highlight trailing whitespaces and fix with :FixWhitespaces
	'bronson/vim-trailing-whitespace',

	-- some extra color schemes
	'flazz/vim-colorschemes',
	'rafi/awesome-vim-colorschemes',

	-- snippet engine
	{'SirVer/ultisnips', init = function()
		g.UltiSnipsExpandTrigger 	= "<S-Tab>"
		g.UltiSnipsJumpForwardTrigger 	= "<C-Down>"
		g.UltiSnipsJumpBackwardTrigger 	= "<C-Up>"
		g.UltiSnipsSnippetDirectories 	= { "UltiSnips", "custom_snips" }
	end},

	-- Snippets
	'honza/vim-snippets',

	-- Draw diagrams
	'jbyuki/venn.nvim',

	-- QML syntax highlighting
	--'peterhoeg/vim-qml',

	{'ycm-core/YouCompleteMe', init = function()
		g.ycm_key_list_select_completion = {"<Down>"}
		g.ycm_key_list_previous_completion = {"<Up>"}
	end},

	'preservim/nerdcommenter',

	-- Better js?
	'pangloss/vim-javascript',

	-------------------
	--  Latex stuff  --
	-------------------

	--Vimtex plugin
	{'lervag/vimtex', init = function()
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

		g.vimtex_fold_enabled 	= true
	end},

	----------------
	--  Markdown  --
	----------------
	{'iamcco/markdown-preview.nvim', config = function()
		vim.fn["mkdp#util#install"]()
	end,
	init = function()
		g.mkdp_autostart 	= true
	end},

	-------------------
	--  Status line  --
	-------------------

	'vim-airline/vim-airline-themes',
	{'vim-airline/vim-airline', init = function()
		g.airline_powerline_fonts = true
		-- candidates:
		-- 	bubblegum, behelit, angr, wombat, violet, [tender], seoul256, lighthaus
		-- 	See :AirlineTheme <tab> for more
		--
		g.airline_theme = 'jet'
	end},


	{'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
	},

	"xiyaowong/telescope-emoji.nvim",

	{'mrcjkb/haskell-tools.nvim',
		version = "^3",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject', 'hs' },
		lazy = false,
	},

	{"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function ()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex",
				"javascript", "html", "haskell" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end},

	{"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	--opts = {
		---- your configuration comes here
		---- or leave it empty to use the default settings
		---- refer to the configuration section below
	--}
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	},
}
