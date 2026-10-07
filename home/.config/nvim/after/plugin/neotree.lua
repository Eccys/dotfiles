-- require('neo-tree').setup({
--       filesystem = {
--         bind_to_cwd = true, -- true establishes a 2-way binding between vim's cwd and neo-tree's root
--         cwd_target = {
--           sidebar = "global",   -- sidebar is when position = left or right
--           current = "global" -- current is when position = current
--         },
--     },
-- })

vim.keymap.set('n', '<C-t>', '<Cmd>Neotree toggle left<CR>')
vim.keymap.set('n', '<leader>t', '<Cmd>Neotree toggle reveal float<CR>')
