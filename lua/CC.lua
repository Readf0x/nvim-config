local function runner(name)
  local r = {
    def_cmd = "echo no "..name.." command set",
    set_cmd = "",
  }
  function r:get()
    if self.set_cmd ~= "" and self.set ~= nil then
      if type(self.set_cmd) == "function" then
        return self.set_cmd()
      else
        return self.set_cmd
      end
    else
      if type(self.def_cmd) == "function" then
        return self.def_cmd()
      else
        return self.def_cmd
      end
    end
  end
  function r:def(str) self.def_cmd = str end
  function r:set(str) self.set_cmd = str end
  function r:run() vim.cmd(":split|:term " .. self:get()) end
  return r
end

local M = {
  compile = runner("compile"),
  run     = runner("run"),
}

function M.setup(opts)
  opts = opts or {}
  vim.api.nvim_create_user_command("CC", function(opts)
    if opts.args == "" then
      M.compile:run()
    else
      M.compile:set(opts.args)
    end
  end, { desc = "Set or run compile command", nargs = "*" })
  vim.api.nvim_create_user_command("RC", function(opts)
    if opts.args == "" then
      M.run:run()
    else
      M.run:set(opts.args)
    end
  end, { desc = "Set or run run command", nargs = "*" })
end

return M

