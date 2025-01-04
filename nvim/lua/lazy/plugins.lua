-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = {},
		}, {
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
				-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
			},
		},
		{
			'nvim-telescope/telescope.nvim',
			tag = '0.1.8',
			-- or                              , branch = '0.1.x',
			dependencies = { 'nvim-lua/plenary.nvim' }
		},
		{
			"rose-pine/neovim",
			opts = {
				transparent = true,
			},
			name = "rose-pine",
			config = function()
				vim.cmd("colorscheme rose-pine")
			end
		},
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			dependencies = {
				{ "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
				{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
			},
			build = "make tiktoken",                            -- Only on MacOS or Linux
			opts = {
				window = {
					width = 0.25, -- fractional width of parent, or absolute width in columns when > 1
				},
				-- See Commands section for default commands if you want to lazy load on them
			},
		},
		{
			"nvim-telescope/telescope-frecency.nvim",
			-- install the latest stable version
			version = "*",
			config = function()
				require("telescope").setup({
					extensions = {
						frecency = {
							show_scores = true, -- Default: false
							-- If `true`, it shows confirmation dialog before any entries are removed from the DB
							-- If you want not to be bothered with such things and to remove stale results silently
							-- set db_safe_mode=false and auto_validate=true
							--
							-- This fixes an issue I had in which I couldn't close the floating
							-- window because I couldn't focus it
							db_safe_mode = false,       -- Default: true
							-- If `true`, it removes stale entries count over than db_validate_threshold
							auto_validate = true,       -- Default: true
							-- It will remove entries when stale ones exist more than this count
							db_validate_threshold = 10, -- Default: 10
							-- Show the path of the active filter before file paths.
							-- So if I'm in the `dotfiles-latest` directory it will show me that
							-- before the name of the file
							show_filter_column = false, -- Default: true
							-- I declare a workspace which I will use when calling frecency if I
							-- want to search for files in a specific path
						},
					},
				})
				require("telescope").load_extension "frecency"
			end,
		},
        {
            "folke/flash.nvim",
            event = "VeryLazy",
            opts = {
                labels = "asdfghjklqwertyuiopzxcvbnm",
                search = {
                    mode = "search",
                },
                modes = {
                    search = { enabled = true },
                    char = { enabled = true },
                },
            },
            -- stylua: ignore
            keys = {
                { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
                { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
                { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
                { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
                { "<C-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
            },
        },
        {
            "stevearc/conform.nvim",
            cmd = { "ConformInfo" },
            keys = {
					{
						-- Customize or remove this keymap to your liking
						"<leader>f",
						function()
							require("conform").format({ async = true })
						end,
						mode = "",
						desc = "Format buffer",
					},
				},
				-- This will provide type hinting with LuaLS
				---@module "conform"
				---@type conform.setupOpts
				opts = {
					-- Define your formatters
					formatters_by_ft = {
						lua = { "stylua" },
						python = { "isort", "black" },
						javascript = { "prettierd", "prettier", stop_after_first = true },
						html = { "prettierd", "prettier" },
						css = { "prettierd", "prettier" },
					},
					-- Set default options
					default_format_opts = {
						lsp_format = "fallback",
					},
					-- Set up format-on-save
					format_on_save = { timeout_ms = 500 },
					-- Customize formatters
					formatters = {
						shfmt = {
							prepend_args = { "-i", "2" },
						},
					},
				},
				init = function()
					-- If you want the formatexpr, here is the place to set it
					vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
				end,
			},
			{
				"nvim-neo-tree/neo-tree.nvim",
				branch = "v3.x",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
					"MunifTanjim/nui.nvim",
					-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
				}
			},
			{
				"hedyhli/outline.nvim",
				config = function()
					-- Example mapping to toggle outline
					vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>",
					{ desc = "Toggle Outline" })

					require("outline").setup {
						-- Your setup opts here (leave empty to use defaults)
					}
				end,
			},
			{
				'arnamak/stay-centered.nvim',
				lazy = false,
				opts = {
					enabled = false,
					disable_on_mouse = false,
				},
			},
			{
				'brenoprata10/nvim-highlight-colors',
				config = function()
					require("nvim-highlight-colors").setup({
						render = 'inline',
						virtual_symbol_position = 'eow',
						virtual_symbol_prefix = ' ',
						virtual_symbol_suffix = '',
						virtual_symbol = '■',
					})
				end,
			},
			{
				"nvim-treesitter/nvim-treesitter",
				build = ":TSUpdate"
			},
			{
				'kevinhwang91/nvim-ufo',
				"kevinhwang91/promise-async",
				dependencies = {
				},
			},
			{
				'akinsho/toggleterm.nvim',
				version = "*",
				config = true
			},
			{
				'echasnovski/mini.nvim',
				version = false
			},
			{ 'yuttie/comfortable-motion.vim' },
			{ 'wfxr/minimap.vim' },
			{ 'jasonccox/vim-wayland-clipboard' },
			{ 'vim-scripts/ReplaceWithRegister' },
			{ 'inkarkat/vim-ReplaceWithSameIndentRegister' },
			{ 'junegunn/fzf.vim' },
			{ 'ThePrimeagen/harpoon' },
			{ 'mbbill/undotree' },
			{ 'tpope/vim-fugitive' },
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'neovim/nvim-lspconfig' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/nvim-cmp' },
			{ 'eandrju/cellular-automaton.nvim' },
			{ 'github/copilot.vim' },
			{ 'rcarriga/nvim-notify' },
			{ 'bullets-vim/bullets.vim' },
			{ 'dstein64/vim-startuptime' },
			{ 'nanotee/zoxide.vim' },
			{ 'smartpde/telescope-recent-files' },
			{ 'sindrets/winshift.nvim' },
			{ 'nvim-treesitter/nvim-treesitter-textobjects' },
		},
		-- Configure any other settings here. See the documentation for more details.
		-- colorscheme that will be used when installing plugins.
		install = { colorscheme = { "habamax" } },
		-- automatically check for plugin updates
		checker = { enabled = false },
	})
