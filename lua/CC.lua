local compile = {
  def = "echo no compile command set",
  set = "",
}

local M = {}

function M.get()
  if compile.set ~= "" then
    return compile.set
  else
    return compile.def
  end
end

function M.def(str)
  compile.def = str
end

function M.set(str)
  compile.set = str
end

function M.setup(opts)
  opts = opts or {}
  vim.api.nvim_create_user_command("CC", function(opts)
    compile.set = opts.args
  end, { desc = "Set compile command", nargs = "+" })
end

return M

