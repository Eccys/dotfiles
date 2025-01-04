

-- Marks keep coming back even after deleting them, this deletes them all
-- This deletes all marks in the current buffer, including lowercase, uppercase, and numbered marks
-- Fix should be applied on April 2024
-- https://github.com/chentoast/marks.nvim/issues/13
vim.keymap.set("n", "<leader>mD", function()
  -- Delete all marks in the current buffer
  vim.cmd("delmarks!")
  print("All marks deleted.")
end, { desc = "[P]Delete all marks" })

-- In visual mode, check if the selected text is already bold and show a message if it is
-- If not, surround it with double asterisks for bold
vim.keymap.set("v", "<leader>mb", function()
  -- Get the selected text range
  local start_row, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
  local end_row, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local selected_text = table.concat(lines, "\n"):sub(start_col, #lines == 1 and end_col or -1)
  if selected_text:match("^%*%*.*%*%*$") then
    vim.notify("Text already bold", vim.log.levels.INFO)
  else
    vim.cmd("normal 2sa*")
  end
end, { desc = "[P]BOLD current selection" })

-- -- Multiline unbold attempt
-- -- In normal mode, bold the current word under the cursor
-- -- If already bold, it will unbold the word under the cursor
-- -- If you're in a multiline bold, it will unbold it only if you're on the
-- -- first line
vim.keymap.set("n", "<leader>mb", function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_buffer = vim.api.nvim_get_current_buf()
  local start_row = cursor_pos[1] - 1
  local col = cursor_pos[2]
  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]
  -- Check if the cursor is on an asterisk
  if line:sub(col + 1, col + 1):match("%*") then
    vim.notify("Cursor is on an asterisk, run inside the bold text", vim.log.levels.WARN)
    return
  end
  -- Search for '**' to the left of the cursor position
  local left_text = line:sub(1, col)
  local bold_start = left_text:reverse():find("%*%*")
  if bold_start then
    bold_start = col - bold_start
  end
  -- Search for '**' to the right of the cursor position and in following lines
  local right_text = line:sub(col + 1)
  local bold_end = right_text:find("%*%*")
  local end_row = start_row
  while not bold_end and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1 do
    end_row = end_row + 1
    local next_line = vim.api.nvim_buf_get_lines(current_buffer, end_row, end_row + 1, false)[1]
    if next_line == "" then
      break
    end
    right_text = right_text .. "\n" .. next_line
    bold_end = right_text:find("%*%*")
  end
  if bold_end then
    bold_end = col + bold_end
  end
  -- Remove '**' markers if found, otherwise bold the word
  if bold_start and bold_end then
    -- Extract lines
    local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, end_row + 1, false)
    local text = table.concat(text_lines, "\n")
    -- Calculate positions to correctly remove '**'
    -- vim.notify("bold_start: " .. bold_start .. ", bold_end: " .. bold_end)
    local new_text = text:sub(1, bold_start - 1) .. text:sub(bold_start + 2, bold_end - 1) .. text:sub(bold_end + 2)
    local new_lines = vim.split(new_text, "\n")
    -- Set new lines in buffer
    vim.api.nvim_buf_set_lines(current_buffer, start_row, end_row + 1, false, new_lines)
    -- vim.notify("Unbolded text", vim.log.levels.INFO)
  else
    -- Bold the word at the cursor position if no bold markers are found
    local before = line:sub(1, col)
    local after = line:sub(col + 1)
    local inside_surround = before:match("%*%*[^%*]*$") and after:match("^[^%*]*%*%*")
    if inside_surround then
      vim.cmd("normal sd*.")
    else
      vim.cmd("normal viw")
      vim.cmd("normal 2sa*")
    end
    vim.notify("Bolded current word", vim.log.levels.INFO)
  end
end, { desc = "[P]BOLD toggle bold markers" })

----------------
-- CHECKBOXES --
----------------
-- Crate task or checkbox lamw25wmal
-- These are marked with <leader>x using bullets.vim
vim.keymap.set("n", "<leader>ml", function()
  vim.cmd("normal! i- [ ]  ")
  vim.cmd("startinsert")
end, { desc = "[P]Toggle checkbox" })


-- In visual mode, surround the selected text with markdown link syntax
vim.keymap.set("v", "<C-k>", function()
  -- Copy what's currently in my clipboard to the register "a lamw25wmal
  vim.cmd("let @a = getreg('+')")
  -- delete selected text
  vim.cmd("normal d")
  -- Insert the following in insert mode
  vim.cmd("startinsert")
  vim.api.nvim_put({ "[]() " }, "c", true, true)
  -- Move to the left, paste, and then move to the right
  vim.cmd("normal F[pf(")
  -- Copy what's on the "a register back to the clipboard
  vim.cmd("call setreg('+', @a)")
  -- Paste what's on the clipboard
  vim.cmd("normal p")
  -- Leave me in normal mode or command mode
  vim.cmd("stopinsert")
  -- Leave me in insert mode to start typing
  -- vim.cmd("startinsert")
end, { desc = "[P]Convert to link" })

-- In visual mode, surround the selected text with markdown link syntax
vim.keymap.set("v", "<C-K>", function()
  -- Copy what's currently in my clipboard to the register "a lamw25wmal
  vim.cmd("let @a = getreg('+')")
  -- delete selected text
  vim.cmd("normal d")
  -- Insert the following in insert mode
  vim.cmd("startinsert")
  vim.api.nvim_put({ '[](){:target="_blank"} ' }, "c", true, true)
  vim.cmd("normal F[pf(")
  -- Copy what's on the "a register back to the clipboard
  vim.cmd("call setreg('+', @a)")
  -- Paste what's on the clipboard
  vim.cmd("normal p")
  -- Leave me in normal mode or command mode
  vim.cmd("stopinsert")
  -- Leave me in insert mode to start typing
  -- vim.cmd("startinsert")
end, { desc = "[P]Convert to link (new tab)" })

vim.keymap.set("n", "<C-c>", function()
  local conceallevel = vim.wo.conceallevel
  if conceallevel < 3 then
    vim.wo.conceallevel = conceallevel + 1
  else
    vim.wo.conceallevel = 0
  end
  vim.notify("Conceal level: " .. vim.wo.conceallevel, vim.log.levels.INFO)
end, { desc = "[P]Cycle conceal level" })

