require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = 'onedark',
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = false,
		refresh = {
			statusline = 100,
			tabline = 100,
			winbar = 100,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_c = { "branch", "diff", "diagnostics" },
		lualine_b = { "filename" },
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = {
            { "buffers",
			show_filename_only = true, -- Shows shortened relative path when set to false.
			hide_filename_extension = false, -- Hide filename extension when set to true.
			show_modified_status = true, -- Shows indicator when the buffer is modified.

			mode = 0, -- 0: Shows buffer name
			-- 1: Shows buffer index
			-- 2: Shows buffer name + buffer index
			-- 3: Shows buffer number
			-- 4: Shows buffer name + buffer number

			max_length = vim.o.columns * 2 / 2.25, -- Maximum width of buffers component,
			-- it can also be a function that returns
			-- the value of `max_length` dynamically.
			filetype_names = {
				TelescopePrompt = "Telescope",
				dashboard = "Dashboard",
				packer = "Packer",
				fzf = "FZF",
                alpha = "Alpha",
            }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
            use_mode_colors = true,


            symbols = {
                modified = " ●", -- Text to show when the buffer is modified
				alternate_file = "#", -- Text to show to identify the alternate file
				directory = "", -- Text to show when the buffer is a directory
			},
        }
    },

		lualine_z = {
			function()
				return os.date("!%H:%M:%S")
			end,
		},
	},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})
