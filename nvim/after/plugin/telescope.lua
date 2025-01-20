local builtin = require("telescope.builtin")
-- vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope git files" })
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Search term > ") })
end)

vim.keymap.set("n", "<leader>pb", function()
	require("telescope.builtin").buffers(require("telescope.themes").get_ivy({
		sort_mru = true,
		-- -- Sorts current and last buffer to the top and selects the lastused (default: false)
		-- -- Leave this at false, otherwise when put in normal mode, the buffer
		-- -- below is selected, not the one at the top
		sort_lastused = false,
		initial_mode = "normal",
		hidden = true,
		-- Pre-select the current buffer
		-- ignore_current_buffer = false,
		-- select_current = true,
		layout_config = {
			-- Set preview width, 0.7 sets it to 70% of the window width
			preview_width = 0.45,
		},
	}))
end, { desc = "[P]Open telescope buffers" })

vim.keymap.set({ "n", "v" }, '<leader>"', function()
	require("telescope.builtin").registers({
		sort_mru = true,
		sort_lastused = false,
		initial_mode = "normal",
		layout_config = {
			preview_width = 0.45,
		},
	})
end, { desc = "[P]Open telescope registers" })

vim.keymap.set("n", "<leader>pf", function()
	require("telescope.builtin").find_files(require("telescope.themes").get_ivy({
		sort_mru = true,
		-- -- Sorts current and last buffer to the top and selects the lastused (default: false) -- Leave this at false, otherwise when put in normal mode, the buffer
		-- -- below is selected, not the one at the top
		sort_lastused = false,
		initial_mode = "insert",
		-- Pre-select the current buffer
		-- ignore_current_buffer = false,
		-- select_current = true,
		hidden = true,
		layout_config = {
			-- Set preview width, 0.7 sets it to 70% of the window width
			preview_width = 0.45,
		},
	}))
end, { desc = "[P]Open telescope buffers" })

vim.keymap.set("n", "<leader>r", function()
	require("telescope").load_extension("frecency") -- Load the frecency extension

	-- Set up the options for the frecency picker
	local opts = require("telescope.themes").get_ivy({
		sort_mru = true,
		sort_lastused = false,
		hidden = true,
		initial_mode = "insert",
		layout_config = {
			preview_width = 0.45,
		},
	})

	-- Call the frecency picker with the given options
	require("telescope").extensions.frecency.frecency(opts)
end, { desc = "[P] Open frecency list" })

vim.keymap.set("n", "<leader>pr", function()
	require("telescope").load_extension("recent_files") -- Load the recent_files extension

	-- Set up the options for the recent_files picker
	local opts = require("telescope.themes").get_ivy({
		sort_mru = true,
		sort_lastused = false,
		hidden = true,
		initial_mode = "normal",
		layout_config = {
			preview_width = 0.45,
		},
		only_cwd = true, -- Load files only in the current working directory
		show_current_file = true,
	})

	-- Call the recent_files picker with the given options
	require("telescope").extensions.recent_files.pick(opts)
end, { desc = "[P] Open recent files" })

vim.keymap.set("n", "<leader>R", function()
	require("telescope").load_extension("recent_files") -- Load the recent_files extension

	-- Set up the options for the recent_files picker
	local opts = require("telescope.themes").get_ivy({
		sort_mru = true,
		hidden = true,
		sort_lastused = false,
		initial_mode = "normal",
		layout_config = {
			preview_width = 0.45,
		},
		show_current_file = true,
	})

	-- Call the recent_files picker with the given options
	require("telescope").extensions.recent_files.pick(opts)
end, { desc = "[P] Open recent files" })

vim.keymap.set({ "n" }, "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "[P]Key Maps" })

local actions = require("telescope.actions")
require("telescope").setup({
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
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
