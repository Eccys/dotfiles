local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)

require("ecys.remap")
require("ecys.set")
require("lazy.plugins")
