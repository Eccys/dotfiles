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
        { "nvim-lualine/lualine.nvim" },
        { import = "images" },
        { "github/copilot.vim",       lazy = true, event = "VeryLazy" },
        {
            "lukas-reineke/indent-blankline.nvim",
            lazy = true,
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
                { "<leader>sr", "<cmd>SessionSearch<CR>",         desc = "Session search" },
                { "<leader>sS", "<cmd>SessionSave<CR>",           desc = "Save session" },
                { "<leader>sa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
                { "<leader>ss", "<cmd>SessionRestore<CR>",        desc = "Restore session" },
                { "<leader>sd", "<cmd>SessionDelete<CR>",         desc = "Delete session" },
            },
            config = function()
                require("auto-session").setup({
                    enabled = true,
                    root_dir = vim.fn.stdpath("data") .. "/sessions/",
                    auto_save = true,
                    auto_restore = true,
                    auto_create = true,
                    suppressed_dirs = nil,
                    allowed_dirs = nil,
                    auto_restore_last_session = false,
                    use_git_branch = false,
                    lazy_support = true,
                    bypass_save_filetypes = { "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
                    close_unsupported_windows = true,
                    args_allow_single_directory = true,
                    args_allow_files_auto_save = false,
                    continue_restore_on_error = true,
                    show_auto_restore_notif = false,
                    cwd_change_handling = {
                        restore_upcoming_session = true,
                    },
                    lsp_stop_on_restore = false,
                    log_level = "error",
                    session_lens = {
                        load_on_setup = true,
                        theme_conf = {
                            layout_config = {
                                height = 0.3,
                            },
                        },
                        previewer = true,
                        mappings = {
                            delete_session = { { "i", "n" }, "<C-D>" },
                            alternate_session = { { "i", "n" }, "<C-S>" },
                            copy_session = { { "i", "n" }, "<C-Y>" },
                        },
                        session_control = {
                            control_dir = vim.fn.stdpath("data") .. "/auto_session/",
                            control_filename = "session_control.json",
                        },
                    },
                })
                vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
            end,
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
            lazy = true,
            tag = "0.1.8",
            dependencies = { "nvim-lua/plenary.nvim" },
            keys = {
                { "<C-p>",      function() require("telescope.builtin").git_files() end, desc = "Telescope git files" },
                {
                    "<leader>ps",
                    function()
                        require("telescope.builtin").grep_string({ search = vim.fn.input("Search term > ") })
                    end,
                    desc = "Grep string"
                },
                {
                    "<leader>pb",
                    function()
                        require("telescope.builtin").buffers(require("telescope.themes").get_ivy({
                            sort_mru = true,
                            sort_lastused = false,
                            initial_mode = "insert",
                            hidden = true,
                            layout_config = { preview_width = 0.45 },
                        }))
                    end,
                    desc = "Telescope buffers"
                },
                {
                    '<leader>"',
                    function()
                        require("telescope.builtin").registers({
                            sort_mru = true,
                            sort_lastused = false,
                            initial_mode = "normal",
                            layout_config = { preview_width = 0.45 },
                        })
                    end,
                    mode = { "n", "v" },
                    desc = "Telescope registers"
                },
                {
                    "<leader>pf",
                    function()
                        require("telescope.builtin").find_files(require("telescope.themes").get_ivy({
                            sort_mru = true,
                            sort_lastused = false,
                            initial_mode = "insert",
                            hidden = true,
                            layout_config = { preview_width = 0.45 },
                        }))
                    end,
                    desc = "Telescope find files"
                },
                {
                    "<leader>r",
                    function()
                        require("telescope").load_extension("frecency")
                        require("telescope").extensions.frecency.frecency(require("telescope.themes").get_ivy({
                            sort_mru = true,
                            sort_lastused = false,
                            hidden = true,
                            initial_mode = "insert",
                            layout_config = { preview_width = 0.45 },
                        }))
                    end,
                    desc = "Telescope frecency"
                },
                {
                    "<leader>pr",
                    function()
                        require("telescope").load_extension("recent_files")
                        require("telescope").extensions.recent_files.pick(require("telescope.themes").get_ivy({
                            sort_mru = true,
                            sort_lastused = false,
                            hidden = true,
                            initial_mode = "normal",
                            layout_config = { preview_width = 0.45 },
                            only_cwd = true,
                            show_current_file = true,
                        }))
                    end,
                    desc = "Recent files (CWD)"
                },
                {
                    "<leader>R",
                    function()
                        require("telescope").load_extension("recent_files")
                        require("telescope").extensions.recent_files.pick(require("telescope.themes").get_ivy({
                            sort_mru = true,
                            hidden = true,
                            sort_lastused = false,
                            initial_mode = "normal",
                            layout_config = { preview_width = 0.45 },
                            show_current_file = true,
                        }))
                    end,
                    desc = "Recent files (all)"
                },
                { "<leader>sk", "<cmd>Telescope keymaps<cr>",                            desc = "Telescope keymaps" },
            },
            config = function()
                local actions = require("telescope.actions")
                require("telescope").setup({
                    extensions = {
                        fzf = {
                            fuzzy = true,
                            override_generic_sorter = true,
                            override_file_sorter = true,
                            case_mode = "smart_case",
                        },
                    },
                    pickers = {
                        buffers = {
                            mappings = {
                                n = {
                                    ["d"] = actions.delete_buffer + actions.move_to_top,
                                },
                                i = {
                                    ["<C-j>"] = actions.move_selection_next,
                                    ["<C-k>"] = actions.move_selection_previous,
                                },
                            },
                        },
                    },
                })
            end,
        },
        { "catppuccin/nvim",                           name = "catppuccin", priority = 1000 },
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            init = function()
                vim.o.timeout = true
                vim.o.timeoutlen = 300
            end,
            opts = {},
        },
        -- {
        -- 	"CopilotC-Nvim/CopilotChat.nvim",
        -- 	lazy = true,
        -- 	event = "VeryLazy",
        -- 	dependencies = {
        -- 		{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
        -- 		{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        -- 	},
        -- 	build = "make tiktoken", -- Only on MacOS or Linux
        -- 	opts = {
        -- 		window = {
        -- 			width = 0.25, -- fractional width of parent, or absolute width in columns when > 1
        -- 		},
        -- 		-- See Commands section for default commands if you want to lazy load on them
        -- 	},
        -- },
        {
            "nvim-telescope/telescope-frecency.nvim",
            lazy = true,
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
            lazy = true,
            build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
        },
        {
            "folke/flash.nvim",
            lazy = true,
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
                { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
                { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
                { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
                { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
                { "<C-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
            },
        },
        {
            "stevearc/conform.nvim",
            lazy = true,
            event = "VeryLazy",
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
            event = "VeryLazy",
            lazy = true,
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
                "MunifTanjim/nui.nvim",
                -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
            },
        },
        -- {
        -- 	"tzachar/local-highlight.nvim",
        -- 	config = function()
        -- 		require("local-highlight").setup()
        -- 	end,
        -- },
        {
            "hedyhli/outline.nvim",
            lazy = true,
            event = "VeryLazy",
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
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            lazy = true,
            event = "VeryLazy",
            version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = "make install_jsregexp",
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
            lazy = true,
            event = "VeryLazy",
            config = function()
                require("footnote").setup({
                    keys = {
                        n = {
                            new_footnote = "<A-f>",
                            organize_footnotes = "<A-S-f>",
                            next_footnote = "]f",
                            prev_footnote = "[f",
                        },
                        i = {
                            new_footnote = "<A-f>",
                        },
                    },
                    organize_on_save = true,
                    organize_on_new = true,
                })
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            lazy = true,
            event = "VeryLazy",
            build = ":TSUpdate",
        },
        {
            "kevinhwang91/nvim-ufo",
            lazy = true,
            dependencies = { "kevinhwang91/promise-async" },
            init = function()
                vim.o.foldcolumn = "0"
                vim.o.foldlevel = 99
                vim.o.foldlevelstart = 99
                vim.o.foldenable = true
            end,
            keys = {
                { "zR", function() require("ufo").openAllFolds() end,  desc = "Open all folds" },
                { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
            },
            config = function()
                require("ufo").setup({
                    provider_selector = function(bufnr, filetype, buftype)
                        return { "treesitter", "indent" }
                    end,
                })
            end,
        },
        {
            "kevinhwang91/nvim-hlslens",
            lazy = true,
            event = "VeryLazy",
            config = function()
                -- require('hlslens').setup() is not required
                require("scrollbar.handlers.search").setup({
                    -- hlslens config overrides
                    override_lens = function() end,
                })
            end,
        },
        {
            "akinsho/toggleterm.nvim",
            lazy = true,
            event = "VeryLazy",
            version = "*",
            config = true,
        },
        {
            "echasnovski/mini.nvim",
            lazy = true,
            event = "VeryLazy",
            version = false,
            keys = {
                { '<A-m>',      function() MiniMap.toggle_focus() end, desc = "MiniMap Focus" },
                { '<Leader>mr', function() MiniMap.refresh() end,      desc = "MiniMap Refresh" },
                { '<Leader>ms', function() MiniMap.toggle_side() end,  desc = "MiniMap Toggle Side" },
                { '<A-S-m>',    function() MiniMap.toggle() end,       desc = "MiniMap Toggle" },
            },
            config = function()
                require('mini.ai').setup({
                    custom_textobjects = nil,
                    mappings = {
                        around = 'a',
                        around_next = 'an',
                        around_last = 'al',
                        goto_left = 'g[',
                        goto_right = 'g]',
                    },
                    n_lines = 50,
                    search_method = 'cover_or_next',
                    silent = false,
                })

                require('mini.surround').setup({
                    custom_surroundings = nil,
                    highlight_duration = 500,
                    mappings = {
                        add = 'gsa',
                        delete = 'gsd',
                        find = 'gsf',
                        find_left = 'gsF',
                        highlight = 'gsh',
                        replace = 'gsr',
                        update_n_lines = 'gsn',
                        suffix_last = 'l',
                        suffix_next = 'n',
                    },
                    n_lines = 20,
                    respect_selection_type = false,
                    search_method = 'cover_or_next',
                    silent = false,
                })

                require("mini.map").setup({
                    integrations = nil,
                    symbols = {
                        encode = nil,
                        scroll_line = "▒",
                        scroll_view = "┃",
                    },
                    window = {
                        focusable = false,
                        side = "right",
                        show_integration_count = true,
                        width = 10,
                        winblend = 25,
                        zindex = 10,
                    },
                })
            end,
        },
        { "yuttie/comfortable-motion.vim" },
        -- { "wfxr/minimap.vim" },
        { "jasonccox/vim-wayland-clipboard" },
        { "vim-scripts/ReplaceWithRegister" },
        { "inkarkat/vim-ReplaceWithSameIndentRegister" },
        { "junegunn/fzf.vim" },
        { "ThePrimeagen/harpoon" },
        { "mbbill/undotree" },
        { "tpope/vim-fugitive" },
        {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup()
            end,
        },
        { -- Language Servers (LSPs)
            "williamboman/mason-lspconfig.nvim",
            -- config = function()
            -- 	require("mason-lspconfig").setup({
            -- 		ensure_installed = {
            -- 			"angularls",
            -- 			"bashls",
            -- 			"cssls",
            -- 			"eslint",
            -- 			"gopls",
            -- 			"html",
            -- 			"jsonls",
            -- 			"lua_ls",
            -- 			"rust_analyzer",
            -- 			"svelte",
            -- 			"tailwindcss",
            -- 			"ts_ls",
            -- 			"yamlls",
            -- 		},
            -- 	})
            -- end,
        },
        { "neovim/nvim-lspconfig",           lazy = true, event = "VeryLazy" },
        -- { "hrsh7th/cmp-nvim-lsp", lazy = true, event = "VeryLazy" },
        -- { "hrsh7th/nvim-cmp", lazy = true, event = "VeryLazy" },
        { "eandrju/cellular-automaton.nvim", lazy = true, event = "VeryLazy" },
        {
            "rcarriga/nvim-notify",
            lazy = true,
            event = "VeryLazy",
            opts = {
                background_colour = "#000000",
            },
        },
        { "bullets-vim/bullets.vim",         lazy = true, event = "VeryLazy" },
        { "dstein64/vim-startuptime",        lazy = true, event = "VeryLazy" },
        { "nanotee/zoxide.vim",              lazy = true, event = "VeryLazy" },
        { "smartpde/telescope-recent-files", lazy = true, event = "VeryLazy" },
        {
            "sindrets/winshift.nvim",
            lazy = true,
            keys = {
                { "<leader>w", "<cmd>WinShift<CR>", desc = "WinShift" },
            },
            config = function()
                require("winshift").setup({
                    highlight_moving_win = true,
                    focused_hl_group = "Visual",
                    moving_win_options = {
                        wrap = false,
                        cursorline = false,
                        cursorcolumn = false,
                        colorcolumn = "",
                    },
                    keymaps = {
                        disable_defaults = false,
                        win_move_mode = {
                            ["h"] = "left",
                            ["j"] = "down",
                            ["k"] = "up",
                            ["l"] = "right",
                            ["H"] = "far_left",
                            ["J"] = "far_down",
                            ["K"] = "far_up",
                            ["L"] = "far_right",
                            ["<left>"] = "left",
                            ["<down>"] = "down",
                            ["<up>"] = "up",
                            ["<right>"] = "right",
                            ["<S-left>"] = "far_left",
                            ["<S-down>"] = "far_down",
                            ["<S-up>"] = "far_up",
                            ["<S-right>"] = "far_right",
                        },
                    },
                    window_picker = function()
                        return require("winshift.lib").pick_window({
                            picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                            filter_rules = {
                                cur_win = true,
                                floats = true,
                                filetype = {},
                                buftype = {},
                                bufname = {},
                            },
                            filter_func = nil,
                        })
                    end,
                })
            end,
        },
        { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true, event = "VeryLazy" },
        -- { 'kperath/dailynotes.nvim', lazy = true, event = "VeryLazy" },
        -- { 'mhinz/vim-startify', lazy = true, event = "VeryLazy" },
        -- {
        -- 	"epwalsh/obsidian.nvim",
        -- 	event = "VeryLazy",
        -- 	version = "*", -- recommended, use latest release
        -- 	dependencies = {
        -- 		"nvim-lua/plenary.nvim",
        -- 	},
        --
        -- 	-- The 'opts' table is where your main setup configuration goes.
        -- 	opts = {
        -- 		-- FIX: Use the absolute path instead of '~'
        -- 		dir = "/home/user/Documents/Office/Notes/main",
        --
        -- 		-- ALL OF YOUR OTHER SETTINGS ARE PRESERVED BELOW
        -- 		notes_subdir = "const",
        -- 		daily_notes = {
        -- 			folder = os.date("Notes/%Y-%m"),
        -- 			date_format = "%d",
        -- 			alias_format = "%B %-d, %Y",
        -- 			default_tags = { "daily-notes" },
        -- 			templates = {
        -- 				folder = "templates",
        -- 				date_format = "%Y-%m-%d",
        -- 				time_format = "%H:%M",
        -- 				substitutions = {},
        -- 			},
        -- 		},
        -- 		completion = {
        -- 			nvim_cmp = true,
        -- 			min_chars = 2,
        -- 		},
        -- 		mappings = {
        -- 			["gf"] = {
        -- 				action = function()
        -- 					return require("obsidian").util.gf_passthrough()
        -- 				end,
        -- 				opts = { noremap = false, expr = true, buffer = true },
        -- 			},
        -- 			["<leader>mc"] = {
        -- 				action = function()
        -- 					return require("obsidian").util.smart_action()
        -- 				end,
        -- 				opts = { buffer = true, expr = true },
        -- 			},
        -- 		},
        -- 		preferred_link_style = "markdown",
        -- 		picker = {
        -- 			name = "telescope.nvim",
        -- 			note_mappings = {
        -- 				new = "<A-x>",
        -- 				insert_link = "<A-l>",
        -- 			},
        -- 			tag_mappings = {
        -- 				tag_note = "<A-x>",
        -- 				insert_tag = "<A-l>",
        -- 			},
        -- 		},
        -- 		sort_by = "modified",
        -- 		sort_reversed = true,
        -- 		open_notes_in = "current",
        -- 		ui = {
        -- 			enable = true,
        -- 			update_debounce = 200,
        -- 			max_file_length = 5000,
        -- 			checkboxes = {
        -- 				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        -- 				["x"] = { char = "", hl_group = "ObsidianDone" },
        -- 				[">"] = { char = "", hl_group = "ObsidianRightArrow" },
        -- 				["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        -- 				["!"] = { char = "", hl_group = "ObsidianImportant" },
        -- 			},
        -- 			bullets = { char = "•", hl_group = "ObsidianBullet" },
        -- 			external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- 			reference_text = { hl_group = "ObsidianRefText" },
        -- 			highlight_text = { hl_group = "ObsidianHighlightText" },
        -- 			tags = { hl_group = "ObsidianTag" },
        -- 			block_ids = { hl_group = "ObsidianBlockID" },
        -- 			hl_groups = {
        -- 				ObsidianTodo = { bold = true, fg = "#f78c6c" },
        -- 				ObsidianDone = { bold = true, fg = "#89ddff" },
        -- 				ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        -- 				ObsidianTilde = { bold = true, fg = "#ff5370" },
        -- 				ObsidianImportant = { bold = true, fg = "#d73128" },
        -- 				ObsidianBullet = { bold = true, fg = "#89ddff" },
        -- 				ObsidianRefText = { underline = true, fg = "#c792ea" },
        -- 				ObsidianExtLinkIcon = { fg = "#c792ea" },
        -- 				ObsidianTag = { italic = true, fg = "#89ddff" },
        -- 				ObsidianBlockID = { italic = true, fg = "#89ddff" },
        -- 				ObsidianHighlightText = { bg = "#444400" },
        -- 			},
        -- 		},
        -- 		attachments = {
        -- 			img_folder = "attachments",
        -- 			img_name_func = function()
        -- 				return string.format("%s-", os.time())
        -- 			end,
        -- 			img_text_func = function(client, path)
        -- 				path = client:vault_relative_path(path) or path
        -- 				return string.format("![%s](%s)", path.name, path)
        -- 			end,
        -- 		},
        -- 	},
        --
        -- 	-- The 'config' function runs AFTER the plugin is loaded.
        -- 	-- This is the correct place for keymaps.
        -- 	config = function(_, opts)
        -- 		-- This line is important to actually apply the options from the 'opts' table above
        -- 		require("obsidian").setup(opts)
        --
        -- 		-- Your keymaps, with the paths fixed
        -- 		vim.keymap.set("n", "<leader>od", vim.cmd.ObsidianDailies)
        -- 		vim.keymap.set("n", "<leader>ot", vim.cmd.ObsidianToday)
        -- 		vim.keymap.set("n", "<leader>oy", vim.cmd.ObsidianYesterday)
        -- 		vim.keymap.set("n", "<leader>os", vim.cmd.ObsidianSearch)
        -- 		vim.keymap.set("n", "<leader>or", vim.cmd.ObsidianQuickSwitch)
        -- 		vim.keymap.set("n", "<leader>oR", vim.cmd.ObsidianQuickSwitch)
        -- 		vim.keymap.set("n", "<leader>ob", vim.cmd.ObsidianBacklinks)
        -- 		vim.keymap.set("n", "<leader>on", vim.cmd.ObsidianNew)
        -- 		vim.keymap.set("n", "<leader>of", vim.cmd.ObsidianFollowLink)
        -- 		-- FIX: Use the absolute path for these keymaps
        -- 		vim.keymap.set("n", "<leader>op", "<cmd>e /home/ecys/Documents/Office/Notes/main/Prayer Times.md<CR>")
        -- 		vim.keymap.set(
        -- 			"n",
        -- 			"<leader>oc",
        -- 			"<cmd>e /home/ecys/Documents/Office/Notes/main/const/chess tutorial<CR>"
        -- 		)
        -- 	end,
        -- },
        { "f3fora/cmp-spell",                            lazy = true, event = "VeryLazy" },
        { "numToStr/Comment.nvim",                       lazy = true, event = "VeryLazy" },
        { "nat-418/boole.nvim",                          lazy = true, event = "VeryLazy" },
        { "famiu/bufdelete.nvim",                        lazy = true, event = "VeryLazy" },
        { "RRethy/vim-illuminate",                       lazy = true, event = "VeryLazy" },
        {
            "petertriho/nvim-scrollbar",
            lazy = true,
            event = "VeryLazy",
            keys = {
                { "<C-s>", "<cmd>ScrollbarToggle<cr>", desc = "Toggle Scrollbar" },
            },
            config = function()
                require("scrollbar").setup({
                    show = false,
                    show_in_active_only = false,
                    set_highlights = true,
                    folds = 1000,
                    max_lines = 10000,
                    hide_if_all_visible = false,
                    throttle_ms = 100,
                    handle = {
                        text = "│",
                        blend = 30,
                        color = nil,
                        color_nr = nil,
                        highlight = "CursorColumn",
                        hide_if_all_visible = true,
                    },
                    marks = {
                        Cursor = {
                            text = "•",
                            priority = 0,
                            gui = nil,
                            color = "white",
                            cterm = nil,
                            color_nr = "white",
                            highlight = "None",
                        },
                        Search = {
                            text = { "-", "=" },
                            priority = 1,
                            gui = nil,
                            color = nil,
                            cterm = nil,
                            color_nr = nil,
                            highlight = "Search",
                        },
                        Error = {
                            text = { "-", "=" },
                            priority = 2,
                            gui = nil,
                            color = nil,
                            cterm = nil,
                            color_nr = nil,
                            highlight = "DiagnosticVirtualTextError",
                        },
                        Warn = {
                            text = { "-", "=" },
                            priority = 3,
                            gui = nil,
                            color = nil,
                            cterm = nil,
                            color_nr = nil,
                            highlight = "DiagnosticVirtualTextWarn",
                        },
                        Info = {
                            text = { "-", "=" },
                            priority = 4,
                            gui = nil,
                            color = nil,
                            cterm = nil,
                            color_nr = nil,
                            highlight = "DiagnosticVirtualTextInfo",
                        },
                        Hint = {
                            text = { "-", "=" },
                            priority = 5,
                            gui = nil,
                            color = nil,
                            cterm = nil,
                            color_nr = nil,
                            highlight = "DiagnosticVirtualTextHint",
                        },
                        Misc = {
                            text = { "-", "=" },
                            priority = 6,
                            gui = nil,
                            color = nil,
                            cterm = nil,
                            color_nr = nil,
                            highlight = "Normal",
                        },
                        GitAdd = {
                            text = "┆",
                            priority = 7,
                            gui = nil,
                            color = nil,
                            cterm = nil,
                            color_nr = nil,
                            highlight = "GitSignsAdd",
                        },
                        GitChange = {
                            text = "┆",
                            priority = 7,
                            gui = nil,
                            color = nil,
                            cterm = nil,
                            color_nr = nil,
                            highlight = "GitSignsChange",
                        },
                        GitDelete = {
                            text = "▁",
                            priority = 7,
                            gui = nil,
                            color = nil,
                            cterm = nil,
                            color_nr = nil,
                            highlight = "GitSignsDelete",
                        },
                    },
                    excluded_buftypes = {
                        "terminal",
                    },
                    excluded_filetypes = {
                        "dropbar_menu",
                        "dropbar_menu_fzf",
                        "DressingInput",
                        "cmp_docs",
                        "cmp_menu",
                        "noice",
                        "prompt",
                        "TelescopePrompt",
                    },
                    autocmd = {
                        render = {
                            "BufWinEnter",
                            "TabEnter",
                            "TermEnter",
                            "WinEnter",
                            "CmdwinLeave",
                            "TextChanged",
                            "VimResized",
                            "WinScrolled",
                        },
                        clear = {
                            "BufWinLeave",
                            "TabLeave",
                            "TermLeave",
                            "WinLeave",
                        },
                    },
                    handlers = {
                        cursor = true,
                        diagnostic = true,
                        gitsigns = false,
                        handle = true,
                        search = true,
                        ale = false,
                    },
                })
            end,
        },
        { "giuxtaposition/blink-cmp-copilot", lazy = true, event = "VeryLazy" },
        { "pteroctopus/faster.nvim",          lazy = true, event = "VeryLazy" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
