local M = {}

M.plugins = vim.fn.stdpath("data") .. "/nix-plugins"

function M.inject(specs)
	base = base or M.plugins

	for _, spec in ipairs(specs) do
		if type(spec) == "table"
			and spec.name
			and not spec.dir
		then
			spec.dir = base .. "/" .. spec.name
		end
	end

	return specs
end

return M
