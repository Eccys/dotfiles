vim.opt.nu = true
vim.opt.rnu = true

vim.opt.showcmd = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.linebreak = true

-- vim.opt.swapfile = false
-- vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.confirm = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.selectmode = "mouse"

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.g.mapleader = " "

vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.o.guifont = "JetBrains Mono:h10" -- text below applies far VimScript

vim.opt.conceallevel = 2

-- Helper function for transparency formatting
local alpha = function()
	return string.format("%x", math.floor(255 * vim.g.neovide_transparency_point or 0.8))
end
-- Set transparency and background color (title bar color)
vim.g.neovide_transparency = 0.6
vim.g.neovide_transparency_point = 0.8
vim.g.neovide_background_color = "#0f1117" .. alpha()
-- Add key binds to change transparency
local change_transparency = function(delta)
	vim.g.neovide_transparency_point = vim.g.neovide_transparency_point + delta
	vim.g.neovide_background_color = "#0f1117" .. alpha()
end

vim.keymap.set({ "n", "v", "o" }, "<A-]>", function()
	change_transparency(0.1)
end)
vim.keymap.set({ "n", "v", "o" }, "<A-[>", function()
	change_transparency(-0.1)
end)

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local line = vim.fn.line
		if line("'\"") > 0 and line("'\"") <= line("$") then
			vim.cmd('normal! g`"')
		end
	end,
})
