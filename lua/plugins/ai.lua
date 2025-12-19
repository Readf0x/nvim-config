return require"genvim".inject {
  { "readf0x/starcoder",
    opts = { model = "starcoder2:7b" },
    cmd = "SCQuery",
    keys = function() local sc = require"starcoder"; return {
      ["gS"]      = { sc.query, desc = "Query StarCoder" },
      ["<C-S-A>"] = { function()
        sc.query()
        vim.schedule(function()
          vim.api.nvim_input("<Esc>")
        end)
      end, mode = "i", desc = "Query StarCoder" },
    } end,
  }
}
