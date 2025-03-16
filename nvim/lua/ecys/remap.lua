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
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<F1>", "<nop>")
vim.keymap.set("n", "Q:", "q:")
vim.keymap.set("n", "q:", "<nop>")
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>x", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")
--
-- vim.keymap.set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a')
--
-- vim.keymap.set("n", "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')
--
-- vim.keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/lazy/plugins.lua<CR>")
vim.keymap.set("n", "<leader>vps", "<cmd>e ~/.config/nvim/lua/ecys/set.lua<CR>")
vim.keymap.set("n", "<leader>vpr", "<cmd>e ~/.config/nvim/lua/ecys/remap.lua<CR>")
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
-- vim.keymap.set("n", "<C-s>", vim.cmd.write)
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
vim.keymap.set("n", "<C-S-X>", "i<C-x>s")
vim.keymap.set("i", "<C-X>", "<C-x>s")

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

vim.keymap.set("n", "<leader>bd", vim.cmd.Bdelete)
-- vim.keymap.set("n", "<C-[>", "<nop>") -- this shouldnt be there
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprev)
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)

-- -- sessions
-- -- load the session for the current directory
-- vim.keymap.set("n", "<leader>ss", function() require("persistence").load() end)
-- -- select a session to load
-- vim.keymap.set("n", "<leader>sS", function() require("persistence").select() end)
-- -- load the last session
-- vim.keymap.set("n", "<leader>sl", function() require("persistence").load({ last = true }) end)
-- -- stop Persistence => session won't be saved on exit
-- vim.keymap.set("n", "<leader>sq", function() require("persistence").stop() end)

-- function delete_current_session()
--   local M = require("persistence")
--   local sfile = M.current()
--   if sfile and vim.loop.fs_stat(sfile) ~= 0 then
--     M.stop()
--     vim.fn.system("rm " .. vim.fn.fnameescape(sfile))
--   end
-- end

-- I think this is not vim philography.
-- vim.keymap.set("i", "<C-k>", "<Esc>gka")
-- vim.keymap.set("i", "<C-j>", "<Esc>gja")

vim.keymap.set("n", "[t", vim.cmd.tabprev)
vim.keymap.set("n", "]t", vim.cmd.tabnext)

-- vim.keymap.set('c', '<Esc>', '<C-c>') -- Does not work =(

---------
-- LSP --
---------

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }

		vim.keymap.set("n", "<leader>K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
		vim.keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		vim.keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		vim.keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
		vim.keymap.set("n", "<leader>go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
		vim.keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
		vim.keymap.set("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		vim.keymap.set("n", "<leader><F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
		-- vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
		vim.keymap.set("n", "<leader><F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
		vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]e", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "<leader>pe", vim.diagnostic.open_float, opts)
		-- vim.keymap.set({ "n", "v" }, "<leader>l", vim.lsp.codelens.run, opts)
	end,
})
vim.keymap.set("i", "<Esc>", "<Esc>l", { noremap = true, silent = true })
