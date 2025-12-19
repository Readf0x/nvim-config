return require"genvim".inject {
  {
    name = "telescope.nvim",
    dependencies = require"genvim".inject {
      "plenary.nvim",
      "telescope-fzf-native.nvim",
      "telescope-zoxide",
    },
    config = function()
      ts = require("telescope")
      ts.load_extension("fzf")
      ts.load_extension("zoxide")
    end,
    keys = {
      ["<leader>tb"] = { "<cmd>Telescope buffers<CR>",     desc = "Buffers" },
      ["<leader>tf"] = { "<cmd>Telescope fd<CR>",          desc = "Files" },
      ["<leader>tg"] = { "<cmd>Telescope live_grep<CR>",   desc = "Search" },
      ["<leader>ts"] = { "<cmd>Telescope grep_string<CR>", desc = "Search word", },
    },
  },
  { name = "plenary.nvim" },
  { name = "telescope-fzf-native.nvim" },
  { name = "telescope-zoxide" },
}
