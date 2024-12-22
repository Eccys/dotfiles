-- VIMRC
local vimrc = vim:wq.fn.stdpath("config") .. "/vimrc.vim"
vim:wq.cmd.source(vimrc)

-- NEOTREE
vim:wq.keymap.set('n', '<C-t>', '<Cmd>Neotree toggle<CR>')

-- IBL
require("ibl").setup()
