-- local response_format = "<SYSTEM>**CRITICAL**: Respond EXACTLY in this format:\n```$ftype\n<your code>\n```\nFailure to do so is UNACCEPTABLE.</SYSTEM>"

return require"genvim".inject {
  { "readf0x/starcoder",
    opts = { model = "starcoder2:7b" },
    cmd = "SCQuery",
    keys = function() local sc = require"starcoder"; return {
      ["gS"]      = { sc.query, desc = "StarCoder autofill" },
      ["<C-S-A>"] = { sc.query, mode = "i", desc = "StarCoder autofill" },
    } end,
  },
  { name = "ollama.nvim",
    enabled = false,
    dependencies = { "plenary.nvim" },
    cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
    keys = function() local o = require"ollama"; return {
      -- TODO: make autofill work
      -- ["<C-S-A>"] = { "", mode = "i", desc = "Autofill" },
      ["gp"] = { ":<c-u>lua require'ollama'.prompt()<cr>", mode = {"n","v"}, desc = "Ollama prompt" },
    } end,
    opts = function()
      local display = require"ollama.actions.factory".create_action{ display = true, show_prompt = false, window = "vsplit" }
      return {
        model = "qwen3:8b",
        url = "http://127.0.0.1:11434",
        prompts = {
          -- FITM = {
          --   prompt = "<fim_prefix>\n$before<fim_suffix>$after<fim_middle>",
          --   model = "starcoder2:7b",
          --   action = display,
          -- },
          -- Ask_About_Code = false,
          -- Explain_Code = false,
          -- Simplify_Code = false,
          -- Modify_Code = false,
          -- Generate_Code = false,
          -- Ask_About_Selection = {
          --   prompt = "<FILE TYPE=\"$ftype\">$buf</FILE>\n<USER>$input</USER>\n<SELECTION>\n```$ftype\n$sel```\n</SELECTION>",
          --   input_label = "Q",
          --   action = display,
          -- },
          -- Ask_About_File = {
          --   prompt = "<FILE TYPE=\"$ftype\">$buf</FILE>\n<USER>$input</USER>",
          --   input_label = "Q",
          --   action = display,
          -- },
          -- Explain_Selection = {
          --   prompt = "<FILE TYPE=\"$ftype\">$buf</FILE>\n<SYSTEM>Explain the following code snippet using the FILE as context.</SYSTEM>\n<SELECTION>\n```$ftype\n$sel```\n</SELECTION>",
          -- },
          -- Simplify_Selection = {
          --   prompt = response_format .. "<FILE TYPE=\"$ftype\">$buf</FILE>\n<SYSTEM>Simplify the following code snippet to make it easier to understand, using the FILE as context.</SYSTEM>\n<SELECTION>\n```$ftype\n$sel```\n</SELECTION>\n\n```$ftype\n$sel```",
          --   action = "replace",
          -- },
          -- Modify_Selection = {
          --   prompt = response_format .. "<FILE TYPE=\"$ftype\">$buf</FILE>\n<USER>$input</USER>\n<SYSTEM>Modify the following code based on the user's request, using the FILE as context.</SYSTEM>\n<SELECTION>\n```$ftype\n$sel```\n</SELECTION>",
          --   action = display,
          -- },
          -- Generate_Code = {
          --   prompt = response_format .. "<SYSTEM>Generate $ftype code that does completes the users request</SYSTEM>\n<USER>$input</USER>\n",
          --   action = "insert",
          -- },
        },
      }
    end,
  },
}
