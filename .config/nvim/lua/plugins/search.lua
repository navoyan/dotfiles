return {
	{
		"nvim-pack/nvim-spectre",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			vim.keymap.set("n", "<leader>fR", function()
				require("spectre").toggle()
			end, {
				desc = "Toggle Spectre",
			})
			-- vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
			-- 	desc = "Search current word",
			-- })
			-- vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
			-- 	desc = "Search current word",
			-- })
			-- vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
			-- 	desc = "Search on current file",
			-- })
		end,
	},
}
