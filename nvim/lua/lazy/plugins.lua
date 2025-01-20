-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
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
		{ import = "images" },
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = {},
		},
		-- {
		-- 	"huy-hng/anyline.nvim",
		-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
		-- 	config = true,
		-- 	event = "VeryLazy",
		-- },
		-- {
		-- 	"folke/persistence.nvim",
		-- 	event = "BufReadPre", -- this will only start session saving when an actual file was opened
		-- 	opts = {
		-- 		-- add any custom options here
		-- 		keys = {
		-- 			{
		-- 				"<leader>qD",
		-- 				function()
		-- 					local M = require("persistence")
		-- 					local sfile = M.current()
		-- 					if sfile and vim.loop.fs_stat(sfile) ~= 0 then
		-- 						M.stop()
		-- 						vim.fn.system("rm " .. vim.fn.fnameescape(sfile))
		-- 					end
		-- 				end,
		-- 				desc = "Delete Current Session",
		-- 			},
		-- 		},
		-- 	},
		-- },
		-- {
		-- 	"gennaro-tedesco/nvim-possession",
		-- 	dependencies = {
		-- 		"ibhagwan/fzf-lua",
		-- 	},
		-- 	config = true,
		-- 	init = function()
		-- 		local possession = require("nvim-possession")
		-- 		vim.keymap.set("n", "<leader>sl", function()
		-- 			possession.list()
		-- 		end)
		-- 		vim.keymap.set("n", "<leader>sn", function()
		-- 			possession.new()
		-- 		end)
		-- 		vim.keymap.set("n", "<leader>su", function()
		-- 			possession.update()
		-- 		end)
		-- 		vim.keymap.set("n", "<leader>sd", function()
		-- 			possession.delete()
		-- 		end)
		-- 	end,
		-- },
		{
			"rmagatti/auto-session", -- ASESH
			lazy = false,
			keys = {
				-- Will use Telescope if installed or a vim.ui.select picker otherwise
				{ "<leader>sr", "<cmd>SessionSearch<CR>", desc = "Session search" },
				{ "<leader>ss", "<cmd>SessionSave<CR>", desc = "Save session" },
				{ "<leader>sa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
				{ "<leader>sl", "<cmd>SessionRestore<CR>", desc = "Restore session" },
			},

			---enables autocomplete for opts
			---@module "auto-session"
			---@type AutoSession.Config
			opts = {
				enabled = true, -- Enables/disables auto creating, saving and restoring
				root_dir = vim.fn.stdpath("data") .. "/sessions/", -- Root dir where sessions will be stored
				auto_save = true, -- Enables/disables auto saving session on exit
				auto_restore = false, -- Enables/disables auto restoring session on start
				auto_create = true, -- Enables/disables auto creating new session files. Can take a function that should return true/false if a new session file should be created or not
				suppressed_dirs = nil, -- Suppress session restore/create in certain directories
				allowed_dirs = nil, -- Allow session restore/create in certain directories
				auto_restore_last_session = false, -- On startup, loads the last saved session if session for cwd does not exist
				use_git_branch = false, -- Include git branch name in session name
				lazy_support = true, -- Automatically detect if Lazy.nvim is being used and wait until Lazy is done to make sure session is restored correctly. Does nothing if Lazy isn't being used. Can be disabled if a problem is suspected or for debugging
				bypass_save_filetypes = nil, -- List of filetypes to bypass auto save when the only buffer open is one of the file types listed, useful to ignore dashboards
				close_unsupported_windows = true, -- Close windows that aren't backed by normal file before autosaving a session
				args_allow_single_directory = true, -- Follow normal sesion save/load logic if launched with a single directory as the only argument
				args_allow_files_auto_save = false, -- Allow saving a session even when launched with a file argument (or multiple files/dirs). It does not load any existing session first. While you can just set this to true, you probably want to set it to a function that decides when to save a session when launched with file args. See documentation for more detail
				continue_restore_on_error = true, -- Keep loading the session even if there's an error
				show_auto_restore_notif = false, -- Whether to show a notification when auto-restoring
				cwd_change_handling = false, -- Follow cwd changes, saving a session before change and restoring after
				lsp_stop_on_restore = false, -- Should language servers be stopped when restoring a session. Can also be a function that will be called if set. Not called on autorestore from startup
				log_level = "error", -- Sets the log level of the plugin (debug, info, warn, error).
				-- ⚠️ This will only work if Telescope.nvim is installed
				-- The following are already the default values, no need to provide them if these are already the settings you want.
				session_lens = {
					-- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
					load_on_setup = false,
					previewer = true,
					mappings = {
						-- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
						delete_session = { "i", "<C-D>" },
						alternate_session = { "i", "<C-S>" },
						copy_session = { "i", "<C-Y>" },
					},
					-- Can also set some Telescope picker options
					-- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
					theme_conf = {
						border = true,
						-- layout_config = {
						--   width = 0.8, -- Can set width and height as percent of window
						--   height = 0.5,
						-- },
					},
				},
			},
		},
		-- {
		-- 	"nvim-neo-tree/neo-tree.nvim",
		-- 	branch = "v3.x",
		-- 	dependencies = {
		-- 		"nvim-lua/plenary.nvim",
		-- 		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		-- 		"MunifTanjim/nui.nvim",
		-- 		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		-- 	},
		-- },
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			-- or                              , branch = '0.1.x',
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{
			"rose-pine/neovim",
			-- opts = {
			-- 	transparent = true,
			-- },
			name = "rose-pine",
			config = function()
				vim.cmd("colorscheme rose-pine")
			end,
		},
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			dependencies = {
				{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
				{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
			},
			build = "make tiktoken", -- Only on MacOS or Linux
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
							db_safe_mode = false, -- Default: true
							-- If `true`, it removes stale entries count over than db_validate_threshold
							auto_validate = true, -- Default: true
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
				require("telescope").load_extension("frecency")
			end,
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
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
					-- search = { enabled = true },
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
					sh = { "shfmt" },
					markdown = { "prettierd", "prettier" },
				},
				-- Set default options
				default_format_opts = {
					lsp_format = "fallback",
				},
				-- Set up format-on-save
				-- format_on_save = { timeout_ms = 500 },
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
			},
		},
		{
			"hedyhli/outline.nvim",
			lazy = true,
			cmd = { "Outline", "OutlineOpen" },
			config = function()
				-- Example mapping to toggle outline
				vim.keymap.set("n", "<leader>l", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

				require("outline").setup({
					-- Your setup opts here (leave empty to use defaults)
				})
			end,
		},
		{
			"arnamak/stay-centered.nvim",
			lazy = false,
			opts = {
				enabled = false,
				disable_on_mouse = false,
			},
		},
		{
			"brenoprata10/nvim-highlight-colors",
			config = function()
				require("nvim-highlight-colors").setup({
					render = "inline",
					virtual_symbol_position = "eow",
					virtual_symbol_prefix = " ",
					virtual_symbol_suffix = "",
					virtual_symbol = "■",
				})
			end,
		},
		{
			"chenxin-yan/footnote.nvim",
			config = function()
				require("footnote").setup({
					keys = {
						new_footnote = "<C-f>",
						organize_footnotes = "<leader>of",
						next_footnote = "]f",
						prev_footnote = "[f",
					},
					organize_on_save = true,
					organize_on_new = true,
				})
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
		},
		{
			"kevinhwang91/nvim-ufo",
			"kevinhwang91/promise-async",
			dependencies = {},
		},
		{
			"akinsho/toggleterm.nvim",
			version = "*",
			config = true,
		},
		{
			"echasnovski/mini.nvim",
			version = false,
		},
		{ "yuttie/comfortable-motion.vim" },
		{ "wfxr/minimap.vim" },
		{ "jasonccox/vim-wayland-clipboard" },
		{ "vim-scripts/ReplaceWithRegister" },
		{ "inkarkat/vim-ReplaceWithSameIndentRegister" },
		{ "junegunn/fzf.vim" },
		{ "ThePrimeagen/harpoon" },
		{ "mbbill/undotree" },
		{ "tpope/vim-fugitive" },
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "neovim/nvim-lspconfig" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/nvim-cmp" },
		{ "eandrju/cellular-automaton.nvim" },
		{ "github/copilot.vim" },
		{ "rcarriga/nvim-notify" },
		{ "bullets-vim/bullets.vim" },
		{ "dstein64/vim-startuptime" },
		{ "nanotee/zoxide.vim" },
		{ "smartpde/telescope-recent-files" },
		{ "sindrets/winshift.nvim" },
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		-- { 'kperath/dailynotes.nvim' },
		-- { 'mhinz/vim-startify' },
		{ "epwalsh/obsidian.nvim" },
		{ "f3fora/cmp-spell" },
		{ "numToStr/Comment.nvim" },
		{ "nat-418/boole.nvim" },
		{ "nvim-lualine/lualine.nvim" },
		{ "famiu/bufdelete.nvim" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = false },
})
