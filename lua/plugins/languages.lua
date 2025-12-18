return require"genvim".inject {
  {
    name = "nvim-treesitter", lazy = false,
    config = function()
    	require"nvim-treesitter.configs".setup {
    		highlight = { enable = true },
    		indent = { enable = true },
    		parser_install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
    	}
    end,
  },
  -- LSP
  {
    name = "nvim-lspconfig",
    dependencies = require"genvim".inject {{
    	name = "lsp_signature.nvim",
    	opts = {
    		fix_pos = true,
    		handler_opts = { border = "none" },
    		hint_prefix = "? "
    	},
    }},
    lazy = false,
    config = function()
    	for lsp, settings in pairs({
    		bashls = {},
    		gopls = {},
    		html = { settings = { filetypes = { "html", "templ" } } },
    		htmx = { settings = { filetypes = { "html", "templ" } } },
    		jsonls = { settings = { json = {
    			schemas = {
    				{ fileMatch = { "package.json" }, url = "https://json.schemastore.org/package.json" },
    				{ fileMatch = { "tsconfig*.json" }, url = "https://json.schemastore.org/tsconfig.json" },
    				{
    					fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
    					url = "https://json.schemastore.org/prettierrc.json",
    				},
    				{
    					fileMatch = { ".eslintrc", ".eslintrc.json" },
    					url = "https://json.schemastore.org/eslintrc.json",
    				},
    				{
    					fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
    					url = "https://json.schemastore.org/babelrc.json",
    				},
    				{ fileMatch = { "lerna.json" }, url = "https://json.schemastore.org/lerna.json" },
    				{ fileMatch = { "now.json", "vercel.json" }, url = "https://json.schemastore.org/now.json" },
    				{
    					fileMatch = { ".stylelintrc", ".stylelintrc.json", "stylelint.config.json" },
    					url = "http://json.schemastore.org/stylelintrc.json",
    				},
    			}
    		}}},
    		nil_ls = { settings = { ["nil"] = { nix = { flake = { autoArchive = true } } } } },
    		ocamllsp = {},
    		ols = {},
    		qmlls = { cmd = { "qmlls", "-E" } },
    		templ = {},
    	}) do
    		vim.lsp.config(lsp, settings)
    		vim.lsp.enable(lsp)
    	end
    end,
    keys = {
    	["gd"] = { vim.lsp.buf.definition, desc = "Goto Definition" },
    	["gr"] = { vim.lsp.buf.references, desc = "References" },
    	["gI"] = { vim.lsp.buf.implementation, desc = "Goto Implementation" },
    	["gy"] = { vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
    	["gD"] = { vim.lsp.buf.declaration, desc = "Goto Declaration" },
    	["K"] = { function() return vim.lsp.buf.hover() end, desc = "Hover" },
    	["gK"] = { function() return vim.lsp.buf.signature_help() end, desc = "Signature Help" },
    	["<c-k>"] = { function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help" },
    },
  },
}
