local function term(str) return "<cmd>split|:term " .. str .. "<CR>" end
require"genvim".autocmds {
  ["BufNewFile,BufRead:**/hypr/**/*.conf"] = "set commentstring='# %s'",
  ["TextChanged,TextChangedI,ModeChanged:*.md"] = function()
    if started == nil then
      started = os.time()
    end
    if os.time() > started then
      vim.cmd("silent write")
      started = os.time()
    end
  end,
  ["BufNewFile,BufRead:*.nix"] = function()
    MiniPairs.map_buf(vim.fn.bufnr('%'), 'i', '=', { action = 'open', pair = '=;', register = { cr = false } })
    MiniPairs.map_buf(vim.fn.bufnr('%'), 'i', ';', { action = 'close', pair = '=;', register = { cr = false } })
    require"genvim".keymaps {
      ["<C-e>"]      = { function() require("luasnip").snip_expand(require("luasnip").get_snippets().nix[1]) end, mode = "i", buffer = vim.fn.bufnr("%") },
      ["<M-C-e>"]    = { function() require("luasnip").snip_expand(require("luasnip").get_snippets().nix[3]) end, mode = "i", buffer = vim.fn.bufnr("%") },
      ["<leader>bh"] = { term"nh home switch .", buffer = vim.fn.bufnr("%"), desc = "Build Home-Manager" },
      ["<leader>bt"] = { term"nh os test .", buffer = vim.fn.bufnr("%"), desc = "System rebuild test" },
      ["<leader>br"] = { term"nh os switch .", buffer = vim.fn.bufnr("%"), desc = "System rebuild switch" },
      ["<C-f>"]      = { "f v3whc.<Esc>jddk", buffer = vim.fn.bufnr("%"), desc = "Format one line attr set" },
      ["<M-C-f>"]    = { "<cmd>s/\\.\\(.*;\\)/ = { \\1 };<CR>f{lr<CR>$F r<CR><cmd>noh<CR>", buffer = vim.fn.bufnr("%"), desc = "Format one line attr set" },
    }
  end,
  ["BufNewFile,BufRead:*.odin"] = function()
    local dir = vim.api.nvim_buf_get_name(0):match("(.*/)")
    require"CC".compile:def("odin build "..dir.." -debug")
    require"CC".run:def("odin run "..dir)
  end,
  ["BufNewFile,BufRead:*.go"] = function()
    local dir = vim.api.nvim_buf_get_name(0):match("(.*/)")
    require"CC".compile:def('go build -gcflags=all="-N -l" '..dir)
    require"CC".run:def('go run '..dir)
  end,
  ["BufNewFile,BufRead:*.js"] = function()
    require"CC".run:def('node '..vim.api.nvim_buf_get_name(0))
  end,
  ["BufNewFile,BufRead:*.py"] = function()
    require"CC".run:def('python3 '..vim.api.nvim_buf_get_name(0))
  end,
  ["BufNewFile,BufRead:*.sh"] = function()
    require"CC".run:def(vim.api.nvim_buf_get_name(0))
  end,
  ["BufNewFile,BufRead:*.bash"] = function()
    require"CC".run:def('bash '..vim.api.nvim_buf_get_name(0))
  end,
  ["BufNewFile,BufRead:*.zsh"] = function()
    require"CC".run:def('zsh '..vim.api.nvim_buf_get_name(0))
  end,
  ["BufNewFile,BufRead:*.fish"] = function()
    require"CC".run:def('fish '..vim.api.nvim_buf_get_name(0))
  end,
  ["BufNewFile,BufRead:*.tet"] = function()
    require"genvim".keymaps {
      ["<C-e>"]      = { function() require("luasnip").snip_expand(require("luasnip").get_snippets().tet[1]) end, mode = "i", buffer = vim.fn.bufnr("%") },
      ["<leader>bb"] = { "<cmd>!te "..vim.fn.expand("%p").."<CR>", buffer = vim.fn.bufnr("%"), desc = "Process file" },
    }
    vim.opt_local.filetype = "tet"
  end,
  ["BufNewFile,BufRead:*.html.tet"] = function()
    require"luasnip".filetype_extend("tet", { "html" })
  end,
  ["BufNewFile,BufRead:*.css.tet"] = "set filetype=css",
  ["BufNewFile,BufRead:*.md"] = "set filetype=markdown",
  ["TermOpen:*"] = "startinsert",
}
