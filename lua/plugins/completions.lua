return require"genvim".inject {
  {
    name = "nvim-cmp",
    dependencies = { "luasnip",
    	{ name = "cmp-nvim-lsp" },
    	{ name = "cmp-nvim-lsp-document-symbol" },
    },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = function()
    	vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
    	local cmp = require"cmp"
    	return {
    		mapping = {
    			["<C-Esc>"] = cmp.mapping(function(fallback)
    				if cmp.visible() then
    					cmp.abort()
    				else
    					fallback()
    				end
    			end),
    			["<C-Space>"] = cmp.mapping.complete(),
    			["<C-d>"] = cmp.mapping.scroll_docs(-4),
    			["<C-e>"] = cmp.mapping.close(),
    			["<C-u>"] = cmp.mapping.scroll_docs(4),
    			["<CR>"] = cmp.mapping(function(fallback)
    				if cmp.visible() then
    					if require"luasnip".expandable() then
    						require"luasnip".expand()
    					else
    						cmp.confirm({ select = true })
    					end
    				else
    					fallback()
    				end
    			end),
    			["<S-Tab>"] = cmp.mapping(function(fallback)
    				if cmp.visible() then
    					cmp.select_prev_item()
    				elseif require"luasnip".locally_jumpable(-1) then
    					require"luasnip".jump(-1)
    				else
    					fallback()
    				end
    			end, { "i", "s" }),
    			["<Tab>"] = cmp.mapping(function(fallback)
    				if cmp.visible() then
    					cmp.select_next_item()
    				elseif require"luasnip".locally_jumpable(1) then
    					require"luasnip".jump(1)
    				else
    					fallback()
    				end
    			end, { "i", "s" }),
    		},
    		preselect = cmp.PreselectMode.None,
    		sources = {
    			{ group_index = 1, name = "calc", priority = 4 },
    			{ group_index = 1, name = "luasnip", priority = 4 },
    			{ group_index = 1, name = "nvim_lsp", priority = 2 },
    			{ group_index = 2, name = "nvim_lsp_document_symbol", priority = 2 },
    			{ group_index = 2, name = "treesitter", priority = 2 },
    			{ group_index = 2, name = "fuzzy_buffer", priority = 1 },
    		},
    	}
    end
  },
  {
    name = "luasnip",
    dependencies = {{
    	name = "friendly-snippets",
    	config = function()
    		require("luasnip.loaders.from_vscode").lazy_load()
    	end,
    }},
    config = function()
    	require("luasnip").config.setup({})
    	require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })
    end,
    keys = {
    	["<C-n>"] = {
    		function()
    			ls = require"luasnip"
    			if ls.choice_active() then
    				ls.change_choice(1)
    			end
    		end,
    		desc = "Prev choice",
    	},
    	["<C-m>"] = {
    		function()
    			ls = require"luasnip"
    			if ls.choice_active() then
    				ls.change_choice(-1)
    			end
    		end,
    		desc = "Next choice",
    	},
    }
  }
}
