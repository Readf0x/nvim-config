vim.g.mapleader = " "

local h = require("helpers")
h.map(require){
	"config.lazy",
	"config.autocmds",
	"config.keymaps",
}

local o = {
	clipboard = 'unnamedplus',
	tabstop = 2,
	shiftwidth = 2,
	wrap = false,
	number = true,
	foldlevel = 99,
	relativenumber = true,
	signcolumn = 'yes',
	scrolloff = 10,
	splitbelow = true,
	splitright = true,
	exrc = true,
}

for k, v in pairs(o) do vim.o[k] = v end
