require('neo-tree').setup({
      filesystem = {
        bind_to_cwd = true, -- true establishes a 2-way binding between vim's cwd and neo-tree's root
        cwd_target = {
          sidebar = "global",   -- sidebar is when position = left or right
          current = "global" -- current is when position = current
        },
    },
    event_handlers = {
        {
            event = "neo_tree_buffer_enter",
            handler = function()
                -- This effectively hides the cursor
                vim.cmd 'highlight! Cursor blend=100'
            end
        },
        {
            event = "neo_tree_buffer_leave",
            handler = function()
                -- Make this whatever your current Cursor highlight group is.
                vim.cmd 'highlight! Cursor guibg=#5f87af blend=0'
            end
        }
    },
})

vim.keymap.set('n', '<leader>t', '<Cmd>Neotree toggle reveal float<CR>')
vim.keymap.set('n', '<C-t>', '<Cmd>Neotree toggle left<CR>')
