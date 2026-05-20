vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Project View (Netrw)" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line (keep cursor)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "LSP Restart" })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without copying" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })

-- linebreaks
vim.keymap.set({ "n", "v" }, "j", 'gj', { desc = "Move down visual line" })
vim.keymap.set({ "n", "v" }, "k", 'gk', { desc = "Move up visual line" })

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<F1>", "<nop>")
vim.keymap.set("n", "Q:", "q:")
vim.keymap.set("n", "q:", "<nop>")

vim.keymap.set("n", "<leader>x", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search/Replace word under cursor" })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/lazy/plugins.lua<CR>", { desc = "Edit lazy plugins config" })
vim.keymap.set("n", "<leader>vps", "<cmd>e ~/.config/nvim/lua/ecys/set.lua<CR>", { desc = "Edit settings config" })
vim.keymap.set("n", "<leader>vpr", "<cmd>e ~/.config/nvim/lua/ecys/remap.lua<CR>", { desc = "Edit remaps config" })
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain (cellular animation)" })

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
end, { desc = "Alternate file", silent = true })

-- Window switching
vim.keymap.set("n", "<A-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<A-j>", "<C-w>j", { desc = "Move to down window" })
vim.keymap.set("n", "<A-k>", "<C-w>k", { desc = "Move to up window" })
vim.keymap.set("n", "<A-l>", "<C-w>l", { desc = "Move to right window" })

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
vim.keymap.set("n", "<F2>", vim.cmd.write, { desc = "Save file" })
vim.keymap.set("i", "<F2>", vim.cmd.write, { desc = "Save file" })

-- linewrap
vim.keymap.set({ "n", "i", "v" }, "<C-l>", function()
	vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "Toggle line wrap" })

-- word del insert mode
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })
vim.keymap.set("i", "<C-Del>", "<C-o>dw", { desc = "Delete word forward" })

-- spell corrector is
vim.keymap.set("n", "<C-S-X>", "i<C-x>s", { desc = "Spell check correction" })
vim.keymap.set("i", "<C-X>", "<C-x>s", { desc = "Spell check correction" })

-- movement
vim.keymap.set("i", "<C-A>", "<Home>", { desc = "Move to start of line" })
vim.keymap.set("i", "<C-E>", "<End>", { desc = "Move to end of line" })

vim.keymap.set({ "n", "i" }, "<M-v>", function()
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

vim.keymap.set("n", "<leader>bd", vim.cmd.Bdelete, { desc = "Close current buffer" })
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprev, { desc = "Previous buffer" })
vim.keymap.set("n", "<Tab>", vim.cmd.bnext, { desc = "Next buffer" })

vim.keymap.set("n", "[t", vim.cmd.tabprev, { desc = "Previous tab" })
vim.keymap.set("n", "]t", vim.cmd.tabnext, { desc = "Next tab" })

---------
-- LSP --
---------

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		vim.keymap.set("n", "<leader>K", "<cmd>lua vim.lsp.buf.hover()<cr>", { buffer = event.buf, desc = "LSP hover information" })
		vim.keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { buffer = event.buf, desc = "LSP go to definition" })
		vim.keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { buffer = event.buf, desc = "LSP go to declaration" })
		vim.keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { buffer = event.buf, desc = "LSP go to implementation" })
		vim.keymap.set("n", "<leader>go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { buffer = event.buf, desc = "LSP go to type definition" })
		vim.keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<cr>", { buffer = event.buf, desc = "LSP show references" })
		vim.keymap.set("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { buffer = event.buf, desc = "LSP signature help" })
		vim.keymap.set("n", "<leader><F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = event.buf, desc = "LSP rename symbol" })
		vim.keymap.set("n", "<leader><F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = event.buf, desc = "LSP code action" })
		vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, { buffer = event.buf, desc = "Go to previous diagnostic" })
		vim.keymap.set("n", "]e", vim.diagnostic.goto_next, { buffer = event.buf, desc = "Go to next diagnostic" })
		vim.keymap.set("n", "<leader>pe", vim.diagnostic.open_float, { buffer = event.buf, desc = "Open diagnostic details float" })
	end,
})
vim.keymap.set("i", "<Esc>", "<Esc>l", { noremap = true, silent = true })

-- Replace With Register
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gra")
