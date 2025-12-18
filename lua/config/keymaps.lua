require"genvim".keymaps {
	["<leader>u"] = { "<cmd>noh<CR>",            desc = "Clear highlight" },
	["<leader>s"] = { "<cmd>w<CR>",              desc = "Save" },
	["<leader>c"] = { function() vim.cmd(":split|:term " .. require"CC".get()) end, desc = "Compile" },
	["C"]         = { "cc",                      desc = "Change line" },
	["<CR>"]      = { "<End>",                   desc = "End of line" },
	["<C-l>"]     = { "zl", mode = { "n", "v" }, desc = "Scroll right single" },
	["<C-k>"]     = { "zL", mode = { "n", "v" }, desc = "Scroll right" },
	["<C-h>"]     = { "zh", mode = { "n", "v" }, desc = "Scroll left single" },
	["<C-j>"]     = { "zH", mode = { "n", "v" }, desc = "Scroll left" },
}
