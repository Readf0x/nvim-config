local launch_config = {}
return require"genvim".inject {
  { name = "nvim-dap",
    dependencies = {"nvim-dap-virtual-text"},
    config = function()
      local dap = require"dap"
      dap.adapters.gdb = function(callback, config)
        launch_config = config
        callback {
          type = "executable",
          command = "gdb",
          args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
        }
      end
      dap.configurations.c = {
        {
          name = "Launch",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.getcwd() .. "/" .. vim.fn.input("Path to executable: ", "", "file")
          end,
          args = {},
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Launch with args",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.getcwd() .. "/" .. vim.fn.input("Path to executable: ", "", "file")
          end,
          args = function()
            return vim.fn.split(vim.fn.input("Args: ", ""), " ")
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Select and attach to process",
          type = "gdb",
          request = "attach",
          program = function()
            return vim.fn.getcwd() .. "/" .. vim.fn.input("Path to executable: ", "", "file")
          end,
          pid = function()
            local name = vim.fn.input("Executable name (filter): ")
            return require("dap.utils").pick_process({ filter = name })
          end,
          cwd = "${workspaceFolder}"
        },
        {
          name = "Attach to gdbserver :1234",
          type = "gdb",
          request = "attach",
          target = "localhost:1234",
          program = function()
            return vim.fn.getcwd() .. "/" .. vim.fn.input("Path to executable: ", "", "file")
          end,
          cwd = "${workspaceFolder}"
        }
      }

      dap.configurations.odin = dap.configurations.c

      dap.adapters.delve = function(callback, config)
        launch_config = config
        if config.mode == 'remote' and config.request == 'attach' then
          callback({
            type = 'server',
            host = config.host or '127.0.0.1',
            port = config.port or '38697'
          })
        else
          callback({
            type = 'server',
            port = '${port}',
            executable = {
              command = 'dlv',
              args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
              detached = vim.fn.has("win32") == 0,
              options = {env = {CGO_CFLAGS="-D_FORTIFY_SOURCE=0"}}
            }
          })
        end
      end
      -- TODO: args
      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}"
        },
        {
          type = "delve",
          name = "Debug binary",
          request = "launch",
          mode = "exec",
          program = function()
            return vim.fn.getcwd() .. "/" .. vim.fn.input("Path to executable: ", "", "file")
          end,
        },
        {
          type = "delve",
          name = "Debug test", -- configuration for debugging test files
          request = "launch",
          mode = "test",
          program = "${file}"
        },
        {
          name = "Attach to delve",
          type = "delve",
          request = "attach",
          target = "localhost:${port}",
          program = function()
            return vim.fn.getcwd() .. "/" .. vim.fn.input("Path to executable: ", "", "file")
          end,
          cwd = "${workspaceFolder}"
        }
      }
      -- dap.listeners.after.variables["local_config"] = function(session, error, response)
      --   inspect(response, true)
      -- end
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
      ["<M-d>P"] = { dap.pause, desc = "Pause" },
      ["<M-d>s"] = { dap.step_into, desc = "Step into" },
      ["<M-d>f"] = { dap.step_out, desc = "Step out" },
      ["<M-d>n"] = { dap.step_over, desc = "Step over" },
      ["<M-d>C"] = { dap.run_to_cursor, desc = "Run to cursor" },
      ["<M-d>t"] = { dap.terminate, desc = "Terminate" },
      ["<M-d>b"] = { dap.toggle_breakpoint, desc = "Toggle breakpoint" },
      ["<M-d>B"] = { dap.clear_breakpoints, desc = "Clear breakpoints" },
      ["<M-d>R"] = { require"dap.repl".toggle, desc = "Toggle repl" },
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
          if vim.fn.mode() == "n" then
            vim.api.nvim_input('"dyiw')
          else
            vim.api.nvim_input('"dy')
          end
          vim.schedule(function()
            word = vim.fn.getreg("d")
            if string.find(word, "\n") then
              print("Invalid selection")
            else
              vim.api.nvim_input("<Esc>")
              dap.repl.execute("p " .. word)
            end
          end)
        end,
        mode = {"n","v"},
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
  { name = "nvim-dap-view",
    dependencies = {"nvim-dap"},
    keys = {
      ["<M-d>v"] = { "<cmd>DapViewToggle<CR>", mode = "n", desc = "Toggle View" },
    },
    cmd = {
      "DapViewClose",
      "DapViewJump",
      "DapViewNavigate",
      "DapViewOpen",
      "DapViewShow",
      "DapViewToggle",
      "DapViewWatch",
    },
  },
  { name = "nvim-dap-virtual-text",
    config = function() require"nvim-dap-virtual-text".setup{
      enabled_commands = true,
      virt_text_pos = "inline",
    } end,
    keys = function() local vt = require"nvim-dap-virtual-text"; return {
      ["<M-d>Vr"] = { function() vt.refresh() end, mode = "n", desc = "Force Refresh" },
      ["<M-d>Vt"] = { function() vt.toggle() end, mode = "n", desc = "Toggle" },
    } end,
    cmd = {
      "DapVirtualTextDisable",
      "DapVirtualTextEnable",
      "DapVirtualTextForceRefresh",
      "DapVirtualTextToggle",
    },
  },
}
