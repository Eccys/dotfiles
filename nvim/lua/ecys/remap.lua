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
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "q:", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>x", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

vim.keymap.set(
    "n",
    "<leader>ea",
    "oassert.NoError(err, \"\")<Esc>F\";a"
)

vim.keymap.set(
    "n",
    "<leader>ef",
    "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj"
)

vim.keymap.set(
    "n",
    "<leader>el",
    "oif err != nil {<CR>}<Esc>O.logger.Error(\"error\", \"error\", err)<Esc>F.;i"
)

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/lazy/plugins.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- Function to copy file path to clipboard
local function copy_filepath_to_clipboard()
    local filePath = vim.fn.expand("%:~") -- Gets the file path relative to the home directory
    vim.fn.setreg("+", filePath)          -- Copy the file path to the clipboard register
    vim.notify(filePath, vim.log.levels.INFO)
    vim.notify("Path copied to clipboard: " .. filePath, vim.log.levels.INFO)
end
-- Keymaps for copying file path to clipboard
-- vim.keymap.set("n", "<leader>fp", copy_filepath_to_clipboard, { desc = "[P]Copy file path to clipboard" })
-- I couldn't use <M-p> because its used for previous reference
vim.keymap.set({ "n", "v", "i" }, "<A-c>", copy_filepath_to_clipboard, { desc = "[P]Copy file path to clipboard" })

-- Keymaps for opening the file in the file explorer
vim.keymap.set({ "n", "v", "i" }, "<M-k>", "<cmd>Telescope keymaps<cr>", { desc = "[P]Key Maps" })

-- Keymaps for opening the file's directory in the nemo file explorer
vim.keymap.set('n', '<leader>n', function()
    vim.fn.jobstart({ 'nemo', vim.fn.expand('%:p:h') }, { detach = true })
end, { silent = true })

-- Alternate file
vim.keymap.set('n', '<leader><leader>', function()
    vim.cmd('silent! e #')
end, { silent = true })

vim.keymap.set("n", "<A-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<A-j>", "<C-w>j", { desc = "Move to down window" })
vim.keymap.set("n", "<A-k>", "<C-w>k", { desc = "Move to up window" })
vim.keymap.set("n", "<A-l>", "<C-w>l", { desc = "Move to right window" })
