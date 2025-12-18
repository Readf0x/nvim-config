local genvim = require("genvim")

require"lazy".setup {
	defaults = { lazy = true },
	install = { missing = false },
	checker = { enabled = false },
	change_detection = { notify = false },

	spec = genvim.inject {
		{ import = "plugins" },
	},
}
