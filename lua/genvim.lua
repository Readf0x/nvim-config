local M = {}

M.plugins = vim.fn.stdpath("data") .. "/nix-plugins"

function M.inject(specs)
  base = base or M.plugins

  for _, spec in ipairs(specs) do
    if type(spec) == "table" then
    	if spec.name and not spec.dir then
    		spec.dir = base .. "/" .. spec.name
    	end
    	if spec.keys then
    		if type(spec.keys) == "table" then
    			spec.keys = M.plug_keymaps(spec.keys)
    		elseif type(spec.keys) == "function" then
    			local keys = spec.keys
    			spec.keys = function() return M.plug_keymaps(keys()) end
    		end
    	end
    	if spec.dependencies then
    		spec.dependencies = M.inject(spec.dependencies)
    	end
    end
  end

  return specs
end

function M.plug_keymaps(maps)
  local fin = {}
  for lhs, spec in pairs(maps) do
    local opts = {}

    opts[1] = lhs

    opts[2] = spec[1]
    if opts[2] == nil then
    	error("Keymap for " .. lhs .. " has no RHS")
    end

    for k, v in pairs(spec) do
    	if k ~= 1 then
    		opts[k] = v
    	end
    end

    -- vim.keymap.set(mode, lhs, rhs, opts)
    table.insert(fin, opts)
  end
  return fin
end

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

return M
