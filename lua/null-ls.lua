-- ~/.config/nvim/lua/custom/configs/null-ls.lua
local null_ls = require("null-ls")

null_ls.setup({
  debug = true,  -- optional: spit logs to ~/.cache/null-ls.log
  sources = {
    -- formatting
    null_ls.builtins.formatting.clang_format,
	null_ls.builtins.diagnostics.cppcheck,
  },
})

