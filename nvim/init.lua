local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"

require("lazy.plugins")
require("ecys.set")
require("ecys.remap")
vim.cmd.source(vimrc)

vim.cmd.source(vim.fn.stdpath("config") .. "/after/plugin/bosidian.lua")
