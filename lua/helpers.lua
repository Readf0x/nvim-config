local M = {}

function M.keymaps(maps)
	for lhs, spec in pairs(maps) do
		local rhs = spec[1]
		if rhs == nil then
			error("Keymap for " .. lhs .. " has no RHS")
		end

		local opts = {}
		for k, v in pairs(spec) do
			if k ~= 1 then
				opts[k] = v
			end
		end

		local mode = opts.mode or "n"
		opts.mode = nil

		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

function M.autocmds(defs)
  local group = defs.group
  local group_id
  
  if group then
    group_id = vim.api.nvim_create_augroup(group, { clear = true })
  end
  
  for key, value in pairs(defs) do
    if key == "group" then
      goto continue
    end
    
    local opts = {}
    
    if type(key) == "number" then
      local event = value[1]
      opts = vim.tbl_extend("force", {}, value)
      opts[1] = nil
      
      if group_id then
        opts.group = group_id
      end
      
      vim.api.nvim_create_autocmd(event, opts)
      goto continue
    end
    
    local events, pattern = key:match("^(.+):(.+)$")
    
    if not events then
      events = key
      pattern = nil
    end
    
    local event_list = {}
    for event in events:gmatch("[^,]+") do
      table.insert(event_list, vim.trim(event))
    end
    
    if type(value) == "string" then
      opts.command = value
    elseif type(value) == "function" then
      opts.callback = value
    elseif type(value) == "table" then
      opts = vim.tbl_extend("force", {}, value)
    end
    
    if pattern and not opts.pattern then
      opts.pattern = pattern
    end
    
    if group_id and not opts.group then
      opts.group = group_id
    end
    
    vim.api.nvim_create_autocmd(event_list, opts)
    
    ::continue::
  end
end

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
