return {
    'neovim/nvim-lspconfig',
    event = "VeryLazy",
    lazy = true,
    enabled = true,
    dependencies = { 'saghen/blink.cmp' },

    config = function()
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        -- Use the native Nvim 0.12+ API instead of the deprecated lspconfig framework
        vim.lsp.config('lua_ls', { capabilities = capabilities })
        vim.lsp.config('ts_ls', { capabilities = capabilities })
        vim.lsp.enable({ 'lua_ls', 'ts_ls' })
    end
}
