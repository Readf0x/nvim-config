return require"genvim".inject {
  { "readf0x/fim.nvim",
    enabled = false,
    opts = {
      model = "qwen2.5-coder:7b",
      context_mode = "directory_buffers",
    },
    cmd = { "FimQuery", "FimToggleContext", "FimEmergencyStop" },
    keys = function() local fim = require"fim"; return {
      ["gA"]      = { function () fim:query() end, desc = "FIM autofill" },
      ["<C-S-A>"] = { function () fim:query() end, mode = "i", desc = "FIM autofill" },
    } end,
  },
}
