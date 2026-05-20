local function smart_file_find()
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname == "" then return end

	-- If the file already exists, do nothing
	if vim.uv.fs_stat(bufname) then return end

	local basename = vim.fs.basename(bufname)
	if basename == "" then return end

	-- Look through v:oldfiles for matches
	local matches = {}
	local oldfiles = vim.v.oldfiles or {}
	for _, file in ipairs(oldfiles) do
		if vim.fs.basename(file) == basename and vim.uv.fs_stat(file) then
			local found = false
			for _, m in ipairs(matches) do
				if m == file then found = true; break end
			end
			if not found then
				table.insert(matches, file)
			end
		end
	end

	if #matches == 0 then return end

	-- Build choice items
	local items = {}
	for _, m in ipairs(matches) do
		table.insert(items, m)
	end
	table.insert(items, "[Create new file: " .. bufname .. "]")

	local dummy_buf = vim.api.nvim_get_current_buf()

	vim.schedule(function()
		local ok_telescope, _ = pcall(require, "telescope")
		if ok_telescope then
			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			local themes = require("telescope.themes")

			local opts = themes.get_ivy({
				prompt_title = string.format("File '%s' not found. Open existing?", basename),
				finder = finders.new_table({
					results = items,
					entry_maker = function(entry)
						local value = entry
						if entry:find("^%[Create new file:") then
							value = ""
						end
						return {
							value = value,
							display = entry,
							ordinal = entry,
						}
					end,
				}),
				previewer = conf.file_previewer({}),
				sorter = conf.generic_sorter({}),
				initial_mode = "insert",
				layout_config = { preview_width = 0.45 },
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						if selection then
							local choice = selection.value
							local display = selection.display
							if display and not display:find("^%[Create new file:") then
								vim.cmd("edit " .. vim.fn.fnameescape(choice))
								vim.api.nvim_buf_delete(dummy_buf, { force = true })
							end
						end
					end)
					return true
				end,
			})
			pickers.new(opts):find()
		else
			-- Fallback to vim.ui.select if Telescope is not available
			vim.ui.select(items, {
				prompt = string.format("File '%s' not found. Open existing?", basename),
			}, function(choice)
				if choice and not choice:find("^%[Create new file:") then
					vim.cmd("edit " .. vim.fn.fnameescape(choice))
					vim.api.nvim_buf_delete(dummy_buf, { force = true })
				end
			end)
		end
	end)
end

vim.api.nvim_create_autocmd("BufNewFile", {
	group = vim.api.nvim_create_augroup("SmartFileFind", { clear = true }),
	callback = smart_file_find,
})
