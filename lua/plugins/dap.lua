return require"genvim".inject {
  {
    name = "nvim-dap",
    enabled = false,
    config = function()
    	local dap = require"dap"
    	dap.adapters.gdb = {

    	}
    end,
  }
}
