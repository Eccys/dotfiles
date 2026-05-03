local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"

require("lazy.plugins")
require("ecys.set")
require("ecys.remap")
vim.cmd.source(vimrc)

vim.cmd.source(vim.fn.stdpath("config") .. "/after/plugin/bosidian.lua")

-- ==========================================================================
-- DYNAMIC THEME LOGIC
-- ==========================================================================
_G.reload_matugen_colors = function()
  -- vim.schedule ensures this massive UI update runs safely on the main event loop
  vim.schedule(function()
    -- FIX: Prevent warning on first lazy.nvim run before Catppuccin is downloaded
    local check_cat_installed = pcall(require, "catppuccin")
    if not check_cat_installed then
      return
    end

    local matugen_path = vim.fn.stdpath("config") .. "/matugen_colors.lua"
    local overrides = {}
    
    if vim.fn.filereadable(matugen_path) == 1 then
      local chunk = loadfile(matugen_path)
      if chunk then
        local colors = chunk()
        if type(colors) == "table" then
          overrides = { all = colors, mocha = colors }
        end
      end
    end

    -- FIX: Only clear catppuccin. Do NOT clear lualine, or it will leak highlight groups!
    for k, _ in pairs(package.loaded) do
      if k:match("^catppuccin") then
        package.loaded[k] = nil
      end
    end

    -- Nuke Neovim's existing highlights
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") then
      vim.cmd("syntax reset")
    end
    vim.g.colors_name = nil

    local ok_cat, cat = pcall(require, "catppuccin")
    if ok_cat then
      cat.setup({
        flavour = "mocha",
        compile = { enabled = false }, -- MUST be false for dynamic overrides
        color_overrides = overrides,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          bufferline = true, 
          telescope = { enabled = true },
          indent_blankline = { enabled = true },
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
        },
      })
      vim.cmd("colorscheme catppuccin")
    end
    
    -- Reload lualine dynamically safely
    local ok_lualine, lualine = pcall(require, "lualine")
    if ok_lualine then
      lualine.setup { options = { theme = 'catppuccin-nvim' } }
    end
    
    -- Force Neovim to redraw
    vim.cmd("redraw!")

    -- Provide visual confirmation
    vim.notify("Matugen colors reloaded!", vim.log.levels.INFO)
  end)
end

-- Initialize the colors immediately on startup
_G.reload_matugen_colors()

-- ==========================================================================
-- ASYNC DIRECTORY WATCHER FOR DYNAMIC RELOADING
-- ==========================================================================
local uv = vim.uv or vim.loop
local config_dir = vim.fn.stdpath("config")
local reload_timer = uv.new_timer()

local watcher = uv.new_fs_event()
if watcher then
  -- We watch the entire config directory to avoid inode replacement breaking the watcher
  watcher:start(config_dir, {}, vim.schedule_wrap(function(err, filename, events)
    if not err and filename == "matugen_colors.lua" then
      
      -- Debounce the events to catch both Matugen's write and our sed modification
      reload_timer:stop()
      reload_timer:start(250, 0, vim.schedule_wrap(function()
        _G.reload_matugen_colors()
      end))
      
    end
  end))
end
