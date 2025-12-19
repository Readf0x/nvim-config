local genvim = require("genvim")

require"lazy".setup {
  defaults = { lazy = true },
  install = { missing = false },
  checker = { enabled = false },
  change_detection = { notify = false },
  rocks = { enabled = false },

  dev = {
    path = "~/Projects/neovim",
    patterns = { "readf0x" },
    fallback = false,
  },

  spec = genvim.inject {
    { import = "plugins" },
  },
}
