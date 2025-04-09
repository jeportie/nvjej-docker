require "nvchad.options"

local o = vim.o

-------------------------------------- options ------------------------------------------

o.cursorlineopt ='both'

-- Indenting
o.expandtab = false
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = true

-- UI
o.scrolloff=8

-- Key mappings for setting the colorcolumn
vim.keymap.set("n", "<Leader>cc", ":set colorcolumn=80<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>ncc", ":set colorcolumn-=80<CR>", { noremap = true, silent = true })

local function insert_include_guard()
  -- Check if the current file is a .hpp file.
  if vim.fn.expand("%:e") ~= "hpp" then
    vim.notify("This is not a .hpp file.", vim.log.levels.WARN)
    return
  end

  -- Get the file name (e.g. "Default.class.hpp")
  local filename = vim.fn.expand("%:t")
  -- Remove the extension (.hpp)
  local base = filename:gsub("%.hpp$", "")
  -- Replace any dot with an underscore, then convert to uppercase and append _HPP.
  local guard = base:gsub("%.", "_"):upper() .. "_HPP"

  -- Calculate stars so that the final line is exactly 80 columns wide.
  -- Fixed parts: "#endif  // " (11 characters) + 1 space + " //" (3 characters) = 15.
  local stars_count = 80 - 15 - #guard
  local stars = string.rep("*", stars_count)

  -- Build the include guard template.
  local template = {
    "#ifndef " .. guard,
    "# define " .. guard,
    "",  -- empty line between "# define" and "#endif"
    "#endif  // " .. stars .. " " .. guard .. " //",
  }

  -- Append the template at the end of the current buffer.
  local total = vim.fn.line("$")
  vim.api.nvim_buf_set_lines(0, total, total, false, template)

  -- Delete line 13 (if it exists) – note: buffer lines are 1-indexed,
  -- but nvim_buf_set_lines expects 0-indexed start/end, so line 13 is index 12.
  if vim.fn.line("$") >= 13 then
    vim.api.nvim_buf_set_lines(0, 12, 13, false, {})
  end

  -- Determine the target line for the cursor: line 15 if it exists; otherwise, the last line.
  local current_total = vim.fn.line("$")
  local target_line = (current_total >= 15) and 15 or current_total

  vim.api.nvim_win_set_cursor(0, {target_line, 0})
  vim.cmd("startinsert")
end

-- Map F2 to call insert_include_guard() in normal mode.
vim.keymap.set("n", "<F2>", insert_include_guard, { noremap = true, silent = true })

local function insert_class_guard()
  -- Check if the current file is a .hpp file.
  if vim.fn.expand("%:e") ~= "hpp" then
    vim.notify("This is not a .hpp file.", vim.log.levels.WARN)
    return
  end

  -- Get the file name (e.g. "MyClass.hpp") and remove the extension.
  local filename = vim.fn.expand("%:t")
  local classname = filename:gsub("%.hpp$", "")

  -- Build the template using Allman formatting.
  local template = {
    "# include <iostream>",
    "# include <string>",
    "",
    "class " .. classname,
    "{",
    "public:",
    "\t" .. classname .. "(void);",
    "\t" .. classname .. "(" .. classname .. " const & src);",
    "\t~" .. classname .. "(void);",
    "",
    "\t" .. classname .. " & operator=(" .. classname .. " const & rhs);",
    "",
    "\tint getFoo(void) const;",
    "",
    "private:",
    "\tint _foo;",
    "};",
    "",
    "// Overload operator<< for output streaming",
    "std::ostream & operator<<(std::ostream & out, " .. classname .. " const & in);",
    "// Overload operator+ for string concatenation",
    "std::string operator+(std::string const & lhs, " .. classname .. " const & rhs);",
  }

  -- Append the template at the end of the current buffer.
  local total = vim.fn.line("$")
  vim.api.nvim_buf_set_lines(0, total, total, false, template)

  -- Move the cursor to the start of the inserted block.
  vim.api.nvim_win_set_cursor(0, { total + 1, 0 })
  vim.cmd("startinsert")
end

-- Map F3 key in normal mode to call insert_class_guard()
vim.keymap.set("n", "<F3>", insert_class_guard, { noremap = true, silent = true })

