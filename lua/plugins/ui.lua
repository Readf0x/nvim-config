return require"genvim".inject {
  {
    name = "everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd(table.concat(vim.fn.readfile(vim.fn.expand("$HOME") .. "/.local/share/nvim/highlights.vim"), "\n"))
      vim.cmd([[colorscheme everforest]])
    end,
  },
  {
    name = "which-key.nvim",
    lazy = false,
    opts = {
      icons = { mappings = false },
      spec = {{
        {
          { "<M-d>",     group = "dap" },
          { "<C-g>",     group = "git" },
          { "<C-g>c",    group = "conflict" },
          { "<leader>",  group = "leader" },
          { "<leader>t", group = "telescope" },
          { "<leader>b", group = "per buffer" },
        },
        mode = { "n", "v" }
      }}
    }
  },
  {
    name = "lualine.nvim",
    lazy = false,
    opts = {
      options = {
        component_separators = { left = "┃", right = "┃" },
        ignore_focus = {
          "neo-tree",
          "nvim-tree",
          "mini-files",
          "dap-repl",
          "dap-view",
          "dap-view-term"
        },
        extensions = { "neo-tree" },
        section_separators = { left = "", right = "" },
        theme = {
          command = {
            a = { bg = "#e69875", fg = "#343f44" },
            b = { bg = "#475258", fg = "#d3c6aa" },
            c = { bg = "#343f44", fg = "#859289" },
          },
          insert = {
            a = { bg = "#a7c080", fg = "#343f44" },
            b = { bg = "#475258", fg = "#d3c6aa" },
            c = { bg = "#343f44", fg = "#859289" },
          },
          normal = {
            a = { bg = "#e67e80", fg = "#343f44" },
            b = { bg = "#475258", fg = "#d3c6aa" },
            c = { bg = "#343f44", fg = "#859289" },
          },
          visual = {
            a = { bg = "#d699b6", fg = "#343f44" },
            b = { bg = "#475258", fg = "#d3c6aa" },
            c = { bg = "#343f44", fg = "#859289" },
          },
        },
      },
      sections = { lualine_x = { "encoding", "filetype" } },
    }
  },
  {
    name = "neo-tree.nvim",
    dependencies = {{ name = "nui.nvim" }},
    keys = {
      ["<leader>e"] = { "<cmd>Neotree toggle<CR>", desc = "File Tree" }
    }
  },
  {
    name = "ccc.nvim",
    config = function() require"ccc".setup() end,
    keys = {["<leader>p"] = { "<cmd>CccPick<CR>", desc = "Color Picker" }},
    cmd = "CccPick"
  },
  {
    name = "nvim-colorizer.lua",
    config = function() require"colorizer".setup() end,
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  },
  -- markdown
  {
    name = "render-markdown.nvim",
    ft = "markdown",
    dependencies = {{ name = "image.nvim" }},
  },
}

