return {
    'neovim/nvim-lspconfig',
    event = "VeryLazy",
    lazy = true,
    enabled = true,
    dependencies = { 'saghen/blink.cmp' },

    -- example calling setup directly for each LSP
    config = function()
        local capabilities = require('blink.cmp').get_lsp_capabilities()
        local lspconfig = require('lspconfig')

        lspconfig['lua_ls'].setup({ capabilities = capabilities })
        lspconfig['ts_ls'].setup({ capabilities = capabilities })
    end
}
