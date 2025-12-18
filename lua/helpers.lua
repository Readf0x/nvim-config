local M = {}

function M.inspect(v, split)
	if split == nil then split = false end
	local buf = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_buf_set_lines(buf, 0, 0, false, vim.fn.split(vim.inspect(v), "\n"))
	vim.api.nvim_buf_set_option(buf, "readonly", true)
	if split then
		vim.api.nvim_open_win(buf, true, { split = "below", win = 0 })
	else
		vim.api.nvim_win_set_buf(0, buf)
	end
end

function M.map(f)
	return function(vals)
		for _, v in ipairs(vals) do f(v) end
	end
end

return M
