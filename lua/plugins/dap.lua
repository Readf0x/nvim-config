local launch_config = {}
local function get_sel()
  local s_start = vim.fn.getpos("'<")
  local s_end   = vim.fn.getpos("'>")

  return vim.api.nvim_buf_get_text(
    0,
    s_start[2] - 1, s_start[3] - 1,
    s_end[2] - 1,   s_end[3],
    {}
  )
end

return require"genvim".inject {
  {
    name = "nvim-dap",
    dependencies = {"nvim-dap-virtual-text"},
    config = function()
      local dap = require"dap"
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
      }
      dap.configurations.c = {
        {
          name = "Launch",
          type = "gdb",
          request = "launch",
          program = function()
            program = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            launch_config = {
              name = "Launch",
              type = "gdb",
              request = "launch",
              program = program,
              args = {},
              cwd = "${workspaceFolder}",
              stopAtBeginningOfMainSubprogram = false,
            }
            return program
          end,
          args = {}, -- provide arguments if needed
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Launch with args",
          type = "gdb",
          request = "launch",
          program = function()
            local program = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            launch_config.name = "Launch"
            launch_config.type = "gdb"
            launch_config.request = "launch"
            launch_config.program = program
            launch_config.cwd = "${workspaceFolder}"
            launch_config.stopAtBeginningOfMainSubprogram = false
            return program
          end,
          args = function()
            local args = vim.fn.split(vim.fn.input('Args: ', ''), " ")
            launch_config.args = args
            return args
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Select and attach to process",
          type = "gdb",
          request = "attach",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          pid = function()
            local name = vim.fn.input('Executable name (filter): ')
            return require("dap.utils").pick_process({ filter = name })
          end,
          cwd = '${workspaceFolder}'
        },
        {
          name = 'Attach to gdbserver :1234',
          type = 'gdb',
          request = 'attach',
          target = 'localhost:1234',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}'
        }
      }
      dap.configurations.odin = dap.configurations.c
      local signs = {
        DapBreakpoint          = { "●", "DiagnosticOk" },
        DapBreakpointCondition = { "○", "DiagnosticWarn" },
        DapBreakpointRejected  = { "!", "DiagnosticError" },
        DapLogPoint            = { "", "DiagnosticInfo" },
        DapStopped             = { "→", "DiagnosticOk" }
      }
      for name, sign in pairs(signs) do
        vim.fn.sign_define(name, { text = sign[1], texthl = sign[2] })
      end
    end,
    keys = function() local dap = require"dap"; return {
      ["<M-d>c"] = { dap.continue, desc = "Continue" },
      ["<M-d>N"] = { "<cmd>DapNew<CR>", desc = "New" },
      ["<M-d>p"] = { dap.pause, desc = "Pause" },
      ["<M-d>s"] = { dap.step_into, desc = "Step Into" },
      ["<M-d>f"] = { dap.step_out, desc = "Step Out" },
      ["<M-d>n"] = { dap.step_over, desc = "Step Over" },
      ["<M-d>C"] = { dap.run_to_cursor, desc = "Run to cursor" },
      ["<M-d>t"] = { dap.terminate, desc = "Terminate" },
      ["<M-d>b"] = { dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
      ["<M-d>R"] = { require"dap.repl".toggle, desc = "Toggle Repl" },
      ["<M-d>r"] = {
        function()
          if dap.session() then
            dap.restart()
          else
            if launch_config.program then
              dap.run(launch_config)
            else
              vim.cmd([[DapNew]])
            end
          end
        end,
        desc = "Restart"
      },
      -- TODO: use treesitter to get the variable name or maybe even expression
      ["<M-d>p"] = {
        function()
          local sel = get_sel()
          if #sel > 1 or string.find(sel[1], "[ \n]") then
            print("Invalid selection")
          else
            vim.api.nvim_input("<Esc>")
            dap.repl.execute("p " .. sel[1])
          end
        end,
        mode = "v",
        desc = "Print value"
      }
    } end,
    cmd = {
      "DapContinue",
      "DapNew",
      "DapPause",
      "DapStepInto",
      "DapStepOut",
      "DapStepOver",
      "DapTerminate",
      "DapToggleBreakpoint",
      "DapToggleRepl",
    },
  },
  {
    name = "nvim-dap-view",
    dependencies = {"nvim-dap"},
    keys = {
      ["<M-d>v"] = { "<cmd>DapViewToggle<CR>", mode = "n", desc = "Toggle View" },
    },
    cmd = {"DapViewToggle"},
  },
  {
    name = "nvim-dap-virtual-text",
    dependencies = {"nvim-dap"},
    opts = {
      enabled_commands = true,
      virt_text_pos = "inline",
    },
    keys = function() local vt = require"nvim-dap-virtual-text"; return {
      ["<M-d>Vr"] = { function() vt.refresh() end, mode = "n", desc = "Force Refresh" },
      ["<M-d>Vt"] = { function() vt.toggle() end, mode = "n", desc = "Toggle" },
    } end,
    -- cmd = { "DapVirtualTextForceRefresh", "DapVirtualTextToggle" },
  },
}
