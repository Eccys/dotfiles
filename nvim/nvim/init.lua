-- VIMRC
local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)

-- NEOTREE
vim.keymap.set('n', '<C-t>', '<Cmd>Neotree toggle<CR>')

-- IBL
require("ibl").setup()
