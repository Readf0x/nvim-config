return require"genvim".inject {
	{
		name = "gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		keys = function() local gs = require"gitsigns.actions"; return require"genvim".plug_keymaps {
			["<C-g>r"] = { function() gs.reset_hunk() end, mode = {"n","v"}, desc = "Reset hunk" },
			["<C-g>s"] = { function() gq.stage_hunk() end, mode = {"n","v"}, desc = "Stage hunk" },
			["<C-g>S"] = { function() gs.stage_buffer() end, desc = "Stage buffer" },
			["<C-g>u"] = { function() gs.undo_stage_hunk() end, desc = "Undo stage" },
			["<C-g>R"] = { function() gs.reset_buffer() end, desc = "Reset buffer" },
			["<C-g>p"] = { function() gs.preview_hunk() end, desc = "Preview hunk" },
			["<C-g>b"] = { function() gs.blame_line() end, desc = "Blame line" },
			["<C-g>d"] = { function() gs.diffthis() end, desc = "Diff" },
			["<C-g>D"] = { function() gs.toggle_deleted() end, desc = "Toggle deleted" },
		} end,
	},
	{
		name = "gitlinker.nvim",
		dependencies = { "plenary.nvim" },
		keys = {
			["<C-g>l"] = { function()
				local mode = vim.api.nvim_get_mode().mode
				if mode == "V" or mode == "\22" then mode = "v" end
				vim.fn.setreg("", require"gitlinker".get_buf_range_url(mode))
			end, mode = {"n","v"}, desc = "Copy line url" },
			["<C-g>R"] = { function()
				vim.fn.setreg("", require"gitlinker".get_repo_url())
			end, desc = "Copy repo url" },
		},
	},
	{
		-- TODO: configure
		name = "git-conflict.nvim",
	},
	{
		name = "lazygit.nvim",
		keys = {
			["<C-g>g"] = { function() require"lazygit".lazygit() end, desc = "LazyGit" }
		}
	}
}
