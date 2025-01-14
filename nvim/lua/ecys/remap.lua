vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<F1>", "<nop>")
vim.keymap.set("n", "q:", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>x", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

vim.keymap.set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a')

vim.keymap.set("n", "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')

vim.keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/lazy/plugins.lua<CR>")
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)

-- Function to copy file path to clipboard
local function copy_filepath_to_clipboard()
	local filePath = vim.fn.expand("%:~") -- Gets the file path relative to the home directory
	vim.fn.setreg("+", filePath) -- Copy the file path to the clipboard register
	vim.notify(filePath, vim.log.levels.INFO)
	vim.notify("Path copied to clipboard: " .. filePath, vim.log.levels.INFO)
end
-- Keymaps for copying file path to clipboard
-- vim.keymap.set("n", "<leader>fp", copy_filepath_to_clipboard, { desc = "[P]Copy file path to clipboard" })
-- I couldn't use <M-p> because its used for previous reference
vim.keymap.set({ "n", "v", "i" }, "<A-c>", copy_filepath_to_clipboard, { desc = "[P]Copy file path to clipboard" })

-- Keymaps for opening the file in the file explorer
vim.keymap.set({ "n", "v", "i" }, "<M-k>", "<cmd>Telescope keymaps<cr>", { desc = "[P]Key Maps" })

-- Keymaps for opening the file's directory in system file explorer
vim.keymap.set("n", "<leader>T", function()
	vim.fn.jobstart({ "nemo", vim.fn.expand("%:p:h") }, { detach = true })
end, { silent = true })

-- Alternate file
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("silent! e #")
end, { silent = true })

-- Window switching
vim.keymap.set("n", "<A-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<A-j>", "<C-w>j", { desc = "Move to down window" })
vim.keymap.set("n", "<A-k>", "<C-w>k", { desc = "Move to up window" })
vim.keymap.set("n", "<A-l>", "<C-w>l", { desc = "Move to ight window" })

-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set("n", "<C-CR>", function()
	-- Get the current line number
	local line = vim.fn.line(".")
	-- Get the fold level of the current line
	local foldlevel = vim.fn.foldlevel(line)
	if foldlevel == 0 then
		vim.notify("No fold found", vim.log.levels.INFO)
	else
		vim.cmd("normal! za")
	end
end, { desc = "[P]Toggle fold" })

-- Quick write
vim.keymap.set("n", "<C-s>", vim.cmd.write)
vim.keymap.set("n", "<C-s>", vim.cmd.write)
vim.keymap.set("n", "<F2>", vim.cmd.write)
vim.keymap.set("i", "<F2>", vim.cmd.write)

-- linewrap
vim.keymap.set({ "n", "i", "v" }, "<C-l>", function()
	vim.opt.wrap = not vim.opt.wrap:get()
end)

-- word del insert mode
vim.keymap.set("i", "<C-BS>", vim.cmd.write)
vim.keymap.set("i", "<C-BS>", "<C-w>")
vim.keymap.set("i", "<C-Del>", "<C-o>dw")

-- spell corrector is
vim.keymap.set("n", "<C-K>", "i<C-x>s")

-- movement 
vim.keymap.set("i", "<C-A>", "<Home>")
vim.keymap.set("i", "<C-E>", "<End>")


vim.keymap.set({ "n", "i" }, "<M-a>", function()
  local pasted_image = require("img-clip").paste_image()
  if pasted_image then
    -- "Update" saves only if the buffer has been modified since the last save
    vim.cmd("silent! update")
    -- Get the current line
    local line = vim.api.nvim_get_current_line()
    -- Move cursor to end of line
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #line })
    -- I reload the file, otherwise I cannot view the image after pasted
    vim.cmd("edit!")
  end
end, { desc = "[P]Paste image from system clipboard" })

vim.keymap.set("n", "<leader>if", function()
  local function get_image_path()
    -- Get the current line
    local line = vim.api.nvim_get_current_line()
    -- Pattern to match image path in Markdown
    local image_pattern = "%[.-%]%((.-)%)"
    -- Extract relative image path
    local _, _, image_path = string.find(line, image_pattern)
    return image_path
  end
  -- Get the image path
  local image_path = get_image_path()
  if image_path then
    -- Check if the image path starts with "http" or "https"
    if string.sub(image_path, 1, 4) == "http" then
      print("URL image, use 'gx' to open it in the default browser.")
    else
      -- Construct absolute image path
      local current_file_path = vim.fn.expand("%:p:h")
      local absolute_image_path = current_file_path .. "/" .. image_path
      -- Open the containing folder in Finder and select the image file
      local command = "zen-browser " .. vim.fn.shellescape(absolute_image_path)
      local success = vim.fn.system(command)
      if success == 0 then
        print("Opened image in Finder: " .. absolute_image_path)
      else
        print("Failed to open image in Finder: " .. absolute_image_path)
      end
    end
  else
    print("No image found under the cursor")
  end
end, { desc = "[P](macOS) Open image under cursor in Finder" })
