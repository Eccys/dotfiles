vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- Option 2: nvim lsp as LSP client
-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.foldingRange = {
--     dynamicRegistration = false,
--     lineFoldingOnly = true
-- }
-- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
-- for _, ls in ipairs(language_servers) do
--     require('lspconfig')[ls].setup({
--         capabilities = capabilities,
--         settings = {
--             Lua = {
--                 runtime = {
--                     -- Tell the language server which version of Lua you're using
--                     -- (most likely LuaJIT in the case of Neovim)
--                     version = 'LuaJIT',
--                 },
--                 diagnostics = {
--                     -- Get the language server to recognize the `vim` global
--                     globals = {
--                         'vim',
--                         'require'
--                     },
--                 },
--                 workspace = {
--                     -- Make the server aware of Neovim runtime files
--                     library = vim.api.nvim_get_runtime_file("", true),
--                 },
--                 -- Do not send telemetry data containing a randomized but unique identifier
--                 telemetry = {
--                     enable = false,
--                 },
--             },
--         },
--     })
-- end
-- require('ufo').setup()

--

-- Option 3: treesitter as a main provider instead
-- (Note: the `nvim-treesitter` plugin is *not* needed.)
-- ufo uses the same query files for folding (queries/<lang>/folds.scm)
-- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
    end
})
--
--
-- Option 4: disable all providers for all buffers
-- Not recommend, AFAIK, the ufo's providers are the best performance in Neovim
-- require('ufo').setup({
--     provider_selector = function(bufnr, filetype, buftype)
--         return ''
--     end
-- })
