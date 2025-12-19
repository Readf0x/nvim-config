return require"genvim".inject {
  {
    name = "mini.nvim",
    lazy = false,
    config = function()
      require("mini.ai").setup({ enable = true })
      require("mini.icons").setup({ enable = true })
      require("mini.pairs").setup({
        markdown = true,
        modes = { command = true, insert = true, terminal = false },
        skip_next = "[=[[%w%%%'%[%\"%.%`%$]]=]",
        skip_ts = '{ "string" }',
        skip_unbalanced = true,
      })
      require("mini.surround").setup({ enable = true })
    end,
  },
  {
    name = "CC",
    dir = vim.fn.stdpath("config"),
    config = function() require"CC".setup() end,
    keys = {
      ["<leader>c"] = { function() vim.cmd(":split|:term " .. require"CC".get()) end, desc = "Compile" },
    },
    cmd = {"CC"}
  },
  {
    name = "vim-easy-align",
    keys = {
      ["<leader>A"] = { ":EasyAlign ",         mode = {"n","v"}, desc = "Align" },
      ["<leader>V"] = { "vi{:EasyAlign<CR>* ", mode = {"n","v"}, desc = "Align Struct" },
    },
    cmd = "EasyAlign"
  },
}
