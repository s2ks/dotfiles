local cmd 	= vim.cmd
local b 	= vim.b
local map 	= vim.api.nvim_buf_set_keymap

function _G.toggle_venn()
	local venn_enabled = vim.b.venn_enabled

	if not venn_enabled then
		b.venn_enabled = true
		cmd [[setlocal ve=all]]

		-- Expand tabs to spaces when in venn mode
		-- to work around alignment issues that occur when
		-- using tabs
		cmd [[setlocal expandtab]]

		map(0, "n", "<S-Up>", "<C-v>k:VBox<CR>", { noremap = true })
		map(0, "n", "<S-Down>", "<C-v>j:VBox<CR>", { noremap = true })
		map(0, "n", "<S-Left>", "<C-v>h:VBox<CR>", { noremap = true})
		map(0, "n", "<S-Right>", "<C-v>l:VBox<CR>", { noremap = true })

		map(0, "v", "f", ":VBox<CR>", { noremap = true })
		map(0, "v", "F", ":VBoxO<CR>", { noremap = true})

		cmd [[echo "Venn enabled..."]]
	else
		cmd [[setlocal ve=]]
		cmd [[setlocal noexpandtab]]
		cmd [[mapclear <buffer>]]
		cmd [[echo "Venn disabled..."]]
		b.venn_enabled = false
	end
end

vim.api.nvim_set_keymap("n", "<leader>v", ":lua toggle_venn()<CR>", { noremap = true })
